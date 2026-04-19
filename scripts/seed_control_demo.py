#!/usr/bin/env python3
"""Seed a running standalone OCP node with enough activity to exercise /control."""

from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.request
from typing import Any


def _post(base_url: str, path: str, payload: dict[str, Any]) -> dict[str, Any]:
    request = urllib.request.Request(
        base_url.rstrip("/") + path,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=10) as response:
        return json.loads(response.read().decode("utf-8"))


def _get(base_url: str, path: str) -> dict[str, Any]:
    with urllib.request.urlopen(base_url.rstrip("/") + path, timeout=10) as response:
        return json.loads(response.read().decode("utf-8"))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Seed a running OCP node with control-deck demo activity.")
    parser.add_argument("--base-url", default="http://127.0.0.1:8421", help="Base URL of the running OCP server.")
    parser.add_argument("--node-id", default="", help="Target peer id for notifications/approvals. Defaults to the manifest organism id.")
    parser.add_argument("--worker-id", default="control-demo-worker", help="Worker id to register for the demo node.")
    parser.add_argument("--agent-id", default="control-demo-agent", help="Agent id for the registered worker.")
    parser.add_argument("--mission-title", default="Control Deck Demo Mission", help="Mission title to launch.")
    args = parser.parse_args(argv)

    try:
        manifest = _get(args.base_url, "/mesh/manifest")
    except urllib.error.URLError as exc:
        print(f"Unable to reach {args.base_url}: {exc}", file=sys.stderr)
        return 1

    organism = dict(manifest.get("organism_card") or {})
    node_id = (args.node_id or organism.get("organism_id") or organism.get("node_id") or "").strip()
    if not node_id:
        print("Could not determine target node id from the manifest.", file=sys.stderr)
        return 1

    try:
        worker = _post(
            args.base_url,
            "/mesh/workers/register",
            {
                "worker_id": args.worker_id,
                "agent_id": args.agent_id,
                "capabilities": ["python", "worker-runtime", "shell"],
                "resources": {"cpu": 1},
            },
        )
        mission = _post(
            args.base_url,
            "/mesh/missions/launch",
            {
                "title": args.mission_title,
                "intent": "Exercise the live control deck with real mission, queue, and continuity metadata.",
                "request_id": "control-demo-mission",
                "priority": "high",
                "continuity": {"resumable": True},
                "job": {
                    "kind": "python.inline",
                    "dispatch_mode": "queued",
                    "requirements": {"capabilities": ["python"]},
                    "policy": {"classification": "trusted", "mode": "batch"},
                    "payload": {"code": "print('control deck demo mission')"},
                    "metadata": {
                        "resumability": {"enabled": True},
                        "checkpoint_policy": {"enabled": True, "mode": "manual"},
                    },
                },
            },
        )
        notification = _post(
            args.base_url,
            "/mesh/notifications/publish",
            {
                "notification_type": "job.summary",
                "priority": "high",
                "title": "Control Deck Demo Alert",
                "body": "Live demo activity for the remote operator deck.",
                "target_peer_id": node_id,
                "target_device_classes": ["light", "micro", "full"],
            },
        )
        approval = _post(
            args.base_url,
            "/mesh/approvals/request",
            {
                "title": "Approve demo recovery",
                "summary": "Manual checkpoint review for the control deck demo mission.",
                "action_type": "job.recovery.resume",
                "severity": "high",
                "target_peer_id": node_id,
                "target_device_classes": ["light", "micro", "full"],
            },
        )
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        print(f"Seed request failed with HTTP {exc.code}: {body}", file=sys.stderr)
        return 1
    except urllib.error.URLError as exc:
        print(f"Seed request failed: {exc}", file=sys.stderr)
        return 1

    print(
        json.dumps(
            {
                "base_url": args.base_url,
                "node_id": node_id,
                "worker_status": worker.get("status"),
                "mission_id": mission.get("id"),
                "mission_status": mission.get("status"),
                "child_job_ids": mission.get("child_job_ids"),
                "notification_id": dict(notification.get("notification") or {}).get("id"),
                "approval_id": dict(approval.get("approval") or {}).get("id"),
                "control_url": args.base_url.rstrip("/") + "/control",
            },
            indent=2,
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

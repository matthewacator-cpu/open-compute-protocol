from __future__ import annotations

import json
import re
import uuid
from typing import Any

from mesh.sovereign import _utcnow
from server_app_status import build_app_status

MAX_HISTORY_SAMPLES_PER_NODE = 10_000


def _as_int(value: Any, default: int = 0) -> int:
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def _redact_token_fragments(value: str) -> str:
    return re.sub(r"(ocp_operator_token=)[^&#\s]+", r"\1[redacted]", str(value or ""))


def _redact_payload(value: Any) -> Any:
    if isinstance(value, dict):
        redacted: dict[str, Any] = {}
        for key, item in value.items():
            key_text = str(key)
            lowered = key_text.lower()
            if "token" in lowered or "secret" in lowered or "authorization" in lowered:
                redacted[key_text] = "[redacted]" if item else ""
            else:
                redacted[key_text] = _redact_payload(item)
        return redacted
    if isinstance(value, list):
        return [_redact_payload(item) for item in value]
    if isinstance(value, str):
        return _redact_token_fragments(value)
    return value


def _mesh_score(status: dict[str, Any]) -> int:
    setup = dict(status.get("setup") or {})
    mesh_quality = dict(status.get("mesh_quality") or {})
    latest_proof = dict(status.get("latest_proof") or {})
    route_count = _as_int(mesh_quality.get("route_count") or setup.get("route_count"))
    healthy_routes = _as_int(mesh_quality.get("healthy_routes") or setup.get("healthy_route_count"))
    peer_count = _as_int(mesh_quality.get("peer_count") or setup.get("known_peer_count"))
    setup_status = str(setup.get("status") or "").lower()
    proof_status = str(latest_proof.get("status") or setup.get("latest_proof_status") or "").lower()

    if route_count:
        score = int(round((healthy_routes / max(1, route_count)) * 70))
    elif peer_count:
        score = 30
    else:
        score = 12

    if proof_status == "completed":
        score += 20
    elif proof_status in {"planned", "queued", "running", "accepted"}:
        score += 8
    elif proof_status in {"failed", "needs_attention", "cancelled"}:
        score -= 12

    if setup_status == "strong":
        score += 10
    elif setup_status == "ready":
        score += 5
    elif setup_status in {"needs_attention", "local_only"}:
        score -= 5

    return max(0, min(100, score))


def _ready_target_count(status: dict[str, Any]) -> int:
    readiness = dict(status.get("execution_readiness") or {})
    return sum(1 for target in list(readiness.get("targets") or []) if str(dict(target or {}).get("status") or "") == "ready")


def _sample_from_status(status: dict[str, Any], *, sampled_at: str = "") -> dict[str, Any]:
    node = dict(status.get("node") or {})
    setup = dict(status.get("setup") or {})
    mesh_quality = dict(status.get("mesh_quality") or {})
    readiness = dict(status.get("execution_readiness") or {})
    local = dict(readiness.get("local") or {})
    artifact_sync = dict(status.get("artifact_sync") or {})
    approvals = dict(status.get("approvals") or {})
    latest_proof = dict(status.get("latest_proof") or {})
    return {
        "id": str(uuid.uuid4()),
        "sampled_at": sampled_at or _utcnow(),
        "node_id": str(node.get("node_id") or status.get("peer_id") or ""),
        "setup_status": str(setup.get("status") or ""),
        "mesh_score": _mesh_score(status),
        "known_peer_count": _as_int(mesh_quality.get("peer_count") or setup.get("known_peer_count")),
        "route_count": _as_int(mesh_quality.get("route_count") or setup.get("route_count")),
        "healthy_route_count": _as_int(mesh_quality.get("healthy_routes") or setup.get("healthy_route_count")),
        "latest_proof_status": str(latest_proof.get("status") or setup.get("latest_proof_status") or ""),
        "execution_ready_targets": _ready_target_count(status),
        "local_ready_workers": _as_int(local.get("ready_worker_count")),
        "artifact_verified_count": _as_int(artifact_sync.get("verified_count")),
        "pending_approvals": _as_int(approvals.get("pending_count")),
        "payload": _redact_payload(status),
    }


def _row_to_sample(row) -> dict[str, Any]:
    return {
        "id": row["id"],
        "sampled_at": row["sampled_at"],
        "node_id": row["node_id"],
        "setup_status": row["setup_status"] or "",
        "mesh_score": int(row["mesh_score"] or 0),
        "known_peer_count": int(row["known_peer_count"] or 0),
        "route_count": int(row["route_count"] or 0),
        "healthy_route_count": int(row["healthy_route_count"] or 0),
        "latest_proof_status": row["latest_proof_status"] or "",
        "execution_ready_targets": int(row["execution_ready_targets"] or 0),
        "local_ready_workers": int(row["local_ready_workers"] or 0),
        "artifact_verified_count": int(row["artifact_verified_count"] or 0),
        "pending_approvals": int(row["pending_approvals"] or 0),
        "payload": json.loads(row["payload"] or "{}"),
    }


def record_app_status_sample(mesh, data: dict[str, Any] | None = None) -> dict[str, Any]:
    status = build_app_status(mesh)
    sample = _sample_from_status(status)
    if not sample["node_id"]:
        sample["node_id"] = getattr(mesh, "node_id", "local")

    with mesh._conn() as conn:
        conn.execute(
            """
            INSERT INTO mesh_app_status_samples (
                id, sampled_at, node_id, setup_status, mesh_score, known_peer_count,
                route_count, healthy_route_count, latest_proof_status, execution_ready_targets,
                local_ready_workers, artifact_verified_count, pending_approvals, payload
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                sample["id"],
                sample["sampled_at"],
                sample["node_id"],
                sample["setup_status"],
                sample["mesh_score"],
                sample["known_peer_count"],
                sample["route_count"],
                sample["healthy_route_count"],
                sample["latest_proof_status"],
                sample["execution_ready_targets"],
                sample["local_ready_workers"],
                sample["artifact_verified_count"],
                sample["pending_approvals"],
                json.dumps(sample["payload"], sort_keys=True),
            ),
        )
        conn.execute(
            """
            DELETE FROM mesh_app_status_samples
            WHERE node_id = ?
              AND id NOT IN (
                SELECT id FROM mesh_app_status_samples
                WHERE node_id = ?
                ORDER BY sampled_at DESC, rowid DESC
                LIMIT ?
              )
            """,
            (sample["node_id"], sample["node_id"], MAX_HISTORY_SAMPLES_PER_NODE),
        )
        conn.commit()

    try:
        mesh.state.record_event(
            "mesh.app.history.sampled",
            peer_id=sample["node_id"],
            payload={
                "mesh_score": sample["mesh_score"],
                "setup_status": sample["setup_status"],
                "route_count": sample["route_count"],
                "healthy_route_count": sample["healthy_route_count"],
                "source": str(dict(data or {}).get("source") or "app"),
            },
        )
    except Exception:
        pass

    return {"status": "ok", "sample": sample, "retention_limit": MAX_HISTORY_SAMPLES_PER_NODE}


def list_app_status_history(mesh, *, limit: int = 240) -> dict[str, Any]:
    normalized_limit = max(1, min(1000, int(limit or 240)))
    with mesh._conn() as conn:
        rows = conn.execute(
            """
            SELECT * FROM mesh_app_status_samples
            ORDER BY sampled_at DESC, rowid DESC
            LIMIT ?
            """,
            (normalized_limit,),
        ).fetchall()
    samples = [_row_to_sample(row) for row in reversed(rows)]
    return {
        "status": "ok",
        "count": len(samples),
        "limit": normalized_limit,
        "samples": samples,
        "generated_at": _utcnow(),
    }


__all__ = ["list_app_status_history", "record_app_status_sample"]

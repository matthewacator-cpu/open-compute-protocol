from __future__ import annotations

from typing import Any, Optional


def normalize_treaty_status(value: Optional[str]) -> str:
    token = str(value or "").strip().lower() or "draft"
    if token in {"draft", "active", "suspended", "expired", "revoked"}:
        return token
    return "draft"


def normalize_treaty_document(raw: Optional[dict]) -> dict:
    data = dict(raw or {})

    def _tokens(values: Any) -> list[str]:
        seen: list[str] = []
        for item in list(values or []):
            token = str(item or "").strip().lower()
            if token and token not in seen:
                seen.append(token)
        return seen

    allowed_execution_classes = _tokens(
        data.get("allowed_execution_classes")
        or data.get("execution_classes")
        or []
    )
    artifact_export = str(data.get("artifact_export") or "restricted").strip().lower() or "restricted"
    if artifact_export not in {"restricted", "trusted_only", "portable", "sealed"}:
        artifact_export = "restricted"
    witness_required = bool(data.get("witness_required")) if "witness_required" in data else False
    custody_mode = str(data.get("custody_mode") or "local_or_sanctuary").strip().lower() or "local_or_sanctuary"
    revival_mode = str(data.get("revival_mode") or "approval").strip().lower() or "approval"
    continuity_scope = str(data.get("continuity_scope") or "mission").strip().lower() or "mission"
    document = {
        "treaty_type": str(data.get("treaty_type") or "continuity").strip().lower() or "continuity",
        "parties": _tokens(data.get("parties") or data.get("party_ids") or []),
        "allowed_execution_classes": allowed_execution_classes,
        "artifact_export": artifact_export,
        "witness_required": witness_required,
        "custody_mode": custody_mode,
        "revival_mode": revival_mode,
        "continuity_scope": continuity_scope,
        "habitat_allow": _tokens(data.get("habitat_allow") or []),
        "habitat_deny": _tokens(data.get("habitat_deny") or []),
        "review_window": str(data.get("review_window") or "").strip(),
        "notes": str(data.get("notes") or "").strip(),
    }
    for key, value in data.items():
        if key not in document:
            document[key] = value
    return document

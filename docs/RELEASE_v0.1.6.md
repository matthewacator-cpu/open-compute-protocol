# OCP v0.1.6 Release Notes

`v0.1.6` is the protocol-first Desktop Alpha tranche. It keeps the local-first HTTP/PWA architecture and SQLite substrate intact while making artifact mobility, execution readiness, and setup explanations more explicit.

## Highlights

- Protocol contract coverage now includes artifact replication auth, route proof freshness, execution readiness, worker capacity, and setup timeline events.
- Private artifact replication supports explicit `remote_auth: {type: "operator_token", token: "..."}` for operator-mediated pulls from trusted peers.
- Remote operator tokens are used only in memory for the outbound content fetch and are redacted from responses, events, and artifact sync metadata.
- `/mesh/app/status` now exposes `protocol`, `execution_readiness`, `artifact_sync`, and `setup.timeline`.
- `/mesh/app/history` and `/mesh/app/history/sample` persist redacted app-status samples for native Mission Control charts.
- `/app` adds a Proof Timeline plus `Run on Best Device` and `Replicate Proof Artifact` actions.
- The easy launcher and Mac launcher can auto-advertise a default worker for full laptop/workstation nodes.
- A native SwiftPM Mac app target, `OCPDesktop`, now wraps the existing OCP server with a SwiftUI Mission Control shell, sidebar pages, charts, guided setup, route topology, and setup/protocol detail views.
- `python3 scripts/build_swift_macos_app.py` builds an unsigned native SwiftPM `.app` beta bundle.

## Compatibility Notes

- Existing `/mesh/*`, `/app`, `/easy`, and `/control` routes remain compatible.
- Artifact replication without `remote_auth` still works for public content and already-local CAS hits.
- Private remote content requires either public artifact policy or explicit operator-mediated remote auth.
- Signed scoped capability grants are not implemented yet; they are the intended future replacement for operator-token-mediated private pulls.

## Verification

Expected release gates:

```bash
git diff --check
python3 scripts/check_protocol_conformance.py
python3 -m unittest tests.test_sovereign_mesh -q
python3 server.py --help
./scripts/start_ocp.sh --help
python3 scripts/start_ocp_easy.py --help
python3 scripts/build_macos_app.py --help
python3 scripts/build_swift_macos_app.py --help
swift build
swift test
python3 -m ocp_desktop.launcher --plan local
```

Current standalone baseline: `tests.test_sovereign_mesh` has 189 tests.

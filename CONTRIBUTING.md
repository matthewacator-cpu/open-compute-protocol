# Contributing to Open Compute Protocol

Thanks for contributing to OCP.

OCP is still early. The most helpful contributions are the ones that make the protocol and reference implementation clearer, safer, and easier to operate, not just larger.

## Ground Rules

- Keep OCP standalone.
- Do not collapse OCP into Personal Mirror or other projects.
- Preserve the current framing:
  - `OCP v0.1` = protocol/spec
  - `Sovereign Mesh` = Python-first reference implementation
  - `sovereign-mesh/v1` = current wire version
- Prefer focused, incremental changes over speculative rewrites.
- Keep local-first, trust-aware behavior intact.

## Good Contribution Areas

- peer federation and sync behavior
- missions, recovery, and continuity
- helper enlistment and offload policy
- cooperative task orchestration
- artifact lineage, replication, and verification
- phone-friendly operator UX
- docs, examples, diagrams, and protocol clarity
- tests that lock in real behavior

## Local Setup

```bash
git clone https://github.com/matthewacator-cpu/open-compute-protocol.git
cd open-compute-protocol
./scripts/start_ocp.sh --help
```

## Before You Open a Pull Request

1. Keep the change scoped to one coherent improvement.
2. Add or update tests when behavior changes.
3. Update docs when commands, semantics, or operator flows change.
4. Check that you are not committing local state, identity material, `.env` files, or generated databases.
5. Run:

```bash
python3 -m unittest tests.test_sovereign_mesh
python3 server.py --help
```

## Code Style

- Prefer straightforward Python over framework-heavy abstractions.
- Keep the runtime legible for protocol work.
- Avoid new dependencies unless the gain is substantial.
- Preserve operator-facing explainability.

## Design Direction

OCP is not trying to be a generic cloud clone.

The strongest current direction is:

- mission-oriented orchestration
- governed helper enlistment
- continuity-aware recovery
- trust-aware peer cooperation
- operator control from desktop and mobile surfaces

If your change strengthens those ideas, it is likely in the right direction.

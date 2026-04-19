<div align="center">

<br/>

```text
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ○ ─ ─ ─ ◎ ─ ─ ─ ○          ○ ─ ─ ─ ◎            │
│   │         \       \        /         │            │
│   │          ○ ─ ─ ─ ◉ ─ ─ ◎          │            │
│   │         /       /        \         │            │
│   ◎ ─ ─ ─ ○ ─ ─ ─ ○          ○ ─ ─ ─ ◎            │
│                                                     │
│          your devices · governed together           │
└─────────────────────────────────────────────────────┘
```

# Open Compute Protocol

**A sovereign, local-first compute fabric for trusted devices.**

[![Tests](https://img.shields.io/badge/tests-119%20passing-00FF88?style=flat-square&labelColor=06090F)](./tests/test_sovereign_mesh.py)
[![Wire Version](https://img.shields.io/badge/wire-sovereign--mesh%2Fv1-00D4FF?style=flat-square&labelColor=06090F)](./docs/OCP_STATUS.md)
[![Status](https://img.shields.io/badge/status-active%20development-C8A96E?style=flat-square&labelColor=06090F)](./docs/OCP_MASTER_PLAN.md)
[![Protocol](https://img.shields.io/badge/protocol-OCP%20v0.1-7BC6FF?style=flat-square&labelColor=06090F)](./docs/OCP_STATUS.md)
[![License](https://img.shields.io/badge/license-AGPL--3.0-F4F1E8?style=flat-square&labelColor=06090F)](./LICENSE)
[![Docs Site](https://img.shields.io/badge/docs-project%20site-9B91E0?style=flat-square&labelColor=06090F)](https://matthewacator-cpu.github.io/open-compute-protocol)

<br/>

*OCP lets laptops, desktops, servers, GPU boxes, relays, and phones act like*
*one practical distributed machine — without pretending to be one literal operating system.*

<br/>

</div>

---

## The Problem

Most systems make you choose between:

- **one machine** — local control, limited power
- **someone else's cloud** — unlimited power, zero control

**OCP is building the third option.**

A governed mesh of your own devices and trusted peers, where computation can move, artifacts can follow it, recovery can survive device failure, and your phone can still govern what the system is allowed to do.

---

## What Makes It Different

OCP does not treat machines as anonymous disposable capacity. It treats them as **situated participants** in a trust-aware system. Some devices are powerful. Some are private. Some are fragile. Some should only be touched with explicit permission. OCP knows the difference.

| Other systems | OCP |
|---|---|
| Blunt autoscaling | Helper enlistment |
| Blind placement | Pressure-aware offload |
| Job retries | Mission continuity |
| Flat worker pool | Device classes |
| Desktop-only control | Phone / watch operator deck |

---

## How It Works

When your workstation strains, the mesh notices. A helper laptop or GPU node is enlisted. The right workload shards move. Artifacts and checkpoints stay coherent. You remain in control from any device.

That is the difference between *scripts on a few boxes* and a real compute protocol.

### Core Concepts

**Peers** — Known remote nodes with trust level, device profile, and availability state.

**Jobs** — Normalized, bounded execution units dispatched across the mesh queue.

**Missions** — Durable higher-level intent that persists above individual jobs. The unit of continuity.

**Cooperative Tasks** — One logical task split across multiple peers with coherent coordination.

**Artifacts** — Bundles, checkpoints, logs, attestations, and replicated results that follow their workload.

**Helpers** — Extra devices enlisted when the local node is under pressure. Lifecycle: Plan -> Enlist -> Drain -> Retire -> Auto-seek.

---

## Architecture

| Surface | Role |
|---|---|
| `mesh/sovereign.py` | Core OCP runtime — peers, jobs, missions, helpers, artifacts, recovery |
| `runtime.py` | Standalone SQLite-backed substrate |
| `server.py` | `/mesh/*` HTTP API and `/control` operator UI |
| `docs/` | Protocol notes, status, and roadmap |
| `tests/test_sovereign_mesh.py` | Regression suite — 119 tests |

---

## Capabilities

<details>
<summary><b>Identity & Peers</b></summary>

- Signed peer identity and handshake
- Peer discovery, manifests, registry, and sync

</details>

<details>
<summary><b>Execution</b></summary>

- Worker registration, polling, claiming, and heartbeats
- Durable queued execution
- Shell, Python, Docker, and WASM execution lanes
- Resumable recovery with checkpoints, resume, restart, and audit trails

</details>

<details>
<summary><b>Artifacts</b></summary>

- Publishing, bundles, attestations, replication
- Graph replication, verification, and pinning

</details>

<details>
<summary><b>Orchestration</b></summary>

- Device profiles: `full` · `light` · `micro` · `relay`
- Compute profiles with CPU, memory, disk, GPU class, and VRAM hints
- Mesh pressure reporting
- GPU-aware cooperative task placement
- Trust-gated autonomous offload
- Durable offload preference memory

</details>

<details>
<summary><b>Operator Layer</b></summary>

- Durable notifications and approvals
- Mission layer above jobs and cooperative tasks
- Mobile-friendly sovereign control deck

</details>

---

## Quick Start

```bash
git clone https://github.com/matthewacator-cpu/open-compute-protocol.git
cd open-compute-protocol
./scripts/start_ocp.sh
```

Then open the control deck:

```text
http://127.0.0.1:8421/control
```

Or launch directly:

```bash
python3 server.py --host 127.0.0.1 --port 8421
```

**Full options:**

```text
--db-path         ./ocp.db
--identity-dir    ./.mesh
--workspace-root  .
--node-id         alpha-node
--display-name    "Alpha"
--device-class    full
--form-factor     workstation
```

For a fuller walkthrough, see [docs/QUICKSTART.md](./docs/QUICKSTART.md).

---

## Operator Control Deck

OCP ships a built-in control surface at `GET /control` — phone-friendly, so your phone acts as a real operator console for the mesh. Inspect and act on:

- Peer and helper state
- Queue and recovery status
- Approvals and notifications
- Cooperative tasks and missions
- Autonomy posture and offload memory

---

## Tests

```bash
python3 -m unittest tests.test_sovereign_mesh
```

> **119 tests passing.** Current baseline for `sovereign-mesh/v1`.

---

## Direction

OCP is past protocol-sketch stage. The strongest near-term vectors:

1. **Richer mission-centric operator UX** — the cockpit should be as legible as a flight deck
2. **Stronger policy and treaty semantics** for peer cooperation — trust as a first-class concept
3. **Continuity-vessel evolution** of checkpoints and recovery — artifacts that never lose their thread
4. **More expressive helper and GPU orchestration** — pressure-aware placement with real semantics
5. **A cinematic, legible constellation-style cockpit** — visible topology for every device in the mesh

If it keeps going in this direction, it becomes more than a scheduler. It becomes a practical sovereign compute layer for all your devices.

---

## Docs

| | |
|---|---|
| [Status](./docs/OCP_STATUS.md) | Current wire version, protocol state |
| [Quickstart](./docs/QUICKSTART.md) | Full setup walkthrough |
| [Master Plan](./docs/OCP_MASTER_PLAN.md) | Long-range direction |
| [All Devices Plan](./docs/OCP_ALL_DEVICES_PLAN.md) | Multi-device topology roadmap |
| [Project Site](https://matthewacator-cpu.github.io/open-compute-protocol) | Visual docs |

---

## Boundary

OCP is standalone. It can integrate with other systems but is not a submodule of any of them and should not be described as one.

---

<div align="center">
<br/>
<sub>sovereign · local-first · trust-aware · all your devices</sub>
<br/><br/>
</div>

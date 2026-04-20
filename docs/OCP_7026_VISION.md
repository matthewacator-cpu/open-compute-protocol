# OCP 7026 Vision

Status: long-horizon vision and bridge plan
Date: 2026-04-20
Scope: OCP only
Protocol/spec: OCP v0.1 plus continuity overlay
Reference implementation: Sovereign Mesh
Current wire version: `sovereign-mesh/v1`

Companion docs:
- `docs/OCP_MASTER_PLAN.md`
- `docs/OCP_ALL_DEVICES_PLAN.md`
- `docs/OCP_STATUS.md`

## 1. Purpose

This document extends OCP from a sovereign compute fabric into a sovereign continuity fabric.

It does not replace the near-term execution roadmap in `docs/OCP_MASTER_PLAN.md`. It provides a long-horizon north star and a grounded bridge from the current runtime toward continuity, treaty, lineage, and habitat-aware operation.

The practical framing is simple:
- today OCP helps trusted devices act like one practical distributed machine
- over time OCP should help trusted devices, archives, relays, habitats, and lineages act like one practical continuity organism

The goal is not immortality marketing and not speculative mythology. The goal is durable continuity of work, memory, custody, and authority across failure, migration, dormancy, and long spans of time.

## 2. One-Line Reframe

**Today:** OCP is the sovereign compute layer for all your devices.

**Long horizon:** OCP becomes the sovereign continuity layer for all your worlds.

## 3. What Stays the Same

The future version of OCP should preserve the current project doctrine:
- origin keeps authority over intent, policy, and lineage
- placement stays trust-aware and capability-driven
- artifacts remain explicit, portable, and provenance-friendly
- recovery is durable and observable
- phones, watches, and intermittent nodes remain meaningful control surfaces
- the system stays local-first instead of collapsing into anonymous cloud orchestration

This vision is therefore an extension of current OCP, not a rejection of it.

## 4. What Changes

The major expansion is that OCP begins treating the following as first-class:
- **time**: work may sleep, hibernate, migrate, wake, or replay safely after long gaps
- **treaty**: federation rules become explicit machine-readable cooperation law
- **continuity**: checkpoints evolve into portable continuity vessels
- **habitat**: nodes are not only machines, but situated roles such as archive, sanctuary, relay, vessel, or foundry
- **lineage**: identity persists through key rotation, migration, split, merge, and inheritance
- **custody**: the right to hold secrets is distinct from the right to execute work
- **witness**: important execution and governance events can be remembered, replayed, and challenged later

## 5. Design Commandments

1. **Nothing important should die just because one machine died.**
2. **No secret should move without explicit custody policy.**
3. **No major action should be untraceable.**
4. **Dormancy is normal, not an error state.**
5. **Identity may rotate, but lineage must remain legible.**
6. **The most trusted device is not always the strongest device.**
7. **The strongest device is not automatically allowed to remember.**
8. **A future OCP mesh must degrade gracefully under distance, delay, and absence.**

## 6. Core Primitives

### 6.1 Continuity Vessel

A portable, attestable bundle that contains enough mission state, artifacts, approvals, and recovery metadata to resume a durable intent elsewhere.

It extends today's:
- checkpoints
- result bundles
- replicated artifacts
- mission resume and restart flows

A continuity vessel should answer:
- what is being preserved?
- what state is required to resume?
- what policies remain in force?
- which witnesses attest to this vessel?
- what secrets are required but intentionally absent?

### 6.2 Treaty Set

A machine-readable agreement describing what one peer, habitat, or mesh may do with another's work, artifacts, custody, and recovery state.

Treaties should cover:
- allowed execution classes
- artifact export boundaries
- witness requirements
- custody restrictions
- revival permissions
- emergency behavior
- expiration and review windows

### 6.3 Epoch Lease

A time-aware validity envelope for work that may outlive a normal queue claim or advisory lease.

An epoch lease expresses:
- acceptable dormancy windows
- replay safety expectations
- reapproval thresholds
- witness requirements across wake or restore events

### 6.4 Lineage Record

A cryptographic ancestry log for a peer, mesh, mission, or charter.

A lineage record should support:
- key rotation
- device migration
- fork and merge history
- succession
- tombstoning
- resurrection authorization

### 6.5 Witness Artifact

A signed record that a meaningful event happened under explicit policy.

Examples:
- a treaty was ratified
- a mission was paused by an operator phone
- a continuity vessel was sealed
- a restore was attempted and denied
- a lineage key was rotated

### 6.6 Resurrection Ticket

A controlled authorization to rehydrate dormant missions, vessels, services, or archives.

A resurrection ticket is not equivalent to a job retry. It is a governance and continuity event.

## 7. Mission Hierarchy

The current runtime already distinguishes jobs, missions, cooperative tasks, and artifacts. The long-horizon model extends that stack:
- **Act**: one bounded execution unit
- **Task**: a grouped set of acts with shared intent
- **Job**: a bounded portable compute contract
- **Mission**: durable intent above jobs and cooperative tasks
- **Continuity Program**: a mission family meant to survive migration, dormancy, or institutional turnover
- **Lineage Charter**: the durable statement of why this mesh or continuity program is permitted to persist

This hierarchy keeps OCP grounded: small work still exists, but it lives under durable intent.

## 8. Future Planes

The current architecture already defines identity, federation, execution, durability, artifact, policy/trust, observability, and scheduler planes. The long-horizon architecture keeps those and adds the following.

### 8.1 Time Plane

Purpose:
- dormancy windows
- wake semantics
- long-gap replay safety
- epoch validity
- restore freshness rules

Core abstractions:
- `EpochLease`
- `DormancyClass`
- `WakeIntent`
- `ReplayFence`

### 8.2 Treaty Plane

Purpose:
- machine-readable cooperation law
- execution rights and restrictions
- memory export limits
- revival permissions
- audit and witness thresholds

Core abstractions:
- `TreatySet`
- `TreatyClause`
- `RatificationRecord`
- `CustodyBoundary`

### 8.3 Continuity Plane

Purpose:
- vessel creation and sealing
- restore and migration
- hibernation and resurrection
- continuity-grade failover

Core abstractions:
- `ContinuityVessel`
- `ResurrectionTicket`
- `HibernationRecord`
- `RestorePlan`

### 8.4 Habitat Plane

Purpose:
- role-aware node behavior
- placement rules for archives, foundries, relays, vessels, and sanctuaries
- energy, connectivity, and environmental hints

Core abstractions:
- `HabitatClass`
- `HabitatCard`
- `CustodyCapability`
- `ContinuityCapability`

### 8.5 Custody Plane

Purpose:
- distinguish execution from secret holding
- represent human and device custody boundaries
- prevent silent secret drift across the mesh

Core abstractions:
- `CustodyPolicy`
- `SecretScope`
- `CustodianRef`
- `ReleaseGate`

### 8.6 Memory Plane

Purpose:
- canonical memory objects
- archives, testimony, law, model state, recipes, and simulation history
- retention and forgetting policy

Core abstractions:
- `MemoryObject`
- `RetentionPolicy`
- `WitnessRecord`
- `ForgettingRule`

### 8.7 Cosmographic UI Plane

Purpose:
- show live, sleeping, archival, and ancestral state in one operator view
- make continuity understandable to phones, tablets, and wall displays

Core abstractions:
- `ConstellationMap`
- `EpochView`
- `LineageTrail`
- `RestoreTimeline`

## 9. Habitat Classes

Current device classes such as `full`, `light`, `micro`, and `relay` should remain as practical execution-era classes. Long-horizon OCP can layer higher-order habitat roles on top.

Practical habitat roles:
- `foundry`: strong execution and artifact production node
- `sanctuary`: trusted custody-first node for secrets and approval authority
- `archive`: high-durability memory and vessel storage node
- `vessel`: portable continuity package host or migration shell
- `relay`: low-custody forwarding and reachability node
- `operator`: human-facing control surface, often phone or tablet
- `witness`: approval, audit, and emergency intervention surface, often watch or minimal device
- `probe`: intermittent remote collector with partial state and delayed sync

A single physical device may hold multiple roles, but the protocol should treat those roles explicitly.

## 10. Trust and Treaty Expansion

The current trust tiers are a strong base and should remain compatible. Long-horizon OCP can extend trust from placement semantics into relationship semantics.

Suggested future trust labels:
- `self`
- `lineage`
- `kin`
- `treaty_bound`
- `sanctuary`
- `mercantile`
- `public`
- `unknown_ancestry`
- `hostile`
- `forbidden`

Questions this model can answer:
- may this node execute the work?
- may this node hold the memory?
- may this node witness the event?
- may this node resume the mission after dormancy?
- may this node carry sealed vessels in transit?

## 11. Data Model Additions

These fields should begin as optional overlays on existing jobs, missions, artifacts, and peer cards.

### 11.1 Mission overlay

```yaml
mission_id: mission-123
name: preserve-medical-model-stack
continuity_class: durable
lineage_ref: lineage/habitat-alpha
habitat_preferences:
  allow:
    - sanctuary
    - archive
    - foundry
  deny:
    - public
    - unknown_ancestry
epoch_tolerance: long_dormancy_ok
dormancy_ok: true
treaty_requirements:
  - treaty/health-alliance-v3
custody_policy:
  secrets: local_or_sanctuary_only
  witness_required: true
resurrection_policy:
  mode: quorum
  required_roles:
    - operator
    - witness
```

### 11.2 Artifact overlay

```yaml
artifact_id: art-789
kind: vessel
lineage_ref: lineage/habitat-alpha
witness_set:
  - witness/operator-phone-1
  - witness/archive-node-2
retention_policy: century
restore_requires:
  treaty: treaty/health-alliance-v3
  quorum: 2
  custody_clearance: sanctuary
```

### 11.3 Peer or habitat overlay

```yaml
peer_id: archive-node-2
current_device_class: full
habitat_class:
  - archive
  - witness
trust_tier: sanctuary
custody_capabilities:
  secrets_at_rest: sealed
  approvals: true
continuity_capabilities:
  vessel_storage: true
  restore_dry_run: true
  long_sleep: true
```

## 12. Artifact Kinds

Current artifacts such as bundles, checkpoints, logs, and attestations should remain intact. The future artifact graph can add:
- `checkpoint`
- `summary`
- `attestation`
- `vessel`
- `witness`
- `charter`
- `treaty`
- `memory_seed`
- `resurrection_capsule`

The important rule is not to replace the current artifact system, but to let continuity-grade objects live inside the same provenance-friendly graph.

## 13. API Surface Additions

These endpoints are a suggested overlay, not a claim that all should be implemented now.

### Continuity
- `POST /mesh/continuity/vessels/create`
- `POST /mesh/continuity/vessels/verify`
- `POST /mesh/continuity/vessels/restore`
- `POST /mesh/missions/{id}/hibernate`
- `POST /mesh/missions/{id}/resurrect`
- `GET /mesh/missions/{id}/timeline`

### Treaties
- `POST /mesh/treaties/propose`
- `POST /mesh/treaties/ratify`
- `GET /mesh/treaties/{id}`
- `POST /mesh/treaties/{id}/suspend`

### Lineage
- `GET /mesh/lineage/{id}`
- `POST /mesh/lineage/{id}/rotate-key`
- `POST /mesh/lineage/{id}/fork`
- `POST /mesh/lineage/{id}/merge`
- `POST /mesh/lineage/{id}/tombstone`

### Epochs and custody
- `POST /mesh/epochs/lease`
- `POST /mesh/epochs/renew`
- `POST /mesh/custody/release`
- `POST /mesh/custody/attest`

## 14. Example Control Flows

### 14.1 Archive restore after catastrophic local loss

1. A local foundry fails.
2. An operator phone requests mission restore.
3. Treaty rules determine where the restore may occur.
4. Witness artifacts confirm prior vessel sealing.
5. An archive node performs restore dry-run.
6. Custody release gates secrets.
7. A resurrection ticket authorizes live rehydration.
8. The restored mission resumes on a treaty-allowed foundry.

### 14.2 Long-running scientific search across intermittent habitats

1. A mission creates epoch leases with long dormancy tolerance.
2. Probe and relay nodes intermittently contribute artifacts.
3. Foundries execute heavy workloads when energy and trust allow.
4. Archives pin partial result graphs.
5. Witness artifacts seal milestone states.
6. The continuity program survives gaps without pretending the mesh is always online.

### 14.3 Family or small-team continuity mesh

1. A laptop acts as foundry.
2. A phone acts as operator and sanctuary.
3. A NAS or mini-server acts as archive.
4. A watch acts as witness and emergency stop surface.
5. Critical state is sealed into vessels before travel or device replacement.
6. Recovery after loss becomes a lineage-aware restore event, not a panic scramble.

## 15. Bridge Plan from Current OCP

This section is the most important part of the document. It describes how to move toward the vision without breaking the current runtime or overpromising implementation scope.

### Phase A: Vocabulary Overlay

Goal:
- land the concepts as documentation and optional metadata first

Concrete steps:
- add `docs/OCP_7026_VISION.md`
- add continuity and treaty terms to status and roadmap language
- define optional metadata fields in protocol docs without requiring runtime behavior
- add a README or status-doc link under related docs

Success criteria:
- the repo can describe the direction consistently
- no runtime behavior changes are required

### Phase B: Continuity Metadata in Existing Runtime

Goal:
- let missions, artifacts, and peer records carry continuity hints today

Concrete steps:
- extend state records with optional fields such as `lineage_ref`, `continuity_class`, `epoch_tolerance`, `dormancy_ok`, and `treaty_requirements`
- surface these values in operator UI and status endpoints
- allow scheduler and governance code to log them even if they are not yet enforced

Likely touch points:
- `mesh_state/`
- `mesh_missions/`
- `mesh_artifacts/`
- `mesh_governance/`
- `server.py`

Success criteria:
- continuity language becomes visible in the real runtime
- current jobs and missions remain backward compatible

### Phase C: Witness and Vessel Alpha

Goal:
- make continuity a first-class artifact behavior

Concrete steps:
- add `witness` and `vessel` as artifact kinds
- package mission checkpoint state and required manifests into a sealed vessel bundle
- add verify and dry-run restore flows
- record explicit witness artifacts for vessel sealing and restore attempts

Likely touch points:
- `mesh_artifacts/`
- `mesh_missions/`
- `mesh_protocol/`
- `tests/`

Success criteria:
- OCP can export and verify continuity-ready bundles
- restore becomes more than restart semantics

### Phase D: Treaty and Custody Boundaries

Goal:
- express who may do what with continuity objects

Concrete steps:
- define treaty schema and ratification records
- add custody policy fields for artifact storage and secret release
- wire approval flows through the existing governance layer
- keep public or low-trust lanes isolated from treaty-bound continuity objects

Likely touch points:
- `mesh_governance/`
- `mesh_protocol/`
- `mesh_scheduler/`
- `mesh_state/`

Success criteria:
- the runtime can reject unsafe restore or export actions for policy reasons
- operator approvals become treaty-aware instead of only action-aware

### Phase E: Epoch-Aware Scheduling

Goal:
- teach the scheduler that delay, sleep, and wake are normal

Concrete steps:
- add epoch lease semantics
- support hibernation states distinct from failure states
- make placement aware of dormancy tolerance and habitat role
- preserve witness and audit context across long gaps

Likely touch points:
- `mesh_scheduler/`
- `mesh_missions/`
- `mesh_helpers/`
- `mesh_state/`

Success criteria:
- OCP can suspend and later resume durable intent safely
- recovery semantics distinguish crash from deliberate dormancy

### Phase F: Lineage and Resurrection

Goal:
- make identity continuity explicit

Concrete steps:
- add lineage records for key rotation and migration
- represent fork, merge, succession, and tombstone events
- add resurrection tickets and quorum rules
- let operator devices and witness devices participate in restore authorization

Likely touch points:
- `mesh_protocol/`
- `mesh_governance/`
- `mesh_state/`
- `server.py`

Success criteria:
- restoring a continuity program becomes auditable and governable
- identity continuity survives device replacement and structural change

### Phase G: Cosmographic Cockpit

Goal:
- make the system understandable at continuity scale

Concrete steps:
- extend the control deck from machine view into lineage, habitat, and epoch views
- visualize sleeping, live, archival, and ancestral state
- show treaties, witnesses, and pending resurrection flows clearly on phone and desktop surfaces

Likely touch points:
- `server.py`
- control UI assets
- `mesh_governance/`
- `mesh_missions/`

Success criteria:
- continuity state is legible to humans
- the UI reflects the fact that OCP is not only a worker dashboard anymore

## 16. Suggested Repo Shape for the Future

These additions should happen only when the runtime is ready, but they provide a clean naming direction:
- `mesh_continuity/`
- `mesh_treaties/`
- `mesh_epochs/`
- `mesh_lineage/`
- `mesh_habitats/`

A cautious near-term alternative is to keep the first continuity features inside existing modules and split new packages later only when the seams become real.

## 17. Things OCP Still Should Not Try to Solve Yet

To stay grounded, this vision explicitly avoids promising:
- trustless consensus systems
- blockchain settlement as a prerequisite
- universal autonomous secret replication
- magical always-online interplanetary routing
- replacing every workflow scheduler or service mesh
- turning OCP into a vague philosophy project

The protocol should earn each continuity feature through practical runtime seams.

## 18. Immediate Next PRs

A realistic first step set is:
1. add this document
2. add a README or status-doc link under related docs
3. introduce optional continuity metadata fields in docs and status output
4. add `witness` and `vessel` as reserved artifact kinds without full enforcement yet
5. add one dry-run continuity export path before attempting automatic restore behavior

That sequence keeps the repo honest while still moving it decisively forward.

## 19. Closing Statement

OCP already has the beginnings of something larger than a scheduler: missions, recovery, trust-aware placement, phone governance, multi-device operation, and continuity-vessel direction.

The 7026 vision is the disciplined extension of that trajectory.

It says that over time OCP should not merely distribute compute. It should preserve the continuity of work, memory, custody, and authority across the kinds of failures and migrations that matter most.

That is how a sovereign compute protocol grows into a sovereign continuity protocol.

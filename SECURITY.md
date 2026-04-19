# Security Policy

## Supported Branches

For now, security fixes are handled on `main`.

## Reporting a Vulnerability

Please do **not** open a public issue with full exploit details.

Use one of these private channels instead:

1. Open a private GitHub security advisory, if available.
2. Otherwise contact the maintainer privately through GitHub.

Please include:

- affected component or endpoint
- reproduction steps
- expected impact
- version or commit if known
- any mitigation ideas you already tested

If your report includes credentials, private keys, or sensitive payloads, redact them where possible.

## What Counts as Security-Sensitive

Priority areas for OCP include:

- peer identity material and handshake flows
- signed envelopes and replay protection
- helper enlistment, autonomy, and policy decisions
- secret delivery and redaction behavior
- artifact verification, replication, and retention
- recovery, checkpoints, and mission continuity surfaces
- operator control endpoints and approval flows

## Project Status

OCP is in active development. Interfaces and trust-policy surfaces are still evolving, so responsible reports are especially valuable at this stage.

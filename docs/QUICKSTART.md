# Quickstart

This is the fastest way to get **The Open Compute Protocol** running locally.

## 1. Clone the repo

```bash
git clone https://github.com/matthewacator-cpu/open-compute-protocol.git
cd open-compute-protocol
```

## 2. Start one local node

```bash
./scripts/start_ocp.sh
```

That script:

- creates a local state directory under `./.local/ocp`
- creates identity and workspace folders
- starts the standalone OCP server with sensible defaults

By default, the node comes up on:

- control deck: `http://127.0.0.1:8421/control`
- manifest: `http://127.0.0.1:8421/mesh/manifest`

## 3. Verify it is alive

In a second terminal:

```bash
curl http://127.0.0.1:8421/mesh/manifest
```

## 4. Run the regression suite

```bash
python3 -m unittest tests.test_sovereign_mesh
python3 server.py --help
```

## Common variations

Use a different port:

```bash
OCP_PORT=8521 ./scripts/start_ocp.sh
```

Bind so another machine on your network can reach it:

```bash
OCP_HOST=0.0.0.0 ./scripts/start_ocp.sh
```

Set a custom node identity:

```bash
OCP_NODE_ID=alpha-node OCP_DISPLAY_NAME=Alpha ./scripts/start_ocp.sh
```

## First multi-machine test

On machine one:

```bash
OCP_HOST=0.0.0.0 OCP_NODE_ID=alpha-node OCP_DISPLAY_NAME=Alpha ./scripts/start_ocp.sh
```

On machine two:

```bash
OCP_HOST=0.0.0.0 OCP_PORT=8422 OCP_NODE_ID=beta-node OCP_DISPLAY_NAME=Beta ./scripts/start_ocp.sh
```

Then confirm each machine can open the other machine's `/mesh/manifest`.

## Notes

- OCP is standalone.
- Personal Mirror can integrate with it, but is not required to run it.
- The main operator surface is `/control`.

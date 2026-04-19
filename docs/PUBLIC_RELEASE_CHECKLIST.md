# Public Release Checklist

Use this before making OCP public or cutting a public milestone.

## Repo Hygiene

- Review `git status` for local-only files.
- Confirm no `.env`, identity material, local state, or generated databases are staged.
- Confirm `.gitignore` still covers runtime state under `.local/` and `.mesh*/`.

## Docs

- README matches the current public baseline.
- `docs/QUICKSTART.md` still works.
- `docs/OCP_STATUS.md` reflects the current implemented surface.
- `SECURITY.md`, `CONTRIBUTING.md`, and `CODE_OF_CONDUCT.md` are still accurate.

## Verification

- `python3 -m unittest tests.test_sovereign_mesh`
- `python3 server.py --help`
- `./scripts/start_ocp.sh --help`

## Release Check

- Confirm license and badges are correct.
- Confirm no internal-only notes or personal-machine paths were added accidentally.
- Confirm new runtime or protocol surfaces are documented before announcing them.

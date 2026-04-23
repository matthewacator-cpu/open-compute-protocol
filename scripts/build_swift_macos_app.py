#!/usr/bin/env python3
"""Build an unsigned native SwiftPM OCP Desktop.app bundle."""

from __future__ import annotations

import argparse
import plistlib
import shutil
import stat
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from ocp_desktop.macos_app import should_exclude


DEFAULT_APP_NAME = "OCP Desktop"
DEFAULT_BUNDLE_ID = "org.opencomputeprotocol.ocpdesktop"


def _copy_repo(repo_root: Path, destination: Path) -> None:
    for source in Path(repo_root).iterdir():
        if should_exclude(source, repo_root):
            continue
        target = destination / source.name
        if source.is_dir():
            shutil.copytree(
                source,
                target,
                ignore=lambda directory, names: [
                    name for name in names if should_exclude(Path(directory) / name, repo_root)
                ],
            )
        else:
            shutil.copy2(source, target)


def _write_info_plist(contents_dir: Path, *, app_name: str, bundle_id: str) -> None:
    plist = {
        "CFBundleDevelopmentRegion": "en",
        "CFBundleDisplayName": app_name,
        "CFBundleExecutable": "OCPDesktop",
        "CFBundleIdentifier": bundle_id,
        "CFBundleInfoDictionaryVersion": "6.0",
        "CFBundleName": app_name,
        "CFBundlePackageType": "APPL",
        "CFBundleShortVersionString": "0.1.6",
        "CFBundleVersion": "1",
        "LSMinimumSystemVersion": "13.0",
        "NSHighResolutionCapable": True,
    }
    with (contents_dir / "Info.plist").open("wb") as handle:
        plistlib.dump(plist, handle)


def build_swift_macos_app(
    repo_root: Path,
    *,
    dist_dir: Path | None = None,
    app_name: str = DEFAULT_APP_NAME,
    bundle_id: str = DEFAULT_BUNDLE_ID,
) -> dict[str, str]:
    root = Path(repo_root).resolve()
    subprocess.run(["swift", "build", "-c", "release", "--product", "OCPDesktop"], cwd=root, check=True)

    executable = root / ".build" / "release" / "OCPDesktop"
    if not executable.exists():
        raise FileNotFoundError(f"Swift build did not produce {executable}")

    output_dir = Path(dist_dir).resolve() if dist_dir else root / "dist"
    app_dir = output_dir / f"{app_name}.app"
    contents_dir = app_dir / "Contents"
    macos_dir = contents_dir / "MacOS"
    resources_dir = contents_dir / "Resources"
    bundled_repo = resources_dir / "open-compute-protocol"

    if app_dir.exists():
        shutil.rmtree(app_dir)
    macos_dir.mkdir(parents=True, exist_ok=True)
    bundled_repo.mkdir(parents=True, exist_ok=True)

    _write_info_plist(contents_dir, app_name=app_name, bundle_id=bundle_id)
    shutil.copy2(executable, macos_dir / "OCPDesktop")
    current = (macos_dir / "OCPDesktop").stat().st_mode
    (macos_dir / "OCPDesktop").chmod(current | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
    _copy_repo(root, bundled_repo)

    return {
        "status": "ok",
        "app_path": str(app_dir),
        "executable": str(macos_dir / "OCPDesktop"),
        "bundled_repo": str(bundled_repo),
        "note": "Unsigned native SwiftPM beta bundle. Requires python3 to run the OCP server.",
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Build an unsigned native SwiftPM OCP Desktop.app bundle.")
    parser.add_argument("--repo-root", default=str(REPO_ROOT))
    parser.add_argument("--dist-dir", default="")
    parser.add_argument("--app-name", default=DEFAULT_APP_NAME)
    parser.add_argument("--bundle-id", default=DEFAULT_BUNDLE_ID)
    args = parser.parse_args(argv)
    result = build_swift_macos_app(
        Path(args.repo_root),
        dist_dir=Path(args.dist_dir) if args.dist_dir else None,
        app_name=args.app_name,
        bundle_id=args.bundle_id,
    )
    for key, value in result.items():
        print(f"{key}: {value}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

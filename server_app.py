from __future__ import annotations

import html
import json
from typing import Any

from mesh import SovereignMesh


def _node_summary(mesh: SovereignMesh) -> dict[str, Any]:
    manifest = mesh.get_manifest()
    card = dict(manifest.get("organism_card") or {})
    profile = dict(manifest.get("device_profile") or card.get("device_profile") or {})
    return {
        "node_id": card.get("node_id") or manifest.get("node_id") or getattr(mesh, "node_id", "ocp-node"),
        "display_name": card.get("display_name") or getattr(mesh, "display_name", "OCP Node"),
        "device_class": profile.get("device_class") or "unknown",
        "form_factor": profile.get("form_factor") or "device",
        "protocol_release": manifest.get("protocol_release") or "0.1",
        "protocol_version": manifest.get("protocol_version") or "",
    }


def build_app_manifest(mesh: SovereignMesh) -> dict[str, Any]:
    summary = _node_summary(mesh)
    display_name = str(summary.get("display_name") or "OCP Node")
    return {
        "name": f"OCP App - {display_name}",
        "short_name": "OCP",
        "description": "One local-first app for OCP setup, control, and protocol inspection.",
        "start_url": "/app",
        "scope": "/",
        "display": "standalone",
        "background_color": "#f7f0e6",
        "theme_color": "#112437",
        "categories": ["productivity", "utilities"],
    }


def build_app_page(mesh: SovereignMesh) -> str:
    summary = _node_summary(mesh)
    bootstrap_json = html.escape(json.dumps(summary, sort_keys=True), quote=True)
    node_id = html.escape(str(summary.get("node_id") or "ocp-node"))
    display_name = html.escape(str(summary.get("display_name") or "OCP Node"))
    device_class = html.escape(str(summary.get("device_class") or "unknown"))
    form_factor = html.escape(str(summary.get("form_factor") or "device"))
    protocol = html.escape(str(summary.get("protocol_release") or "0.1"))
    version = html.escape(str(summary.get("protocol_version") or ""))
    version_label = f" / {version}" if version else ""

    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
  <meta name="theme-color" content="#112437">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-title" content="OCP">
  <link rel="manifest" href="/app.webmanifest">
  <title>OCP App</title>
  <style>
    :root {{
      --ink: #132132;
      --muted: #5f6875;
      --paper: #fffaf3;
      --paper-strong: #fffdf8;
      --line: rgba(19, 33, 50, 0.13);
      --blue: #0c5c78;
      --green: #1d7d58;
      --gold: #a86c24;
      --shadow: 0 24px 70px rgba(45, 33, 18, 0.16);
    }}
    * {{ box-sizing: border-box; }}
    html {{ scroll-behavior: smooth; }}
    body {{
      margin: 0;
      min-height: 100vh;
      color: var(--ink);
      font-family: ui-sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background:
        radial-gradient(circle at 12% 6%, rgba(168, 108, 36, 0.18), transparent 25%),
        radial-gradient(circle at 88% 0%, rgba(12, 92, 120, 0.16), transparent 28%),
        linear-gradient(180deg, #fff8ec 0%, #f2eadf 100%);
    }}
    a {{ color: inherit; }}
    button {{ font: inherit; }}
    .app-shell {{
      width: min(1240px, 100%);
      margin: 0 auto;
      padding: 18px clamp(14px, 3vw, 28px) 32px;
    }}
    .hero {{
      display: grid;
      grid-template-columns: minmax(0, 1.5fr) minmax(260px, 0.7fr);
      gap: 18px;
      align-items: stretch;
      margin-bottom: 16px;
    }}
    .panel {{
      background: rgba(255, 250, 243, 0.9);
      border: 1px solid var(--line);
      border-radius: 28px;
      box-shadow: var(--shadow);
      backdrop-filter: blur(16px);
    }}
    .intro {{
      padding: clamp(22px, 4vw, 38px);
      position: relative;
      overflow: hidden;
    }}
    .intro::after {{
      content: "";
      position: absolute;
      width: 190px;
      height: 190px;
      right: -70px;
      top: -70px;
      border-radius: 999px;
      background: conic-gradient(from 180deg, rgba(12, 92, 120, 0.22), rgba(168, 108, 36, 0.28), transparent);
    }}
    .eyebrow {{
      margin: 0 0 12px;
      color: var(--blue);
      font-size: 0.78rem;
      font-weight: 800;
      letter-spacing: 0.14em;
      text-transform: uppercase;
    }}
    h1 {{
      max-width: 780px;
      margin: 0;
      font-size: clamp(2.25rem, 8vw, 5.75rem);
      line-height: 0.88;
      letter-spacing: -0.08em;
    }}
    .lead {{
      max-width: 760px;
      margin: 18px 0 0;
      color: var(--muted);
      font-size: clamp(1rem, 2.5vw, 1.22rem);
      line-height: 1.55;
    }}
    .node-card {{
      padding: 22px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      gap: 18px;
    }}
    .node-card h2 {{ margin: 0 0 6px; font-size: 1.3rem; }}
    .node-card p {{ margin: 0; color: var(--muted); line-height: 1.45; }}
    .chips {{
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-top: 16px;
    }}
    .chip {{
      display: inline-flex;
      border: 1px solid var(--line);
      border-radius: 999px;
      padding: 8px 10px;
      background: rgba(255, 255, 255, 0.58);
      color: #24364a;
      font-size: 0.82rem;
      font-weight: 700;
    }}
    .install {{
      border-radius: 20px;
      padding: 14px;
      background: #112437;
      color: #fff9ed;
    }}
    .install strong {{ display: block; margin-bottom: 4px; }}
    .install span {{ color: rgba(255, 249, 237, 0.75); font-size: 0.9rem; line-height: 1.4; }}
    .tabs {{
      position: sticky;
      top: 0;
      z-index: 20;
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 8px;
      padding: 10px;
      margin-bottom: 14px;
      border: 1px solid var(--line);
      border-radius: 24px;
      background: rgba(255, 250, 243, 0.88);
      backdrop-filter: blur(18px);
      box-shadow: 0 18px 40px rgba(45, 33, 18, 0.12);
    }}
    .tab {{
      min-height: 48px;
      border: 0;
      border-radius: 16px;
      background: transparent;
      color: #34455a;
      font-weight: 800;
      cursor: pointer;
    }}
    .tab[aria-selected="true"] {{
      color: #fff9ed;
      background: linear-gradient(135deg, #112437, #0c5c78);
      box-shadow: 0 10px 22px rgba(12, 92, 120, 0.22);
    }}
    .module {{
      display: none;
      overflow: hidden;
      min-height: 68vh;
    }}
    .module.active {{ display: block; }}
    .module-head {{
      display: flex;
      justify-content: space-between;
      gap: 14px;
      align-items: center;
      padding: 16px 18px;
      border-bottom: 1px solid var(--line);
      background: rgba(255, 253, 248, 0.8);
    }}
    .module-head h2 {{ margin: 0; font-size: 1.1rem; }}
    .module-head p {{ margin: 4px 0 0; color: var(--muted); font-size: 0.92rem; }}
    .open-link {{
      flex: 0 0 auto;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border-radius: 999px;
      padding: 10px 12px;
      background: #fff;
      border: 1px solid var(--line);
      color: var(--blue);
      font-size: 0.88rem;
      font-weight: 800;
      text-decoration: none;
    }}
    iframe {{
      display: block;
      width: 100%;
      min-height: 76vh;
      border: 0;
      background: #fffaf3;
    }}
    .protocol-grid {{
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 12px;
      padding: 16px;
    }}
    .protocol-card {{
      min-height: 170px;
      padding: 18px;
      border: 1px solid var(--line);
      border-radius: 22px;
      background: rgba(255, 253, 248, 0.8);
      text-decoration: none;
    }}
    .protocol-card span {{
      color: var(--muted);
      font-size: 0.82rem;
      font-weight: 800;
      letter-spacing: 0.08em;
      text-transform: uppercase;
    }}
    .protocol-card strong {{
      display: block;
      margin: 10px 0 8px;
      font-size: 1.2rem;
    }}
    .protocol-card p {{
      margin: 0;
      color: var(--muted);
      line-height: 1.45;
    }}
    .protocol-actions {{
      padding: 0 16px 16px;
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }}
    .action {{
      border: 0;
      border-radius: 16px;
      padding: 12px 14px;
      background: var(--green);
      color: white;
      font-weight: 800;
      cursor: pointer;
    }}
    .contract-preview {{
      margin: 0 16px 16px;
      max-height: 340px;
      overflow: auto;
      white-space: pre-wrap;
      padding: 14px;
      border-radius: 18px;
      border: 1px solid var(--line);
      background: #101b2a;
      color: #e9f3ff;
      font-size: 0.78rem;
      line-height: 1.5;
    }}
    @media (max-width: 780px) {{
      .hero {{ grid-template-columns: 1fr; }}
      .tabs {{ border-radius: 20px; }}
      .tab {{ min-height: 44px; font-size: 0.92rem; }}
      .module-head {{ align-items: flex-start; flex-direction: column; }}
      .open-link {{ width: 100%; }}
      .protocol-grid {{ grid-template-columns: 1fr; }}
      iframe {{ min-height: 72vh; }}
    }}
  </style>
</head>
<body>
  <main class="app-shell" data-ocp-app="{bootstrap_json}">
    <section class="hero">
      <div class="panel intro">
        <p class="eyebrow">Open Compute Protocol</p>
        <h1>One app for the mesh.</h1>
        <p class="lead">
          OCP App brings setup, the phone control deck, and protocol inspection into one installable local-first surface.
          The old routes still work: <strong>/easy</strong> for OCP Easy Setup and <strong>/control</strong> for OCP Control Deck.
        </p>
      </div>
      <aside class="panel node-card" aria-label="Current OCP node">
        <div>
          <p class="eyebrow">This node</p>
          <h2>{display_name}</h2>
          <p>{node_id}</p>
          <div class="chips">
            <span class="chip">{device_class}</span>
            <span class="chip">{form_factor}</span>
            <span class="chip">OCP {protocol}{version_label}</span>
          </div>
        </div>
        <div class="install">
          <strong>Install this app</strong>
          <span>On your phone, open this page, choose Share or browser menu, then Add to Home Screen.</span>
        </div>
      </aside>
    </section>

    <nav class="tabs" aria-label="OCP app sections">
      <button class="tab" type="button" data-tab="setup" aria-selected="true">Setup</button>
      <button class="tab" type="button" data-tab="control" aria-selected="false">Control</button>
      <button class="tab" type="button" data-tab="protocol" aria-selected="false">Protocol</button>
    </nav>

    <section id="setup" class="panel module active" aria-label="OCP Easy Setup module">
      <div class="module-head">
        <div>
          <h2>OCP Easy Setup</h2>
          <p>Pair nearby machines, copy the easy link, scan QR, and test the whole mesh.</p>
        </div>
        <a class="open-link" href="/easy">Open /easy directly</a>
      </div>
      <iframe title="OCP Easy Setup" src="/easy"></iframe>
    </section>

    <section id="control" class="panel module" aria-label="OCP Control Deck module">
      <div class="module-head">
        <div>
          <h2>OCP Control Deck</h2>
          <p>Operate missions, queues, approvals, helpers, artifacts, treaties, and live mesh state from the phone.</p>
        </div>
        <a class="open-link" href="/control">Open /control directly</a>
      </div>
      <iframe title="OCP Control Deck" src="/control" loading="lazy"></iframe>
    </section>

    <section id="protocol" class="panel module" aria-label="OCP protocol module">
      <div class="module-head">
        <div>
          <h2>Protocol</h2>
          <p>Inspect the live wire contract and node manifest without leaving the app.</p>
        </div>
        <a class="open-link" href="/mesh/contract">Open /mesh/contract</a>
      </div>
      <div class="protocol-grid">
        <a class="protocol-card" href="/mesh/manifest">
          <span>Runtime</span>
          <strong>Manifest</strong>
          <p>Identity, device profile, capabilities, and compatibility facts advertised by this node.</p>
        </a>
        <a class="protocol-card" href="/mesh/contract">
          <span>Protocol</span>
          <strong>HTTP Contract</strong>
          <p>The versioned route registry, schema references, and request validation surface.</p>
        </a>
        <a class="protocol-card" href="/mesh/device-profile">
          <span>Device</span>
          <strong>Profile</strong>
          <p>How this device describes its compute class, mobility, power, and sync posture.</p>
        </a>
      </div>
      <div class="protocol-actions">
        <button class="action" type="button" data-fetch-contract>Preview contract</button>
      </div>
      <pre class="contract-preview" data-contract-preview>Press "Preview contract" to fetch /mesh/contract.</pre>
    </section>
  </main>

  <script>
    const tabs = Array.from(document.querySelectorAll("[data-tab]"));
    const modules = Array.from(document.querySelectorAll(".module"));
    const activate = (name) => {{
      tabs.forEach((tab) => tab.setAttribute("aria-selected", String(tab.dataset.tab === name)));
      modules.forEach((module) => module.classList.toggle("active", module.id === name));
      if (window.location.hash !== "#" + name) {{
        history.replaceState(null, "", name === "setup" ? window.location.pathname : "#" + name);
      }}
    }};
    tabs.forEach((tab) => tab.addEventListener("click", () => activate(tab.dataset.tab)));
    const initial = window.location.hash.replace("#", "");
    if (["setup", "control", "protocol"].includes(initial)) activate(initial);

    const preview = document.querySelector("[data-contract-preview]");
    const fetchButton = document.querySelector("[data-fetch-contract]");
    fetchButton?.addEventListener("click", async () => {{
      preview.textContent = "Loading /mesh/contract...";
      try {{
        const response = await fetch("/mesh/contract");
        const payload = await response.json();
        preview.textContent = JSON.stringify(payload, null, 2);
      }} catch (error) {{
        preview.textContent = "Unable to fetch /mesh/contract: " + error;
      }}
    }});
  </script>
</body>
</html>"""


__all__ = ["build_app_manifest", "build_app_page"]

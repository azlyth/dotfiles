# Pi environment (global)

This machine is **berryfive** — a Raspberry Pi 5 running Debian 13 (trixie),
arm64. It's an always-on home server, not a workstation. LAN IP (`wlan0`) is
`192.168.1.185`; also on a tailnet (`tailscale`). This file loads in every
session on the Pi, in any directory. Machine-wide facts live here; per-project
detail lives in each project's own CLAUDE.md.

## Working here

- **`sudo` is passwordless** for user `peter` — `NOPASSWD: ALL` via
  `/etc/sudoers.d/010_peter-nopasswd`. Run privileged steps yourself (restart
  systemd services, install packages, edit system config); no need to hand them
  off. Still prefer a project's documented path (e.g. `make svc-restart`) over
  ad-hoc commands, and confirm before anything destructive/outward-facing.
- Long-running services are **boot-persistent** — systemd units for native apps,
  `docker compose` for containerized ones. When you change a service, restart it
  the way that project documents; don't assume a bare re-run.
- Projects live under `~/projects/{personal,common37}`. Each is self-contained
  with its own CLAUDE.md — read it before working in a project.

## The backlog repo

`~/projects/personal/backlog` (GitHub: `azlyth/backlog`) is the **parking lot for
potential projects and future specs** — ideas worth capturing before they
evaporate, but not being built yet. Each idea is one Markdown file; the
`README.md` is the index. Deliberately low-ceremony: no build, no service, not
wired into the fleet. When an idea graduates into real work it moves out into its
own project under `~/projects/personal/`. When a session surfaces a "someday"
idea or a researched-but-shelved plan, drop it here as a note (and update the
README index) rather than losing it.

## The front door: http-routing

`~/projects/personal/http-routing` is the Pi's **single HTTPS front door** — a
host-networked Caddy reverse proxy owning `192.168.1.185:443` (+ `:80`
redirects), terminating TLS and routing by Host header to loopback backends.
Certs are self-issued via Cloudflare DNS-01 (no inbound ACME). A sibling
**cloudflared** tunnel adds outbound-only public ingress for hosts meant to be
on the open internet.

- **Don't casually restart Caddy.** The Caddyfile is a single-file bind mount, so
  reload/restart serve the stale inode — editing it needs
  `docker compose up -d --force-recreate caddy`.
- **LAN-only hosts** are grey-cloud A records → private IP (added by hand to
  Caddy's explicit `domains` list; auto-discovery is OFF). **Public hosts** are
  orange-cloud CNAMEs → the cloudflared tunnel; keep them OUT of Caddy's DNS list.
  Adding a public host = Caddy site block + `cloudflared/config.yml` ingress +
  `cloudflared tunnel route dns`.
- Two DNS zones on the same Cloudflare account: **ubbe.nyc** (personal / home
  services) and **astoria.app** (public Astoria projects). The route table and
  the full "add a service" flow live in `http-routing/CLAUDE.md` — check there,
  it changes more often than this file.

## Reaching the Pi remotely

- **persistent-claude** — a systemd unit running `claude rc` (remote control)
  always-on in `personal/`, so Claude here is reachable from the phone /
  claude.ai (outbound-only, no proxy). Spawns sessions in `auto` permission mode.
- **tortoise** — a web terminal (fronted by Caddy at `pi.tortoise.ubbe.nyc`),
  the non-Claude phone path to a shell.

## Fleet map

The full inventory of `personal/` projects and how they relate is kept in the
memory index (`MEMORY.md` → `personal-fleet.md`), which loads automatically when
working in that tree. Consult it for the project rundown rather than restating it
here.

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
- **Self-verify web UIs with headless Chromium** (`/usr/bin/chromium`). Screenshot
  a locally-running app and `Read` the PNG to actually see your work instead of
  guessing — iterate on layout/legibility before handing off. Example:
  `chromium --headless=new --no-sandbox --disable-gpu --hide-scrollbars
  --user-data-dir=/tmp/chromeprofile --window-size=412,915 --virtual-time-budget=8000
  --screenshot=/tmp/shot.png http://127.0.0.1:<port>/` (rm the profile dir between
  runs for a clean cache; hit the loopback origin to bypass Cloudflare caching).

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

## AWS / cloud resources

When any project needs an AWS resource (SES email, S3, IAM, …), it goes through
**`~/projects/personal/personal-cloud-infra`** — OpenTofu (Terraform fork) IaC,
**never** console click-ops. One account (`265217855447`), reusable
`modules/<service>` × `environments/{dev,prod}` roots, encrypted S3 state (first
consumer: spruce's SES magic-link email). To add a resource: extend/add a module +
a `module` block in each env root, then `make plan-<env>` / `make apply-<env>`. Read
that repo's `CLAUDE.md`/`README.md` for the runbook. **Scope every resource by service
— in name AND `Service` tag** (`uptime-kuma-mailer-prod`); IAM inline policies + access
keys can't be tagged in AWS, so those are scoped by name only. **Service emails send
from the service's own domain** (`login@spruce.ubbe.nyc`, `alerts@uptime.ubbe.nyc`), not
a shared `send.` subdomain — each sender gets its own DKIM-verified SES identity.

- **Auth = IAM Identity Center SSO, no persisted keys.** Profile
  `personal-cloud-infra` (`~/.aws/config`; `superadmin` on `265217855447`,
  us-east-1), token lasts ~8–12h. Check with `aws sts get-caller-identity
  --profile personal-cloud-infra`.
- **Re-auth from any Claude conversation (device-code, cross-device):** run, in the
  background, `BROWSER=/bin/true aws sso login --profile personal-cloud-infra
  --use-device-code` — it prints a verification URL + `user_code` and then *polls*.
  **Give Peter the autofill link** `https://ssoins-722347cfbf7ebdeb.us-east-1.portal.amazonaws.com/#/device?user_code=XXXX-XXXX`
  to approve in his own browser; the command completes once he authorizes.
  Gotchas learned the hard way: **`--use-device-code` is required** (the plain
  `--no-browser` default is a `127.0.0.1` localhost-callback PKCE flow that can't work
  from another device), but do **NOT** combine `--use-device-code` with `--no-browser`
  — that combo fails instantly with `invalid_grant / Invalid device code provided`.
  `BROWSER=/bin/true` just stops it hanging on a headless browser-open. If a code gets
  wedged, clear `~/.aws/sso/cache/*.json` and retry. The Makefile exports
  `AWS_PROFILE=personal-cloud-infra`.
- **If the login times out** (the code expires before Peter approves — a lapsed code
  fails with the same `invalid_grant / Invalid device code provided`), do **NOT**
  auto-retry or spew fresh codes into the void: just tell Peter it timed out and that
  you'll mint a new code whenever he's ready at his browser. Codes only live a few
  minutes, so mint one *when he signals he's ready*, not speculatively.
- **Secrets:** `*.tfstate` / `*.tfvars` / `backend.hcl` / AWS creds are gitignored —
  never commit them. Scoped product keys (e.g. spruce's send-only SES key) are read
  via `tofu output -raw …` and synced into the consumer's `.env`, not pasted around.

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

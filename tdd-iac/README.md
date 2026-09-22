# TDD IaC demo: nginx improvements

Prerendered, step-by-step TDD kata for the nginx VM, in the same spirit as
[`tdd-python/`](../tdd-python): each `step-NN` directory is a complete,
runnable snapshot — its own `playbook.yml` plus its own full `test/` tree
(all three InSpec tiers, even the ones that didn't change this step) — so you
never have to jump between directories mid-demo. Steps are cumulative: each
one's playbook carries forward everything the previous step added.

Shared VM infrastructure (`compose.yml`, `inventory.ini`, `ansible.cfg`,
`demo-key`) stays at the repo root; only what a step actually teaches — the
playbook and the tests — lives under `tdd-iac/`.

Run any step from the repo root with:

```bash
./run-playbook.sh 01   # or 02, etc.
./run-tests.sh 01
```

(no argument still runs the root-level `playbook.yml`/`test/`, unchanged.)

## Before step 1: the RED that motivates it

This kata assumes `compose.yml` already points at `v2/Dockerfile` (the
hardened image, default-deny inbound firewall). With `v2` and the
**root-level** `playbook.yml`/`test/` (unchanged, same as `v1`), the existing
`index-reachable-over-network-is-neutral` control fails: connection refused.
Config and local-behaviour tests don't notice — only the network tier does.
That failure is the live demo's cold open; it lives at the repo root, not as
a `tdd-iac` step, since no code changes yet.

| Step | State | What changes |
| --- | --- | --- |
| [01](step-01) | GREEN | Fix: open `tcp dport 80` in nftables, reload the firewall. Resolves the RED above. Assumes v2 (`/etc/nftables.conf` exists) — the kata doesn't go back to v1 from here on, so the playbook doesn't guard for it. |
| [02](step-02) | RED | Test: an off-box `GET /health` must return `200` with a plain `ok` body. |
| [03](step-03) | GREEN | Impl: nginx site config (`files/etc/nginx/sites-available/default`) adds a `/health` location, reloaded via a handler. |
| [04](step-04) | RED | Test: an off-box request for an unknown path must return `404` with a neutral, custom body — not nginx's stock page. |
| [05](step-05) | GREEN | Impl: a neutral `404.html` plus `error_page 404 /404.html;` in the site config. |
| [06](step-06) | GREEN (refactor) | Externalize the inline `index.html` from `playbook.yml` into `files/var/www/html/index.html`, same as the other served files. No test changes — the point of a refactor step is that nothing here should need one. |

Bonus catches along the way:
- **Step 4, while RED**: nginx's `try_files ... =404` already returns status
  `404` (that half of the control already passes) — but the *body* is still
  the stock nginx page, which names `nginx`. A status-only check would have
  missed it; the body assertion is what actually drives the fix.
- **Step 2, while RED**: the stock nginx 404 page (what `/health` returns
  before step-03) names `nginx` in its body — the same leak the index-page
  tests already guard against, just not yet covered for other paths.
- **Step 1's first draft** used `ansible.builtin.service: state: restarted`
  to apply the firewall change. `nftables.service`'s `ExecStop` runs a bare
  `nft flush ruleset` — restarting (stop+start) wipes Docker's own DNS NAT
  rules along with our table, silently breaking `apt` on the *next* playbook
  run. Fixed by using `state: reloaded` (systemd's `ExecReload` calls
  `nft -f` directly, no stop/flush). Worth calling out live: a real
  infra landmine that TDD around HTTP behaviour alone wouldn't have caught —
  it only showed up as an unrelated `apt` failure one run later.

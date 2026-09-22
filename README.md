# Test Driven Development with Infrastructure as Code

Small demo that shows how to do [Test Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) (TDD)
with [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) (IaC).

IaC covers two main areas: provisioning (creating resources) and configuration (configuring those resources).
This demo only covers configuration. It uses [Ansible](https://ansible.com) for configuration management and
[Cinc Auditor](https://cinc.sh/docs/auditor/) to perform tests.

The subject of this demo is a fake VM: a Docker container acting like a VM. Using a Docker container instead of
a VM makes it much faster to repeat certain actions. We'll be configuring this VM using Ansible with SSH.

## Instructions

```bash
./setup.sh
./run-tests.sh
./run-playbook.sh
./run-tests.sh
```

Update compose.yml to use v2, then

```bash
./reset.sh
./run-playbook.sh
./run-tests.sh
```

To clean up:

```bash
./cleanup.sh
```

## Unit test intro: `is_ip_address`

[`unit-test-python/`](unit-test-python) is a small, finished (non-TDD) example for introducing what a unit test
is before diving into the TDD kata below: a strict IPv4 validator (`is_ip_address.py`) with three tests
(`test_is_ip_address.py`). It's deliberately unrelated to bucket names, and deliberately stricter than the
shape-only IP check the kata below reaches for — that contrast gets reused in [step 22](tdd-python/step-22).

## TDD demo: `is_valid_bucket_name`

[`tdd-python/`](tdd-python) contains a prerendered, step-by-step TDD kata that builds up a function validating S3
bucket names. Each `step-NN` directory is a complete, runnable snapshot: `test_bucket_name.py` plus
`bucket_name.py`. Every step is either RED (a failing test drives the next bit of behaviour) or GREEN (the simplest
implementation that satisfies all tests so far) — running `pytest` inside a step directory always compiles and
always reports a clear pass/fail, never a crash. The matching [VS Code snippets](.vscode/tdd-bucket-demo.code-snippets)
(`py.step-01` .. `py.step-22`) let you type the same progression live instead of jumping between directories.

| Step | State | What changes |
| --- | --- | --- |
| [01](tdd-python/step-01) | RED | Test: empty string is invalid |
| [02](tdd-python/step-02) | GREEN | Impl: dumbest possible (`return False`) |
| [03](tdd-python/step-03) | RED | Test: a real name (`mybucket`) should be valid |
| [04](tdd-python/step-04) | GREEN | Impl: any non-empty name is valid |
| [05](tdd-python/step-05) | RED | Test: shorter than 3 chars is invalid |
| [06](tdd-python/step-06) | GREEN | Impl: enforce minimum length |
| [07](tdd-python/step-07) | RED | Test: longer than 63 chars is invalid |
| [08](tdd-python/step-08) | GREEN | Impl: enforce length range (3–63) |
| [09](tdd-python/step-09) | RED | Test: uppercase letters are invalid |
| [10](tdd-python/step-10) | GREEN | Impl: enforce lowercase |
| [11](tdd-python/step-11) | RED | Test: underscore is invalid |
| [12](tdd-python/step-12) | GREEN | Impl: restrict to letters only (`str.isalpha`) |
| [13](tdd-python/step-13) | RED | Test: a hyphen should be valid — letters-only was too strict |
| [14](tdd-python/step-14) | GREEN | Impl: allow hyphen too (still a simple character check) |
| [15](tdd-python/step-15) | RED | Test: digits should be valid |
| [16](tdd-python/step-16) | GREEN | Impl: allow digits too (still a simple character check) |
| [17](tdd-python/step-17) | RED (surprise) | Refactor: character checks become a regex — first-time mistake: `.match` instead of `.fullmatch` |
| [18](tdd-python/step-18) | GREEN | Fix: `.match` → `.fullmatch` (spot another optimization, see abstractions) |
| [19](tdd-python/step-19) | GREEN | Refactor: split into named helper functions (no new test, regex was already correct) |
| [20](tdd-python/step-20) | RED | Test: a name shaped like an IP address is invalid |
| [21](tdd-python/step-21) | GREEN | Impl: final version, ready to pivot to IaC |
| [22](tdd-python/step-22) | GREEN | Refactor: replace `looks_like_ip_address` with the properly tested [`is_ip_address`](unit-test-python/is_ip_address.py) (no new test, everything still passes) |

Run any step's tests with:

```bash
pytest tdd-python/step-01
```

## TDD IaC demo: nginx improvements

[`tdd-iac/`](tdd-iac) contains a prerendered, step-by-step TDD kata for the nginx VM, in the same spirit as
[`tdd-python/`](tdd-python) above: each `step-NN` directory is a complete, runnable snapshot — its own
`playbook.yml` plus its own full `test/` tree (all three InSpec tiers, even the ones that didn't change this
step) — so you never have to jump between directories mid-demo. Steps are cumulative: each one's playbook
carries forward everything the previous step added.

Shared VM infrastructure (`compose.yml`, `inventory.ini`, `ansible.cfg`, `demo-key`) stays at the repo root;
only what a step actually teaches — the playbook and the tests — lives under `tdd-iac/`.

Run any step from the repo root with:

```bash
./run-playbook.sh 01   # or 02, etc.
./run-tests.sh 01
```

(no argument still runs the root-level `playbook.yml`/`test/`, unchanged.)

### Before step 1: the RED that motivates it

This kata assumes `compose.yml` already points at `v2/Dockerfile` (the hardened image, default-deny inbound
firewall). With `v2` and the **root-level** `playbook.yml`/`test/` (unchanged, same as `v1`), the existing
`index-reachable-over-network-is-neutral` control fails: connection refused. Config and local-behaviour tests
don't notice — only the network tier does. That failure is the live demo's cold open; it lives at the repo
root, not as a `tdd-iac` step, since no code changes yet.

| Step | State | What changes |
| --- | --- | --- |
| [01](tdd-iac/step-01) | GREEN | Fix: open `tcp dport 80` in nftables, reload the firewall. Resolves the RED above. Assumes v2 (`/etc/nftables.conf` exists) — the kata doesn't go back to v1 from here on, so the playbook doesn't guard for it. |
| [02](tdd-iac/step-02) | RED | Test: an off-box `GET /health` must return `200` with a plain `ok` body. |
| [03](tdd-iac/step-03) | GREEN | Impl: nginx site config (`files/etc/nginx/sites-available/default`) adds a `/health` location, reloaded via a handler. |
| [04](tdd-iac/step-04) | RED | Test: an off-box request for an unknown path must return `404` with a neutral, custom body — not nginx's stock page. |
| [05](tdd-iac/step-05) | GREEN | Impl: a neutral `404.html` plus `error_page 404 /404.html;` in the site config. |
| [06](tdd-iac/step-06) | GREEN (refactor) | Externalize the inline `index.html` from `playbook.yml` into `files/var/www/html/index.html`, same as the other served files. No test changes — the point of a refactor step is that nothing here should need one. |

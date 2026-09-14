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

## Ideas

- Have a working playbook with green tests. Then switch to an updated fresh VM, handed to you by another department.
  This VM has firewall enabled that blocks everything by default. The playbook runs successfully but you can't reach
  the page.
- Add one or two improvements using TDD: custom 404 page, health endpoint
- Refactor: move inline index.html to file.

## TDD demo: `is_valid_bucket_name`

[`tdd-python/`](tdd-python) contains a prerendered, step-by-step TDD kata that builds up a function validating S3
bucket names. Each `step-NN` directory is a complete, runnable snapshot: `test_bucket_name.py` plus
`bucket_name.py`. Every step is either RED (a failing test drives the next bit of behaviour) or GREEN (the simplest
implementation that satisfies all tests so far) — running `pytest` inside a step directory always compiles and
always reports a clear pass/fail, never a crash. The matching [VS Code snippets](.vscode/tdd-bucket-demo.code-snippets)
(`py.step-01` .. `py.step-21`) let you type the same progression live instead of jumping between directories.

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

Run any step's tests with:

```bash
pytest tdd-python/step-01
```

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

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
./teardown.sh
```

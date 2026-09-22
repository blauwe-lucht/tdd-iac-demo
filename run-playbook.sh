#!/bin/bash

set -euo pipefail

dir="."
if [[ $# -ge 1 ]]; then
  dir="tdd-iac/step-${1}"
fi

ansible-playbook "${dir}/playbook.yml"

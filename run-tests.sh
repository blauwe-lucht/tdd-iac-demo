#!/bin/bash

set -uo pipefail

rc=0

# from-vm profiles run ON the VM (over SSH): they see localhost and declared state.
for p in from-vm-config from-vm-behaviour; do
  echo "===================== ${p} ====================="
  cinc-auditor exec "test/${p}" \
    --target "ssh://root@172.28.0.11" \
    --key-files demo-key \
    --chef-license accept-silent || rc=1
done

# to-vm profile runs on the HOST as an external client, reaching the VM over the network.
echo "===================== to-vm-behaviour ====================="
cinc-auditor exec test/to-vm-behaviour \
  --target "local://" \
  --chef-license accept-silent || rc=1

exit "${rc}"

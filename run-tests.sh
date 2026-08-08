#!/bin/bash

set -euo pipefail

cinc-auditor exec test/nginx \
  --target "ssh://root@172.28.0.11" \
  --key-files demo-key \
  --chef-license accept-silent \
  --no-color \
  "$@"

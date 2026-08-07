#!/bin/bash

set -euo pipefail

docker compose down
docker compose up -d --build

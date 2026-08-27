#!/usr/bin/env bash
set -euo pipefail

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

grep -Fqx 'shm_opts=""' "$repo_root/config.sh"
grep -Fqx '        $shm_opts \' "$repo_root/lab-new.sh"
grep -Fq 'shm_opts="--shm-size=2g"' "$repo_root/README.md"

echo 'shared-memory runtime option regression test passed'

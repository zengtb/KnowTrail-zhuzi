#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/_common.sh"
cd "$ROOT"
exec $PYTHON "$AGENT_DIR/wiki/lint-wiki-format.py"

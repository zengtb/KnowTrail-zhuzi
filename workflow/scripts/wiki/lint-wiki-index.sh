#!/usr/bin/env bash
# 检查专题注册和索引链接。
set -euo pipefail
source "$(dirname "$0")/../lib/_common.sh"
cd "$ROOT"
exec $PYTHON "$AGENT_DIR/wiki/wiki_links.py" index

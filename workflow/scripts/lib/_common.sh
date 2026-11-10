# 公共路径与配置；不选择或修改 JDK。
AGENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(cd "$AGENT_DIR/../.." && pwd)"

# WindowsApps 里的 python3 是商店占位，调用即失败。跳过它，再试 py -3。
workflow_python() {
  local candidate version_line
  local -a found=()
  if command -v python3 >/dev/null 2>&1; then
    found+=("$(command -v python3)")
  fi
  shopt -s nullglob
  found+=(/usr/bin/python3 /usr/local/bin/python3 \
    "$LOCALAPPDATA"/Programs/Python/Python3*/python.exe \
    "$LOCALAPPDATA"/Python/pythoncore-*/python.exe)
  shopt -u nullglob
  for candidate in "${found[@]}"; do
    [ -n "$candidate" ] && [ -x "$candidate" ] || continue
    case "$candidate" in
      *[Ww]indows[Aa]pps/*) continue ;;
    esac
    version_line="$("$candidate" -c 'import sys; print("%d.%d" % sys.version_info[:2])' 2>/dev/null)" || continue
    case "$version_line" in
      3.[9-9]|3.[1-9][0-9]) printf '%s\n' "$candidate"; return 0 ;;
    esac
  done
  if command -v py >/dev/null 2>&1 && py -3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 9) else 1)' >/dev/null 2>&1; then
    printf '%s\n' "py -3"
    return 0
  fi
  echo "ERROR: 找不到 Python 3.9+。PATH 中的 python3 若来自 WindowsApps，是商店占位，不是解释器。" >&2
  return 1
}

PYTHON="$(workflow_python)" || { return 2 2>/dev/null || exit 2; }
export PYTHONUTF8=1
export PYTHONIOENCODING=utf-8
_config_exports="$($PYTHON "$AGENT_DIR/lib/workflow_support.py" shell)" || { return 2 2>/dev/null || exit 2; }
eval "$_config_exports"
workflow_has_pack() { case ",${WORKFLOW_PACKS}," in *",$1,"*) return 0;; *) return 1;; esac; }

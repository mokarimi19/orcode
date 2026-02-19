#!/usr/bin/env bash
# orcode installer — sets up OpenRouter for Claude Code
# Usage: curl -fsSL https://raw.githubusercontent.com/mokarimi19/orcode/main/install.sh | bash

set -euo pipefail

REPO="mokarimi19/orcode"
INSTALL_DIR="${ORCODE_INSTALL_DIR:-$HOME/.local/bin}"
SCRIPT_URL="https://raw.githubusercontent.com/$REPO/main/bin/orcode"

echo "orcode installer"
echo "================"
echo ""

# ── Check dependencies ────────────────────────────────────────────────
check_dep() {
  if ! command -v "$1" &>/dev/null; then
    echo "ERROR: $1 is required but not installed."
    echo "  $2"
    exit 1
  fi
}

check_dep claude "Install Claude Code: https://docs.anthropic.com/en/docs/claude-code"
check_dep curl   "Install curl via your package manager"
check_dep jq     "Install jq: brew install jq / apt install jq"

echo "[✓] Dependencies: claude, curl, jq"

# ── Optional: fzf for interactive model selection ─────────────────────
if command -v fzf &>/dev/null; then
  echo "[✓] Optional: fzf (interactive model selector available)"
else
  echo "[ ] Optional: fzf not found (install for --or-select-model)"
fi

# ── Download ──────────────────────────────────────────────────────────
mkdir -p "$INSTALL_DIR"

echo ""
echo "Downloading orcode to $INSTALL_DIR/orcode ..."
curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/orcode"
chmod +x "$INSTALL_DIR/orcode"

echo "[✓] Installed orcode to $INSTALL_DIR/orcode"

# ── Check PATH ────────────────────────────────────────────────────────
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo ""
  echo "WARNING: $INSTALL_DIR is not in your PATH."
  echo ""
  echo "Add it by running:"
  echo ""
  SHELL_NAME=$(basename "$SHELL")
  case "$SHELL_NAME" in
    zsh)  echo "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.zshrc && source ~/.zshrc" ;;
    bash) echo "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.bashrc && source ~/.bashrc" ;;
    fish) echo "  fish_add_path $INSTALL_DIR" ;;
    *)    echo "  export PATH=\"$INSTALL_DIR:\$PATH\"" ;;
  esac
fi

# ── API key reminder ─────────────────────────────────────────────────
echo ""
if [[ -n "${OPENROUTER_API_KEY:-}" ]]; then
  echo "[✓] OPENROUTER_API_KEY is set"
else
  echo "Next: set your OpenRouter API key:"
  echo ""
  echo "  export OPENROUTER_API_KEY=\"sk-or-...\""
  echo ""
  echo "  Get one at https://openrouter.ai/keys"
fi

echo ""
echo "Done! Run 'orcode' to start."

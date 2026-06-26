#!/usr/bin/env bash
# Pre-Launch Readiness — installer for Claude Code.
# Copies the skill into your Claude Code skills folder so it's available on every
# project. Re-run any time to update.
set -euo pipefail

SKILL_NAME="prelaunch-readiness"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skill/${SKILL_NAME}"

# Where Claude Code looks for skills:
#   personal (default) -> ~/.claude/skills/   (available on every project)
#   project            -> ./.claude/skills/   (this repo/project only)
# Override anything with: CLAUDE_SKILLS_DIR=/path ./install.sh
if [[ "${1:-}" == "--project" ]]; then
  DEST_ROOT="$(pwd)/.claude/skills"
else
  DEST_ROOT="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
fi

if [[ ! -f "${SRC_DIR}/SKILL.md" ]]; then
  echo "✗ Couldn't find the skill at ${SRC_DIR}. Run this from inside the cloned repo." >&2
  exit 1
fi

DEST="${DEST_ROOT}/${SKILL_NAME}"
mkdir -p "${DEST_ROOT}"
rm -rf "${DEST}"
cp -R "${SRC_DIR}" "${DEST}"

echo "✓ Installed '${SKILL_NAME}' to: ${DEST}"
echo
echo "Next: open Claude Code in any project and say"
echo "      \"run the pre-launch readiness check\""
echo "      (or just \"scan my repo before launch\" / \"do I need a cookie banner?\")"

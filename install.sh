#!/usr/bin/env bash
# Founder Stack — installer for Claude Code.
# Copies every skill in skill/ into your Claude Code skills folder so they're
# available on every project. Re-run any time to update.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Where Claude Code looks for skills:
#   personal (default) -> ~/.claude/skills/   (available on every project)
#   project            -> ./.claude/skills/   (this repo/project only)
# Override anything with: CLAUDE_SKILLS_DIR=/path ./install.sh
if [[ "${1:-}" == "--project" ]]; then
  DEST_ROOT="$(pwd)/.claude/skills"
else
  DEST_ROOT="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
fi

mkdir -p "${DEST_ROOT}"

FOUND=0
for SKILL_MD in "${REPO_DIR}"/skill/*/SKILL.md; do
  [[ -f "${SKILL_MD}" ]] || continue
  SRC_DIR="$(dirname "${SKILL_MD}")"
  SKILL_NAME="$(basename "${SRC_DIR}")"
  DEST="${DEST_ROOT}/${SKILL_NAME}"
  rm -rf "${DEST}"
  cp -R "${SRC_DIR}" "${DEST}"
  echo "✓ Installed '${SKILL_NAME}' to: ${DEST}"
  FOUND=$((FOUND + 1))
done

if [[ "${FOUND}" -eq 0 ]]; then
  echo "✗ No skills found under ${REPO_DIR}/skill/. Run this from inside the cloned repo." >&2
  exit 1
fi

echo
echo "Installed ${FOUND} skills. Next: open Claude Code in any project and say"
echo "      \"/layers-orient\"                            (what should I design first?)"
echo "      \"set up build orchestration\"               (gated plan→review→test builds)"
echo "      \"vibe-audit this code\" / \"find the bugs\"   (is the code correct?)"
echo "      \"run the pre-launch readiness check\"       (safe + legally covered to launch?)"
echo "      \"create offers for this app\" / \"write hooks\"   (how do I market it?)"

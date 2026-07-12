---
name: build-orchestration
description: Use when the user wants disciplined AI-assisted building in a project — asks to "set up build orchestration", "/change pipeline", "plan before coding", "stop the AI changing 12 files", "add review gates", "decision docs", "workflow discipline", or complains that AI edits things without approval or that decisions get lost.
---

# Build orchestration

Installs a proven build-discipline system into the **current project**: 5 sub-agents (cm-planner, cm-decider, reviewer, conventions-audit, test-author) + a `/change` command + CLAUDE.md routing rules. Result: every change runs `plan → verify → implement → review → audit → test → commit`, with human gates on architectural decisions.

This skill is an **installer + guide** — the discipline itself lives in the agent files under `assets/`, vendored from [Aleksacom/claude-code-orchestration-agents](https://github.com/Aleksacom/claude-code-orchestration-agents). Do not improvise your own agent files; copy the vendored ones.

## When NOT to use

- Target is not a git repo with at least one commit → tell user to init/commit first.
- User wants a one-off review, not standing discipline → use the code-review or vibe-audit flow instead.
- Project already has these agents installed → offer update (overwrite with vendored versions) or tune, don't duplicate.

## Install procedure

Run from the target project root. `<skill>` below = this skill's own directory.

1. **Pre-flight.** Verify: git repo with ≥1 commit; check for existing `.claude/agents/` files with the same names and existing "Routing rules" section in project CLAUDE.md. Any conflict → show what exists, ask user: overwrite / merge / abort. Never silently clobber.
2. **Copy files** (create dirs as needed):
   - `<skill>/assets/agents/*.md` → `./.claude/agents/`
   - `<skill>/assets/commands/change.md` → `./.claude/commands/`
   - `<skill>/assets/conventions/decision-docs.md` → `./docs/conventions/`
3. **Detect monitored paths.** Inspect the project structure and propose test-author's monitored source paths: single-package Node → `src/`, `lib/`; monorepo → `packages/*/src/`, `apps/*/src/`; Next.js → `app/` or `apps/web/src/`; Django → `apps/*/`, `<project>/`; Expo/React Native → `app/`, `src/`, `components/`. Confirm with user.
4. **Update CLAUDE.md.** Read `<skill>/assets/claude-md-routing.md`, replace `{{MONITORED_PATHS}}` with the confirmed paths, append the whole section to the project's CLAUDE.md (create the file if missing). If a "Routing rules" section already exists, replace it only after user confirms.
5. **Restart notice.** Tell the user: exit and relaunch Claude Code so `.claude/agents/` is picked up, then verify with `/agents` (all 5 listed) and `/change`.
6. **Practice run.** Suggest: `/change update the README tagline` — narrate the expected pipeline (planner → edit → stage → reviewer → commit) so the user sees each gate fire.

## Tuning (offer after install, don't force)

- Project-specific rules: `.claude/rules/<topic>.md` (auth, api, database), referenced from CLAUDE.md — cm-planner reads them when planning.
- "Architecture rules — NEVER violate these" list in CLAUDE.md — reviewer enforces.
- Commit conventions in CLAUDE.md or `.claude/rules/commits.md`.
- Pipeline too slow on trivial work → tune cm-planner's trivial fast-path criteria.

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Writing agent files from memory instead of copying assets | Copy vendored files verbatim — they're tested; yours aren't |
| Appending routing rules with `{{MONITORED_PATHS}}` unreplaced | Replace placeholder BEFORE writing CLAUDE.md |
| Installing into `~/.claude/` (global) | Agents are per-project by design — always `./.claude/` in project root |
| Skipping the restart step | Claude Code only picks up `.claude/agents/` on launch — without restart, /agents shows nothing |
| Silently overwriting an existing CLAUDE.md section | Diff + confirm first |

## Relation to sibling skills

This is the **build** stage: layers-* designs it → **build-orchestration** disciplines the building → vibe-audit sweeps the whole codebase for defects → prelaunch-readiness gates launch → marketing sells it. The `reviewer` agent here is a per-change gate; vibe-audit is the periodic deep sweep — complementary, not redundant.

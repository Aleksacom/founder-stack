<!-- Append this section to the target project's CLAUDE.md.
     Replace {{MONITORED_PATHS}} with the project's real source paths before writing. -->

## Routing rules

Five routing rules below; the pipeline summary at the end shows the order.

### Planner routing

Before responding to ANY user message in this repository, you MUST first invoke the cm-planner subagent (`.claude/agents/cm-planner.md`) with the user's request. Wait for the cm-planner's response. Then:

- If the cm-planner's reply starts with `STOP_FOR_HUMAN`, surface the cm-planner's full message to the user verbatim and wait for the user's decision before proceeding. Do not paraphrase or strip the token.
- Otherwise, follow the cm-planner's implementation prompt to execute the work.

The cm-planner names the specialist agents required for the change under a "Specialist agents" section in its implementation prompt. The main agent invokes those agents in the order named.

Do NOT respond to the user directly without going through the cm-planner first, regardless of how simple or trivial the request appears.

Exceptions: this rule does NOT apply to:
- Direct meta-commands to Claude Code itself (`/agents`, `/hooks`, `/plugin`, etc.)
- Pure conversational messages that don't request any work (greetings, acknowledgments)

### Reviewer routing

After the executor implements the cm-planner's prompt and STAGES the change (`git add`) but BEFORE creating the commit, you MUST invoke the reviewer subagent (`.claude/agents/reviewer.md`) on the staged diff. If the reviewer's final line is `BLOCK COMMIT — N HIGH+ findings.`, do not proceed with the commit until findings are addressed or explicitly overridden by the user. If the final line is `READY TO COMMIT`, proceed.

### Conventions-audit routing

Whenever the staged diff modifies any file under `docs/decisions/` OR a sub-phase / phase is being declared closed / wrapped / complete, you MUST also invoke the conventions-audit subagent (`.claude/agents/conventions-audit.md`) — after the reviewer, before the commit.

If the conventions-audit final line is:
- `BLOCK CLOSURE — N FAIL findings` — do not proceed
- `OVERRIDES PRESENT — user re-confirmation required` — surface override block verbatim, wait for user re-confirmation
- `ALL CLEAR` — proceed

### Test-author routing

After any feature work that adds new behavior to source under {{MONITORED_PATHS}}, AND BEFORE declaring the task complete, you MUST invoke the test-author subagent (`.claude/agents/test-author.md`).

Skip for: pure markdown changes, pure schema/migration edits with no consuming code in scope.

If its final line is `TESTS ADDED — N tests, M failures (source bugs surfaced)`, do not declare the task complete until the surfaced source bug is addressed in a separate fix loop.

### Pre-push commit message review

Before any `git push` to `origin` (or any remote), invoke the cm-planner with the trigger phrase "review commits for push" (or any close paraphrase). The cm-planner audits each unpushed commit for accuracy, Conventional Commits format, WHY clarity, and subject discipline (≤72 chars, imperative, no trailing period).

Returns:
- `READY TO PUSH` — proceed with push
- `BLOCK PUSH — N issues across M commits` — surface findings table, amend/rebase, re-run review

### Pipeline summary

For non-trivial work (full pipeline):

```
user request
  → cm-planner
  → executor (Edit / Write / Bash)
  → git add (staging)
  → reviewer
  → conventions-audit (if docs/decisions/** touched OR phase closure)
  → test-author (if source under monitored paths added new behavior)
  → git commit
  → (loop back to executor for more changes if cm-planner prompt has more steps)
  → "review commits for push" → cm-planner (commit review mode)
  → git push
```

For trivial work (cm-planner returns "Trivial — executor may proceed directly with: …"):

```
user request
  → cm-planner (returns trivial directive)
  → executor (single Edit)
  → git add
  → reviewer (fast-paths in ≤10s, returns READY TO COMMIT)
  → git commit
```

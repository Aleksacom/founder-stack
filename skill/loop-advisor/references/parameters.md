# Parameter checklists per loop type

Work through the checklist for the chosen type. Every parameter gets an explicit
value — "default" is a decision too, say it out loud.

## Turn-based + verification skill

- [ ] **Verification steps** — the manual checks the user does today, written as numbered steps
- [ ] **Quantitative checks first** — tests pass, zero console errors, score thresholds; the more measurable, the better self-verification
- [ ] **Tools needed** — browser (claude-in-chrome/devtools), test runner, screenshots
- [ ] **Fail behavior** — "if any step fails, fix and rerun from step 1 — never hand back partially verified work"
- Offer to WRITE the verification SKILL.md for the user's specific flow (project-level: `.claude/skills/verify-<thing>/SKILL.md`).

## Goal-based — /goal

- [ ] **Done condition** — deterministic and checkable: "all tests pass", "Lighthouse ≥ 90", "queue empty". Reject vague ("make it good") — help sharpen until an evaluator could check it mechanically
- [ ] **Turn cap** — always set one: "stop after N tries" (default suggestion: 5; higher only with justification)
- [ ] **Verification method** — HOW the condition gets checked (command to run, score to read); pair with a verification skill if manual
- [ ] **Scope guard** — name what the loop must NOT touch
- Template: `/goal <deterministic condition>, stop after <N> tries.`
- Monitoring: `/goal` with no arguments shows turns + token usage so far.

## Time-based — /loop vs /schedule

**Choose the runner first:**
- Machine on and session open while it runs? → `/loop` (local; dies with the machine)
- Must survive laptop closed / run unattended? → `/schedule` (cloud routine)

- [ ] **Interval** — match how fast the watched thing actually changes. CI run takes ~8 min → check ~10m, not 1m. Slack summary → daily, not hourly. Longest interval that works.
- [ ] **The per-tick prompt** — one clear task, same every tick, inputs change
- [ ] **Completion stop** — does the loop END itself (PR merged, queue empty)? State the condition inside the prompt so a tick can conclude "done, stop looping"
- [ ] **Interval-less option** — `/loop` without interval = model self-paces; good when change rate varies
- [ ] **Permissions** — unattended runs can't answer prompts; decide what's pre-approved vs what the loop should leave for the user (e.g. push yes, merge no)
- Templates: `/loop 10m <check X, do Y, stop when Z>` · `/schedule daily 9am: <task>`

## Proactive (composed)

Only for recurring + well-defined + unattended streams. Compose explicitly:
- [ ] **Trigger** — `/schedule <cadence>` (match cadence to arrival rate of work)
- [ ] **Done per task** — `/goal` condition embedded in the routine prompt
- [ ] **Verification** — skill(s) documenting how to check each item
- [ ] **Orchestration** — dynamic workflows only if items need parallel attempts/judging; pilot on a small slice first (workflows can spawn hundreds of agents)
- [ ] **Permissions** — auto mode for no-stop runs; name the actions still forbidden
- [ ] **Model routing** — smaller/faster models for routine ticks, capable model for judgment calls only

## Quality rules (any loop that edits code)

- Second agent for review — fresh context, less biased (`/code-review` or review agents)
- Verification skills > trusting the loop's own judgment
- When a result fails the bar: fix the SYSTEM (skill, prompt, convention), not just the instance

## Token rules (any loop)

- Simplest primitive that works; no multi-agent for small tasks
- Specific done criteria = fewer turns
- Scripts for deterministic steps — running a script beats re-reasoning the steps every tick
- Don't run more often than the watched thing changes
- Review: `/usage` (by skill/subagent/MCP), `/goal` no-args (turns+tokens), `/workflows` (per-agent usage + stop button)

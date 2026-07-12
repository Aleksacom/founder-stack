---
name: loop-advisor
description: Use when the user wants something to run repeatedly, automatically, on a schedule, in the background, or "until done" and the right mechanism isn't already decided — says "automate this", "keep doing X until", "check X every N minutes", "run overnight", "monitor my PR/CI/deploy", "set up a loop", "babysit this", or asks which of /loop, /goal, /schedule to use.
---

# Loop advisor

Routes a repetition/automation request to the right Claude Code loop primitive and sets every parameter explicitly. Based on the Claude Code team's loop taxonomy (turn-based / goal-based / time-based / proactive).

**Design first, environment second.** Do NOT explore the filesystem, list repos, or start executing the task while advising — the deliverable of this skill is a configured loop, not the task itself. Ask, don't scan.

## Step 1 — Interview (max 4 questions, one message)

Skip any the user's request already answers. Ask remaining ones together, not one-by-one:

1. **The task** — what should repeat or continue, in one sentence?
2. **Done check** — can "done" be written as a condition a machine could check (tests pass, score ≥ X, queue empty, PR merged)? What is it?
3. **Trigger** — run now until done · on a time interval · watching an external system (CI, PRs, channel) · every time you make a change?
4. **Attendance** — will you be at the machine watching, or unattended (laptop possibly closed)? Any budget/model preference?

## Step 2 — Route

Read `references/loop-types.md`; apply its decision table. State the chosen type AND why the neighbors lose (one line each). Common routings:

- One-off task, user reviews result → **no loop** — normal prompt, maybe + verification skill. Say so; recommending no-loop is a valid outcome (anti-overkill rule).
- "Until condition X", running now → **/goal**
- "Every N / watch external system", session stays open → **/loop**; must survive machine off → **/schedule**
- Recurring stream of well-defined items, unattended → **proactive composition** (/schedule + /goal + skills + workflows + auto mode)
- Hybrids are normal: "/loop 10m …" whose per-tick prompt contains a /goal-style done condition.

## Step 3 — Set parameters

Read `references/parameters.md`; walk the checklist for the chosen type out loud — every box gets an explicit value, including defaults. Minimum bar for any loop: deterministic done/stop condition, a cap (turns / interval / cancel condition), permissions decided (especially irreversible actions: merge, publish, delete — default them to "leave for user"), and a token note (interval/model justified against how fast the watched thing changes).

## Step 4 — Deliver

1. The exact command, ready to run (`/goal …`, `/loop 10m …`, `/schedule …` prompt) — or the routine text for /schedule.
2. What the user will observe: first tick behavior, where to check status (`/goal` no-args, `/usage`, `/workflows`), how to stop it.
3. A pilot suggestion when blast radius is real: one manual run of the tick prompt BEFORE starting the loop; small slice before a workflow fan-out.
4. If a verification skill would cut turns: offer to write `.claude/skills/verify-<thing>/SKILL.md` for their flow (steps from their manual checks, quantitative first).

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Jumping to /loop vs /schedule without considering /goal or no-loop | Walk the decision table; say why neighbors lose |
| Exploring repos/files instead of designing the loop | Interview answers, not filesystem scans |
| Vague done ("make it good", "keep it healthy") | Sharpen until mechanically checkable, or use turn cap as the only honest stop |
| No turn cap on /goal | Always cap; "stop after 5 tries" default |
| 1m polling on a thing that changes hourly | Longest interval that works; match change rate |
| Loop pre-authorized to merge/publish/delete | Irreversible actions stay with the user unless they explicitly hand them over |
| Designing a mega-loop for a one-off task | Anti-overkill rule: simplest solution first, loops selectively |

# Loop types — Claude Code team taxonomy

Source: Claude Code team, "Getting started with loops" (July 2026). A loop = an agent
repeating cycles of work until a stop condition is met. Types differ by trigger, stop
criteria, primitive, and the piece YOU hand off.

## Decision table (the core routing logic)

| Loop | You hand off | Use it when | Reach for |
|------|-------------|-------------|-----------|
| **Turn-based** | The check | You're exploring or deciding; shorter tasks, no schedule | Custom verification skills |
| **Goal-based** | The stop condition | You know what done looks like (checkable) | `/goal` |
| **Time-based** | The trigger | Work happens outside your project or on a schedule | `/loop` (local), `/schedule` (cloud) |
| **Proactive** | The prompt | Work is recurring AND well-defined | All of the above + dynamic workflows |

## Type details

### Turn-based (the default agentic loop)
- **Triggered by:** a user prompt. **Stops:** Claude judges task complete or needs input.
- **Best for:** shorter one-off tasks, exploration, anything you want to review each step.
- **Usage control:** specific prompts; encode manual verification steps as a SKILL.md so Claude self-checks (browser interaction, console errors, quantitative checks — the more quantitative, the better self-verification works).
- Every normal prompt IS this loop. If the task fits in it — no other loop needed.

### Goal-based — `/goal`
- **Triggered by:** manual prompt now. **Stops:** goal achieved OR max turns reached.
- **Best for:** verifiable exit criteria. An evaluator model checks the condition each time Claude tries to stop, sends it back until met or turn cap hit.
- **Usage control:** deterministic criteria (tests passed, score ≥ threshold) + explicit turn cap ("stop after 5 tries").
- Example: `/goal get the homepage Lighthouse score to 90 or above, stop after 5 tries.`

### Time-based — `/loop` and `/schedule`
- **Triggered by:** time interval. **Stops:** you cancel, or the work completes (PR merged, queue empty).
- **Best for:** recurring work with same task/changing inputs (morning Slack summary), or polling external systems (PR reviews, CI).
- **`/loop` runs on YOUR machine** — dies when the machine sleeps/shuts down. **`/schedule` runs in the cloud** as a routine — survives your machine. Choose by whether it must run unattended.
- **Usage control:** longest interval that works — match interval to how fast the watched thing actually changes; prefer reacting to events over tight polling.
- Example: `/loop 5m check my PR, address review comments, and fix failing CI`

### Proactive (composed)
- **Triggered by:** event or schedule, no human in real time. **Stops:** each task exits when its goal is met; the routine runs until turned off.
- **Best for:** recurring streams of well-defined work — bug triage, migrations, dependency upgrades, feedback handling.
- **Composition:** `/schedule` (trigger) + `/goal` (done definition) + verification skills (how to check) + dynamic workflows (parallel agents/judging) + auto mode (no permission stops).
- **Usage control:** route routine work to smaller/faster models; most capable model only for judgment calls.
- Example: `/schedule every hour: check the project-feedback channel for bug reports. /goal: don't stop until every report found this run is triaged, actioned, and responded to. When fixing a bug, use a workflow to explore three solutions in parallel worktrees and have a judge adversarially review them.`

## Anti-overkill rule (from the manual, verbatim spirit)

"Not all tasks require complex loops; start with the simplest solution and use these
patterns selectively." If the task is one-off and reviewable in a turn — it's a normal
prompt, not a loop. Say so and stop.

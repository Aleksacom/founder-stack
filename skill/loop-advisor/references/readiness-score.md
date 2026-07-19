# Loop Readiness Score — gate before you run

A designed loop isn't the same as a *runnable* loop. Before delivering the command,
score it. A loop that scores low burns tokens and produces nothing (the "churned, no
result" failure). Score = go/no-go.

Adapted from the loop-engineering "Loop Ready" score and L1/L2/L3 rollout ladder
(cobusgreyling/loop-engineering).

## Score the designed loop: 0–100 (5 dimensions × 20)

| Dimension | 20 pts if… | 0 pts if… |
|-----------|-----------|-----------|
| **Sharp goal** | "done" is a condition a machine can check (tests pass, score ≥ X, PR merged, queue empty) | vague ("make it good", "keep healthy") |
| **Verification** | a real check confirms each iteration (command, score read, verification skill) | the loop trusts its own judgment |
| **Stop / circuit breaker** | turn cap set AND (unattended) a circuit breaker (see below) | no cap, can spin forever |
| **Budget** | token/cost cap set; interval justified against how fast the watched thing changes | unbounded; polls faster than it changes |
| **Permissions & scope** | irreversible actions (merge/publish/delete) decided; path/scope guard; human gates where needed | loop can do anything, anywhere |

**Bands:**
- **70–100 — ship it.** Deliver the command.
- **40–69 — warning.** Name the low dimensions and fix them before delivering. Don't ship a warning-band loop unattended.
- **Below 40 — do not run.** The loop will churn. Redesign (usually the goal or verification is missing) before giving any command.

State the score and the per-dimension reasoning in the delivery. A low score is a
finding, not a failure — it tells the user exactly what to fix.

## Rollout ladder — never jump straight to unattended

Escalate one level at a time; a loop earns L3 by proving L2.

- **L1 — report-only.** Loop observes and reports; makes no writes. Lowest risk. Ship at score ~40+.
- **L2 — assisted.** Loop proposes/edits; a human approves each change. Requires real verification + an explicit human gate.
- **L3 — unattended.** Loop acts with no human in the tick (auto mode). Requires: score ≥ 70, a circuit breaker, a token/cost cap, and proven L2 runs first.

If the user asks for L3 ("run overnight, fix it, merge") but the loop is untested,
recommend starting at L1/L2 and graduating — don't hand them an unattended merge loop
on day one.

## Circuit breaker (mandatory for any unattended / L3 loop)

An unattended loop must ESCALATE to a human instead of retrying forever. Trip the
breaker — stop and hand off — on any of:

- **Max iterations** hit (hard cap).
- **Same error N× in a row** (default N=3) — it's stuck, not progressing.
- **Too many consecutive failures** across ticks.
- **Token/cost budget exceeded.**

Encode it in the loop's prompt in plain language, e.g.: *"If the same CI failure
survives 3 fix attempts, or you hit the token cap, STOP and ask me — do not keep
retrying."* Without this, an unattended loop thrashes on one failure and drains budget.

## Where this plugs into the skill

Run the score in **Step 3.5** — after parameters are set, before the command is
delivered. It reuses the same values you already collected (done condition, cap,
budget, permissions) and turns them into one number + a rollout level.

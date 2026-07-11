---
name: vibe-audit
description: >
  Autonomous, read-only code-correctness audit for any codebase — especially
  AI-/vibe-coded projects where "it works" hasn't been stress-tested. Runs 20
  sequential passes hunting real defects (injection, IDOR/authorization,
  auth/session, secrets, error-handling, concurrency/race conditions, resource
  leaks, N+1 & data-access, algorithmic complexity, unbounded memory growth,
  external-call timeouts/resilience, idempotency/retry safety, transaction &
  consistency boundaries, config hardening, dependency/supply-chain, logging &
  observability, API-contract consistency, cross-module contracts, test-gap
  quality) and a final verification pass that kills false positives. Use when the
  user wants a code review / bug hunt / "audit this code", asks "what's wrong with
  this", "find the bugs", "is this production-ready code", "review for race
  conditions / N+1 / memory leaks / idempotency", or after building a feature and
  wanting a correctness sweep. NOT a launch/legal gate — for "safe + legally
  covered to launch?" (privacy policy, cookie banner, GDPR, RLS-as-launch-blocker)
  use the prelaunch-readiness skill instead. The two overlap on security by design.
---

# Vibe Audit

An autonomous correctness sweep that answers one question: **is this code actually
correct and robust, or does it just happen to work on the happy path?** It reads the
code, runs 20 focused passes, verifies its own findings, and reports. It changes
nothing.

Built from Ersin Koç's 20-prompt vibe-code audit thread, wired into a harness with a
verification stage and honest provenance.

## How this differs from `prelaunch-readiness`

- **prelaunch-readiness** answers *"safe + legally covered to LAUNCH?"* — security +
  legal/privacy (privacy policy, cookie banner, GDPR, DPA, hosting region), run once
  before go-live, interactive (it interviews you).
- **vibe-audit** answers *"is the CODE correct?"* — correctness, reliability, perf,
  tests. Run anytime, repeatedly, during development. Autonomous (no interview).

They **overlap on security** on purpose (injection, IDOR, auth, secrets, config,
deps, plus the reliability subset). Same checks, two lenses: prelaunch asks "does
this block launch?"; vibe-audit asks "is this a bug?". If the user needs the legal
side or a launch verdict, hand off to `prelaunch-readiness`.

## Core principles (do not violate)

1. **No fabrication.** Never invent a defect, file path, symbol, or "fact." If you
   can't confirm something read-only, it is `UNVERIFIED` with the exact file/context
   needed — never a guess. A confident wrong finding is worse than an honest "I
   couldn't confirm this."
2. **Provenance on every finding.** Tag how you know:
   - `[verified]` — you read it in the code (cite `file:line`).
   - `[UNVERIFIED]` — depends on code you couldn't see; name what's needed.
   "Present in code" ≠ "reachable at runtime" (an import may be dead, a flag off) —
   say which you mean.
3. **Read-only.** Investigate and REPORT. Do not edit, branch, or commit during the
   audit. Surface findings; let the user decide and scope fixes afterward.
4. **Proportionality over theater.** Severity by real impact. A race on a non-money
   path is LOW; a double-charge is CRITICAL. A pattern that never sees scale is a NIT.
   Don't inflate counts to look thorough.
5. **Adapt to the stack, skip the impossible.** If the runtime makes a whole category
   impossible (e.g. no shared memory in a stateless-function deploy), say so and move
   on rather than forcing a finding.
6. **Pass 20 is mandatory and final.** Every finding must survive the verification
   pass before it reaches the report. No finding ships unverified-as-confirmed.

## How to run

1. **Set scope.**
   - *Full audit* (default): all 20 passes.
   - *Targeted*: the user named a class ("just concurrency", "check idempotency and
     transactions") → run those passes + always run pass 20 on the results.
   - *Diff mode*: if asked to audit a change/PR, scope each pass to the changed
     surface and its blast radius, not the whole repo.
2. **Read first, orient.** Identify the stack, runtime/concurrency model, data
   stores, and the hot/critical paths (auth, money, data mutation, multi-tenant
   boundaries). State assumptions (load model, "N items per request, M concurrent")
   where a pass needs them.
3. **Run passes 1–19** from `references/passes.md`, in order. Each pass produces
   findings; a pass that finds nothing still reports "clean" for that class.
4. **Run pass 20 (verification)** over ALL findings: relocate each citation, try to
   falsify each claim against existing guards/constraints/framework behavior, merge
   duplicates, re-score severity conservatively. Split into CONFIRMED / UNVERIFIED /
   REJECTED.
5. **Report** (format below). Call out the **first CRITICAL** explicitly.

Run the passes concurrently across independent files if it helps, but keep the
pass-by-pass structure in the report — and pass 20 always runs last, after everything
else has produced findings.

## The 20 passes

Full text in `references/passes.md`. Grouped:

- **Security (1–4):** injection & untrusted input · auth & session · authorization &
  IDOR · secrets & sensitive-data exposure.
- **Failure & concurrency (5–7):** error handling & failure paths · concurrency &
  race conditions · resource lifecycle & leaks.
- **Performance & scale (8–10):** data access & N+1 · algorithmic complexity & hot
  paths · memory & unbounded growth.
- **Distributed correctness (11–13):** external calls, timeouts & resilience ·
  idempotency & retry safety · transaction & consistency boundaries.
- **Operability (14–17):** config & environment hardening · dependency & supply
  chain · logging, observability & auditability · API-contract consistency.
- **Systemic (18–19):** cross-module contracts & emergent risks · test-gap &
  assertion quality.
- **Verification (20, always last):** verification & false-positive filter.

## Output format

```
# Vibe Audit — <project/scope> (<date>)
**Stack:** <detected>   **Scope:** full / targeted:<passes> / diff
**Assumptions:** <load model, runtime concurrency model, anything a pass depended on>

## Verdict
<one honest line: e.g. "3 CONFIRMED CRITICAL, 5 HIGH — not production-ready" or
"no CONFIRMED issues above LOW; see UNVERIFIED for what needs your context">
First CRITICAL: pass #<n> — <one line>   (or "none")

## Confirmed findings  (sorted by severity)
<table: # | pass | severity | provenance | evidence (file:line) | defect | concrete failure it produces>

## Unverified  (need your context to confirm)
<table: pass | what's suspected | exact files/schema/config needed to confirm>

## Rejected  (surfaced then disproved — shown for transparency)
<table: pass | claim | why rejected (the disproving guard/constraint, with location)>

## Suggested fix order
1. <highest-impact CONFIRMED first, with why>  ...
   (Fixes are out of scope for this read-only pass — hand each to your normal
    implement/review flow. Never auto-applied here.)
```

Rank by real impact, not pass order. A CONFIRMED finding states the concrete failure
you can articulate yourself; if you can't, it's UNVERIFIED, not CRITICAL.

## Tone

Direct and proportionate. The goal is a defect list the user can act on — not a wall
of red, not false reassurance. If the code is genuinely solid, say so; if one thing
will corrupt data or charge a card twice, say it first.

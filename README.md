# Pre-Launch Readiness + Vibe Audit — two Claude Code skills

Two complementary skills for shipping software you can trust. They answer two
different questions:

- **`prelaunch-readiness`** — *"Is this safe and legally covered enough to **launch**?"*
  Security + legal/privacy. Run once before go-live.
- **`vibe-audit`** — *"Is the **code** actually correct and robust?"*
  Correctness, reliability, performance, tests. Run anytime, repeatedly, during dev.

Both are **read-only** (they report, they don't change your code), both are
**honest** (every finding tagged `[verified] file:line` or `[UNVERIFIED]`, never
guessed), and both **adapt to your stack**. They're plain Markdown Claude Code reads
— no build, no dependencies.

> The repo is named `prelaunch-readiness` for historical reasons; it now ships **two**
> skills. The clone URL below is unchanged.

---

## Install (one step, installs both)

```bash
git clone https://github.com/Aleksacom/prelaunch-readiness.git
cd prelaunch-readiness
./install.sh
```

That copies **both skills** into your Claude Code skills folder (`~/.claude/skills/`),
so they're available in **every** project. Re-run `./install.sh` any time to update.

> One project only? `./install.sh --project` from inside that project.
> Custom location? `CLAUDE_SKILLS_DIR=/your/path ./install.sh`

---

## Which one do I use?

|                     | `prelaunch-readiness`                              | `vibe-audit`                                    |
| ------------------- | -------------------------------------------------- | ----------------------------------------------- |
| **Question**        | Safe + legally covered to **launch**?              | Is the **code** correct & robust?               |
| **When**            | Once, before go-live                               | Anytime, repeatedly, during dev                 |
| **Scope**           | Security **+ legal/privacy**                        | Correctness + reliability + perf + tests        |
| **Style**           | Interactive (interviews you)                        | Autonomous (reads code, no interview)           |
| **Legal docs?**     | Yes (privacy policy, cookie, terms, DPA)            | No                                              |
| **Verdict**         | "Ready / ready after N fixes / not yet"             | "First CRITICAL at pass N; here's the list"     |

They **overlap on security by design** (injection, auth, IDOR, secrets, config,
dependencies, plus a reliability subset). Same checks, two lenses: prelaunch asks
*"does this block launch?"*, vibe-audit asks *"is this a bug?"*. Use both — vibe-audit
throughout development to catch defects early, prelaunch once before you ship to gate
launch safety and legal coverage.

Analogy: `vibe-audit` is the mechanic's full inspection; `prelaunch-readiness` is the
roadworthiness + registration check before you're allowed to drive it.

---

## Skill 1 — `prelaunch-readiness`

Point Claude Code at your repo and it **scans the code**, asks you only what code
can't reveal, and gives you one prioritized report covering **security** and
**legal/privacy** — plus ready-to-run fix prompts. It checks the things that actually
get apps sued, fined, or breached.

**Use it** — open Claude Code in any project and say:

- **"run the pre-launch readiness check"** — the full pass
- **"scan my repo before launch"** — security-focused
- **"do I need a cookie banner?"** / **"check my privacy docs against the code"** —
  legal-focused

**What you get:**

- **Security audit** — database authorization (RLS / tenant isolation), server-side
  validation, secret/bundle exposure, error-message leaks, auth failure-case &
  enumeration tests, HTTP security headers, rate limits & cost caps, CAPTCHA/CORS/
  SameSite, email deliverability, dependency CVEs, feature-flag awareness, and a
  reliability spot-check for the launch-blocking correctness classes (idempotency on
  money/side-effects, transaction consistency, races on money/seat/quota state,
  external-call timeouts).
- **Legal & privacy coverage** — which of {privacy policy, cookie notice, terms, DPA,
  sub-processor list} you need, what's missing, and a **docs-vs-code mismatch** check,
  jurisdiction-agnostic (GDPR, UK GDPR, US state laws, LGPD, PIPEDA…). Includes
  generalized templates.
- **One prioritized report** — what blocks launch vs. nice-to-have hardening, code
  fixes as gated prompts, and a separate list of things you do yourself (dashboard
  caps, lawyer review, SPF/DKIM).

---

## Skill 2 — `vibe-audit`

An autonomous correctness sweep for any codebase — especially AI-/vibe-coded projects
where "it works" hasn't been stress-tested. It reads the code, runs **20 focused
passes** hunting real defects, then a **final verification pass** that relocates each
citation and kills false positives before anything reaches the report.

**Use it** — open Claude Code in any project and say:

- **"vibe-audit this code"** / **"find the bugs"** — the full 20-pass sweep
- **"review for race conditions"** / **"check idempotency and transactions"** —
  targeted (runs those passes + the verification pass)
- **"audit this PR / diff"** — scoped to the change and its blast radius

**The 20 passes** (grouped): injection · auth/session · authorization & IDOR · secrets
· error-handling & failure paths · concurrency & races · resource leaks · data-access
& N+1 · algorithmic complexity · memory & unbounded growth · external-call
timeouts/resilience · idempotency & retry safety · transaction & consistency
boundaries · config hardening · dependency/supply-chain · logging & observability ·
API-contract consistency · cross-module contracts · test-gap & assertion quality ·
**verification & false-positive filter (always last)**.

**What you get** — one report with **CONFIRMED** (survived verification, sorted by
severity, with the concrete failure each produces), **UNVERIFIED** (needs your context
— names the exact files/schema/config), and **REJECTED** (surfaced then disproved,
shown for transparency), plus the first CRITICAL called out and a suggested fix order.
Fixes are **not** applied — hand them to your normal implement/review flow.

The 20 passes are adapted from
[Ersin Koç's vibe-code audit thread](https://x.com/ersinkoc/status/2074552091826413695),
wired into a harness with a verification stage and honest provenance.

---

## How they stay honest (both skills)

- **No fabrication.** Every finding is tagged `[verified]` (read in the code, with
  `file:line`) or `[UNVERIFIED]` (says what would confirm it). No guessing.
- **Read-only.** They audit and report; they never change your code.
- **Proportionate.** A real hole vs. defense-in-depth; a double-charge vs. a
  theoretical race on a non-money path. Severity by real impact, not checklist theater.
- **Not legal advice.** `prelaunch-readiness` legal output is draft text with `[CHECK]`
  markers for a lawyer in your jurisdiction to review.

## What's inside

```
skill/
├── prelaunch-readiness/
│   ├── SKILL.md                 # the launch/legal orchestrator
│   ├── references/              # intake · security-audit · legal-coverage
│   └── templates/               # privacy policy, cookie notice, terms, DPA, sub-processors
└── vibe-audit/
    ├── SKILL.md                 # the code-audit orchestrator
    └── references/passes.md     # the 20 passes
```

You never touch these individually — `install.sh` handles them. They're here if you
want to read or tailor them.

## License

MIT — see [LICENSE](LICENSE). Set your name in the LICENSE file before publishing.

# Design, Ship & Sell — a Claude Code skills toolkit

Twelve skills covering the full arc of building software: **decide what to build**,
**verify the code is correct**, **gate the launch**, and **get customers**. Four
tools, one pipeline:

1. **`layers-*`** (9 skills) — *"What should we build, and is the design sound?"*
   The Layers of Product Design framework: user research → domain → needs →
   strategy → conceptual model → interaction flow → surface. Run before and during
   design.
2. **`vibe-audit`** — *"Is the **code** actually correct and robust?"*
   Correctness, reliability, performance, tests. Run anytime, repeatedly, during dev.
3. **`prelaunch-readiness`** — *"Is this safe and legally covered enough to **launch**?"*
   Security + legal/privacy. Run once before go-live.
4. **`marketing`** — *"How do I get **customers** for this?"*
   Hormozi-style offers, hooks, content calendar, proof, funnel audit.

All are **honest by construction** — no fabricated findings, no fabricated
testimonials, no invented product facts, design models flagged as hypotheses until
there's evidence. Plain Markdown Claude Code reads — no build, no dependencies.

> The repo is named `prelaunch-readiness` for historical reasons; it now ships the
> whole toolkit. The clone URL below is unchanged.

---

## Install (one step, installs everything)

```bash
git clone https://github.com/Aleksacom/prelaunch-readiness.git
cd prelaunch-readiness
./install.sh
```

That copies **every skill** into your Claude Code skills folder
(`~/.claude/skills/`), so they're available in **every** project. Re-run
`./install.sh` any time to update — it auto-discovers whatever is in `skill/`.

> One project only? `./install.sh --project` from inside that project.
> Custom location? `CLAUDE_SKILLS_DIR=/your/path ./install.sh`

---

## The pipeline — which one when?

|                 | `layers-*` (design)                       | `vibe-audit`                              | `prelaunch-readiness`                    | `marketing`                                  |
| --------------- | ------------------------------------------ | ----------------------------------------- | ---------------------------------------- | -------------------------------------------- |
| **Question**    | What to **build**? Is the design sound?    | Is the **code** correct & robust?         | Safe + legally covered to **launch**?    | How do I get **customers**?                  |
| **When**        | Before & during design                     | Anytime, repeatedly, during dev           | Once, before go-live                     | After launch prep; whenever you need assets  |
| **Style**       | Interactive working sessions               | Autonomous (reads code, no interview)     | Interactive (interviews you)             | Interactive first run, then reads saved context |
| **Touches files?** | Captures decisions you choose to keep   | Read-only, report only                    | Read-only + legal doc drafts             | Writes marketing assets to `marketing/` (never code) |
| **Output**      | Job stories, object maps, flows, decisions | "First CRITICAL at pass N; here's the list" | "Ready / ready after N fixes / not yet" | Scored & ranked assets, saved as files       |

Natural sequence: **layers** to design it → build it → **vibe-audit** while you code →
**prelaunch-readiness** before you ship → **marketing** to sell it. Bonus loop:
`layers-user-needs` produces prioritized user pains — exactly the input the
`marketing` skill's offer and hook modes feed on.

---

## Skill group 1 — `layers-*` (product design, 9 skills)

The **Layers of Product Design** framework by [Jamie Mill](https://github.com/jamiemill/layers-skills):
seven layers from observed user behaviour up to surface polish, with the rule that
weak lower layers create UX debt in everything above. Each skill runs a structured
working session at one layer, using named methods (OOUX noun foraging, job stories,
Opportunity Solution Trees, breadboarding, ubiquitous language, event storming).

**Use it** — say:

- **`/layers-intro`** — load first each session; the framework context the others assume
- **`/layers-orient`** — "where should I focus?" — audits all 7 layers, names the
  bottleneck, routes you to the right skill

| Layer | Skill | Produces |
|---|---|---|
| 1 · Observed behaviour | `/layers-observed-behaviour` | Confidence-rated job stories from research |
| 2 · The domain | `/layers-domain` | Concept map, terminology conflicts |
| 3 · User needs | `/layers-user-needs` | Prioritised job stories (needs, pains, desires) |
| 4 · Strategy | `/layers-product-strategy` | Opportunity Solution Tree, prioritised bets |
| 5 · Conceptual model | `/layers-conceptual-model` | Object map, state diagrams, vocabulary |
| 6 · Interaction & flow | `/layers-interaction-flow` | Breadboard with edge cases |
| 7 · Surface | `/layers-surface` | Surface audit against the layers below |

Vendored unmodified from [jamiemill/layers-skills](https://github.com/jamiemill/layers-skills)
(MIT, © Jamie Mill — see [LICENSE-layers-skills](LICENSE-layers-skills)). Update by
re-vendoring from upstream.

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

## Skill 3 — `prelaunch-readiness`

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

## Skill 4 — `marketing`

A Hormozi-style marketing system with **5 modes** — offers built on the Value
Equation, hook generation with scoring rubrics, a 30-day content calendar, a proof/
testimonial library, and a funnel audit. It embeds the actual frameworks (formulas,
1–10 scoring rubrics, platform specs), so output is scored and ranked — never a
generic brainstorm dump.

**How it grounds itself** (the anti-slop rules):

- **Context first, always.** On first run in a project it reads your README/landing
  copy/pricing, drafts a context summary (product, niche, audience, pricing, platforms,
  stage), asks you to confirm it, and saves it to `marketing/context.md`. Every later
  run reads that file. It **never silently invents product facts**.
- **Research, not memory.** Audience pains and competitor proof come from live web
  research (forums, Reddit, reviews — exact quotes with sources). No web access? It
  interviews you instead of faking quotes.
- **No fabricated proof.** Missing testimonials/stats are reported as gaps with the
  cheapest way to fill them — never invented (fake testimonials violate FTC / EU
  consumer law).

**Use it** — open Claude Code in any project and say:

| You say | Mode | Output file |
|---------|------|-------------|
| "create offers for this app" / "help with pricing & positioning" | Offer builder — 10 offers scored 1–10 on the Value Equation, top 3 rewritten | `marketing/offers.md` |
| "write hooks" / "I need headlines / ad titles" | Hook generator — 20+ hooks per pain across 4 formula families, ranked top 25, top 10 in 3 formats | `marketing/hooks.md` |
| "make a content plan / calendar" | Content batching — 5–7 pillars, platform-specific formats, 30-day calendar, ≥50% posts carry proof | `marketing/content-calendar.md` |
| "organize my testimonials / build trust" | Proof & authority — 4-category proof library, each asset in 3 lengths, 20 proof-stories | `marketing/proof.md` |
| "audit my funnel / landing page" | Funnel audit — attention-leak flags with 10 ranked fixes, lead magnets scored on the Value Equation | `marketing/funnel-audit.md` |

Everything is written to a `marketing/` folder in your project (dated sections,
versionable with git). It writes marketing assets only — **never your code**.

The 5 modes are adapted from Alex Hormozi's $100M Offers / $100M Leads frameworks,
with explicit scoring rubrics and research protocols added so an agent can't fake
its way through them.

---

## How they stay honest (all of them)

- **No fabrication.** Audit findings are tagged `[verified]` (read in the code, with
  `file:line`) or `[UNVERIFIED]`. Marketing claims must trace to your code, research
  quotes with sources, or your own statements. Design models are flagged as
  hypotheses until there's user evidence.
- **Code is never touched.** The audits are read-only; `marketing` writes only
  marketing documents; `layers-*` captures only the design decisions you choose to keep.
- **Proportionate.** Severity by real impact, not checklist theater; rankings use
  explicit rubrics; layers tells you when a layer *doesn't* need work.
- **Not legal advice.** `prelaunch-readiness` legal output is draft text with `[CHECK]`
  markers for a lawyer in your jurisdiction to review.

## What's inside

```
skill/
├── layers-intro/ · layers-orient/           # framework context + diagnostic router
├── layers-observed-behaviour/ · layers-domain/ · layers-user-needs/      # problem space
├── layers-product-strategy/ · layers-conceptual-model/
│   · layers-interaction-flow/ · layers-surface/                          # solution space
├── vibe-audit/
│   ├── SKILL.md                 # the code-audit orchestrator
│   └── references/passes.md     # the 20 passes
├── prelaunch-readiness/
│   ├── SKILL.md                 # the launch/legal orchestrator
│   ├── references/              # intake · security-audit · legal-coverage
│   └── templates/               # privacy policy, cookie notice, terms, DPA, sub-processors
└── marketing/
    ├── SKILL.md                 # the 5-mode marketing orchestrator
    └── references/              # value-equation · hook-formulas · proof-types · content-system
```

You never touch these individually — `install.sh` handles them. They're here if you
want to read or tailor them.

## Credits & licenses

- `layers-*` — [jamiemill/layers-skills](https://github.com/jamiemill/layers-skills),
  MIT © Jamie Mill, vendored unmodified — [LICENSE-layers-skills](LICENSE-layers-skills).
- `vibe-audit` passes — adapted from Ersin Koç's audit thread (linked above).
- `marketing` — adapted from Alex Hormozi's published frameworks.
- Everything else: MIT — see [LICENSE](LICENSE).

---
name: marketing
description: Use when the user asks for marketing help on any project — offers, pricing positioning, social media content, hooks, headlines, content calendar, lead magnets, funnel review, landing page copy, testimonials/proof, audience pains, or says "marketing", "promote this", "get users/customers", "write posts", "improve conversion".
---

# Marketing

Hormozi-style marketing system: 5 modes that turn a project into offers, content, hooks, proof, and a funnel audit. Works on any project. Grounded in real audience research, scored with explicit rubrics, saved to files.

**Core principle: research before generation, score before shipping.** Never invent audience pains or product facts — extract them. Never present unranked lists — score and rank with the rubrics in `references/`.

## Step 0 — Context (ALWAYS first, every mode)

1. Read `marketing/context.md` in the project root. If it exists and is current → proceed.
2. If missing: auto-detect from the codebase — README, landing page copy, app store text, pricing config, package descriptions. Build a draft context: **product, niche, audience, core problem solved, pricing, platforms used, stage (pre-launch/launched/scaling)**.
3. Present the draft to the user for confirmation/correction. NEVER silently invent facts about the product — every claim in the draft must trace to a file you read or a user statement.
4. Write confirmed context to `marketing/context.md`. All modes read this file; user corrections update it.

## Research protocol (modes 2, 3, 4)

Use live research, not memory: WebSearch/WebFetch for forums, Reddit, review sites, competitor pages; browser tools (claude-in-chrome) when logged-in platforms needed. Collect **exact quotes** with source URLs. If web tools are unavailable, say so and interview the user for pains/proof instead — never fabricate quotes.

## Modes

Pick by user intent. If ambiguous, ask which mode.

| Mode | Trigger words | Output file |
|------|--------------|-------------|
| 1. Content batching | posts, calendar, content plan, repurpose | `marketing/content-calendar.md` |
| 2. Offer builder | offer, pricing, positioning, "why would anyone buy" | `marketing/offers.md` |
| 3. Hook generator | hooks, headlines, openers, ads, titles | `marketing/hooks.md` |
| 4. Proof & authority | testimonials, case studies, trust, credibility | `marketing/proof.md` |
| 5. Funnel audit | funnel, conversion, landing page review, opt-in | `marketing/funnel-audit.md` |

### Mode 1 — Content batching
Read `references/content-system.md`, then:
1. Extract 5–7 content pillars from context.md + top audience pains; 10 subtopics each.
2. Repurpose any long-form piece the user has (or one pillar deep-dive) into 20 short-form ideas: hooks, one-liners, mini-stories.
3. Format per platform the user actually uses (from context.md) — don't produce formats for platforms they're not on.
4. Proof-loop injection: ≥50% of planned posts carry proof (stat, case study, result, screenshot).
5. Batch into 30-day calendar: pillar × platform grid, one row per day.

### Mode 2 — Offer builder
Read `references/value-equation.md`, then:
1. Research top 10 burning pains (research protocol) — exact quotes + sources.
2. Flip each pain → vivid dream outcome (specific, sensory, time-bound).
3. Build 10 offers using the Value Equation: pricing, bonuses, guarantee, positioning.
4. Score each offer 1–10 on all four variables using the rubric in the reference file. Show the scoring table.
5. Rank by composite score; rewrite top 3 for maximum irresistibility.

### Mode 3 — Hook generator
Read `references/hook-formulas.md`, then:
1. Pick the 4 formula families: pain, desire, proof, curiosity.
2. Generate 5 hooks per pain per family (pains from context.md or Mode 2 research), 10–15 words each, 20+ per pain minimum.
3. Score all hooks on clarity / curiosity / pull (rubric in reference); rank top 25.
4. Rewrite top 10 in 3 formats each: short-video opener, text post first line, ad headline.

### Mode 4 — Proof & authority
Read `references/proof-types.md`, then:
1. Gather all available proof (research protocol + ask user): categorize quantitative / qualitative / transformation / authority. Flag which categories are EMPTY — that's a gap the user must fill, don't fake it.
2. Rewrite each proof asset in 3 lengths: short (1 line), mid (3–4 lines), long (full story).
3. Fuse proof with narrative → 20 proof-stories (logic + emotion, per reference structure).

### Mode 5 — Funnel audit
1. Awareness audit: walk the actual funnel (fetch live pages when URL exists) — stress-test hooks, messaging, proof placement. Flag every attention leak with location + why. Deliver 10 concrete fixes ranked by impact.
2. Lead capture audit: score each opt-in/lead magnet on the Value Equation; list friction points to kill; rewrite the weakest magnet.

## Output rules

- Every mode writes its file under `marketing/` in the project (create dir if missing). Update, don't overwrite prior good content — append dated sections.
- Every generated list is scored and ranked, never raw brainstorm dumps.
- End each run with: what was produced, where saved, suggested next mode.

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Inventing product features/pains | Only claims traceable to code, research quotes, or user statements |
| Value Equation as adjectives | Use the 1–10 rubric; show scoring table |
| 3 offers / 13 hooks "good enough" | Hit the counts — volume then ranking IS the method |
| Chat-only output | Write the mode's file every run |
| Formats for platforms user isn't on | context.md lists real platforms; respect it |

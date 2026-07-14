---
name: first-customer-finder
description: Use when the user wants to find actual people or companies to sell to — first customers, early adopters, beta users, design partners, prospects, leads — or asks "who would buy this", "where are my first users", "find people with this problem", "who should I talk to before launch". Works from a product URL, repo, or description.
---

# First Customer Finder

Turn a product URL or description into a short, evidence-backed list of plausible first customers. Public signals only, every prospect cited, outreach drafted but NEVER sent. A prospect is a research hypothesis — not a confirmed buyer; label output "potential customer based on public signals".

Read [references/research-framework.md](references/research-framework.md) before researching or scoring. Read [references/report-artifact.md](references/report-artifact.md) before the final report.

## Workflow

### 1. Understand the product

- FIRST read existing context: `marketing/context.md` and `.agents/product-marketing.md` in the project — if present, the product brief is largely done; don't re-ask what they answer.
- Else inspect the supplied URL, repository, landing copy, or description.
- Identify product, outcome, buyer, user, price/buying motion, geography, strongest use case.
- Define one primary ICP, one adjacent ICP, pain triggers, positive signals, disqualifiers.
- Infer missing context when safe and label the inference. Ask one concise question only when ambiguity would materially change the search.

### 2. Build a public-signal search plan

Use WebSearch/WebFetch (and browser tools for JS-heavy public pages). Search current public sources for:

- explicit tool or alternative requests
- first-person descriptions of the target problem
- manual workflows and repeated workaround complaints
- migration, churn, or competitor-frustration signals
- public company changes that create timing (hiring, launching, expanding, adopting a relevant workflow)

Multiple query angles and source types (query buckets in the framework reference). Prefer original pages over search snippets. Record source URL, source type, publication date when visible, and the exact evidence.

### 3. Research safely

- Public, intentionally shared professional or business information only.
- Do not bypass login walls, paywalls, access controls, rate limits, or robots restrictions.
- No data brokers, leaked datasets, private groups, personal email discovery, phone enrichment, or sensitive personal information.
- Do not infer protected traits or target people via health, financial hardship, political belief, sexuality, religion, or other sensitive attributes.
- Prefer companies, public professional profiles, public requests, community posts.
- Quote minimally, paraphrase by default. Link every material pain or timing signal.

### 4. Qualify and deduplicate

Score each prospect with the framework's weighted rubric (pain strength, product fit, timing, public reachability, evidence quality — 0–100 composite). Remove duplicates and weak matches. A prospect without a cited pain, need, or timing signal must not appear in the primary shortlist. Never claim a prospect is interested, has consented, or will buy.

### 5. Draft outreach, never send it

- Recommend the most natural public channel already associated with the source.
- One short opener (<90 words) grounded only in the cited public context; no false familiarity.
- Do NOT send messages, submit forms, connect, follow, comment, or create CRM records — drafting only. Sending is the user's separate, explicit decision.

### 6. Produce the report

Order: **Verdict** (are there reachable early-customer signals?) → **ICP** → **Top prospect** → **Prospect shortlist** (source, signal, score, stage, why now, channel, opener) → **Repeated patterns** → **Seven-day manual outreach plan** → **Limits** (what only real conversations can confirm).

Deliver as files in the project (chat-only on request):

1. Write structured JSON per `references/report-artifact.md` to `marketing/prospects/analysis.json`.
2. Run `python3 <skill>/scripts/generate_report.py marketing/prospects/analysis.json marketing/prospects/report.html`.
3. Verify prospect cards, source links, scores, patterns, plan, limitations render.
4. Also append the shortlist as a dated section to `marketing/prospects.md` (plain markdown, so the `marketing` skill can consume the pain quotes and patterns).
5. Return the absolute report path in the final response.

## Modes

- **quick**: up to five strong prospects.
- **standard** (default): up to ten prospects across several public source types.
- **deep**: up to twenty prospects + repeated pain-pattern map.
- **design-partners**: prioritize users willing to test and give feedback over immediate buyers.
- **b2b**: prioritize companies, public business triggers, decision roles.
- **community**: prioritize public discussion and explicit request signals.

## Quality bar

- Every prospect linked to at least one meaningful public signal.
- Ten strong matches beat a long generic list.
- Uncertainty and stale evidence made visible (dates, freshness warnings).
- Personalize from the source, never from invented assumptions.
- Outreach stays manual and respectful.

## Relation to sibling skills

SELL-stage research: run it around launch to find the first ten conversations. Its pain quotes and patterns feed the `marketing` skill's offer (Mode 2) and proof (Mode 4) work via `marketing/prospects.md`. For ongoing outbound at volume, graduate to the marketingskills collection's `prospecting` + `cold-email`.

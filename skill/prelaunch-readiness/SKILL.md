---
name: prelaunch-readiness
description: >
  Interactive pre-launch readiness pass for any web/app/SaaS project: it SCANS the
  repo when it can, interviews you for what code can't reveal, then runs a
  read-only SECURITY audit and a LEGAL/PRIVACY coverage check, ending in a
  prioritized readiness report plus ready-to-run fix prompts. Use whenever the user
  is preparing to launch, ship, or "go live"; asks "is my app safe/ready to
  launch", wants a security review or pre-launch checklist, mentions RLS, rate
  limits, API-key exposure, security headers, CORS, auth enumeration, secrets in
  the bundle, npm audit / CVEs; or needs a privacy policy, cookie notice, terms of
  use, DPA, sub-processor list, a privacy-regime decision under GDPR, UK GDPR, US
  state laws (CCPA/CPRA and similar), Brazil LGPD, Canada PIPEDA, or the
  controller's home-country law (the framework is jurisdiction-agnostic, not
  EU-only), a consent-banner decision, a cross-border
  Art-27 representative or processor-DPA / SCC question, a passive-availability
  "which markets do we target" call, EU consumer withdrawal / ADR / governing-law
  terms, or to check whether their legal docs match what the app actually does.
  Trigger it even if the user
  only mentions one piece (e.g. "do I need a cookie banner?", "scan my repo before
  launch") — run the relevant phase.
---

# Pre-Launch Readiness

A repeatable, project-agnostic pass that answers one question: **is this project
safe and legally covered enough to put in front of real users?** It scans the code
where it can, asks about what code can't reveal, and produces one prioritized
readiness report with fix prompts.

## Core principles (apply throughout — do not violate)

1. **No fabrication.** Never invent findings, file paths, config values, library
   names, regions, or "facts." If you can't verify something, mark it `UNVERIFIED`
   and name what to check. A confident wrong answer is worse than an honest "I
   couldn't confirm this."
2. **Evidence provenance on every finding.** Tag each finding with how you know it:
   - `[verified]` — you read it in the code (give `file:line`).
   - `[reported]` — stated by a trusted prior gate/audit, not re-checked by you.
   - `[UNVERIFIED]` — not confirmed; say what would confirm it.
   "Verified present in code" is not "confirmed live" — an imported SDK may be dead
   code, a flag may be off. Say which you mean.
3. **The audit is read-only first.** Investigate and REPORT. Don't change code,
   branch, or commit during the audit. Surface findings, let the user decide, then
   scope fixes onto a branch with the project's own review/gate.
4. **Match docs to reality.** A privacy policy or terms doc describing a process the
   app doesn't run (or omitting one it does) is a liability, not protection. Check
   every legal claim against the real data flows.
5. **Not legal advice.** Templates are starting drafts with `{{placeholders}}` and
   `[CHECK]` markers; a qualified lawyer in the relevant jurisdiction must review
   them, and where a local-language version legally binds users, that version is
   authoritative and must be human-reviewed before publishing.
6. **Proportionality over theater.** Recommend what the project's real risk
   warrants. Distinguish a real hole from defense-in-depth tidiness, and a
   free-tier service that can't bill you from a metered API that can. Don't inflate
   severities; don't add security that breaks legitimate use.

## Phase 0 — Mode + intake

**First, pick the mode based on access to the code:**

- **Scan mode** — you can read the project's files (Claude Code pointed at the
  repo, or files provided). This is the default and the strong one. Read the code
  FIRST and auto-fill everything verifiable with `[verified]` + `file:line`:
  database authorization, validation, secrets/bundle exposure, security headers,
  CORS, auth-cookie SameSite, rate limits, which third-party SDKs are wired in (the
  real sub-processor list), dependency CVEs, feature flags, and which legal docs
  exist + whether they match the code. Then the interview **shrinks to only what
  code can't reveal**: hosting region, dashboard spend caps/alerts, who the legal
  controller is, retention commitments, lawyer-review status, SPF/DKIM. Route
  "where is data hosted" and "does the browser contact this sub-processor directly"
  to a **code check**, not a self-report, whenever the code is available.

- **Interview mode** — no code access. Gather everything by asking
  `references/intake.md`, and mark code-dependent findings `[UNVERIFIED]` honestly.
  Do not fabricate to fill gaps.

State which mode you're in at the top of the report.

**Then run intake** (full in interview mode; gaps-only in scan mode) from
`references/intake.md`. It builds the **Project Profile** — company identity, what
the product is, **whether it's actually deployed or pre-deploy**, what ships
**enabled vs feature-flagged-off** at launch, users/roles, personal data, hosting,
third-party services, trackers (yes/no), payments, metered/billable APIs, auth
model, jurisdiction (incl. **cross-border** controller-vs-users). Write the profile
down and confirm it before auditing — controller/processor role, the trackers
answer, hosting region, deployment status, and cross-border setup drive most of
what follows.

**Interactive vs single-pass:** prefer interactive (ask in small batches, confirm,
then audit). If asked to run end-to-end in one turn, don't block on the interview —
produce the full report with `[UNVERIFIED]` markers and a short **confirm-block**
of the open questions at the end.

If the user only wants one phase (e.g. "just the security scan" or "do I need a
cookie banner?"), run the relevant intake subset and that phase only.

## Phase 1 — Security audit (read-only)

Read `references/security-audit.md` and work through every check, producing a
finding per item: provenance tag · status (`OK` / `NEEDS ATTENTION` / `N/A` /
`UNVERIFIED`) · severity · evidence (`file:line` when `[verified]`) · one-line
recommendation. It covers: legal/data baseline, database authorization (RLS /
tenant isolation), server-side validation, error-message leakage, auth
failure-case + enumeration tests, the secret/OWASP/data-leak sweep, **HTTP security
headers**, environment-variable lockdown, rate limits & cost caps (free-tier vs
billable), CAPTCHA/honeypot & CORS/SameSite, **email deliverability + built-in-
provider-email trap**, **dependency / supply-chain (CVEs)**, **feature-flag / dark-
launch awareness**, and the automated scanner. Adapt to the stack from the Profile;
the principles are universal even when the implementation differs. Change nothing.

## Phase 2 — Legal & privacy coverage

Read `references/legal-coverage.md`. Using the Profile, determine which documents
this project needs (not all are always needed), check what exists and whether it
matches reality, and generate/update drafts from `templates/`. It walks the
controller-vs-processor call, the **sharpened** single-vs-split-terms trigger (split
only when a business customer is itself a separate controller of its own end-users'
data — not merely when two user roles exist), the consent-banner decision (banner
only if non-essential trackers exist; and **verify an existing gate before
prescribing one**), the **cross-border branch** (targeting-vs-accessibility /
**passive-availability** posture, representative appointment, and the transfer
mechanism — a **signed processor DPA**, not a policy sentence; plus the
no-transfer single-entity test and its two risk vectors — fires only on the
cross-border trigger), the **EU consumer-protection branch** (withdrawal rights +
exemptions, the mandatory intermediary savings clause, the governing-law consumer
carve-out, and ADR + the **retired EU ODR platform**), retention (incl. the
**statutory accounting-record floor** from home-country law), data-subject rights +
supervisory authority, and the match-docs-to-reality cross-check. Templates:
`PRIVACY-POLICY.md`, `COOKIE-NOTICE.md`, `TERMS-OF-USE.md`, `DPA.md`,
`SUBPROCESSORS.md`.

## Phase 3 — Readiness report + fix prompts

Produce ONE consolidated report:

```
# Pre-Launch Readiness Report — <project> (<date>)
**Mode:** scan / interview   **Deployment:** live / pre-deploy

## Project profile (confirmed)
<one paragraph; note dark-shipped/flagged-off features>

## Verdict
<one honest line: ready / ready after N fixes / not yet — and why>

## Security
<table: # | area | provenance | status | severity | evidence | recommendation>

## Legal & privacy
<table: doc/requirement | needed? | exists? | matches reality? | action>

## Do these before launch (prioritized)
1. <highest-impact, with why>  ...

## Launch-time enable checklist  (only if dark-shipped/flagged features exist)
<what must be wired/checked the moment each flagged feature is turned on>

## Do yourself (not code)
<dashboard caps/alerts, lawyer review, SPF/DKIM, regenerating a leaked key,
setting hosting region>

## Open / unverified
<the confirm-block: questions whose answers would close [UNVERIFIED] items>

## Ready-to-run fix prompts
<one consolidated, gated prompt per cluster of code fixes — branch, implement,
run the project's checks/gate, STOP for review. Never auto-merge.>
```

Rank by real impact, not checklist order. **Re-time findings to deployment status:**
for a pre-deploy project, "regions not set / caps not set / SPF-DKIM missing" are
launch-time tasks, not current breakages — say so. Separate code fixes (gated
prompts) from things the user does outside code. End by stating plainly what, if
anything, actually blocks launch versus what is nice-to-have hardening.

## Tone

Direct and proportionate. An honest readiness picture the user can act on — not a
wall of red flags, not false reassurance. If the project is in good shape, say so;
if one thing genuinely blocks launch, say it first.

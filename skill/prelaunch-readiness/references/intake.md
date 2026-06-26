# Intake Interview

Builds the **Project Profile**. Ask in small batches, conversational, skipping
anything the code or conversation already answers (confirm instead of re-asking).

**Scan mode:** read the code first and auto-fill everything verifiable; the
interview then covers only what code can't reveal (marked ⓘ below). **Interview
mode:** ask everything; mark code-dependent answers `[UNVERIFIED]`.

The answers drive every later decision — especially controller/processor role, the
"do we have trackers" question, hosting region, deployment status, cross-border
setup, and which billable APIs exist.

## A. Company / publisher identity
- Legal entity name, registered address, country.
- Registration / tax number.
- Public contact email(s) — support vs. sales vs. privacy if they differ.

## B. What the product is + its launch state
- One-line description.
- Shape: B2C app? B2B SaaS? marketplace / two-sided? multi-tenant / white-label?
  internal-only? (Decides single vs. split docs and controller/processor role.)
- Web / mobile / PWA / native app store / several? (App-store distribution adds
  terms; a PWA does not.)
- **Is it actually DEPLOYED/live, or pre-deploy?** (Distinct from revenue. For a
  pre-deploy project, missing regions/caps/SPF-DKIM are launch-time tasks, not live
  breakages — the report re-times findings accordingly.)
- **Is it pre-revenue or already charging?**
- **What ships ENABLED vs. feature-flagged-OFF at launch?** Dark-shipped/flagged
  surfaces change what is actually live — and therefore what must be audited and
  legally covered now — and create a launch-time enable checklist (e.g. a
  password-reset flag must be turned on in lockstep with its email template).

## C. Users and data subjects
- Who are the users (and are there multiple roles)?
- Accounts, or some anonymous users?
- What personal data per role (name, email, phone, location, payment, content)? Be
  specific (e.g. "location only if the user taps 'use my location'").
- Any special-category data (health, biometric, children's)? Raises the bar — flag.

## D. Where data lives + third parties
- ⓘ Hosting/database provider(s) and **region(s)** — verify from code/config in
  scan mode; ask only if not determinable.
- Every third-party service touching user data — auth, DB, **email/SMTP**, SMS,
  payments, maps/geocoding, storage, error tracking, support chat, CDN. For each:
  purpose, data received, region, and ⓘ whether the **user's browser contacts it
  directly** (exposes the user's IP) — determine by tracing client-vs-server calls
  in scan mode, don't self-report. This is the sub-processor inventory.
- **Email specifically:** built-in provider email (e.g. Supabase/Firebase default)
  or custom SMTP? Built-in provider email is often not production-grade and hurts
  deliverability of security-critical mail (password resets, verification);
  switching to custom SMTP adds a sub-processor to the privacy policy. Capture both
  facts.

## E. Tracking & marketing (decides consent-banner need)
- Any analytics, ad pixels, session replay, A/B, or marketing tags?
- Anything in cookies / localStorage / sessionStorage beyond strictly-necessary
  (auth/session, security) + functional (a language/theme preference)?
  - **Non-essential tracker present → consent banner (opt-in, blocks trackers until
    consent) likely required.**
  - **Only essential/functional → a cookie *notice* suffices; no opt-in banner.**
    Don't add a consent tool for trackers you don't have.

## F. Payments & billable/metered APIs (decides cost-cap strategy)
- Payments? Via whom?
- Which third-party APIs are **metered/billable or quota-limited**? For each, note
  the limit and whether overage is **auto-charged or just blocked**:
  - **Auto-charging** (LLM APIs, SMS gateways, Stripe usage, paid maps): a runaway
    can run up a real bill → **hard caps + alerts** in the provider dashboard.
  - **Free-tier / soft-limit** (an email tier that stops at N/day; a geocoder that
    emails you to upgrade rather than billing): can't surprise-bill you; risk is
    silent failure → **monitoring + a known upgrade trigger**, plus rate limits so
    abuse can't exhaust the quota. A "spend cap" here is theater — say so.

## G. Auth & access model
- Auth provider/mechanism.
- Roles and what each can access; how isolation is enforced (DB row-level security?
  app-layer scoping? both?).
- ⓘ Session cookie attributes (SameSite, Domain) — verify from code in scan mode.

## H. Jurisdiction & legal (incl. cross-border)
- Primary market and governing law for the terms.
- Which data-protection regime(s) apply (GDPR, UK GDPR, CCPA, a national act) and
  the relevant supervisory authority.
- **Cross-border check:** is the controller established **outside** the regime
  where the users are (e.g. a non-EU company serving EU users)? If so, it triggers
  the legal-coverage cross-border branch — likely a **representative appointment**
  (GDPR Art. 27-style) and an explicit **international-transfer mechanism**. Capture
  this; it's easy to miss and legally significant.
- Retention periods committed to or legally required (e.g. accounting records).
- Will a lawyer review the legal docs before publishing? (There should be.)

## I. Tech stack (to tailor the security audit)
- Framework / language / runtime, hosting platform, database.
- How deploys happen and how they're verified (so fix prompts match the real
  workflow and gate).

---

Write a concise **Project Profile** and confirm it before auditing. In scan mode,
mark each profile field `[verified]` (from code) or `[reported]`/`[UNVERIFIED]`.
List explicitly anything still unknown so it's checked in Phase 1/2, not assumed.

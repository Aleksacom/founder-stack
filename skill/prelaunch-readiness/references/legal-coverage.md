# Legal & Privacy Coverage

Using the Project Profile, decide which documents the project needs, check what
exists and whether it matches reality, and generate/update drafts from
`templates/`. Not every project needs every document.

**You are not a lawyer.** Everything here produces *drafts* with `{{placeholders}}`
and `[CHECK]` markers for a qualified lawyer in the relevant jurisdiction. Where a
local-language version legally binds users, that version is authoritative and must
be human-reviewed before publishing.

**Jurisdiction note (read first).** This guide names **EU/UK examples** (GDPR, the
EU Consumer Rights Directive, the Unfair Terms Directive, EDPB guidance) because
they are the strictest common bar and make the worked examples concrete — but the
**structure is jurisdiction-agnostic**. Identify the project's ACTUAL regime(s)
from the Profile and apply the local equivalent; do not assume EU.
- **Privacy:** UK GDPR; US state laws (California CCPA/CPRA, plus Virginia,
  Colorado, etc.); Brazil **LGPD**; Canada **PIPEDA**; Switzerland **revFADP**; and
  the controller's **home-country** data-protection + accounting law. Most share the
  same spine — controller/processor, lawful basis, data-subject rights, breach
  duties — under different names.
- **Consumer terms:** the withdrawal / unfair-terms / governing-law branch
  (Step 5.5) maps to each market's own consumer-protection statute.
- **Cross-border (Step 5):** the targeting-vs-accessibility test and the
  "transfer mechanism is a signed contract" rule apply to ANY
  controller-outside-the-users'-regime pairing — not only non-EU→EU. A US company
  serving Californians, or a company serving several regimes at once, runs the same
  branch per regime.
When regimes overlap (e.g. EU + US + home-country footprint), apply each in parallel
and, where they conflict, the **stricter** one — and flag the overlap for the
lawyer.

## Step 1 — Build the data inventory
List (from the Profile + code): every category of personal data collected per role;
where each is stored and for how long; every third-party service that receives it
(purpose, data, region, direct-browser-contact yes/no). **Verify against the code**
in scan mode — don't take a doc's word for what the app does. This inventory is the
backbone of the privacy policy, sub-processor list, and DPA.

## Step 2 — Controller vs processor, and single vs split terms
- Decide the purposes/means of processing → **controller**. Process data **on
  another organization's behalf** → **processor** (your customer is the controller;
  you need a **DPA**, and end-user-facing privacy text belongs to the customer).
- **Single vs. split terms — sharpened trigger:** split into platform (B2B) terms +
  end-user terms **only when a business customer is itself a separate controller of
  its own end-users' data** (true white-label / B2B-reseller). Do **not** split
  merely because there are two user roles. A two-sided *consumer* marketplace
  (e.g. travelers + providers, both your users, you control both) needs **one terms
  doc with role-specific sections**, not a split. The deciding question is "is
  there a business customer who is a separate controller?", not "are there two
  roles?".

## Step 3 — Decide which documents are needed

| Document | Needed when |
|---|---|
| **Privacy Policy** | Almost always — any collection of personal data. |
| **Cookie / Storage Notice** | Any browser storage. *Notice* if only essential/functional; full *consent banner* if non-essential trackers (Step 4). |
| **Terms of Use** | Almost always. Split only per the Step 2 controller test. |
| **DPA** | When you are a processor for business customers. |
| **Sub-processor list** | When third parties process data on a customer's behalf (pairs with the DPA). |

## Step 4 — Consent-banner decision
A consent **banner** (opt-in + preference center) is required **only when you load
non-essential cookies/trackers** (analytics, ad pixels, session replay, marketing).
- **Only strictly-necessary + functional storage** (auth/session, security, a
  language/theme preference)? → a **cookie notice**, NOT an opt-in banner.
- **Any non-essential tracker?** → a banner that **blocks those until opt-in**, plus
  a way to change consent later.
- Don't add a consent tool (and its third-party script) for trackers you don't
  have — it's a non-functional widget and a new third-party data flow. Add the
  banner the moment you add analytics/ads, not before.
- **In scan mode, check whether a banner/gate already EXISTS before prescribing
  one.** Look for both a consent component AND a server/edge gate that actually
  withholds the non-essential cookies until opt-in — a banner that only hides UI
  but still sets the cookie is non-compliant theatre. Verify: cookies set ONLY
  after opt-in (no speculative set-then-delete); **reject as easy as accept**
  (equal prominence on the first layer — 2023 EDPB cookie-banner taskforce + 2025
  DPA rulings require a first-layer reject); a withdrawal path **reachable by
  anonymous visitors** (not only behind login); and that a later "denied" clears
  any cookie already set. Don't recommend building what's already there.
- A self-built banner for a few first-party cookies is fully compliant — a
  commercial CMP (Cookiebot/OneTrust) is not required and adds a third-party data
  flow. The consent *record* itself (e.g. a `consent=granted|denied` cookie) is
  strictly-necessary and may be stored pre-consent.

## Step 5 — Cross-border branch (fires only on the cross-border trigger)
If the controller is established **outside** the regime where the users are (e.g. a
non-EU company serving EU users), work these — otherwise skip this step:

**5a — Targeting vs. mere accessibility (the threshold question).** Extraterritorial
reach (GDPR Art. 3(2); EU consumer law via Rome I Art. 6 and the *Pammer/Alpenhof*
"directing activities" test) triggers on **targeting** a region, not on a site being
**accessible** there. A controller can serve some regions and deliberately **not
target** others. If the project wants to be reachable everywhere but only operate in
some markets, a **"geographic scope / intended audience" disclaimer** (in privacy +
terms) — naming the intended markets and the non-target ones, and backed by
*actually not targeting* them (no local-currency pricing, no localized marketing, no
region-specific campaigns) — keeps it on a **passive-availability** footing and can
avoid appointing a representative in every accessible region. Flag the posture for
the lawyer; it only holds if behaviour matches the words.
  - **Currency is a targeting signal only in YOUR own pricing.** Offering a
    non-target market's **local currency in your core pricing / budget tools** reads
    as targeting it; a neutral multi-currency **display-preference** picker
    (many currencies, user-chosen) does not. Pull a market's local currency out of
    the *core funnel* if you're not targeting it; a broad display picker can stay.

**5b — Representative.** A designated representative in the users' region (GDPR
Art. 27-style). The **competent supervisory authority** for that controller is then
typically the SA of the member state **where the representative is established** —
use that one where a form (e.g. an SCC annex) asks for it. Flag the appointment
itself as a `[CHECK]` for the lawyer.

**5c — The transfer mechanism is a SIGNED contract, not a policy sentence.** A
privacy-policy line saying "we use SCCs" is only a *disclosure*; the safeguard is an
**executed Data Processing Agreement** (which incorporates the SCCs) with each
processor.
  - **Acceptance method varies per provider** — some incorporate the DPA by
    reference into the ToS accepted at sign-up (already binding; download a copy),
    others require **explicit signature** (click-to-sign / e-sign) before it exists
    at all. Scan mode can't see this — route it to the user: *"have you executed
    each processor's DPA, and do you have the copy on file?"* Keep executed PDFs in
    a secure store (NOT the repo — they carry signatures); an internal evidence
    ledger (processor · agreement ref · executed date · SCCs y/n) is good practice.
  - **The no-transfer case — don't over-apply SCCs.** Under EDPB Guidelines 05/2021
    a Chapter-V "transfer" needs **three** things: (1) the exporter is subject to
    GDPR, (2) it discloses data to a **separate** importer entity, (3) the importer
    is in a third country. A **single controller accessing its own data hosted in
    the users' region** has no separate importer → **no transfer, no SCCs strictly
    required**. State that as the primary basis where it fits.
  - **But belt-and-suspenders is the market norm, and there are two real risk
    vectors** — so most still execute the processor DPAs anyway: (a) an EU-hosted
    but **foreign-owned sub-processor** (e.g. a US-parented cloud) can face
    foreign-government compulsion (CLOUD Act / FISA), which regulators treat as a
    transfer-risk; (b) any **outbound replication** of data back to the controller's
    own third country (backups, read-replicas, exports) **is** a real transfer
    needing SCCs. Recommend: keep the no-transfer reasoning as primary, execute the
    processor DPAs as the safeguard, confirm **no replication leaves the users'
    region**, and keep a one-page transfer impact assessment on file.

Reflect controller identity + representative + the transfer basis in the privacy
policy and (where kept) the Art-30 record.

## Step 5.5 — EU consumer-protection branch (consumer-facing products serving the EU)
Fires when the product contracts with **EU consumers** (B2C), including a consumer
marketplace — independently of where the company is established (Rome I Art. 6
applies the consumer's home mandatory law; Brussels I-bis gives them their home
courts). Raise these in the terms and flag for the lawyer:
- **Right of withdrawal (14-day cooling-off, CRD 2011/83/EU).** State it, then state
  the exemptions that actually apply — e.g. accommodation, transport, car rental,
  catering, and **leisure-activity services tied to a specific date/period**
  (Art. 16(l)) are exempt; most travel/event/date-bound bookings fall here. Word the
  exemption; never a blanket "no refunds".
- **Intermediary / "not a party" framing needs a savings clause.** A marketplace can
  describe itself as a **commercial agent** for the provider and say the contract is
  between user and provider — but it **cannot** disclaim mandatory consumer rights
  that way. Every limitation-of-liability / intermediary clause must carry a
  **"nothing here limits your statutory consumer rights"** savings clause, or it is
  void under the Unfair Terms Directive 93/13. Liability for death/personal-injury by
  negligence and for fraud can **never** be excluded.
- **Governing-law consumer carve-out.** You may choose your own governing law, but EU
  consumers keep (a) the **mandatory protections of their home country** and (b) the
  right to litigate in **their home courts**. A bare "our-country law + our-country
  courts" clause is unfair; the simplest compliant wording applies the consumer's
  home-country law for consumer-protection purposes.
- **ADR notice + the dead ODR link.** Provide an alternative-dispute-resolution
  notice pointing to national ADR bodies. **Do NOT link the EU ODR platform — it was
  discontinued on 20 July 2025; a live link to it is itself a compliance risk.**

## Step 6 — Generate / update drafts
Use the matching `templates/` file per needed doc, filling placeholders from the
Profile. Adapt structure to the product; don't paste blindly. Keep each template's
lawyer-review disclaimer and `[CHECK]` markers. Every privacy policy / DPA should
cover: controller identity; what's collected and why (with legal basis); recipients/
sub-processors; storage location + international-transfer basis; retention;
data-subject rights (access/correct/delete/restrict/object/portability) and **how to
exercise them**; identity-verification for requests (state the ACTUAL method,
especially for anonymous users); and the **supervisory authority** + complaint
route.

For **retention**, separate what you *choose* from what is *statutorily fixed*:
financial/accounting/invoice records carry a **mandatory minimum set by the
controller's home-country accounting & tax law** — get the exact statute, article,
and year-count from the user or their accountant; **don't guess**, and don't copy a
peer's number. These are often **tiered** (e.g. invoices vs. journals/ledgers vs.
annual statements vs. payroll, which is frequently permanent). Other categories
(account data, server/security logs, marketing-consent proof) follow
purpose-limitation + a defensible industry norm — peers are a reasonable guide
there, but the financial floor is law, not preference.

## Step 7 — Match docs to reality (critical cross-check)
Re-read each finished doc against the code and Profile; fix every mismatch — this is
where real liability hides:
- A policy claiming identity for data requests is verified by **SMS OTP** when the
  app has no SMS and actually does a manual/export process.
- A policy claiming **magic-link / passwordless** auth when the app uses passwords
  (or vice-versa).
- A cookie clause asserting **consent-gating** before any consent mechanism exists.
- "Hosted in <country X>" contradicting the real region in the privacy policy/DPA.
- App-store / mobile-license clauses on a **PWA-only** product.
- Generic-generator clauses that don't fit: company ownership of user "submissions/
  feedback," disproportionate arbitration, wrong data-transfer statements.
Treat any auto-generated or templated doc as a **checklist of clauses to verify**,
not a finished document.

## Step 8 — Account for dark-shipped features
For features flagged-off at launch, don't publish docs describing flows users can't
reach yet — but add them to the **launch-time enable checklist** so the relevant
clauses/sub-processors go live in lockstep when the flag flips (e.g. a marketplace
surface needs its terms + payment sub-processor live before it's enabled).

## Step 9 — Output
Per document: needed? · exists already? · matches reality? · action (create draft /
fix mismatch / fill placeholders / send to lawyer). Note human-only steps clearly:
lawyer review, translation to the binding language, the cross-border representative
appointment, and SPF/DKIM domain authentication (an email-deliverability step often
mistaken for a legal one).

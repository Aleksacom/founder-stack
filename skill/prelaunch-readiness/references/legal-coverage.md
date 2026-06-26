# Legal & Privacy Coverage

Using the Project Profile, decide which documents the project needs, check what
exists and whether it matches reality, and generate/update drafts from
`templates/`. Not every project needs every document.

**You are not a lawyer.** Everything here produces *drafts* with `{{placeholders}}`
and `[CHECK]` markers for a qualified lawyer in the relevant jurisdiction. Where a
local-language version legally binds users, that version is authoritative and must
be human-reviewed before publishing.

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

## Step 5 — Cross-border branch (fires only on the cross-border trigger)
If the controller is established **outside** the regime where the users are (e.g. a
non-EU company serving EU users), raise these — otherwise skip this step:
- **Representative appointment:** likely a designated representative in the users'
  region (GDPR Art. 27-style). Flag as a `[CHECK]` for the lawyer.
- **International-transfer mechanism:** an explicit basis for moving data out of the
  users' region (e.g. SCCs / adequacy). Caveat the lawyer must resolve: when the
  data *importer* is itself subject to the users' regime (e.g. an EU-hosted
  sub-processor), standard SCCs may not be the right fit — note it rather than
  asserting a mechanism.
- Reflect both in the privacy policy (controller identity + representative; transfer
  basis section).

## Step 6 — Generate / update drafts
Use the matching `templates/` file per needed doc, filling placeholders from the
Profile. Adapt structure to the product; don't paste blindly. Keep each template's
lawyer-review disclaimer and `[CHECK]` markers. Every privacy policy / DPA should
cover: controller identity; what's collected and why (with legal basis); recipients/
sub-processors; storage location + international-transfer basis; retention; data-
subject rights (access/correct/delete/restrict/object/portability) and **how to
exercise them**; identity-verification for requests (state the ACTUAL method,
especially for anonymous users); and the **supervisory authority** + complaint
route.

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

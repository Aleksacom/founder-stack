# Security Audit (read-only)

Work through every check against the **actual code** when available, adapting to
the stack from the Project Profile. For each, produce a finding:

`provenance` (`[verified]` file:line / `[reported]` / `[UNVERIFIED]`) · `status`
(OK / NEEDS ATTENTION / N/A / UNVERIFIED) · `severity` (CRITICAL / HIGH / MED / LOW
/ INFO) · `evidence` · `recommendation` (one line).

**Do not change anything in this phase.** If you can't determine something
read-only, mark `[UNVERIFIED]` and name what to check — never guess a value.
"Verified present in code" ≠ "confirmed live" (an import may be dead code; a flag
may be off) — say which you mean.

Severity discipline: a real, exploitable-without-a-secret hole is HIGH/CRITICAL;
something already mitigated by another layer (rate limit, signature, capability
token, SameSite cookie) is LOW/MED defense-in-depth. Say which.

## Table of contents
1. Legal & data-handling baseline
2. Database authorization (RLS / tenant isolation)
3. Server-side validation on every write
4. Error messages that don't leak internals
5. Auth failure-case & enumeration tests
6. Secret / OWASP / data-leak sweep
7. HTTP security headers
8. Environment-variable lockdown
9. Rate limits & cost caps
10. CAPTCHA / honeypot & CORS / SameSite
11. Email deliverability & built-in-provider-email trap
12. Dependency / supply-chain (CVEs)
13. Feature-flag / dark-launch awareness
14. Automated scanner as final gate

---

## 1. Legal & data-handling baseline
Confirm the basics that protect the publisher: a privacy policy exists or is
drafted (Phase 2), the team knows exactly where data lives, and nothing reckless is
happening (no selling data, no exporting to personal inboxes, no plaintext
passwords, no secrets in version control). Flag obviously unsafe handling here;
depth is in Phase 2.

## 2. Database authorization (RLS / tenant isolation)
The most common catastrophic failure: a database anyone can read via DevTools.
- Client queries the DB directly (e.g. Supabase from the browser): confirm **Row
  Level Security is ON with policies** on every table holding user data. RLS off,
  or on with zero policies, = anyone can read everything.
- Data reached only through a server/API layer (server holds the privileged key,
  client never queries the DB): confirm **every query is scoped to the
  authenticated user/tenant from server-derived context**, never a client-supplied
  id. App-layer scoping is a valid substitute for RLS *only if* the client truly
  never touches the DB — verify that.
- Multi-tenant: confirm one tenant can never read another's rows.
- **Test isolation, don't just confirm it exists** — RLS enabled incorrectly
  creates false confidence.

## 3. Server-side validation on every write
Client validation is UX, not security. For every endpoint/action that writes:
- Confirm **server-side** validation: types, required fields, length caps,
  format/bounds (coordinate ranges, UUID format, enum membership), sanitization.
- Confirm authority-bearing fields (tenant id, user id, role, price) come from
  **server context or the DB**, not the client body.
- Report any input relying on client validation only.

## 4. Error messages that don't leak internals
- User-facing errors generic ("User not found", "Something went wrong").
- No stack traces, SQL, or table/column names returned to the client; log
  server-side instead.
- Watch distinguishable responses that leak existence/state (see §5).

## 5. Auth failure-case & enumeration tests
Test unhappy paths. Report behavior for each:
- **Wrong password repeatedly:** rate-limit / lockout? generic error?
- **Reset for a non-existent email:** must NOT reveal existence — always return the
  same "if an account exists, we sent a link", ideally constant-time + rate-limited.
- **Verification link used twice:** handled gracefully?
- **Signup with an already-registered email:** note whether it confirms existence;
  some disclosure is inherent to signup. Flag if distinct error codes leak more
  than necessary (role vs. reuse). Enumeration is usually lower-risk for B2B than
  consumer — judge proportionally, but always report so the user decides.

## 6. Secret / OWASP / data-leak sweep
- **OWASP-style review:** injection (SQL/command), XSS, broken access control,
  SSRF, insecure deserialization.
- **Data-leak audit:** API responses that over-return; sensitive data in logs.
- **API-key / secret exposure:** scan for any secret reachable from the client
  bundle (referenced in client components, or a public env prefix when it
  shouldn't be). Distinguish keys *designed* to be public (anon/publishable/public-
  VAPID) from genuine secrets (service-role, API secret, webhook signing, private
  VAPID). Flag only genuine leaks; if a real secret may be exposed, **regenerate it
  immediately**.
- If the workflow already runs an automated security review per change, note it —
  stronger than a one-time manual pass.

## 7. HTTP security headers
Check the response headers (and framework config that sets them) for the standard
set; report which are present/absent:
- **Content-Security-Policy** (the big one — restricts script/style sources; report
  if missing or `unsafe-inline`-heavy)
- **Strict-Transport-Security** (HSTS)
- **X-Frame-Options** / frame-ancestors (clickjacking)
- **X-Content-Type-Options: nosniff**
- **Referrer-Policy**
- **Permissions-Policy**
For Next.js/most frameworks these are a concrete, checkable artifact (config or
middleware). Missing headers are usually LOW–MED but easy to fix; CSP absence on an
app handling auth is worth calling out.

## 8. Environment-variable lockdown
- Secret keys read **only in server-only code**, never imported into client
  components (a `server-only` import guard is good evidence).
- Only genuinely-public values carry a public/`NEXT_PUBLIC_`-style prefix.
- Secrets not committed to version control (check repo + history; public repos get
  scraped within minutes).

## 9. Rate limits & cost caps
Two distinct risks — don't conflate:
- **Abuse / DoS:** every public, state-changing, or expensive endpoint rate-limited
  (per IP and/or per user). Confirm login, signup, reset, search/geocode,
  booking/submit, and any send (email/SMS) are capped.
- **Cost / quota:** per metered API, apply the right control:
  - **Auto-charging APIs** (LLM, SMS, paid maps, Stripe usage): **hard daily caps +
    alerts** in the provider dashboard — the real "$20→$200 overnight" risk.
  - **Free-tier / soft-limit services** (email tier that stops at N/day; geocoder
    that emails you to upgrade): can't surprise-bill you. Real risk is **silent
    failure** (legit reset emails stop arriving once the cap is hit). Control =
    **monitoring + a known upgrade trigger** + the rate limits above. A spend cap
    here is theater — say so.
- Caching + a server-side proxy on an expensive read API (e.g. geocoding) is strong
  defense; note if present.

## 10. CAPTCHA / honeypot & CORS / SameSite
- **Public forms:** need bot protection. A **honeypot + rate limit + same-origin
  check** is a legitimate lighter alternative to CAPTCHA for low-traffic forms; a
  CAPTCHA (e.g. Cloudflare Turnstile, free) is the upgrade if spam appears.
- **CORS:** confirm no permissive `Access-Control-Allow-Origin: *` on credentialed/
  state-changing routes. No CORS headers at all is usually fine — browsers block
  cross-origin reads by default. Don't recommend adding permissive CORS.
- **The real CSRF defense for cookie-auth routes is the session cookie's
  `SameSite`** (`Lax`/`Strict` blocks cross-site POSTs), NOT an origin header.
  Verify the auth cookie's SameSite (and Domain). `None`/unset = the genuine issue
  to flag. Also watch same-name cookies at different Domain scopes coexisting
  (host-only vs domain-wide) → nondeterministic session resolution.
- For **unauthenticated** state-changing routes, a same-origin guard is reasonable
  defense-in-depth but LOW/MED if they're already rate-limited and carry no victim
  credentials cross-site — be honest about the modest benefit.

## 11. Email deliverability & built-in-provider-email trap
Security-critical mail (password resets, verification) must actually arrive.
- Flag if the project uses a **provider's built-in email** (e.g. Supabase/Firebase
  default) — often not production-grade; resets land in spam or are rate-limited.
- Confirm **SPF/DKIM/DMARC** domain authentication for the sending domain (a DNS/
  dashboard task, not code — route to "do yourself").
- Note the privacy-policy consequence: moving to **custom SMTP adds a sub-processor**
  that must appear in the privacy policy + sub-processor list.

## 12. Dependency / supply-chain (CVEs)
- Run/recommend `npm audit` (or the stack's equivalent) and report known
  HIGH/CRITICAL CVEs in the dependency tree.
- Flag obviously abandoned or typo-squat-risk packages. For large vibe-coded dep
  trees this is a real surface, not a formality.

## 13. Feature-flag / dark-launch awareness
- Identify features that ship **disabled / behind flags**. They change both audit
  scope (don't fail an app for a surface that isn't live) and legal coverage (don't
  document a flow users can't reach yet).
- Produce a **launch-time enable checklist**: what must be wired/verified the moment
  each flag flips on (e.g. password-reset flag ↔ email template lockstep; a
  marketplace surface ↔ its terms + sub-processors).

## 14. Automated scanner as final gate
If the toolchain ships a scanner (CI security review, IDE/agent scanner, platform
scanner), treat passing it as the final gate before deploy — no shipping with open
warnings. If one runs per-change already, that's a strong baseline; if not,
recommend wiring one in.

---

## What NOT to over-flag (keep this calibration)
- A signature-verified webhook (HMAC/`constructEvent`) is authenticated by the
  signature — not an "open" route.
- A route gated by an unguessable capability token or resource UUID isn't
  CSRF-exploitable without that secret.
- Keys designed to be public (anon/publishable/public-VAPID) are not "leaked
  secrets."
- Absence of CORS headers is not a vulnerability.
- RLS is not mandatory when app-layer scoping is real and the client never touches
  the DB.
Correct an over-eager finding rather than passing it through — a report the user
can trust is the whole point.

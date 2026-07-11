# Pre-Launch Readiness — a Claude Code skill

A pre-launch checker for any web/app/SaaS project. Point Claude Code at your repo
and it **scans the code**, asks you only what code can't reveal, and gives you one
prioritized report covering **security** and **legal/privacy** — plus ready-to-run
fix prompts. It changes nothing; it reports.

It checks the things that actually get apps sued, fined, or breached: open
databases, secrets in the browser bundle, missing server-side validation, auth
leaks, missing security headers, rate-limit / cost-cap gaps, dependency CVEs — and
whether you have a privacy policy, cookie notice, terms, and (if needed) a DPA that
**match what your app actually does**.

---

## Install (one step)

```bash
git clone https://github.com/Aleksacom/prelaunch-readiness.git
cd prelaunch-readiness
./install.sh
```

That copies the skill into your Claude Code skills folder (`~/.claude/skills/`), so
it's available in **every** project. Re-run `./install.sh` any time to update.

> Want it only in one project instead of globally? Run `./install.sh --project`
> from inside that project.
>
> Custom skills location? `CLAUDE_SKILLS_DIR=/your/path ./install.sh`

No build step, no dependencies — it's plain Markdown that Claude Code reads.

## Use

Open Claude Code in any project and just say:

- **"run the pre-launch readiness check"** — the full pass
- **"scan my repo before launch"** — security-focused
- **"do I need a cookie banner?"** / **"check my privacy docs against the code"** —
  legal-focused

Claude picks up the skill automatically (no need to attach any files), interviews
you briefly for what it can't read from the code, and produces the report.

## What you get

- **Security audit** — database authorization (RLS / tenant isolation), server-side
  validation, secret/bundle exposure, error-message leaks, auth failure-case &
  enumeration tests, HTTP security headers, rate limits & cost caps, CAPTCHA/CORS/
  SameSite, email deliverability, dependency CVEs, feature-flag awareness, and a
  reliability spot-check for the launch-blocking correctness classes (idempotency on
  money/side-effects, transaction consistency, races on money/seat/quota state,
  external-call timeouts).
- **Legal & privacy coverage** — which of {privacy policy, cookie notice, terms,
  DPA, sub-processor list} you need, what's missing, and a **docs-vs-code mismatch**
  check. Includes generalized templates to fill in.
- **One prioritized report** — what blocks launch vs. nice-to-have hardening, code
  fixes as gated prompts, and a separate list of things you do yourself (dashboard
  caps, lawyer review, SPF/DKIM).

## How it stays honest

- **No fabrication.** Every finding is tagged `[verified]` (read in the code, with
  `file:line`), `[reported]`, or `[UNVERIFIED]`. It says what it couldn't confirm
  rather than guessing.
- **Read-only.** It audits and reports; it never changes your code.
- **Proportionate.** It distinguishes a real hole from defense-in-depth, and a
  free-tier service that can't bill you from a metered API that can.
- **Not legal advice.** Legal output is draft text with `[CHECK]` markers for a
  lawyer in your jurisdiction to review.

## What's inside

```
skill/prelaunch-readiness/
├── SKILL.md                 # the orchestrator Claude follows
├── references/
│   ├── intake.md            # the interview (shrinks in scan mode)
│   ├── security-audit.md    # the security checks
│   └── legal-coverage.md    # the legal/privacy decisions
└── templates/               # privacy policy, cookie notice, terms, DPA, sub-processors
```

You never touch these individually — `install.sh` handles them. They're here if you
want to read or tailor them.

## License

MIT — see [LICENSE](LICENSE). Set your name in the LICENSE file before publishing.

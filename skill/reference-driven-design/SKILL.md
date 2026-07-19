---
name: reference-driven-design
description: Use when building or redesigning a website/landing page/portfolio UI and you want it to look premium instead of templated — especially when the user has (or can find) reference sites/screenshots they like. Triggers on "build me a site/landing page/portfolio", "redesign this to look expensive/like <site>", "make it look like Awwwards", "here are some references", or any premium-visual frontend build. Pairs with taste-skill (quality bar) — this is the workflow that feeds it.
---

# Reference-driven design

The reason AI-built sites look generic: the agent designs from a text description, not
from references. This skill fixes that with a reference-first workflow. Method adapted
from monokern's "$10,000-level website in Claude Code" walkthrough.

**Core principle: show, don't describe.** Borrow what works from real sites, section by
section, and map each reference to a part of the build. Then let the agent ask before
it builds.

## The workflow

### 1. Gather references (section by section, not whole-page)
- Find 1–3 sites in the target aesthetic (Awwwards, Godly, Land-book, Dribbble, or a direct competitor). Ask the user for any site they like.
- Grab ONLY the sections that work, each as its own screenshot — hero, the section below hero, a feature block, footer, an inner page, the loading state. Different references for different sections is normal ("borrow what works from each").
- If no reference fits a section (e.g. a list/index page), find a separate one in a similar style.
- Drop every screenshot into a `/reference` folder in the project.

### 2. Write the build prompt — map each reference explicitly
Name every screenshot to a section, name the real assets, and END with a clarifying-questions line. Template:

```
Build a premium <site type> for <who>. It should look expensive, modern, and
technically impressive, with elegant animations that perform on any device.

Use the references in the /reference folder:
- hero.png = hero section
- below-hero.png = the section right under the hero (<format, e.g. video + title>)
- features.png = <what it shows>
- footer.png = footer / bottom of site
- inner.png = an individual <item> page
- loading.png = loading screen
Place <asset> using <file.png>; for placeholders use <example.png>.

Ask me any clarifying questions you need before building.
```

**The last line is the key.** The agent stops and asks 4–6 questions (style, fonts, sections, animation level, tone). The answers become the site's foundation — answer them specifically. This one line prevents most wrong-direction rebuilds.

### 3. Describe animations concretely, then "implement this"
Don't say "add nice animations." Describe the exact effect — trigger, states, geometry, feel — and end with "Implement this." Example (a spotlight/flashlight hero):

```
Flashlight/spotlight cursor effect in the hero. Dark background, subject barely
visible at default. On cursor move, a soft-edged circular mask (radius 100–150px,
feathered edges) follows the cursor and reveals a brighter, warm-lit version of the
subject underneath. Implement this.
```

### 4. Review pass — your eyes first, batched
Scroll the built site yourself, note everything that feels off (transitions, lag, overflow, fonts), then send ALL fixes in ONE message, numbered:

```
Here are things to fix. Please address all:
1. <issue>
2. <issue>
3. <issue>
```

Batching beats one-at-a-time — fewer turns, the agent sees the whole picture.

### 5. Polish pass — hand off to taste-skill
For the structured quality check (typography / color / hierarchy / animation / mobile /
copy, anti-slop rules), invoke **taste-skill** — it does this more thoroughly than a
manual prompt, plus a design-read. This skill gets you TO a solid build fast; taste-skill
makes it excellent. Read the taste-skill grade, agree/disagree per item, then batch the
agreed fixes into one message (step 4 again).

## When NOT to use
- Backend/data/dashboard work — this is for visual/marketing surfaces only.
- No references available and none findable — fall back to taste-skill's Design Read alone (it can infer a direction), but references almost always beat pure description.

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Screenshot a whole page, "make me this" | Grab sections; map each to a part of the build |
| Describe the site in prose, no references | Show real references — that's the whole point |
| "Add animations" | Describe trigger + states + geometry + feel, then "implement this" |
| Fixes one-at-a-time over many turns | Batch all fixes in one numbered message |
| Skipping the clarifying-questions line | Always end the build prompt with it — it's the highest-value line |
| Re-inventing the quality rubric | Hand the polish pass to taste-skill |

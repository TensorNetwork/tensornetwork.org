# `stoch_kin/` — tensornetwork.org contribution (proof of concept)

This folder is a self-contained page for **tensornetwork.org**. Dropped in at
`tensornetwork.org/src/stoch_kin/`, it renders as a normal contribution page
whose interactive pieces are driven by a single JavaScript bundle. No change to
the site's Julia/`cmark` generator is required.

## Why no generator changes are needed

- **Raw HTML passes through.** The site builds pages with `cmark --unsafe`, so
  the `<div id="rn-builder">`, `<div id="rn-chain">`, `<link>` and `<script>`
  tags in `index.md` are emitted verbatim (several existing pages already use
  raw HTML).
- **Assets ship automatically.** The generator copies every non-markdown file in
  a page folder into the output, so `stoch_kin_widget.js`, `stoch_kin_widget.css`
  and the `*.svg` figures deploy alongside the page.
- **The site already runs JS.** It loads KaTeX globally, so the widget reuses the
  page's KaTeX stylesheet instead of shipping its own.

## Contents

| File | Purpose |
|------|---------|
| `index.md` | The page. Prose + `$...$` math + `\cite{}` + two widget mount points. |
| `index.bib` | The 17 references, resolved by the site's `\cite{}` mechanism. |
| `stoch_kin_widget.js` | The compiled interactive bundle (self-mounting IIFE). |
| `stoch_kin_widget.css` | Widget styles only (~10 KB; no KaTeX fonts). |

## Mount points

The bundle renders each widget only if its div is present, so the same file
serves both:

- `<div id="rn-builder"></div>` — the reaction-network builder + live operator diagram.
- `<div id="rn-mps"></div>` — the Matrix Product State figure.
- `<div id="rn-mpo"></div>` — the Matrix Product Operator figure.
- `<div id="rn-chain"></div>` — the interactive chain / bond-dimension widget.

## Rebuilding the widget bundle

From the app repo root:

```bash
npm run build:embed        # -> dist-embed/stoch_kin_widget.{js,css}
cp dist-embed/stoch_kin_widget.js dist-embed/stoch_kin_widget.css src/stoch_kin/
```

The build target is `vite.embed.config.ts`; its entry is `src/embed.tsx`, which
mounts `ReactionBuilder` and `InteractiveChainDiagram` onto the div ids above.

## Known follow-ups before a real submission (the "do it properly" list)

1. **React weight.** The bundle is ~150 KB gzipped because React is bundled in.
   Aliasing `react`/`react-dom` to `preact/compat` in `vite.embed.config.ts`
   cuts it to ~10 KB gzipped. A two-line change; left out of the POC to keep it
   obviously correct.
2. **KaTeX version skew.** The widget reuses the site's global KaTeX CSS (0.15.x)
   while its JS bundles a newer KaTeX. The rendered classes are compatible, but a
   quick check against the site's exact version is due diligence.
3. **CSS containment.** `stoch_kin_widget.css` is derived from the app's styles,
   which were themselves copied from this site. Audit that only the widget rules
   (`td-`, builder classes) ship, and nothing bleeds into skeleton/normalize.
4. **Static figures.** The MPS/MPO diagrams currently mount from the JS bundle
   (`rn-mps`, `rn-mpo`). For a purely static rendering they could instead be
   exported as SVG files and referenced with `![medium](mps.svg)`.
5. **Governance.** The only non-technical question is whether the maintainer
   accepts a built JS artifact in the repo. Two clean options: commit the widget
   source alongside the bundle (auditable, rebuildable), or vendor a
   version-stamped bundle with a provenance comment.

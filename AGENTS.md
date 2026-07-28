# AGENTS.md

Guidance for AI coding agents working in this repo (`websites/cv-resume`).

This is the Markdown → multi-format build system for **Mark Allanson's CV/Resume**.
Content lives as per-section Markdown files in `sections/`; `make` + `pandoc`
assemble them into HTML, PDF, DOCX, and Markdown in `./out/`. The site is published
to GitHub Pages at <https://cv-mark.allanson.org/>.

## Commands (verified against the makefile)

```bash
make all        # clean, then html, html_index, pdf, docx, markdown  ← default
make clean      # rm -rf ./out
make html       # out/mark-allanson-cv.html  (--self-contained; CSS inlined)
make pdf        # out/mark-allanson-cv.pdf   (xelatex engine, A4, 2cm, 10pt)
make docx       # out/mark-allanson-cv.docx  (reference-doc=styles/basic.docx)
make markdown   # out/mark-allanson-cv.md
```

- **No test suite.** No lint/format config. Don't claim tests exist or add them
  unless asked.
- **Toolchain:** `make` + `pandoc` for all formats; PDF additionally needs
  `xelatex` (Debian: `texlive-xetex texlive-fonts-recommended texlive-extra-utils`).
  The CI workflow installs exactly these — match it if you change PDF deps.

## Repo layout

```
sections/   one Markdown file per CV section (the editable content)
styles/     basic.css (HTML), pdf.css (PDF), basic.docx (DOCX reference template)
makefile    build targets; input_files define block sets section order
.github/workflows/deploy.yml   CI: per-format build jobs → GitHub Pages deploy
out/        build output (gitignored; created on demand)
.gitignore  ignores ./out
```

## How a build works (read the makefile before editing)

- `input_files` is a GNU Make `define ... endef` **multi-line variable** that lists
  section files **in concat order**. This order — not filename order — is what ends
  up in every output. Order: `header → contact → personal-statement → experience
  (reverse-chronological: 2010, 2009, 2006, 2005, 2004-natgrid, 2004-thameswater,
  1999-triniteq) → education → other → footer`.
- Output base name is `mark-allanson-cv`; extension is set per-target via the
  `cv_extension` variable.
- `pandoc_exec` is the shared invocation: `pandoc -s --metadata pagetitle="..." -o
  out/mark-allanson-cv.<ext> -c ./styles/basic.css $(input_files)`.
- Target-specific overrides to know about:
  - **`html`** appends **`./sections/other-formats-links.md`** (the cross-format
    links block) at the end, and uses `--self-contained` to inline the CSS.
  - **`html_index`** depends on `html` and copies the result to `out/index.html`
    (so GitHub Pages serves it as the directory index).
  - **`pdf`** overrides the stylesheet to `styles/pdf.css` and passes
    `--pdf-engine=xelatex -V papersize=A4 -V geometry:margin=2cm -V fontsize=10pt
    -V documentclass=article`.
  - **`docx`** and **`markdown`** both override `metadata:=` to empty, i.e. they
    drop the `pagetitle` metadata that the other formats use. `docx` also passes
    `-V papersize=A4 --reference-doc=styles/basic.docx`.
- `all` runs `clean` first, so every `make all` is a full rebuild from scratch.

## CI/CD (`.github/workflows/deploy.yml`)

- Triggers: push to `main` or `wf`, plus `workflow_dispatch`.
- Four parallel build jobs (`build-html`, `build-pdf`, `build-docx`,
  `build-markdown`) each install only their own deps, run their `make <fmt>`
  target (after `mkdir -p out`), and upload an artifact. **PDF job installs the
  texlive packages**; the others install only `pandoc`.
- `combine-and-deploy` downloads all artifacts, flattens them into one `out/`,
  and deploys to GitHub Pages (`actions/deploy-pages@v4`). Concurrency group
  `"pages"`, `cancel-in-progress: false`.
- If you add a new output format, mirror this pattern: a dedicated job, its deps,
  an artifact upload, and an entry in `combine-and-deploy`'s `needs`.

## Conventions & gotchas

- **Section order is in the makefile, not the filesystem.** Adding a file under
  `sections/` does nothing until you add it to `input_files` in the makefile at the
  right position. Experience entries go newest-first.
- **`other-formats-links.md` is HTML-only.** It's appended only by the `html`
  target; don't add it to `input_files` or it'll leak into PDF/DOCX/MD.
- **Don't edit files in `out/`.** The directory is wiped by `make clean` /
  `make all` and is gitignored.
- **`--self-contained` is a pandoc flag** (newer pandoc prefers
  `--embed-resources --standalone`). If a pandoc upgrade breaks the HTML build,
  this flag is the likely culprit.
- **PDF failures are usually TeX, not pandoc.** A failed `make pdf` on a machine
  without `xelatex`/texlive is an environment issue — the CI job shows the exact
  apt packages to install.

## Do / Don't

- **Do** change content by editing the relevant `sections/*.md` file.
- **Do** update `input_files` (and keep ordering consistent) when adding/removing a
  section.
- **Don't** reorder outputs by renaming files — edit `input_files` instead.
- **Don't** commit generated `out/` artifacts.
- **Don't** add the `other-formats-links.md` section to `input_files`.

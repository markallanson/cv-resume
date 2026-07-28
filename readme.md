# Mark Allanson — CV/Resume

The Markdown source and build system for **Mark Allanson's CV/Resume**. Content is
written as small version-controlled Markdown files in [`sections/`](./sections) and
assembled by `make` + [pandoc](https://pandoc.org/) into **HTML, PDF, DOCX, and
Markdown** outputs.

The latest published release is live at **<https://cv-mark.allanson.org/>**
(deployed automatically to GitHub Pages — see [Deployment](#deployment)).

---

## What / Why

A single source of truth for one person's CV that can be rebuilt into every format
an employer might ask for. Splitting the CV into one file per section makes content
easy to diff, reorder, and review in git, while the build pipeline takes care of
producing consistent HTML / PDF / DOCX / Markdown artifacts from the same inputs.

---

## Prerequisites

| Tool      | Required for            | Notes                                                              |
| --------- | ----------------------- | ------------------------------------------------------------------ |
| `make`    | All builds              | GNU Make                                                            |
| `pandoc`  | All formats             | <https://pandoc.org/>                                              |
| `xelatex` | PDF only                | Provided by a TeX Live distribution (e.g. `texlive-xetex`)         |

On Debian/Ubuntu the PDF toolchain is:

```bash
sudo apt-get install -y make pandoc texlive-xetex texlive-fonts-recommended texlive-extra-utils
```

HTML, DOCX, and Markdown builds need only `make` + `pandoc`.

---

## Building

All artifacts are written to `./out/` (gitignored) and named
`mark-allanson-cv.<ext>`.

```bash
make all        # clean, then build html + index.html + pdf + docx + markdown
make clean      # remove the ./out/ directory

# Individual formats
make html       # → out/mark-allanson-cv.html  (self-contained, CSS inlined)
make pdf        # → out/mark-allanson-cv.pdf   (xelatex, A4, 2cm margins, 10pt)
make docx       # → out/mark-allanson-cv.docx  (uses styles/basic.docx template)
make markdown   # → out/mark-allanson-cv.md
```

The `html` target additionally copies its output to `out/index.html` so it can be
served as a directory index by GitHub Pages. See the
[`makefile`](./makefile) for the exact flags and section ordering.

---

## Project layout

```
.
├── sections/                # CV content, one Markdown file per section
│   ├── header.md            # Name / title
│   ├── contact.md           # Phone + email
│   ├── personal-statement.md
│   ├── 20YY-*.md            # Experience entries (reverse-chronological)
│   ├── education.md
│   ├── other.md             # Other interests / links
│   ├── other-formats-links.md  # Cross-links to PDF/DOCX/MD (HTML output only)
│   └── footer.md
├── styles/
│   ├── basic.css            # Stylesheet for HTML output
│   ├── pdf.css              # Stylesheet for PDF output
│   └── basic.docx           # Reference template for DOCX output
├── makefile                 # Build targets for each format
└── .github/workflows/deploy.yml   # CI: build all formats, deploy to GitHub Pages
```

### Section ordering

The order in which sections are concatenated is defined by the `input_files`
block in the [`makefile`](./makefile) — **not** by filename order. To reorder, add,
or remove a section, edit that list. Experience entries are listed
reverse-chronologically (most recent first).

---

## Deployment

Pushes to the `main` or `wf` branches (and manual `workflow_dispatch` runs)
trigger [`.github/workflows/deploy.yml`](./.github/workflows/deploy.yml), which:

1. Builds each format in its own job (installing the required toolchain).
2. Uploads each artifact.
3. Combines all artifacts into a single `out/` and deploys it to **GitHub Pages**
   at <https://cv-mark.allanson.org/>.

---

## License

No license file is included; all content is the personal CV of Mark Allanson and is
not licensed for redistribution.

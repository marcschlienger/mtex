# mtex — LaTeX classes for teaching material

> Copyright (C) 2017–2026 Marc Schlienger <marc.schlienger@posteo.de>
>
> This work may be distributed and/or modified under the conditions of the
> LaTeX Project Public License, either version 1.3 of this license or (at
> your option) any later version. The latest version of this license is in
> <http://www.latex-project.org/lppl.txt> and version 1.3 or later is part of
> all distributions of LaTeX version 2005/12/01 or later.
>
> This work has the LPPL maintenance status author-maintained.

Four document classes and one package for writing lesson sheets, class tests,
oral exams and talks — aimed at math and physics teaching at the
Rolf-Benz-Schule Nagold, but not tied to it beyond the default logo.

The companion bundle **[mstuff](https://github.com/marcschlienger/mstuff)**
(amsmath, tikz/pgfplots, siunitx, tables, hyperref — the preamble I want in
almost every document) lives in its own repository. It is optional here, and
useful without these classes.

## Contents

| Class | For | Base class |
| --- | --- | --- |
| `msheet` | lesson sheets, worksheets, fact sheets | `scrartcl` |
| `mtest`  | class tests (Klassenarbeiten) | `scrartcl` |
| `mexam`  | oral exam sheets | `scrartcl` |
| `mtalk`  | talks, slides | `beamer` + [Moloch](https://ctan.org/pkg/moloch) |

| Package | For |
| --- | --- |
| `msheet.sty` | exercise headings, boxes, lists and scores — usable with all four classes |

Examples, each with its compiled PDF, are in `doc/latex/<name>/`. `doc/NOTES.md`
holds the installation details and the migration notes for documents written
against the pre-2026 versions.

## Installation

This repository is a TDS tree, so it can be used as a TeX file tree as it is.
Point `TEXMFHOME` at it, or clone it to `~/texmf`:

```bash
export TEXMFHOME=/path/to/this/repo
```

`TEXMFHOME` accepts a brace-delimited list, so this tree and the `mstuff`
tree work side by side — which is what the examples expect:

```bash
export TEXMFHOME="{$HOME/Repos/mtex,$HOME/Repos/mstuff}"
```

To make that permanent:

```bash
tlmgr conf texmf TEXMFHOME "{$HOME/Repos/mtex,$HOME/Repos/mstuff}"
```

No `texhash` is needed — `TEXMFHOME` is not part of `TEXMFDBS`.

## Building

Use `latexmk -pdf`. **Two runs are required**, and not only for cross
references: `totcount` reads the page total from the previous run's `.aux`
(the footer page number is missing without it), and `marginnote` — used by
`\mscore` — silently drops the note on the first pass.

```bash
latexmk -pdf my-worksheet.tex
```

## Quick start

```latex
\documentclass[worksheet, yellow, onehalfspacing, 11pt, a4paper]{msheet}
\usepackage{mstuff}      % optional
\usepackage{msheet}

\title{Ableitungsregeln}
\author{Marc Schlienger}
\license{\href{https://creativecommons.org/licenses/by/4.0}{CC BY 4.0}}

\begin{document}
\maketitle

\msection[Kettenregel]
Leiten Sie ab. \mscore{4}
\begin{mexccolumns}(3)
	\exc $f(x) = (2x+1)^3$
	\exc $f(x) = \sin(3x)$
	\exc $f(x) = e^{-x^2}$
\end{mexccolumns}

\begin{mtbred}[Merksatz]
	Äußere Ableitung mal innere Ableitung.
\end{mtbred}

\mtotalscore
\end{document}
```

## Class options

### `msheet`

| Group | Options |
| --- | --- |
| document type (picks the title icon) | `worksheet` (default), `factsheet`, `groupwork`, `schedulework`, `experiment` |
| title box | `rounded`; background `white` (default), `cyan`, `grey`, `yellow` |
| line spacing | `singlespacing`, `onehalfspacing`, `doublespacing` |

Everything else is handed to `scrartcl`. `twoside` is refused on purpose.

### `mtest`, `mexam`

Line spacing as above. `mexam` additionally understands `tabletitle`, which
swaps the boxed title for a two-by-two cover table (`\exam` / `\title` over
`Fachlehrer` / `\date`).

### `mtalk`

| Option | Effect |
| --- | --- |
| `dark` | Moloch's dark background |
| `nocharter` | keep Moloch's own sans body font instead of Bitstream Charter |

Everything else is handed to `beamer`.

## Document metadata

| Command | Classes |
| --- | --- |
| `\logo{<file>}` | `msheet`, `mtest`, `mexam` |
| `\license{<text>}` | all four |
| `\attribution{<text>}` | all four |
| `\class{<text>}` | `mtest` — appears in the head |
| `\testnumber{<n>}` | `mtest` — appears in the title table |
| `\tasknumber{<n>}` | `mexam` — appears in the head |
| `\exam{<text>}` | `mexam` — appears in the `tabletitle` cover table |

`\license` and `\attribution` are optional; if omitted, that part of the
footer is left out and a single warning goes to the log.

`msheet` also has a key/value interface, which — unlike class options — works
in the preamble *and* in the document body:

```latex
\msheetsetup{type=experiment, titlecolor=DarkCyan, icon=my-icon.png,
             logo=my-logo.png, license=…, attribution=…}
```

`mtalk` has `\mtalksetup{logo=…, license=…, attribution=…}`. It has no
`\logo` command because beamer already owns that name.

> The old public `\icon` and `\titlebackcolor` commands were removed in v2.0.
> See [doc/NOTES.md](doc/NOTES.md) for the one-line migration and a
> compatibility shim.

## `msheet.sty` reference

Works with all four classes (and with a plain `scrartcl` document).

### Headings

| Command | Effect |
| --- | --- |
| `\mchapter{<text>}` | large centred heading in the school blue |
| `\mtestpart{<text>}` | smaller centred heading, for the parts of a test |
| `\msection[<note>]` | `**Aufgabe** n  *note*`, numbered, followed by a break |
| `\msectionr[<note>]` | the same, run-in: the text continues on the heading line |
| `\mwish` | a centred “Viel Erfolg!” |

Both `\msection` and `\msectionr` have a starred form that omits the number.
`\msexercise` and `\mpexercise` are kept as aliases of the two.

### Scores

| Command | Effect |
| --- | --- |
| `\mscore{<n>}` | prints `n BE` in the margin and adds `n` to the running total |
| `\mtotalscore` | prints the total, underlined, in the margin |
| `\mresetscore` | starts a new count |

Half points work (`\mscore{2.5}`). The total is accumulated globally, so
`\mscore` may sit inside a box, a list or an environment.

### Lists

| Environment | Labels |
| --- | --- |
| `mtasklist` | `1.`, `1.1.`, `1.1.1.`, … (four levels) |
| `msectionlist` | `Aufgabe 1`, `a)`, `i.`, `A.` |
| `menumerate` | `a)`, `(1)`, `A.`, `I` |
| `menumeratex` | section-prefixed: `2.1.`, `2.1.1.`, … |
| `mexccolumns(<n>)` | `n` columns, items separated by `\exc`, labels `a)` |
| `mtaskcolumns(<n>)` | `n` columns, items separated by `\task`, labels `1.` |
| `mdone(<n>)` | `n` columns, items separated by `*`, thumbs-up labels |

`mexerciselist` is an alias of `msectionlist`.

### Boxes

Titled (the title is the optional argument):

| Environment | Default title |
| --- | --- |
| `mtbred[<title>]` | Merksatz |
| `mtbgreen[<title>]` | Versuch |
| `mtbblue[<title>]` | Beispiel |
| `mtbcolor[<color>]{<title>}` | — (colour is the optional argument) |

Untitled: `mbred`, `mbgreen`, `mbblue`, `mbinfo`, `mbcolor[<color>]`.

Inline, for margins and hints: `\mibred{}`, `\mibgreen{}`, `\mibblue{}`,
`\mibcolor[<color>]{}`. `\mibnp` puts a “Bitte wenden!” marker at the bottom
of the page and breaks it.

Colours are `xcolor` `svgnames`, so any of those names works as `<color>`.

## Legacy

`attic/` holds superseded versions of everything above — the pre-2026 copies
of `msheet.cls`/`.sty`, the abandoned `mposter.cls`, and the `tex/misc`
preambles these classes grew out of (`school_document_style.tex`, `exam.tex`,
`kontaktstudium.tex`, …). Nothing in `attic/` is on a TeX search path; it is
kept so that nothing is lost and can be dropped once the history is pushed.

## Credits

Icons by [flaticon](https://www.flaticon.com/).

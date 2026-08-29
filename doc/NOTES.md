# Notes

Everything that does not belong in the README: how the tree is hooked into a
TeX installation, and what has to change in documents written against the
pre-2026 versions of these classes.

---

## 1. Integrating this tree into the TeX installation

This repository *is* a TEXMF tree: it has the TDS layout (`tex/latex/<pkg>/`,
`doc/latex/<pkg>/`) that kpathsea expects. So is the companion repository
[`marcschlienger/mstuff`](https://github.com/marcschlienger/mstuff), which
holds the `mstuff` convenience bundle. The examples here use both.

### The simple way (what I do now)

Point `TEXMFHOME` at the clone:

```bash
export TEXMFHOME=/path/to/this/repo
```

or, to make it permanent for every TeX run on the machine:

```bash
kpsewhich --var-value=TEXMFHOME          # shows the current value
tlmgr conf texmf TEXMFHOME /path/to/this/repo
```

or simply clone (or symlink) the repository to the default location,
`~/texmf`, and nothing has to be configured at all.

Because there are **two** trees (the classes here, `mstuff` next door), the
brace-list form is the one to use:

```bash
export TEXMFHOME="{$HOME/Repos/mtex,$HOME/Repos/mstuff}"
# or permanently:
tlmgr conf texmf TEXMFHOME "{$HOME/Repos/mtex,$HOME/Repos/mstuff}"
```

That is exactly the trick the old `web2c/texmf.cnf` in this tree was there to
remember — see below.

**No `texhash`/`mktexlsr` is needed.** `TEXMFHOME` is not part of `TEXMFDBS`,
so kpathsea always scans it directly. An `ls-R` file in this tree would be
ignored at best and stale at worst — there used to be one here (April 2025)
and it has been removed.

### The old way (why there was a `web2c/texmf.cnf` here)

The tree used to carry a full copy of the distribution's `texmf.cnf`, whose
only local change was on the `TEXMFHOME` line:

```
TEXMFHOME = {~/texmf,~/data/templates/texmf}
```

That is the trick for having **more than one** personal tree: `TEXMFHOME`
accepts a brace-delimited list, so both directories are searched. It is worth
remembering, but it does not need a 942-line copy of the distribution's
configuration file to write down — and that copy was a *Debian* `texmf.cnf`
(`TEXMFLOCAL=/usr/local/share/texmf`, `TEXMFSYSVAR=/var/lib/texmf`), which is
wrong on this Mac. It has been deleted.

If a second tree is ever needed again, the modern equivalent is either

```bash
tlmgr conf texmf TEXMFHOME "{~/texmf,~/somewhere/else/texmf}"
```

or the purpose-built `TEXMFAUXTREES` variable, which is meant exactly for
temporarily bolting an extra tree onto the search path:

```bash
export TEXMFAUXTREES=/path/to/extra/texmf,
```

(note the trailing comma — it is required).

---

## 2. Compiling: always run LaTeX twice

Use `latexmk -pdf`. Two runs are required, not optional:

- `totcount` reads the page total from the previous run's `.aux`, so the page
  number in the footer is missing on a single run;
- `marginnote` (used by `\mscore`/`\mtotalscore`) saves its horizontal
  position with `\pdfsavepos` and **silently drops the note** on the first
  run. It does ask for a rerun in the log, but nothing is printed in the
  margin until the second pass.

---

## 3. Migrating documents written for the old classes

### `\icon` and `\titlebackcolor` are gone

A class has no business claiming names as generic as `\icon` — it clashes
with anything else that wants them (and `\logo` is already taken by beamer,
which is why `mtalk` does not define it). Both are now internal
(`\msheet@icon`, `\msheet@titlebackcolor`) and are set through the class
options as before, or through the new key/value interface:

```latex
\msheetsetup{
  type        = experiment,   % worksheet|factsheet|groupwork|schedulework|experiment
  icon        = my-icon.png,  % or an explicit file, bypassing "type"
  logo        = my-logo.png,
  titlecolor  = DarkCyan,
  license     = \href{https://creativecommons.org/licenses/by/4.0}{CC BY 4.0},
  attribution = {Nach einer Idee von ...},
}
```

`\msheetsetup` works in the preamble *and* in the document body, which the
class options never did.

**Old documents that did `\renewcommand{\icon}{...}` now fail** with
`Undefined control sequence: \icon`. The fix is one line — replace

```latex
\renewcommand{\icon}{flask.png}
```

with

```latex
\msheetsetup{icon=flask.png}
```

If a document really must keep the old spelling (for instance because it is
shared with someone still on the 2023 class), put this shim in its preamble
instead of editing the body:

```latex
\makeatletter
\newcommand{\icon}{edit.png}
\AtBeginDocument{\renewcommand*{\msheet@icon}{\icon}}
\makeatother
```

`\logo{...}`, `\license{...}` and `\attribution{...}` are unchanged.

### Exercise headings and lists

The 2026 rename (a search-and-replace of `exerc` → `section` that also
produced the environment name `msectioniselist`) has been kept, but the old
spellings still work as aliases, so nothing has to change:

| old | new |
| --- | --- |
| `\msexercise` | `\msection` |
| `\mpexercise` | `\msectionr` |
| `mexerciselist` | `msectionlist` |
| `msectioniselist` | `msectionlist` |

The counter is now called `msection` (it used to be `exccnt`); only a
document that referred to `\theexccnt` directly is affected.

### `menumeratex` now actually works

`menumeratex` never produced output, and the cause was a catcode bug in
`msheet.sty`. The `\mscore` block was wrapped in `\makeatletter` …
`\makeatother` — but inside a `.sty` file `@` is *already* a letter, so that
closing `\makeatother` turned `@` into an ordinary character **for the rest
of the file**. Every `\p@enumi` … `\p@enumiv` in `menumeratex` below it was
therefore read as `\p` followed by the ordinary text `@enumi`, which
typesets — and typesetting in the preamble gives

```
! LaTeX Error: Missing \begin{document}.
l.190 \providecommand*{\p@enumi}
```

The `\makeatletter`/`\makeatother` pair is gone; nothing else was needed.
Any document that worked around `menumeratex` being broken can drop the
workaround.

### fontawesome → fontawesome5

`msheet.sty` now loads `fontawesome5`. Documents that use FontAwesome 4 macro
names directly have to be updated; the two used by the package itself were

| fontawesome (v4) | fontawesome5 |
| --- | --- |
| `\faThumbsOUp` | `\faThumbsUp[regular]` |
| `\faAngleDoubleRight` | `\faAngleDoubleRight` (unchanged) |

If a document needs the old names, load `fontawesome` *before* `msheet`; the
two packages can coexist, but the v4 names win.

### `mposter` → `mtalk`

`mposter.cls` was `msheet.cls` with `\LoadClass{scrartcl}` replaced by
`\LoadClass{tikzposter}` and nothing else adapted — it kept KOMA's
`\setkomafont`/`\KOMAoptions` calls and overrode tikzposter's own
`\maketitle`. It never worked and is now in `attic/mposter.cls.unfinished`.

Its replacement is `mtalk.cls` (beamer + the Moloch theme); see
`doc/latex/mtalk/mtalk-example.tex`.

### `tex/misc` is gone

The pre-class-file preambles (`school_document_style.tex`,
`school_document_style_ALS.tex`, `exam.tex`, `kontaktstudium.tex`,
`doc.tex`, `tikz-er2.sty`) have been moved out of the TeX search path to
`attic/misc/`. Documents that did `\input{school_document_style.tex}` will no
longer find it — copy the file next to the document, or port it to
`msheet`/`mtest`.

Note that `exam.tex` redefined standard math operators (`\div`, `\exp`,
`\arg`, `\sinh`, `\cosh`, `\tanh`) as one-argument macros. That is why none
of it was folded into `mstuff.sty`: importing those would silently change the
meaning of `\div` and friends in every document. The genuinely reusable bits
(`\circled`, `\sframebox`, `\simplebox`, `\bbox`, `\cbox`, the `graph` and
`tsdiagram` tikz environments, `\function`, `\molec`) are still in
`attic/misc/exam.tex` and can be lifted by hand.

### mexam and mtest now load hyperref

Needed so that `\license{\href{...}{...}}` works, and set up with
`colorlinks` exactly as `msheet.cls` already did. If an exam should have no
coloured links at all, add `\hypersetup{hidelinks}` to the document.

---

## 4. What changed in `mstuff.sty` (v2.0)

`mstuff` lives in its own repository now
([`marcschlienger/mstuff`](https://github.com/marcschlienger/mstuff)) — it is
useful without these classes and the classes work without it. It is a
convenience bundle, so the changes are all of the "load the right thing in
the right order" kind:

- **beamer guard.** `enumitem`, `placeins`, `caption` and `subcaption` are
  now skipped when the document class is `beamer` (i.e. under `mtalk`).
  `enumitem` in particular silently deletes the Moloch theme's itemize
  markers — the bullets simply vanish, with no warning. This was a real bug:
  a `mtalk` document that loaded `mstuff` lost every list marker.
- **`tcolorbox` library set unified to `most`.** `msheet.cls`/`.sty` asked
  for `many` and `mstuff` for `most`; whichever loads first wins, so with a
  `msheet` document `most` was silently ignored and the extra libraries were
  missing. All four files now agree.
- **`\newcolumntype{Z}` fixed.** It was
  `>{\flushleft\arraybackslash}X` — `\flushleft` is an environment, not a
  declaration; the correct one is `\raggedright`. The old definition either
  errored or produced junk spacing depending on context.
- **`hyperref` moved late, `caption`/`subcaption` after it**, which is the
  order the `caption` package asks for.
- **`pgfplots` `compat` raised** from `1.16` to `1.18`.
- **`mathtools` added**, and the `P`/`M`/`B` column types recovered from the
  old `school_document_style.tex`.
- **`\ProcessOptions` added**, so a stray option produces a clear warning
  instead of a confusing "unused global option" at the end of the run.
- `arrows.meta` is loaded *in addition to* the deprecated `arrows` library,
  not instead of it, so old pictures keep working.
- `siunitx` still uses `locale=DE`, which is valid in siunitx v3.
- **`csquotes` added**, so `\enquote{…}` gives the correct German quotes and
  follows the document language.
- **`\dd` and `\molec` recovered** from the retired `school_document_style`
  preamble (`\dd` is the upright differential, `\molec{H}{2}{}` a chemistry
  shorthand). The rest of that file's math macros are deliberately *not*
  imported — it redefined `\div`, `\exp`, `\arg` and the hyperbolic
  functions as one-argument macros.
- **`ltablex` is no longer loaded.** It was present in the 2023 GitHub
  version of `mstuff.sty` and absent from the 2025 working copy — the two had
  drifted apart. It is left out deliberately: `ltablex` globally redefines
  `tabularx` to be page-breakable, which a convenience bundle should not do
  behind your back. The handful of documents that need it should say
  `\usepackage{ltablex}` themselves.

---

## 5. Layout: geometry, not typearea

Short answer to "geometry does not go well with KOMA, right?": **geometry is
fine with KOMA — what was not fine was `msheet.cls` setting `\textwidth`,
`\topmargin` and `\textheight` by hand after `scrartcl` had already run
`typearea`.** That is the combination KOMA cannot cope with, and it also
silently overrode a `DIV=calc` passed by the document.

The KOMA-native alternative, `\areaset`, was measured and rejected for these
classes:

```
\areaset[current]{\dimexpr\paperwidth-2in}{\dimexpr\paperheight-2.2in}
  =>  headheight 24.35pt -> 15.95pt, headsep 15pt -> 20.4pt,
      footskip 30pt -> 47.6pt, head starting 5.9mm from the paper edge
```

`typearea` recomputes the head and foot dimensions from the font size and
overwrites whatever the class set. The school logo is 20.15 pt tall at
`width=153pt`, so `\headheight` has to stay at 24.35 pt — which `geometry`
respects and `typearea` does not.

All four sheet classes therefore use `geometry`, and none of them touches
`\textwidth` and friends directly. For `msheet` the settings reproduce the
old hand-made layout exactly:

| | |
| --- | --- |
| left / right margin | 25.4 mm |
| top of text block | 25.4 mm (head above it, in the margin) |
| bottom margin | 30.5 mm |
| `headheight` / `headsep` / `footskip` | 24.34654 pt / 15 pt / 30 pt |

%% mtalk.cls -- class for talks (beamer + the Moloch theme).
%%
%% Copyright (C) 2026 Marc Schlienger <marc.schlienger@posteo.de>
%% Released under the LaTeX Project Public License v1.3c or later, see
%% http://www.latex-project.org/lppl.txt
%%
%% Replaces mposter.cls (see attic/mposter.cls.unfinished).  Compiles with
%% pdflatex; Moloch does not need fontspec.  The body font is Bitstream
%% Charter via mathdesign, as in msheet/mtest/mexam; the headings stay in
%% the sans face so that the Moloch look survives.  The metadata and credit
%% line machinery shared with the sheet classes lives in mtex-base.sty.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mtalk}[2026/08/29 v0.2 Class for talks (beamer + moloch).]
\def\mtex@cls{mtalk}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          CLASS OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\if@mtalk@dark		\@mtalk@darkfalse
\DeclareOption{dark}{\@mtalk@darktrue}

\newif\if@mtalk@charter		\@mtalk@chartertrue
\DeclareOption{nocharter}{\@mtalk@charterfalse}

\PassOptionsToPackage{many}{tcolorbox}
\PassOptionsToPackage{svgnames, table}{xcolor}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax

%% beamer pulls in amssymb, which mathdesign refuses to co-exist with; the
%% charter math fonts provide the AMS symbols themselves.
\if@mtalk@charter
	\PassOptionsToClass{noamssymb}{beamer}
\fi
\LoadClass[aspectratio=169, 11pt]{beamer}

%% mtex-base must come after \LoadClass: it checks for beamer to leave
%% \logo alone (beamer owns that name; use \mtalksetup{logo=...} instead).
\RequirePackage{mtex-base}
\renewcommand*{\mtex@creditauthor}{\insertauthor}

\RequirePackage[T1]{fontenc}
\RequirePackage[ngerman]{babel}
\RequirePackage{microtype}

\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tcolorbox}
\RequirePackage{fontawesome5}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          THEME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usetheme{moloch}
\molochset{
	sectionpage=progressbar ,
	progressbar=frametitle ,
	block=fill
}
%% moloch's own "numbering" key is deprecated -- use beamer's template.
\setbeamertemplate{page number in head/foot}[totalframenumber]
\if@mtalk@dark
	\molochset{background=dark}
\fi

%% The school's blue, as used by \mchapter in msheet.sty.
\definecolor{rbsblue}{HTML}{009BD4}
\setbeamercolor{alerted text}{fg=rbsblue}
\setbeamercolor{progress bar}{fg=rbsblue}
\setbeamercolor{title separator}{fg=rbsblue}
\setbeamercolor{progress bar in head/foot}{fg=rbsblue}
\setbeamercolor{progress bar in section page}{fg=rbsblue}

%% Charter for the running text, sans for everything structural.  Loaded
%% after the theme so that Moloch's own font settings are not undone.
\if@mtalk@charter
	\RequirePackage[bitstream-charter]{mathdesign}
	\renewcommand{\familydefault}{\rmdefault}
	\setbeamerfont{title}{family=\sffamily}
	\setbeamerfont{subtitle}{family=\sffamily}
	\setbeamerfont{frametitle}{family=\sffamily}
	\setbeamerfont{section title}{family=\sffamily}
	\setbeamerfont{standout}{family=\sffamily}
\fi

%% Leave the itemize/enumerate markers to Moloch -- overriding them with
%% beamer's [circle] etc. loses the theme's own markers.
\setbeamertemplate{caption}[numbered]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          KEY/VALUE INTERFACE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\mtex@definebasekeys{mtalk}
\newcommand{\mtalksetup}[1]{\setkeys{mtalk}{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          TITLE PAGE AND FOOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The school logo goes on the title frame, not on every slide.  moloch only
%% draws the "title graphic" template when \inserttitlegraphic is non-empty,
%% so the logo has to go through \titlegraphic (\mtex@logo stays unexpanded,
%% so \mtalksetup{logo=...} still works afterwards).
\titlegraphic{\includegraphics[width=45mm]{\mtex@logo}}

%% Copyright / license line in the foot, matching the sheet classes.
\setbeamertemplate{frame footer}{\mtexcredit}

\mtex@warnifempty{\mtex@license}{\license}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          BOXES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The same four boxes as msheet.sty, so that material can be moved between
%% a sheet and a talk without rewriting it.
\newtcolorbox{mtbcolor}[2][Chocolate]{%
	size=fbox,
	fonttitle=\large\sffamily\bfseries,
	colback=#1!6!white,
	colframe=#1!24!black,
	colbacktitle=#1!50!white,
	coltitle=#1!12!black,
	title={#2}
}%
\newtcolorbox{mtbred}[1][Merksatz]{%
	size=fbox,
	fonttitle=\large\sffamily\bfseries,
	colback=Yellow!6!white,
	colframe=FireBrick!24!black,
	colbacktitle=FireBrick!70!white,
	coltitle=FireBrick!12!black,
	title={#1}
}%
\newtcolorbox{mtbgreen}[1][Versuch]{%
	size=fbox,
	fonttitle=\large\sffamily\bfseries,
	colback=Yellow!6!white,
	colframe=LightGreen!24!black,
	colbacktitle=LightGreen!80!white,
	coltitle=LightGreen!12!black,
	title={#1}
}%
\newtcolorbox{mtbblue}[1][Beispiel]{%
	size=fbox,
	fonttitle=\large\sffamily\bfseries,
	colback=Yellow!6!white,
	colframe=DodgerBlue!24!black,
	colbacktitle=DodgerBlue!50!white,
	coltitle=DodgerBlue!12!black,
	title={#1}
}%

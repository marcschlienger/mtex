%% msheet.cls -- class for writing lesson sheets.
%%
%% Copyright (C) 2022--2026 Marc Schlienger <marc.schlienger@posteo.de>
%% Released under the LaTeX Project Public License v1.3c or later, see
%% http://www.latex-project.org/lppl.txt
%%
%% See doc/NOTES.md for the migration notes (the public \icon and
%% \titlebackcolor commands are gone, use \msheetsetup instead).
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{msheet}[2026/08/29 v2.0 Class for writing lesson sheets.]

\newif\if@rounded		\@roundedfalse
\DeclareOption{rounded}{\@roundedtrue}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          METADATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% All defaults are empty; a missing value is reported once at
%% \begin{document} rather than on every shipout.
\DeclareRobustCommand\license[1]{\gdef\msheet@license{#1}}
\newcommand*{\msheet@license}{}

\DeclareRobustCommand\attribution[1]{\gdef\msheet@attribution{#1}}
\newcommand*{\msheet@attribution}{}

\DeclareRobustCommand\logo[1]{\gdef\msheet@logo{#1}}
\newcommand*{\msheet@logo}{Rolf-Benz-Schule.png}

%% Sheet type -> title icon.  These used to be the public \icon macro, which
%% is far too generic a name for a class to claim.
\@namedef{msheet@icon@worksheet}{edit.png}
\@namedef{msheet@icon@factsheet}{info.png}
\@namedef{msheet@icon@groupwork}{teamwork.png}
\@namedef{msheet@icon@schedulework}{task.png}
\@namedef{msheet@icon@experiment}{flask.png}

\newcommand*{\msheet@icon}{edit.png}
\newcommand{\msheet@settype}[1]{%
	\@ifundefined{msheet@icon@#1}%
		{\ClassError{msheet}{Unknown sheet type '#1'}%
			{Known types are worksheet, factsheet, groupwork, schedulework
			 and experiment.}}%
		{\edef\msheet@icon{\@nameuse{msheet@icon@#1}}}%
}

\newcommand*{\msheet@titlebackcolor}{white}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          CLASS OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{twoside}{\OptionNotUsed}

\DeclareOption{worksheet}{\msheet@settype{worksheet}}
\DeclareOption{factsheet}{\msheet@settype{factsheet}}
\DeclareOption{groupwork}{\msheet@settype{groupwork}}
\DeclareOption{schedulework}{\msheet@settype{schedulework}}
\DeclareOption{experiment}{\msheet@settype{experiment}}

\DeclareOption{singlespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{onehalfspacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{doublespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}

\DeclareOption{cyan}{\renewcommand*{\msheet@titlebackcolor}{DarkCyan}}
\DeclareOption{grey}{\renewcommand*{\msheet@titlebackcolor}{LightSlateGray}}
\DeclareOption{white}{\renewcommand*{\msheet@titlebackcolor}{white}}
\DeclareOption{yellow}{\renewcommand*{\msheet@titlebackcolor}{Yellow}}

\PassOptionsToPackage{many}{tcolorbox}
%% "table" pulls in colortbl; msheet.sty needs it and xcolor is loaded here
%% first, so the option has to be requested here as well.
\PassOptionsToPackage{svgnames, table}{xcolor}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessOptions\relax
\LoadClass{scrartcl}

\RequirePackage{etoolbox}
\RequirePackage{keyval}
\RequirePackage{totcount}

\RequirePackage{geometry}
\RequirePackage[footsepline]{scrlayer-scrpage}

\RequirePackage[bitstream-charter]{mathdesign}
\RequirePackage[T1]{fontenc}
\RequirePackage{microtype}
\RequirePackage[ngerman]{babel}

\RequirePackage{setspace}

\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tcolorbox}

%% hyperref wants to be loaded after (almost) everything else.
\RequirePackage{hyperref}

%% Key/value interface.  Everything that used to be a class option or a
%% public command can be set here, also after \begin{document}.
\define@key{msheet}{type}{\msheet@settype{#1}}
\define@key{msheet}{icon}{\renewcommand*{\msheet@icon}{#1}}
\define@key{msheet}{logo}{\renewcommand*{\msheet@logo}{#1}}
\define@key{msheet}{license}{\gdef\msheet@license{#1}}
\define@key{msheet}{attribution}{\gdef\msheet@attribution{#1}}
\define@key{msheet}{titlecolor}{\renewcommand*{\msheet@titlebackcolor}{#1}}
\newcommand{\msheetsetup}[1]{\setkeys{msheet}{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This reproduces the old hand-made layout (text block 1in from the top,
%% 1in left and right, 30.5mm at the bottom) -- but via geometry, so that
%% \headheight survives and KOMA is not fighting over \textwidth.
%% The logo is 2582x340px and 20.15pt tall at width=153pt, so 24.34654pt of
%% \headheight is enough.
\geometry{%
	left=25.4mm ,
	right=25.4mm ,
	top=25.4mm ,
	bottom=30.5mm ,
	headheight=24.34654pt ,
	headsep=15pt ,
	footskip=30pt ,
	marginparwidth=.5in ,
	marginparsep=5pt
}
\setlength{\footheight}{23.04692pt}

%Head and foot
\pagestyle{scrheadings}
\setkomafont{pageheadfoot}{\sffamily\mdseries\scriptsize}

\ihead{}
\chead{}
\ohead{\includegraphics[width=153pt]{\msheet@logo}\hspace{5pt}}

%% Evaluated at shipout, so \license/\attribution may be given in the preamble.
\ifoot{%
	\ifdefempty{\msheet@attribution}{}{\msheet@attribution\;}%
	\copyright\;\the\year\;\@author
	\ifdefempty{\msheet@license}{}{\;(\msheet@license)}%
}
\cfoot{}
\regtotcounter{page}
\ofoot{\ifnumcomp{\totvalue{page}}{>}{1}{\textbf{\thepage}}{}}

\AtBeginDocument{%
	\ifdefempty{\msheet@license}%
		{\ClassWarningNoLine{msheet}{No \noexpand\license given}}{}%
	\ifdefempty{\msheet@attribution}%
		{\ClassWarningNoLine{msheet}{No \noexpand\attribution given}}{}%
}

\AddToLayerPageStyleOptions{scrheadings}
{oninit={%
		\ifnumcomp{\the\c@page}{>}{1}{\KOMAoptions{headsepline=true}}{\KOMAoptions{headsepline=false}}
}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          TITLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\hypersetup{colorlinks=true, linkcolor=blue, filecolor=magenta, urlcolor=cyan}
\if@rounded
	\tcbset{mytitle/.style=
		{%
			sidebyside ,
			sidebyside gap=0pt ,
			lower separated=false ,
			lefthand width=20pt ,
			size=fbox ,
			boxrule=0.6pt ,
			colback=\msheet@titlebackcolor!6!white
		}%
	}%
\else
	\tcbset{mytitle/.style=
		{%
			sidebyside ,
			sidebyside gap=0pt ,
			lower separated=false ,
			lefthand width=20pt ,
			size=fbox ,
			boxrule=0.6pt ,
			colback=\msheet@titlebackcolor!6!white ,
			sharp corners
		}%
	}%
\fi

\renewcommand{\maketitle}{%
	{
		\vspace*{-38pt}
		\fontsize{14}{17}\fontfamily{phv}\fontseries{b}\selectfont
		\begin{tcolorbox}[mytitle]
			\includegraphics[width=20pt]{\msheet@icon}
			\tcblower
			\centering
			\@title
		\end{tcolorbox}
	}
  \medskip
}

%% mexam.cls -- class for writing oral exam sheets.
%%
%% Copyright (C) 2023--2026 Marc Schlienger <marc.schlienger@posteo.de>
%% Released under the LaTeX Project Public License v1.3c or later, see
%% http://www.latex-project.org/lppl.txt
%%
%% Merged 2026-08-29 from:
%%   texmf/tex/latex/mexam/mexam.cls          (2024-06-26, the working class)
%%   latex/mexam/tex/latex/mexam/mexam.cls    (2026-01-27, an abandoned fork
%%     that declared itself as "msheet" and used tabu commands without
%%     loading tabu; its \exam field and its license foot are kept here, its
%%     table title is available via the class option "tabletitle")
%% See attic/ for the originals.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mexam}[2026/08/29 v2.0 Class for writing oral exam sheets.]

\DeclareRobustCommand\logo[1]{\gdef\mexam@logo{#1}}
\newcommand{\mexam@logo}{Rolf-Benz-Schule.png}

\DeclareRobustCommand\tasknumber[1]{\gdef\mexam@tasknumber{#1}}
\newcommand{\mexam@tasknumber}{}

\DeclareRobustCommand\exam[1]{\gdef\mexam@exam{#1}}
\newcommand{\mexam@exam}{}

\DeclareRobustCommand\license[1]{\gdef\mexam@license{#1}}
\newcommand{\mexam@license}{}

\DeclareRobustCommand\attribution[1]{\gdef\mexam@attribution{#1}}
\newcommand{\mexam@attribution}{}

\DeclareOption{twoside}{\OptionNotUsed}

\newif\if@tabletitle		\@tabletitlefalse
\DeclareOption{tabletitle}{\@tabletitletrue}

\DeclareOption{singlespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{onehalfspacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{doublespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}

\PassOptionsToPackage{many}{tcolorbox}
\PassOptionsToPackage{svgnames, table}{xcolor}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessOptions\relax
\LoadClass{scrartcl}

\RequirePackage{etoolbox}
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
\RequirePackage{tabularx}

%% needed so that \license{\href{...}{...}} works, as in msheet.cls
\RequirePackage{hyperref}
\hypersetup{colorlinks=true, linkcolor=blue, filecolor=magenta, urlcolor=cyan}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% headheight has to be big enough for the 20.15pt logo; geometry keeps
%% the value, typearea/\areaset would silently overwrite it.
\geometry{left=15mm, right=15mm, top=25mm, headheight=24.34654pt}

%Head and foot
\pagestyle{scrheadings}
\setkomafont{pageheadfoot}{\sffamily\mdseries\scriptsize}

%% \tasknumber used to be stored and warned about but never printed.
\ihead{\ifdefempty{\mexam@tasknumber}{}{\hspace{2pt}Aufgabe~\mexam@tasknumber}}
\chead{}
\ohead{\smash{\includegraphics[width=153pt]{\mexam@logo}}}

%% Evaluated at shipout, so \license/\attribution may be set in the preamble.
\ifoot{%
	\ifdefempty{\mexam@attribution}{}{\mexam@attribution\;}%
	\ifdefempty{\mexam@license}{}{\copyright\;\the\year\;\@author\;(\mexam@license)}%
}
\regtotcounter{page}
\cfoot{\ifnumcomp{\totvalue{page}}{>}{1}{\textbf{\thepage}}{}}
\ofoot{}

\AddToLayerPageStyleOptions{scrheadings}
{oninit={%
		\ifnumcomp{\the\c@page}{>}{1}{\KOMAoptions{headsepline=true}}{\KOMAoptions{headsepline=false}}
}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          TITLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\tcbset{mytitle/.style=
	{%
		colback=white ,
		boxrule=0.8pt ,
		sharp corners
	}%
}%

\if@tabletitle
	%% Two-by-two cover table (from the abandoned fork; re-implemented with
	%% tabularx instead of the tabu commands the fork used but never loaded).
	\renewcommand{\maketitle}{%
		{
			\vspace*{-38pt}
			\fontsize{14}{17}\fontfamily{phv}\fontseries{b}\selectfont
			\setlength{\arrayrulewidth}{0.5pt}%
			\renewcommand{\arraystretch}{1.6}%
			\begin{tabularx}{\linewidth}{|>{\raggedright\arraybackslash}X|>{\raggedright\arraybackslash}X|}
				\hline
					\mexam@exam								& \@title \\
				\hline
					Fachlehrer: \@author	& \@date \\
				\hline
			\end{tabularx}
		}
	  \medskip
	}
\else
	\renewcommand{\maketitle}{%
		{
			\vspace*{-52pt}
			\fontsize{16}{19}\fontfamily{phv}\fontseries{b}\selectfont
			\begin{tcolorbox}[mytitle]
				\centering
				\@title
			\end{tcolorbox}
		}
	  \medskip
	}
\fi

\AtBeginDocument{%
	\ifdefempty{\mexam@tasknumber}%
		{\ClassWarningNoLine{mexam}{No \noexpand\tasknumber given}}{}%
	\if@tabletitle
		\ifdefempty{\mexam@exam}%
			{\ClassWarningNoLine{mexam}{No \noexpand\exam given}}{}%
	\fi
}

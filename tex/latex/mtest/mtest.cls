%% mtest.cls -- class for writing test sheets (Klassenarbeiten).
%%
%% Copyright (C) 2023--2026 Marc Schlienger <marc.schlienger@posteo.de>
%% Released under the LaTeX Project Public License v1.3c or later, see
%% http://www.latex-project.org/lppl.txt
%%
%% Updated 2026-08-29: xcolor is now actually loaded (the class asked for
%% the "svgnames, table" options but never loaded the package), and the
%% \license / \attribution foot of msheet.cls is available here too.
%% See attic/ for the original.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mtest}[2026/08/29 v2.0 Class for writing test sheets.]

\DeclareRobustCommand\logo[1]{\gdef\mtest@logo{#1}}
\newcommand{\mtest@logo}{Rolf-Benz-Schule.png}

\DeclareRobustCommand\class[1]{\gdef\mtest@class{#1}}
\newcommand{\mtest@class}{}

\DeclareRobustCommand\testnumber[1]{\gdef\mtest@testnumber{#1}}
\newcommand{\mtest@testnumber}{}

\DeclareRobustCommand\license[1]{\gdef\mtest@license{#1}}
\newcommand{\mtest@license}{}

\DeclareRobustCommand\attribution[1]{\gdef\mtest@attribution{#1}}
\newcommand{\mtest@attribution}{}

\DeclareOption{twoside}{\OptionNotUsed}

\DeclareOption{singlespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{onehalfspacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{doublespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}

\PassOptionsToPackage{left=20mm, right=20mm, top=25mm,
	headheight=24.34654pt}{geometry}
\PassOptionsToPackage{footsepline}{scrlayer-scrpage}
\PassOptionsToPackage{bitstream-charter}{mathdesign}
\PassOptionsToPackage{T1}{fontenc}
\PassOptionsToPackage{ngerman}{babel}
\PassOptionsToPackage{svgnames, table}{xcolor}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessOptions\relax
\LoadClass{scrartcl}

\RequirePackage{etoolbox}
\RequirePackage{totcount}
\RequirePackage{geometry}
\RequirePackage{scrlayer-scrpage}
\RequirePackage{mathdesign}
\RequirePackage{fontenc}
\RequirePackage{microtype}
\RequirePackage{babel}
\RequirePackage{setspace}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tabularx}

%% needed so that \license{\href{...}{...}} works, as in msheet.cls
\RequirePackage{hyperref}
\hypersetup{colorlinks=true, linkcolor=blue, filecolor=magenta, urlcolor=cyan}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Head and foot
\pagestyle{scrheadings}
\setkomafont{pageheadfoot}{\sffamily\mdseries\scriptsize}

\ihead{\hspace{2pt}\mtest@class}
\chead{}
\ohead{\smash{\includegraphics[width=153pt]{\mtest@logo}}\hspace{2pt}}

%% Evaluated at shipout, so \license/\attribution may be set in the preamble.
\ifoot{%
	\ifdefempty{\mtest@attribution}{}{\mtest@attribution\;}%
	\ifdefempty{\mtest@license}{}{\copyright\;\the\year\;\@author\;(\mtest@license)}%
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
\renewcommand{\maketitle}{%
	{
		\fontsize{14}{17}\fontfamily{phv}\selectfont
		\renewcommand{\arrayrulewidth}{0.7pt}
		\centering
		\vspace*{\dimexpr1.5\parsep-\baselineskip-\headsep\relax}
		\begin{tabularx}{\linewidth}{| >{\centering\arraybackslash}X | >{\centering\arraybackslash}p{32mm} | }
			\hline
			{\bfseries \@title}					& Klassenarbeit~\mtest@testnumber \\
			\hline
			\multicolumn{1}{|l|}{Name:}	& \@date \\
			\hline
		\end{tabularx}
	}
  \medskip
}

\AtBeginDocument{%
	\ifdefempty{\mtest@class}%
		{\ClassWarningNoLine{mtest}{No \noexpand\class given}}{}%
	\ifdefempty{\mtest@testnumber}%
		{\ClassWarningNoLine{mtest}{No \noexpand\testnumber given}}{}%
}

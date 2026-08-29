%% mtest.cls -- class for writing test sheets (Klassenarbeiten).
%%
%% Copyright (C) 2023--2026 Marc Schlienger <marc.schlienger@posteo.de>
%% Released under the LaTeX Project Public License v1.3c or later, see
%% http://www.latex-project.org/lppl.txt
%%
%% The machinery shared with msheet/mexam/mtalk lives in the internal
%% packages mtex-base.sty and mtex-komabase.sty.  The pre-merge original
%% is in attic/.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mtest}[2026/08/29 v2.1 Class for writing test sheets.]
\def\mtex@cls{mtest}

\DeclareRobustCommand\class[1]{\gdef\mtest@class{#1}}
\newcommand{\mtest@class}{}

\DeclareRobustCommand\testnumber[1]{\gdef\mtest@testnumber{#1}}
\newcommand{\mtest@testnumber}{}

\DeclareOption{twoside}{\OptionNotUsed}

\DeclareOption{singlespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{onehalfspacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{doublespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessOptions\relax
\LoadClass{scrartcl}

\RequirePackage{mtex-komabase}

\mtex@definebasekeys{mtest}
\define@key{mtest}{class}{\gdef\mtest@class{#1}}
\define@key{mtest}{testnumber}{\gdef\mtest@testnumber{#1}}
\newcommand{\mtestsetup}[1]{\setkeys{mtest}{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\geometry{left=20mm, right=20mm, top=25mm, headheight=24.34654pt}

\ihead{\hspace{2pt}\mtest@class}
\ohead{\smash{\mtexlogobox}\hspace{2pt}}
\ifoot{\mtexcredit}
\cfoot{\mtexpagenumber}
\ofoot{}

\mtex@warnifempty{\mtest@class}{\class}
\mtex@warnifempty{\mtest@testnumber}{\testnumber}

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

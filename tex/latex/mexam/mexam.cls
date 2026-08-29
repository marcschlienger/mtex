%% mexam.cls -- class for writing oral exam sheets.
%%
%% Copyright (C) 2023--2026 Marc Schlienger <marc.schlienger@posteo.de>
%% Released under the LaTeX Project Public License v1.3c or later, see
%% http://www.latex-project.org/lppl.txt
%%
%% The machinery shared with msheet/mtest/mtalk lives in the internal
%% packages mtex-base.sty and mtex-komabase.sty.  The pre-merge originals
%% are in attic/.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mexam}[2026/08/29 v2.1 Class for writing oral exam sheets.]
\def\mtex@cls{mexam}

\DeclareRobustCommand\tasknumber[1]{\gdef\mexam@tasknumber{#1}}
\newcommand{\mexam@tasknumber}{}

\DeclareRobustCommand\exam[1]{\gdef\mexam@exam{#1}}
\newcommand{\mexam@exam}{}

\DeclareOption{twoside}{\OptionNotUsed}

\newif\if@tabletitle		\@tabletitlefalse
\DeclareOption{tabletitle}{\@tabletitletrue}

\DeclareOption{singlespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{onehalfspacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}
\DeclareOption{doublespacing}{\PassOptionsToPackage{\CurrentOption}{setspace}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessOptions\relax
\LoadClass{scrartcl}

\RequirePackage{mtex-komabase}

\mtex@definebasekeys{mexam}
\define@key{mexam}{tasknumber}{\gdef\mexam@tasknumber{#1}}
\define@key{mexam}{exam}{\gdef\mexam@exam{#1}}
\newcommand{\mexamsetup}[1]{\setkeys{mexam}{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\geometry{left=15mm, right=15mm, top=25mm, headheight=24.34654pt}

\ihead{\ifdefempty{\mexam@tasknumber}{}{\hspace{2pt}Aufgabe~\mexam@tasknumber}}
\ohead{\smash{\mtexlogobox}}
\ifoot{\mtexcredit}
\cfoot{\mtexpagenumber}
\ofoot{}

\mtex@warnifempty{\mexam@tasknumber}{\tasknumber}

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
	%% Two-by-two cover table: \exam / \title over Fachlehrer / \date.
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
	\mtex@warnifempty{\mexam@exam}{\exam}
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

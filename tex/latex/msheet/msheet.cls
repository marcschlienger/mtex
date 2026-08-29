%% msheet.cls -- class for writing lesson sheets.
%%
%% Copyright (C) 2022--2026 Marc Schlienger <marc.schlienger@posteo.de>
%% Released under the LaTeX Project Public License v1.3c or later, see
%% http://www.latex-project.org/lppl.txt
%%
%% The machinery shared with mtest/mexam/mtalk lives in the internal
%% packages mtex-base.sty and mtex-komabase.sty; this file keeps what is
%% specific to lesson sheets: the class options, the layout numbers and
%% \maketitle.  See doc/NOTES.md for the migration notes.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{msheet}[2026/08/29 v2.1 Class for writing lesson sheets.]
\def\mtex@cls{msheet}

\newif\if@rounded		\@roundedfalse
\DeclareOption{rounded}{\@roundedtrue}

%% Sheet type -> title icon.
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

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessOptions\relax
\LoadClass{scrartcl}

\RequirePackage{mtex-komabase}

%% Key/value interface.  Everything that used to be a class option or a
%% public command can be set here, also after \begin{document}.
\mtex@definebasekeys{msheet}
\define@key{msheet}{type}{\msheet@settype{#1}}
\define@key{msheet}{icon}{\renewcommand*{\msheet@icon}{#1}}
\define@key{msheet}{titlecolor}{\renewcommand*{\msheet@titlebackcolor}{#1}}
\newcommand{\msheetsetup}[1]{\setkeys{msheet}{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The numbers reproduce the old hand-made layout: text block 1in from the
%% top, 1in left and right, 30.5mm at the bottom.
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

\ihead{}
\ohead{\mtexlogobox\hspace{5pt}}
\ifoot{\mtexcredit}
\cfoot{}
\ofoot{\mtexpagenumber}

\mtex@warnifempty{\mtex@license}{\license}
\mtex@warnifempty{\mtex@attribution}{\attribution}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          TITLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

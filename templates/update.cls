\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}} % Pass through any options to the base class
\ProcessOptions\relax % Process given options

\LoadClass{article} % Load the base class

\usepackage[document]{ragged2e}
\usepackage{hyperref}
\usepackage{titlesec}
\usepackage{graphicx}
\usepackage[normalem]{ulem}
\usepackage{geometry}
\usepackage{tabularx}
\usepackage{enumitem}
\usepackage{parskip}
\useunder{\uline}{\ul}{}

\geometry{
	paper=a4paper, % Paper size, change to letterpaper for US letter size
	top=2cm, % Top margin
	bottom=2cm, % Bottom margin
	left=2cm, % Left margin
	right=2cm, % Right margin
}

\newlist{myitemize}{itemize}{1}
\setlist[myitemize]{label=$\bullet$, nosep, wide=0pt, leftmargin=*, before=\vspace{-0.5\baselineskip}}

\newenvironment{leveldown}% Demote sectional commands
  {\let\section\subsection%
   \let\subsection\subsubsection%
   \let\subsubsection\paragraph%
   \let\paragraph\subparagraph%
   %\let\subparagraph\relax%
  }{}
\newenvironment{levelup}% Promote sectional commands
  {\let\subparagraph\paragraph%
   \let\paragraph\subsubsection%
   \let\subsubsection\subsection%
   \let\subsection\section%
   %\let\section\relax%
  }{}

  % \titleformat{\section}{\normalfont\Large\bfseries}{Week \thesection}{1em}{}
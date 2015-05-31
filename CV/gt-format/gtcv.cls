%%
%% This is file `gtcv.cls',
%% 


% identification
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{gtcv}[2010/03/15 by Nick Feamster]
\LoadClass{article}
\PassOptionsToClass{11pt}{article}
\RequirePackage{ifthen}%

\newfont{\sfblarger}{cmssbx10 scaled\magstep2}   %-- 12+pt sans serif bold
\newfont{\sfblarge}{cmssbx10 scaled\magstep1}      %-- 12pt sans serif bold
\newfont{\sfbeleven}{cmssbx10 scaled\magstephalf}  %-- 11pt sans serif bold
\newfont{\sfb}{cmssbx10}                           %-- 10pt sans serif bold
\newfont{\sfeight}{cmss8}                          %-- 8pt sans serif

\newfont{\df}{phvb at 12pt}
\newfont{\mf}{phvro at 9.5pt}
\newfont{\nf}{rpncb at 18pt}


\newcommand{\mkbib}[1]{
\item
 \begin{bibunit}[plain]
      \nocite{#1}
      \putbib[ref,rfc,talks]
    \label{bib:#1}
  \end{bibunit}
}


\newcommand{\mkbiba}[2]{
\item
 \begin{bibunit}[plain]
      \nocite{#1}
      \putbib[ref,rfc,talks]
    \label{bib:#1} \vspace{-0.05in}
    {\em Acceptance rate: #2\%}
  \end{bibunit}
}



\newcommand{\refbib}[1]{\ref{bib:#1}}

\newcommand{\ie}{{\em i.e.}}
\newcommand{\eg}{{\em e.g.}}


\newcommand*{\@cvplace}{\@empty}%
\newsavebox{\@cvlistheading}%
\newlength{\cvlabelsep}%
\newlength{\cvlabelskip}%
\newlength{\cvlabelwidth}%
\newboolean{cv@many@bibs}%
\newboolean{cv@no@date}%
\newboolean{cv@open@bib}%
\DeclareOption{LabelsAligned}{%
  \setlength{\cvlabelskip}{0ex}%
}%
\DeclareOption{TextAligned}{%
  \setlength{\cvlabelskip}{%
    1.5\baselineskip plus 3pt minus 3pt%
  }%
}%
\DeclareOption{openbib}{%
  \@ifundefined{bibindent}{%
    \newlength{\bibindent}%
  }{}%
  \setlength{\bibindent}{1.5em}%
  \setboolean{cv@open@bib}{true}%
}%
\DeclareOption{ManyBibs}{%
  \setboolean{cv@many@bibs}{true}%
}%
\DeclareOption{NoDate}{%
  \setboolean{cv@no@date}{true}%
}%

\ExecuteOptions{internal}
\ExecuteOptions{TextAligned}%
\ProcessOptions*%
\AtBeginDocument{%
  \setlength{\cvlabelsep}{1em}%
  \settowidth{\cvlabelwidth}{%
    \cvlabelfont 88/8888--88/8888%
%     \cvlabelfont{phvb at 12pt}
  }%
}%
\DeclareRobustCommand*{\cvheadingfont}{\bfseries\Large}%
\DeclareRobustCommand*{\cvbibname}{Publications}%
\DeclareRobustCommand*{\cvplace}[1]{%
  \gdef\@cvplace{#1}%
}%
\providecommand*{\date}[1]{\gdef\@date{#1}}%
\newenvironment{cv}[1]{%
  \ifthenelse{\equal{#1}{\@empty}}{%
  }{%
    {%
      \noindent\cvheadingfont#1\par\nopagebreak
    }%
  }%
  \ifthenelse{\boolean{cv@many@bibs}}{%
    \DeclareRobustCommand*{\@biblabel}[1]{\@gobble{##1}}%
  }{}%
  \providecommand{\newblock}{%
    \hspace{0.11em plus 0.33em minus 0.07em}%
  }%
  \long\def\thebibliography##1{%
    \ifthenelse{\boolean{cv@many@bibs}}{%
    }{%
      {%
        \noindent\cvlistheadingfont\cvbibname
        \par\nopagebreak
      }%
    }%
    \ifthenelse{\boolean{cv@open@bib}}{%
      \renewcommand{\newblock}{\par}%
    }{}%
    \begin{list}{\@biblabel{\@arabic\c@enumiv}}{%
      \setlength{\parsep}{0ex}%
      \setlength{\itemsep}{%
        0.5\baselineskip plus 1pt minus 1pt%
      }%
      \setlength{\topsep}{0ex}%
      \setlength{\partopsep}{0ex}%
      \ifthenelse{\boolean{cv@many@bibs}}{%
        \setlength{\labelsep}{0em}%
      }{}%
      \settowidth{\labelwidth}{\@biblabel{##1}}%
      \setlength{\leftmargin}{\labelwidth}%
      \addtolength{\leftmargin}{\labelsep}%
      \ifthenelse{\boolean{cv@open@bib}}{%
        \addtolength{\leftmargin}{\bibindent}%
        \setlength{\itemindent}{-\bibindent}%
        \setlength{\listparindent}{\itemindent}%
      }{}%
      \usecounter{enumiv}%
      \let\p@enumiv\@empty
      \renewcommand*{\theenumiv}{\@arabic\c@enumiv}%
    }%
    \sloppy
    \clubpenalty4000%
    \@clubpenalty\clubpenalty
    \widowpenalty4000%
    \sfcode`\.=\@m
  }%
  \long\def\endthebibliography{%
    \renewcommand*{\@noitemerr}{%
      \@latex@warning{Empty `thebibliography' environment}%
    }%
    \end{list}%
  }%
}{%
  \vspace{1.333\baselineskip plus 3pt minus 3pt}%
  \ifthenelse{\equal{\@cvplace}{\@empty}}{%
  }{%
    \noindent
    \@cvplace
    \ifthenelse{\boolean{cv@no@date}}{}{%
      ,~%
    }%
  }%
  \ifthenelse{\boolean{cv@no@date}}{}{%
    \@date
  }%
  \par\noindent\ignorespacesafterend
}%
\DeclareRobustCommand*{\cvlistheadingfont}{%
  \df
%\bfseries\large
}%
\DeclareRobustCommand*{\cvlabelfont}{%
  \normalsize
}%

\newenvironment{cvlist}[1]{%
  \sbox{\@cvlistheading}{\cvlistheadingfont#1}%
  \begin{list}{}{%
      \renewcommand*{\makelabel}[1]{%
        \settowidth{\@tempdima}{\usebox{\@cvlistheading}}%
        \ifthenelse{\lengthtest{\@tempdima > 0pt}}{%
          \settowidth{\@tempdimb}{\cvlabelfont##1}%
          \ifthenelse{%
            \lengthtest{\@tempdima < \cvlabelwidth} \and
            \lengthtest{\@tempdimb = 0pt}}{%
            \parbox[b]{\cvlabelwidth}{%
              \vspace{\cvlabelskip}%
              \makebox[\cvlabelwidth][l]{%
                \box\@cvlistheading
              }%
            }%
          }{%
            \parbox[b]{0pt}{%
              \makebox[0pt][l]{\box\@cvlistheading}%
              \\*[0.5\baselineskip plus 1pt minus 1pt]%
            }%
          }%
        }{}%
        \cvlabelfont##1\hfill
      }%
      \setlength{\itemsep}{0ex}%
      \setlength{\parsep}{%
        0.5\baselineskip plus 1pt minus 1pt%
      }%
      \setlength{\topsep}{%
        1\baselineskip plus 2pt minus 2pt%
      }%
      \setlength{\partopsep}{0ex}%
      \setlength{\labelsep}{0ex}%
      \setlength{\labelwidth}{\cvlabelwidth}%
      \setlength{\leftmargin}{\cvlabelwidth}%
      \addtolength{\leftmargin}{\cvlabelsep}%
    }%
}{%
  \end{list}%
}%


% inital setup
%\newif\ifgtcv@full
%\newif\ifgtcv@short
\newif\ifgtcv@internaldraft
\newif\ifgtcv@externaldraft
\newif\ifgtcv@internalfinal
\newif\ifgtcv@externalfinal

\newlength{\titlespace}
\setlength{\titlespace}{0.25in}

\newcommand{\gtcv@pointsize}{}
\newcommand{\gtcv@empty}{}

\newcommand{\gtcv@affiliation}{}
\newcommand{\affiliation}[1]{\renewcommand{\gtcv@affiliation}{#1}}
\newcommand{\gtcvaffiliation}[1]{\affiliation{#1}}
%
\newcommand{\gtcv@fullname}{}
\newcommand{\fullname}[1]{\renewcommand{\gtcv@fullname}{#1}}
\newcommand{\gtcvfullname}[1]{\fullname{#1}}
%
\newcommand{\gtcv@initials}{}
\newcommand{\initials}[1]{\renewcommand{\gtcv@initials}{#1}}
\newcommand{\gtcvinitials}[1]{\initials{#1}}
%
\newcommand{\gtcv@position}{}
\newcommand{\position}[1]{\renewcommand{\gtcv@position}{#1}}
\newcommand{\gtcvposition}[1]{\position{#1}}
%
\newcommand{\gtcv@email}{}
\newcommand{\email}[1]{\renewcommand{\gtcv@email}{#1}}
\newcommand{\gtcvemail}[1]{\email{#1}}
%
\newcommand{\gtcv@webpage}{}
\newcommand{\webpage}[1]{\renewcommand{\gtcv@webpage}{#1}}
\newcommand{\gtcvwebpage}[1]{\webpage{#1}}
%

\newcommand{\gtcv@sectionfont}{}
%\newcommand{\sectionfont}[1]{\renewcommand{\acm@sectionfont}{#1}}

\newcommand{\gtcv@version}{}
\newcommand{\version}[1]{\renewcommand{\gtcv@version}{#1}}
\newcommand{\gtcvversion}[1]{\version{#1}}

\newcommand{\gtcv@mode}{}
\newcommand{\mode}[1]{\renewcommand{\gtcv@mode}{#1}}
\newcommand{\gtcvmode}[1]{\mode{#1}}

\newcommand{\setmode}[1]{\def\mode{#1}}
\newcommand{\setversion}[1]{\def\version{#1}}
\newcommand{\sethighlightnew}[1]{\def\highlightnew{#1}}



%
% options

%\DeclareOption{internal}{%
%    \gtcv@internaltrue%
%    \gtcv@externalfalse%
%    \gtcv@reviewfalse%
% }
% 
% % Assume, for the moment, that we're preparing a 'cameraready' version.
%
%\ExecuteOptions{internal}

% Here's a warning command for use just below.

%\newcommand{\gtcv@optwarning}[1]{%
%    \ifgtcv@internal
%        \ClassWarningNoLine{gtcv}%
%            {#1 option used in internal mode.\MessageBreak
%             This violates format specifications}
%    \fi
%}

\renewcommand{\@maketitle}{%
        \begin{center}%
            {\LARGE\sffamily\bfseries\gtcv@sectionfont \gtcv@fullname \par}%
            \vspace{1\baselineskip}%
            \large
            \begin{tabular}[t]{c}%
                \gtcv@position
            \end{tabular}\par%
            \ifx\gtcv@affiliaton\gtcv@empty \else%
                \vspace{1\baselineskip}%
                \gtcv@affiliation\par%
            \fi%
           \vspace{\titlespace}%
        \end{center} \par%
    	}

\newcommand{\ifcvfull}[1]{\ifcv@full \else #1 \fi}
\newcommand{\ifcvshort}[1]{\ifcv@short \else #1 \fi}
%\newcommand{\ifcvfullelse}[2]{\if #2 \else #1 \fi}
%\newcommand{\ifcvshortelse}[2]{\if #1 \else #2 \fi}



% to change the numbering of sections
\renewcommand{\thesection}{\Roman{section}.}
\renewcommand{\thesubsection}{\Alph{subsection}.}
\renewcommand{\thesubsubsection}{\Alph{subsection}.\arabic{subsubsection}.}
%\renewcommand{\theenumi}{\Alph{subsection}.\arabic{subsubsection}.\arabic{enumi}}
\setlength\leftmargini{4em} \setlength\labelsep{1em}
\setlength\labelwidth{\leftmargini}
\renewcommand\contentsname{\centerline{\bf\normalsize Table of Contents}}


% a new counter and list style for CV

\newcounter{cvitemno}
\newenvironment{cvitem}
    {\begin{list}{\Alph{subsection}.\arabic{subsubsection}.\arabic{cvitemno}}
    {\usecounter{cvitemno}}}
    {\end{list}}
\renewcommand{\thecvitemno}{\Alph{subsection}.\arabic{subsubsection}.\arabic{cvitemno}}

\newcounter{pubno}
\newenvironment{pub}
    {\begin{list}{\Alph{subsection}.\arabic{subsubsection}.\arabic{pubno}}
    {\usecounter{pubno}\labelsep=0.7in\leftmargin=1.15in}}
    {\end{list}}
\renewcommand{\thepubno}{\Alph{subsection}.\arabic{subsubsection}.\arabic{pubno}}

\newcounter{grantno}
\newenvironment{grants}
    {\begin{list}{\Alph{subsection}.\arabic{subsubsection}.\arabic{grantno}}
    {\usecounter{grantno}}}
    {\end{list}}
\renewcommand{\thegrantno}{\Alph{subsection}.\arabic{subsubsection}.\arabic{grantno}}


\def\cvname#1{\gdef\@cvname{#1}}

\usepackage{fullpages}
\resetwidth{6.5in} \resetheight{8.7in}

\setlength{\parskip}{0pt}
\newlength{\tabitemskip} \setlength{\tabitemskip}{2pt}


\usepackage[usenames]{color}
\usepackage{graphicx}
\usepackage{fancyhdr}
\usepackage{amssymb}
\usepackage{ifthen}

\reversemarginpar

\long\def\HIDE#1{}
\newcommand{\info}[1]{{\small\sl [#1]}}
%\newcommand{\nw}{\marginpar{$\rhd$}}
\newcommand{\nw}{}

\usepackage[breaklinks=true,pagebackref,filecolor=black,citecolor=black,urlcolor=black,linkcolor=black,colorlinks,pdfpagelabels,pdfpagelayout=SinglePage]{hyperref}


\pagestyle{fancyplain} %
\lhead{} \rhead{} \chead{}
\lfoot{\fancyplain{Revised: \today}{Nick Feamster}}

\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{.5pt}
\renewcommand{\plainfootrulewidth}{1pt}
\addtolength{\headheight}{3pt}


%\newcommand\note#1{\marginpar{\tiny{IE}}{\sc#1}}


\global\def\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {1.8ex}%
%                                   {\noindent \Large $\blacksquare$
%                                   \hspace{0.1in}
%                                   \normalfont\Large\sfblarger}}
				   {\normalfont\Large\sfblarger}}

\global\def\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-2.75ex\@plus -1ex \@minus -.2ex}%
                                     {1.2ex}%
%                                     {\noindent $\blacksquare$
%                                      \hspace{0.1in}
%                                     \normalfont\large\sfblarge} 
				     {
				       %\setcounter{bibctr}{0}  
				       \normalfont\large\sfblarge}}

\global\def\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-2.75ex\@plus -1ex \@minus -.2ex}%
                                     {1.2ex}%
                                     {
				       %\setcounter{bibctr}{0} 
				       \normalfont\large\sfb}}



\endinput

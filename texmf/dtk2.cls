
\listfiles
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\RequirePackage{hyphsubst}% Trennregeln austauschen
\HyphSubstIfExists{ngerman-x-latest}{%
  \HyphSubstLet{ngerman}{ngerman-x-latest}}{}
\HyphSubstIfExists{german-x-latest}{%
  \HyphSubstLet{german}{german-x-latest}}{}

\ProvidesClass{dtk2}%
  [2015/07/30 v0.1c dtk document class (RN)]

\RequirePackage{ifxetex,ifluatex,ifpdf,ifvtex}
\newcommand*\DTK@engine{}

\ifluatex
  \def\DTK@engine{4}% LuaTeX
\else
  \ifxetex
    \def\DTK@engine{3}% XeTeX
  \else
    \ifpdf
      \def\DTK@engine{2}% pdfTeX
    \else
      \ifvtex
        \def\DTK@engine{1}% VTeX
      \else
        \def\DTK@engine{0}% TeX+dvips
      \fi
    \fi
  \fi
\fi

\newif\ifDTK@Author@ \DTK@Author@true
\newif\ifDTK@bib@ \DTK@bib@false
\newif\ifDTKcolor \DTKcolorfalse % "@" ?

\DeclareOption{full}{\DTK@Author@false}
\DeclareOption{color}{\DTKcolortrue}
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{scrbook}}
\DeclareOption*{\OptionNotUsed}
\ProcessOptions\relax

\PassOptionsToPackage{paper=a5,pagesize}{typearea}

\newdimen\DTK@tempdima
\newdimen\DTK@tempdimb
\newdimen\DTK@tempdimc

\newcommand*\DTK@tempa{}
\newcommand*\DTK@tempb{}
\newcommand*\DTK@tempc{}

\RequirePackage{xkeyval}

\LoadClass[%
,twoside
,fontsize=10pt
,captions=oneline
,parskip=full*
,headings=small
,open=any
,pagesize
]{scrbook}

\usepackage{scrhack}% Andere Pakete KOMA-Script-freundlich machen

% http://www.komascript.de/release3.18
\ifstr{\KOMAScriptVersion}{2015/07/02 v3.18 KOMA-Script}{%
  \ifx\par@update\default@par@update\else
    \AtBeginDocument{\par@updaterelative}%
  \fi
}{}

% *** Konstanten ***

\ifDTK@Author@\else\setcounter{errorcontextlines}{100}\fi

\textheight = 485pt %
\textwidth  = 333pt %
\oddsidemargin  = -35.89157pt %
\evensidemargin = -17.70235pt %
\marginparwidth = 1cm %
\marginparsep = 7pt %
\topmargin  = -55.66684pt %
\headheight = 17pt %
\headsep    = 17pt %
\footskip = 24pt %
\parskip   = 0.3\baselineskip
\advance\parskip by 0pt plus 2pt %
\parindent = 0pt %
\columnsep = 5pt %

\emergencystretch = 1.5em %
\clubpenalty  = 10000 %
\widowpenalty = 10000 %
\raggedbottom

\setcounter{secnumdepth}{\numexpr\partnumdepth-1\relax}
\setcounter{tocdepth}{\chapternumdepth}

\@fptop=\z@
\renewcommand\topfraction{.9}
\renewcommand\bottomfraction{.9}
\renewcommand\textfraction{.1}

\ifnum\DTK@engine < 3 %
  \input{dtk-old-engines.clo}% pdfTeX oder TeX+dvips oder VTeX
\else
  \input{dtk-new-engines.clo}% LuaTeX oder XeTeX
\fi

\RequirePackage[main=ngerman]{babel}
\RequirePackage[autostyle=true,babel=once,german=guillemets,maxlevel=3]{csquotes}%
\MakeAutoQuote{»}{«}
\defineshorthand{"`}{\openautoquote}%
\defineshorthand{"'}{\closeautoquote}%

\ifxetex\else
\RequirePackage[%
,factor=1500
,protrusion=true
,expansion=true
,verbose=true
,final=true
,letterspace=100
,babel=true
]{microtype}
% TODO: Spezielle Angaben zu den Schriften?
\fi

\RequirePackage[%
,style=dtk
,language=auto
,hyperref=auto
,abbreviate=true
,sorting=nyt
,bibencoding=utf8
,block=ragged
,backend=biber
%,useprefix=true
%,backrefstyle=two
,sortlocale=de_DE
%  ,sortlocale=de_DE_phonebook
,dateabbrev=false
,datezeros=false
,maxnames=3
,minnames=3
%,defernumbers=true
]{biblatex}

\newcommand*\journalname{Die \protect\TeX{}nische Kom\"odie}

\newcommand*\DTKyear{\the\year}
\newcommand*\DTKmonth{0}
\newcommand*\DTKissue{0}
\newcommand*\DTKvolume{??}
\newcommand*\DTKdate{?/??}
\newcommand*\DTKcorrVersion{\mbox{}}
\newcommand*\DTKfullIssue{\mbox{}}
\newcommand*\DTKissn{1434-5897}

%\RequirePackage{etex} % ???
\RequirePackage{dantelogo,hologo,dtklogos}

\renewcommand\title[2][]{%
  \gdef\@title{#2}%
  \ifx\relax#1\relax\gdef\@@title{#2}\else\gdef\@@title{#1}\fi%
}

\newcommand\DTK@maketitle[1][]{%
  \begingroup
    \dimen0=\textheight
    \advance\dimen0 by -\pagetotal
    \ifdim\dimen0<.2\textheight
      \newpage
      %\global\FirstArticletrue
    \fi
    \chapter[\@@title]{\@title}%
    \ifx\@author\@empty\else\par
      \begingroup
        \usekomafont{section} \@author
      \endgroup
    \fi
    \@thanks
    \let\thanks\@gobble
  \endgroup
  \let\@title=\@empty
  \let\@author=\@empty
  \let\@thanks=\@empty
  \medskip\par
}

\renewcaptionname{ngerman}{\bibname}{Literatur und Software}
\defbibheading{dtk}{\section{\bibname}}

\RequirePackage[automark,draft=false]{scrlayer-scrpage}
\pagestyle{scrheadings}
\clearpairofpagestyles
\ihead{\headmark}
\ohead{\pagemark}
\ofoot*{\normalsize\DTKcorrVersion}
\ifoot*{\journalname~~\DTKdate}
\automark[chapter]{chapter}

\RequirePackage{xpatch}
\def\chapterheadstartvskip{} %\vspace {\@tempskipa }
\def\chapterpagestyle{scrheadings}
\xpatchcmd{\scr@startchapter}{\clearpage}{\relax}{}{\PaTchFaiLED}% ???

\RequirePackage{xcolor}

\iffalse
\ifDTKcolor
  \colorlet{DTK@marker}{red!30}
  \definecolor{DTK@fancy}{rgb}{.72,.525,.044}
  \definecolor{DTKlstBackground}{rgb}{1,1,0.86}
  \definecolor{DTKlstKeys}{rgb}{0,0,1}
  \definecolor{DTKlstIdentifiers}{rgb}{0,0,0}
  \definecolor{DTKlstComments}{rgb}{1,0,0}
  \definecolor{DTKlstStrings}{rgb}{0,0.5,0}
  \newcommand*\DTKlstKeywordfont{\color{DTKlstKeys}}
\else
  \colorlet{DTK@marker}{black!20}
  \colorlet{DTK@fancy}{black!60}
  \colorlet{DTKlstBackground}{black!14}
  \colorlet{DTKlstKeys}{black}
  \colorlet{DTKlstIdentifiers}{black}
  \colorlet{DTKlstComments}{black}
  \colorlet{DTKlstStrings}{black}
  \newcommand*\DTKlstKeywordfont{\bfseries}
\fi
\fi

\ifDTKcolor
  \colorlet{DTK@marker}{red!30}
  \definecolor{DTK@fancy}{rgb}{.72,.525,.044}
  \definecolor{DTKlstBackground}{rgb}{1,1,0.86}
  \definecolor{DTKlstKeys}{HTML}{2AA198}
  %\colorlet{DTKlstIdentifiers}{black}
  \definecolor{DTKlstComments}{HTML}{93A1A1}
  \definecolor{DTKlstStrings}{HTML}{268BD2}
  \definecolor{DTKlstNumbers}{HTML}{6C71C4}
  \newcommand*\DTKlstKeywordfont{\color{DTKlstKeys}}
\else
  \colorlet{DTK@marker}{black!20}
  \colorlet{DTK@fancy}{black!60}
  \colorlet{DTKlstBackground}{black!5}
  \colorlet{DTKlstKeys}{black}
  %\colorlet{DTKlstIdentifiers}{black}
  \colorlet{DTKlstComments}{black}
  \colorlet{DTKlstStrings}{black}
  \colorlet{DTKlstNumbers}{black}
  \newcommand*\DTKlstKeywordfont{\bfseries}
\fi

\RequirePackage[final]{listings}
\RequirePackage{lstautogobble}

\@ifundefined{ifDTKrecord}{\newif\ifDTKrecord \DTKrecordfalse}{}
\ifDTK@Author@
  \input{dtk-author.clo}
\else
  \input{dtk-full.clo}
\fi

%%%\ifDTKrecord \expandafter \endinput \fi % lohnt es?

\addtokomafont{caption}{\small}
\addtokomafont{captionlabel}{\bfseries\sffamily}
\setcapindent{1em}
\setcapwidth[c]{.8\textwidth}

\setkomafont{disposition}{\normalfont\sffamily}
\setkomafont{part}{\usekomafont{disposition}\huge}
\setkomafont{chapter}{\usekomafont{disposition}\Large}
\setkomafont{section}{\usekomafont{disposition}\large}
\setkomafont{pagenumber}{\normalfont\sffamily}
\setkomafont{pagehead}{\sffamily\slshape}% \itshape?
\setkomafont{pagefoot}{\footnotesize\sffamily\slshape}% \itshape?

% Kompakte Listen
\RequirePackage[neverdecrease]{paralist}
\newcommand*\DTK@begin@list[1]{%
  \DTK@tempdima=\parindent
  \DTK@tempdimb=\parskip
  \@nameuse{#1}%
  \parindent=\DTK@tempdima
  \parskip=\DTK@tempdimb
}

\def\enumerate{\DTK@begin@list{compactenum}}
\def\itemize{\DTK@begin@list{compactitem}}
\def\description{\DTK@begin@list{compactdesc}}
\let\enditemize\endcompactitem
\let\endenumerate\endcompactenum
\let\enddescription\endcompactdesc
\pltopsep=\medskipamount
\plitemsep=1pt %
\plparsep=1pt %

%\def\labelitemi{...}
%\def\labelitemii{...}
%\def\labelitemiii{...}

% Listings
\newcommand*\DTKlstfont{\small\ttfamily}

% siehe ggf.: https://github.com/jez/latex-solarized

\lstdefinestyle{DTKlstSimple}{%
,basicstyle=\DTKlstfont
,identifierstyle=\DTKlstfont
,stringstyle=\DTKlstfont
,commentstyle=\DTKlstfont
,basewidth=0.55em
,keepspaces
,autogobble=false
,backgroundcolor=\color{DTKlstBackground}
,numbers=none
,tabsize=2
,frame=single
,framesep=\fboxsep
,aboveskip=\medskipamount
,belowskip=\medskipamount
,xleftmargin=\fboxsep
,xrightmargin=\fboxsep
}

\newcommand*\DTK@lst@colorbox[2]{%
  \fboxsep=.16em %
  \settowidth\DTK@tempdima{#2}\settoheight\DTK@tempdimb{#2}%
  \settodepth\DTK@tempdimc{#2}%
  \makebox[\DTK@tempdima][c]{\colorbox{#1}{%
    \raisebox{0pt}[\DTK@tempdimb][\DTK@tempdimc]{#2}}}%
}

\lstdefinestyle{DTKlstBase}{%
,style=DTKlstSimple
%,identifierstyle=\color{DTKlstIdentifiers}
,keywordstyle=\DTKlstKeywordfont
,stringstyle=\itshape\color{DTKlstStrings}
,commentstyle=\itshape\color{DTKlstComments}
,columns=fullflexible
%,extendedchars=true
,showspaces=false
,showstringspaces=false
,breaklines=true
,breakindent=0.5em
,breakautoindent=true
,breakatwhitespace=false  % ???
,captionpos=t
,emphstyle=\DTK@lst@colorbox{DTKlstBackground!70!-DTKlstBackground}%
%,prebreak=
,postbreak=\mbox{$\hookrightarrow$}
,autogobble=true
}

\lstdefinestyle{number}{%  TODO: Evtl. doch besser Zeilennummern ganz ausrücken?
,style=DTKlstBase
,numbers=left
,numberstyle=\tiny\ttfamily
,numbersep=1em
,xleftmargin=1.5em
}

\lstdefinestyle{noNumber}{%
,style=DTKlstBase
,numbers=none
,xleftmargin=\fboxsep % ???
}

\lstset{style=number}

% noHilit, latex ???

\let\verbatim=\relax
\lstnewenvironment{verbatim}
{\lstset{style=DTKlstSimple,language={}}}{}

\endinput

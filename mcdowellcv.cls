%% The MIT License (MIT)
%%
%% Permission is hereby granted, free of charge, to any person obtaining a copy
%% of this software and associated documentation files (the "Software"), to deal
%% in the Software without restriction, including without limitation the rights
%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the Software is
%% furnished to do so, subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in all
%% copies or substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%% SOFTWARE.

%% This work is heavily based on the code from https://github.com/dnl-blkv/mcdowell-cv
%% with some changes:
%%    * a4paper used and font size set to 10pt 
%%    * font selected for small caps
%%    * some vspace adjusted by \parskip
%%    * theme color support
%%    * microtype and \makeatletter \makeatother removed

\ProvidesClass{mcdowellcv}[2017/03/16 v0.1 McDowell CV class]

% Set up the fonts according to options
\def\mainfontsize{11pt}
\def\mainfontface{Times New Roman}

\DeclareOption{osx}{
  \def\mainfontface{Times}
}

\DeclareOption{win}{
  \def\mainfontface{Calibri}
}

\DeclareOption{print}{
  \def\mainfontface{Times New Roman}
}

\ProcessOptions\relax

% Set font size and paper type
\LoadClass[a4paper,\mainfontsize]{article}

% Set document margins
\usepackage[left=0.75in,top=0.75in,right=0.75in,bottom=1in]{geometry} 

% Set font face
\usepackage{fontspec}
\setmainfont{\mainfontface}
\newfontfamily\namefont{TeX Gyre Termes} % set a font for small caps (required by name in header)

% Remove paragraph indentation
\usepackage[parfill]{parskip}

% Required for boldface (\bf and \bfseries) tabular columns
\usepackage{array}

% Required for ifthenelse statements
\usepackage{etoolbox}

% Suppress page numbers
\pagestyle{empty} 

% Flexible tables
\usepackage{tabu}

% For custom margins
\usepackage{changepage}

% To customize lists
\usepackage{enumitem}
% Remove left margin from lists, suppress vertical item separation and set top 
% separation to a negative value to suppress a single parskip before lists
\setlist{leftmargin=*, noitemsep, topsep=-1\parskip}

% Theme color support
\usepackage{xcolor}
\def\@normalcolor{80,80,80}
\def\@highlightcolor{192,0,0}
\newenvironment{themecolornormalenv}{
	\color[RGB]{\@normalcolor}
}{}
\newenvironment{themecolorhighlightenv}{
	\color[RGB]{\@highlightcolor}
}{}
\newcommand\themecolornormal[1]{
	\color[RGB]{\@normalcolor}#1
}
\newcommand\themecolorhighlight[1]{
	\color[RGB]{\@highlightcolor}#1
}

%--------------------------------------------------------------------------------
%                                    Constants                                  -
%--------------------------------------------------------------------------------
\def\afterheaderspace{0.3in} %3pt
\def\beforesectionheaderspace{4.75pt} %4.75pt
\def\sectionheadermargin{6pt} %6pt
\def\aftersectionheaderspace{-0\parskip} %-4pt
\def\sectionheaderhrlueheight{0.75pt} %0.5pt
\def\aftersinglelinesubsectionheaderspace{-1\parskip} %-18.5pt
\def\afterdoublelinesubsectionheaderspace{-0.5\parskip} %-10pt
\def\aftermultilinesubsectionheaderspace{0\parskip} %-6pt
\def\afteremptysubsectionheaderspace{3pt} %3pt
\def\subsectionmargin{9pt} %9pt
\def\aftersubsectionspace{4pt} %4pt

%--------------------------------------------------------------------------------
%                            Header Setup and Printing                          -
%--------------------------------------------------------------------------------

% Address
\newcommand\address[1]{\def\@address{#1}}
\newcommand\printaddress{
	\themecolornormal{\footnotesize{\@address}}
}

% Name
\newcommand\name[1]{\def\@name{#1}}
\newcommand\printname{
	 \themecolorhighlight{\namefont \textbf{\LARGE\textsc{\@name}}}
}

% Contacts
\newcommand\contacts[1]{\def\@contacts{#1}}
\newcommand\printcontacts{
	\themecolornormal{\footnotesize{\@contacts}}
}

% Header
\newcommand\makeheader{
	\begin{center}
		\begin{tabu} to 1\textwidth { X[l,m] X[2,c,m] X[r,m] }
			\printaddress & \printname & \printcontacts \\
		\end{tabu}	
	\end{center}
	\vspace*{\afterheaderspace}
}

%--------------------------------------------------------------------------------
%                            Sections and Subsections                           -
%--------------------------------------------------------------------------------

% Print a section header
\newenvironment{cvsection}[1]{
	\begin{themecolorhighlightenv}
		\vspace*{\beforesectionheaderspace}
		% Set text margins to equal \tabcolsep (6pt by default)
		\begin{adjustwidth}{\sectionheadermargin}{\sectionheadermargin}
			\textbf{#1}
		\end{adjustwidth}
		\smallskip
		\hrule height \sectionheaderhrlueheight
		\vspace*{\aftersectionheaderspace}
	\end{themecolorhighlightenv}
	\begin{themecolornormalenv}
}{
	\end{themecolornormalenv}
}

% Print a subsection
% Define toggles checking if titles were defined
\newtoggle{lefttitledefined}
\newtoggle{centertitledefined}
\newtoggle{righttitledefined}

\newenvironment{cvsubsection}[4][1]{
	\notblank{#2}{\toggletrue{lefttitledefined}}{}
	\notblank{#3}{\toggletrue{centertitledefined}}{}
	\notblank{#4}{\toggletrue{righttitledefined}}{}
	\ifboolexpr{togl {lefttitledefined} or togl {centertitledefined} or togl {righttitledefined}}{
		\begin{tabu} to 1\textwidth { X[l,m] X[c,m] X[r,m] }
			\textbf{#2} & \textbf{#3} & \textbf{#4} \\
		\end{tabu}
		% Add space according to the specidied number of lines
		\ifnumcomp{#1}{=}{1}{\vspace*{\aftersinglelinesubsectionheaderspace}}{
			\ifnumcomp{#1}{=}{2}{\vspace*{\afterdoublelinesubsectionheaderspace}}{
				\vspace*{\aftermultilinesubsectionheaderspace}
			}
		}
	}{
		\vspace*{\afteremptysubsectionheaderspace}
	}
	\togglefalse{lefttitledefined}
	\togglefalse{centertitledefined}
	\togglefalse{righttitledefined}
	\begin{adjustwidth}{\subsectionmargin}{\subsectionmargin}
}
{
	\end{adjustwidth}
	\vspace*{\aftersubsectionspace}
}
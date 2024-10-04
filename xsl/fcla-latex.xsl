<?xml version="1.0" encoding="UTF-8"?>

<!-- This file is part of the book                -->
<!--                                              -->
<!--      A First Course in Linear Algebra        -->
<!--                                              -->
<!-- Copyright (C) 2004-2017  Robert A. Beezer    -->
<!-- See the file COPYING for copying conditions. -->

<!-- Customizations for ALL LaTeX runs of any type for FCLA  -->
<!-- Override further for Solutions Manual, Sage Primer, etc -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Assumes current file is in mathbook/user, so it must be copied there -->
<xsl:import href="../xsl/pretext-latex.xsl" />
<!-- Assumes next file can be found in mathbook/user, so it must be copied there -->
<xsl:import href="fcla-common.xsl" />

<!-- This is formatting for the title and     -->
<!-- lead-in for a "fact" within the write-up -->
<!-- of an Archetype.  This is the abstract   -->
<!-- template called by the generic template  -->
<!-- in fcla-common.xsl for an enclosing      -->
<!-- "archetype" element                      -->
<xsl:template match="*" mode="archetype-fact">
    <xsl:param name="title" />
    <xsl:param name="lead" />
    <xsl:text>\noindent$\square$\quad</xsl:text>
    <xsl:text>\textbf{</xsl:text>
    <xsl:copy-of select="$title" />
    <xsl:text>}</xsl:text>
    <xsl:text>\quad </xsl:text>
    <xsl:copy-of select="$lead" />
    <xsl:text> </xsl:text>
    <xsl:apply-templates />
    <xsl:text>%&#xa;\par&#xa;</xsl:text>
</xsl:template>

<!-- ###### -->
<!-- Blocks -->
<!-- ###### -->

<!-- For "blocks" we produce a new LaTeX environment              -->
<!-- so we can replace numbers by acronyms                        -->
<!-- Mostly we kill numbers and prefix titles                     -->
<!--                                                              -->
<!-- This should all support the "usual" method for adjusting     -->
<!-- style via the "tcb-style" mechanism                          -->

<!-- Prefix titles with the type and the "short acronym". This is     -->
<!-- for use only where born, it seems the "list-of" are not affected -->
<xsl:template match="definition|theorem|principle|computation|example" mode="title-full">
    <xsl:apply-templates select="." mode="type-name"/>
    <xsl:text>~</xsl:text>
    <xsl:apply-templates select="." mode="get-short-acro" />
    <xsl:text>: </xsl:text>
    <xsl:apply-imports/>
</xsl:template>

<xsl:template match="definition|theorem|principle|computation|example" mode="environment">
    <!-- Names of various pieces normally use the      -->
    <!-- element name, but "exercise" does triple duty -->

    <!-- RAB: simplified, no inline exercise -->

    <xsl:variable name="environment-name">
        <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <!-- projects and inline exercises sometimes run on their own counters -->
    <!-- <xsl:variable name="counter"> -->
        <!-- <xsl:choose> -->
            <!-- <xsl:when test="(&PROJECT-FILTER;) and $b-number-project-distinct"> -->
                <!-- <xsl:text>project-distinct</xsl:text> -->
            <!-- </xsl:when> -->
            <!-- <xsl:when test="self::exercise and boolean(&INLINE-EXERCISE-FILTER;) and $b-number-exercise-distinct"> -->
                <!-- <xsl:text>exercise-distinct</xsl:text> -->
            <!-- </xsl:when> -->
            <!-- <xsl:otherwise> -->
                <!-- <xsl:text>block</xsl:text> -->
            <!-- </xsl:otherwise> -->
        <!-- </xsl:choose> -->
    <!-- </xsl:variable> -->
    <xsl:text>%% </xsl:text>
    <!-- per-environment style -->
    <xsl:value-of select="$environment-name"/>
    <xsl:text>: fairly simple numbered block/structure&#xa;</xsl:text>
    <xsl:text>\tcbset{ </xsl:text>
    <xsl:value-of select="$environment-name"/>
    <xsl:text>style/.style={</xsl:text>
    <xsl:apply-templates select="." mode="tcb-style"/>
    <xsl:text>} }&#xa;</xsl:text>
    <!-- create and configure the environment/tcolorbox -->
    <xsl:text>\newtcolorbox</xsl:text>
    <!-- run on a common, default, faux counter -->
    <!-- <xsl:text>[</xsl:text> -->
    <!-- <xsl:text>use counter from=</xsl:text> -->
    <!-- <xsl:value-of select="$counter"/> -->
    <!-- <xsl:text>]</xsl:text> -->
    <!-- environment's tcolorbox name, pair -->
    <!-- with actual constructions in body  -->
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$environment-name"/>
    <xsl:text>}</xsl:text>
    <!-- number of arguments -->
    <xsl:choose>
        <xsl:when test="self::theorem or self::principle">
            <xsl:text>[4]</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>[3]</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <!-- begin: options -->
    <xsl:text>{</xsl:text>
    <!-- begin: title construction -->
    <!-- <xsl:text>title={{#1~\thetcbcounter</xsl:text> -->
    <xsl:text>title={{#1</xsl:text>
    <xsl:choose>
        <xsl:when test="self::theorem or self::principle">
            <!-- first space of double space -->
            <xsl:text>\notblank{#2#3}{\space}{}</xsl:text>
            <xsl:text>\notblank{#2}{\space#2}{}</xsl:text>
            <xsl:text>\notblank{#3}{\space(#3)}{}</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\notblank{#2}{\space\space#2}{}</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}}, </xsl:text>
    <!-- end: title construction -->
    <!-- label in argument 3 or argument 4 -->
    <xsl:choose>
        <xsl:when test="self::theorem or self::principle">
            <xsl:text>phantomlabel={#4}, </xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>phantomlabel={#3}, </xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <!-- always breakable -->
    <xsl:text>breakable, after={\par}, </xsl:text>
    <!-- italic body (this should be set elsewhere) -->
    <xsl:if test="self::theorem or self::principle">
        <xsl:text>fontupper=\itshape, </xsl:text>
    </xsl:if>
    <xsl:value-of select="$environment-name"/>
    <xsl:text>style, }&#xa;</xsl:text>
    <!-- end: options -->
</xsl:template>

<!-- ################## -->
<!-- Figures (Captions) -->
<!-- ################## -->

<!-- 2020-01-13: verbatim from pretext-latex, -->
<!-- EXCEPT automatic numbering is killed, ** -->
<!-- Removed or edited entities               -->
<xsl:template match="figure" mode="environment">
    <xsl:variable name="environment-name">
        <xsl:apply-templates select="." mode="environment-name"/>
    </xsl:variable>
    <xsl:text>%% </xsl:text>
    <!-- per-environment style -->
    <xsl:value-of select="$environment-name"/>
    <xsl:text>: 2-D display structure&#xa;</xsl:text>
    <xsl:text>\tcbset{ </xsl:text>
    <xsl:value-of select="$environment-name"/>
    <xsl:text>style/.style={</xsl:text>
    <xsl:apply-templates select="." mode="tcb-style"/>
    <xsl:text>} }&#xa;</xsl:text>
    <!-- create and configure the environment/tcolorbox -->
    <xsl:text>\newtcolorbox</xsl:text>
    <!-- environment's tcolorbox name, pair -->
    <!-- with actual constructions in body  -->
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$environment-name"/>
    <xsl:text>}</xsl:text>
    <!-- number of arguments -->
    <xsl:text>[3]</xsl:text>
    <!-- begin: options -->
    <xsl:text>{</xsl:text>
    <!-- begin: title/caption construction -->
    <xsl:text>lower separated=false, </xsl:text>
    <xsl:text>before lower={{</xsl:text>
    <xsl:text>\textbf{</xsl:text>
    <xsl:apply-templates select="." mode="type-name"/>
    <xsl:text>}</xsl:text>
    <xsl:text>~</xsl:text>
    <xsl:text>#1</xsl:text>
    <xsl:text>}}, </xsl:text>
    <!-- end: title/caption construction -->
    <!-- label in argument 2             -->
    <xsl:text>phantomlabel={#2}, </xsl:text>
    <!-- always unbreakable, except for "list"           -->
    <xsl:text>unbreakable, </xsl:text>
    <xsl:text>parbox=false, </xsl:text>
    <xsl:value-of select="$environment-name"/>
    <xsl:text>style, }&#xa;</xsl:text>
    <!-- end: options -->
</xsl:template>

<!-- Bold "Figure~" comes from environment/style         -->
<!-- Caption here adds bold acronym, then "real" caption -->
<xsl:template match="figure" mode="caption-full">
    <!-- <xsl:text>\textbf{</xsl:text> -->
    <xsl:apply-templates select="." mode="get-short-acro" />
    <!-- <xsl:text>}</xsl:text> -->
    <xsl:text>~</xsl:text>
    <xsl:apply-imports/>
</xsl:template>

<!-- ############# -->
<!-- Page Headings -->
<!-- ############# -->

<!-- Page headers + Chapter/Section XYZ Title      -->
<!-- \sethead[even-left][even-center][even-right]  -->
<!--         {odd-left}{odd-center}{odd-right}     -->
<xsl:template match="book" mode="titleps-headings">
    <xsl:text>{&#xa;</xsl:text>
    <xsl:text>\sethead[\thepage][][\textsl{\chaptertitle}]&#xa;</xsl:text>
    <xsl:text>{\textsl{\sectiontitle}}{}{\thepage}&#xa;</xsl:text>
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>


<!-- ######### -->
<!-- Divisions -->
<!-- ######### -->


<!-- Re-do the environment creation, to be starred -->
<!-- versions of a traditional LaTeX division      -->
<xsl:template match="chapter|appendix|section|subsection|exercises|reading-questions" mode="environment">
    <!-- all not auto-numbered -->
    <xsl:variable name="elt-name" select="local-name(.)"/>
    <!-- the (traditional) LaTex name of this division -->
    <xsl:variable name="div-name">
        <xsl:apply-templates select="." mode="division-name"/>
    </xsl:variable>
    <!-- explanatory string in preamble -->
    <xsl:text>%% Environment for a PTX "</xsl:text>
    <xsl:value-of select="$elt-name"/>
    <xsl:text>" at the level of a LaTeX "</xsl:text>
    <xsl:value-of select="$div-name"/>
    <xsl:text>"&#xa;</xsl:text>
    <!-- Define implementation of a 5-argument environment          -->
    <!-- Template ensures consistency of definition and application -->
    <xsl:text>\NewDocumentEnvironment{</xsl:text>
    <xsl:apply-templates select="." mode="division-environment-name"/>
    <xsl:text>}{mmmmm}&#xa;</xsl:text>
    <xsl:text>{%&#xa;</xsl:text>
    <!-- load 6 macros with values, for style writer use -->
    <xsl:text>\renewcommand{\divisionnameptx}{</xsl:text>
    <xsl:apply-templates select="." mode="type-name"/>
    <xsl:text>}%&#xa;</xsl:text>
    <xsl:text>\renewcommand{\titleptx}{#1}%&#xa;</xsl:text>
    <xsl:text>\renewcommand{\subtitleptx}{#2}%&#xa;</xsl:text>
    <xsl:text>\renewcommand{\shortitleptx}{#3}%&#xa;</xsl:text>
    <xsl:text>\renewcommand{\authorsptx}{#4}%&#xa;</xsl:text>
    <xsl:text>\renewcommand{\epigraphptx}{#5}%&#xa;</xsl:text>
    <!-- invoke the right LaTeX division, causes title format -->
    <!-- and spacing, along with setting running heads        -->
    <xsl:text>\</xsl:text>
    <xsl:value-of select="$div-name"/>
    <xsl:text>*</xsl:text>
    <xsl:text>{#1}%&#xa;</xsl:text>
    <!-- ToC line for divisions with titles -->
    <xsl:choose>
        <xsl:when test="self::chapter|self::appendix">
            <xsl:text>\addcontentsline{toc}{chapter}{#3}&#xa;</xsl:text>
        </xsl:when>
        <!-- Short title is blank for sections within large appendices -->
        <xsl:when test="self::section">
            <xsl:text>\notblank{#3}{\addcontentsline{toc}{section}{#3}}{}&#xa;</xsl:text>
        </xsl:when>
        <xsl:when test="self::subsection|self::exercises|self::reading-questions"/>
    </xsl:choose>
    <!-- explicitly set marks for titleps -->
    <xsl:choose>
        <xsl:when test="self::chapter|self::appendix">
            <xsl:text>\chaptermark{#1}%&#xa;</xsl:text>
        </xsl:when>
        <xsl:when test="self::section">
            <xsl:text>\sectionmark{#1}%&#xa;</xsl:text>
        </xsl:when>
    </xsl:choose>
    <!-- close the environment definition -->
    <xsl:text>}</xsl:text>
    <!-- add post-body finish, for primary division, a "section" -->
    <xsl:choose>
        <xsl:when test="self::section and not(parent::appendix)">
            <xsl:text>{\cleardoublepage}%&#xa;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>{}%&#xa;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Headings are marginally different, since we incorporate -->
<!-- the short acronym into the title for most divisions     -->
<xsl:template match="chapter|appendix|section|subsection|exercises|reading-questions" mode="latex-division-heading">
    <xsl:text>\begin{</xsl:text>
    <xsl:apply-templates select="." mode="division-environment-name" />
    <xsl:text>}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:if test="self::chapter|self::appendix|self::section|self::subsection">
        <xsl:apply-templates select="." mode="get-short-acro" />
        <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="." mode="title-full"/>
    <xsl:text>}</xsl:text>
    <xsl:text>{</xsl:text>
    <!-- no subtitle here -->
    <xsl:text>}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:choose>
        <xsl:when test="self::chapter|self::appendix">
            <xsl:apply-templates select="." mode="get-short-acro" />
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="." mode="title-simple"/>
        </xsl:when>
        <!-- Kill ToC line for sections within large appendices -->
        <xsl:when test="parent::appendix[title = 'Proof Techniques']"/>
        <xsl:when test="parent::appendix[title = 'Archetypes']"/>
        <!-- align section titles in ToC as they follow acronyms -->
        <!-- width of box is experimentally determined           -->
        <xsl:when test="self::section">
            <xsl:text>\makebox[3.5em][l]{</xsl:text>
            <xsl:apply-templates select="." mode="get-short-acro" />
            <xsl:text>}</xsl:text>
            <xsl:apply-templates select="." mode="title-simple"/>
        </xsl:when>
    </xsl:choose>
    <xsl:text>}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates select="author" mode="name-list"/>
    <xsl:text>}</xsl:text>
    <xsl:text>{</xsl:text>
    <!-- no epigraph here -->
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="." mode="label" />
    <xsl:text>&#xa;</xsl:text>
</xsl:template>

<!-- Footers are straightfoward -->
<xsl:template match="chapter|appendix|section|subsection|exercises|reading-questions" mode="latex-division-footing">
    <xsl:text>\end{</xsl:text>
    <xsl:apply-templates select="." mode="division-environment-name" />
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>

<!-- ############ -->
<!-- GFDL License -->
<!-- ############ -->

<!-- Mildly hackish, makes the legal bits have tiny print -->
<!-- Paragraph titles shrunk: \normalsize -> \small       -->
<!-- http://tex.stackexchange.com/questions/22576         -->
<xsl:template match="introduction[@xml:id='gfdl-introduction']">
    <xsl:text>{\tiny&#xa;</xsl:text>
    <xsl:text>\makeatletter&#xa;</xsl:text>
    <xsl:text>\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%&#xa;</xsl:text>
    <xsl:text>{3.25ex \@plus1ex \@minus.2ex}%&#xa;</xsl:text>
    <xsl:text>{-1em}%&#xa;</xsl:text>
    <xsl:text>{\normalfont\small\bfseries}}&#xa;</xsl:text>
    <xsl:text>\makeatother&#xa;</xsl:text>
    <xsl:apply-imports />
</xsl:template>

<xsl:template match="paragraphs[@xml:id='gfdl-addendum']">
    <xsl:apply-imports />
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>

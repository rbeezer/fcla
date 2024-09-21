<?xml version="1.0" encoding="UTF-8"?>

<!-- This file is part of the book                -->
<!--                                              -->
<!--      A First Course in Linear Algebra        -->
<!--                                              -->
<!-- Copyright (C) 2004-2017  Robert A. Beezer    -->
<!-- See the file COPYING for copying conditions. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Assumes current file is in mathbook/user, so it must be copied there -->
<!-- These are defined in matbook-common.xsl, so these are overrides      -->
<!-- Explanations are verbatim, from 2015/05/19                           -->

<!-- ################ -->
<!-- Names of Objects -->
<!-- ################ -->

<!-- We have a few non-standard objects for FCLA, -->
<!-- invented before general XML was designed     -->

<!-- NB: standard elements get renamed via facility in source's "docinfo" -->
<!-- "computation" becomes "Sage", and "li" becomes "Property"            -->

<!-- Rename two elements -->
<!-- We name/rename custom element via more intricate XSL, -->
<!-- this will need adjustment for any translation         -->
<xsl:template match="archetype" mode="type-name">
    <xsl:text>Archetype</xsl:text>
</xsl:template>
<xsl:template match="technique" mode="type-name">
    <xsl:text>Proof Technique</xsl:text>
</xsl:template>

<!-- Rename two "section" -->
<!-- These are "section" within appendices that    -->
<!-- we will cross-reference via specialized names -->
<xsl:template match="section[contains(@xml:id, 'archetype')]" mode="type-name">
    <xsl:text>Archetype</xsl:text>
</xsl:template>

<xsl:template match="section[contains(@xml:id, 'technique')]" mode="type-name">
    <xsl:text>Proof Technique</xsl:text>
</xsl:template>


<!-- ########################### -->
<!-- Numbering, Cross-References -->
<!-- ########################### -->

<!-- Every  xml:id  looks like  typename-acro  as a result    -->
<!-- of the automated conversion from historical source       -->
<!-- We extract the the base or "short" acronym from the very -->
<!-- end of the xml:id, ignoring qualifications by "section", -->
<!-- as used for subsections and exercises                    -->
<xsl:template match="*" mode="get-short-acro">
    <xsl:choose>
        <xsl:when test="not(@xml:id)">
            <xsl:text>[NOACRO]</xsl:text>
            <!-- DEBUG: remove this message but leave visually bad item above -->
            <xsl:message>Asking for acronym of an element (<xsl:value-of select="local-name(.)"/>) without an xml:id</xsl:message>
            <xsl:apply-templates select="." mode="location-report" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="substring-after-last">
                <xsl:with-param name="input" select="@xml:id" />
                <xsl:with-param name="substr" select="'-'" />
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- For acronyms typically prefixed by section acronyms  -->
<!-- in cross-references, we create "qualified" versions, -->
<!-- using periods as separators in what the reader sees, -->
<!-- since we use dashes in the actual  xml:id  so as to  -->
<!-- not confuse jQuery on the HTML side                  -->

<!-- A subsection is qualified by its section -->
<xsl:template match="subsection" mode="get-qualified-acro">
    <xsl:apply-templates select="parent::section" mode="get-short-acro" />
    <xsl:text>.</xsl:text>
    <xsl:apply-templates select="." mode="get-short-acro" />
</xsl:template>

<!-- An exercise always has a number attribute, one of  -->
<!-- RQn, Cn, Mn, Tn; and it always lives in a section. -->
<xsl:template match="exercise" mode="get-qualified-acro">
    <xsl:apply-templates select="ancestor::section" mode="get-short-acro" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="@number" />
</xsl:template>

<!-- An item in a two-level list has a qualified number          -->
<!-- So a list item of a reading question can become a knowl     -->
<!-- with a bad number/acronym.  Restricting acronyms to         -->
<!-- one-level description lists ("Properties") should avoid     -->
<!-- most problems of this nature, excepting following.          -->
<!-- Some dl/li will create bad acronymns in knowls for li       -->
<!-- Mostly: vector space definitions in VS (polys, etc) and     -->
<!-- the three parts of "similarity is an equivalence relation", -->
<!-- plus a two part list in a reading question with no xml:id   -->

<!-- "Numbering" is replaced by short acronyms        -->
<!-- Some items are unnumbered, etc, so we try not    -->
<!-- to upset those situations and only replace items -->
<!-- we know are present in FCLA and numbered         -->
<xsl:template match="chapter|appendix|section|subsection|exercises|reading-questions|theorem|definition|principle|example|computation|exercise|technique|figure|archetype|dl/li" mode="number">
    <xsl:apply-templates select="." mode="get-short-acro" />
</xsl:template>

<!-- For a cross-reference, LaTeX needs an override of  -->
<!-- its label/ref system and we also want to use the   -->
<!-- qualified versions for cross-references since they -->
<!-- are needed to make the visual identifiers unique.  -->
<!-- This is universal, even if it agrees with defaults -->
<!-- once numbers are redefined above                   -->
<xsl:template match="chapter|appendix|section|theorem|definition|principle|example|computation|technique|figure|archetype|dl/li" mode="xref-number">
    <xsl:apply-templates select="." mode="get-short-acro" />
</xsl:template>

<!-- FCLA subsections have duplicates (we could try to remove them?)          -->
<!-- Results of grep "<subsection ", isolate @acro, sort                      -->
<!-- D (2x), FS (2x), IVLT (2x), NM (2x), SC (2x), SI (2x), VR (2x), VSP (3x) -->
<!-- Investigate with, eg: grep -A 1 '<subsection xml:id=".*" acro="D"' *.xml -->
<!-- Rarely due to identical titles, ie duplicates are "accidental"           -->
<!-- FCLA exercises are similar, but no question about duplicates             -->
<xsl:template match="subsection|exercises|reading-questions|exercise" mode="xref-number">
    <xsl:apply-templates select="." mode="get-qualified-acro" />
</xsl:template>

<!-- ################# -->
<!-- Archetype Support -->
<!-- ################# -->

<!-- The Archetypes are not a standard MBX feature,  -->
<!-- but they do benefit from common, repeated text. -->
<!-- So we implement that with extra XML elements    -->
<!-- (collected in the "boilerplate" element) along  -->
<!-- with XSL to render that additional text         -->

<!-- An "archetype" is a container -->
<xsl:strip-space elements="archetype" />

<!-- NB: subsidary containers could be listed as well, -->
<!-- such as "systemdefn" if all extra whitespace is   -->
<!-- to be removed from the full Archetype listing.    -->
<!-- We only list the "*defn" and "*summary", since     -->
<!-- they will appear in the print version             -->
<xsl:strip-space elements="shortsummary summary systemdefn matrixdefn ltdefn" />

<!-- The "boilerplate" is killed as   -->
<!-- the Archetype appendix is parsed -->
<xsl:template match="boilerplate" />

<!-- A short summary may be used as a replacement, -->
<!-- but we elect to kill it in general            -->
<xsl:template match="archetype/shortsummary" />

<!-- Each archetype is a collection of facts, typically       -->
<!-- just the mathematics.  We provide a generic "title"      -->
<!-- and "lead-in" for each fact, common across all           -->
<!-- Archetypes, in the source.  This scheme rests on         -->
<!-- getting the "local-name()" of each fact and using        -->
<!-- that as the "key" into a collection of templates         -->
<!-- providing the generic information.  So it should         -->
<!-- suffice to describe an Archetype by just dropping        -->
<!-- in a fact, by name, whose content is 100% formatted,     -->
<!-- ready to go.                                             -->
<!--                                                          -->
<!-- To get output-specific formatting, the modal template    -->
<!-- "archetype-fact" supplies light formatting and wrapping. -->
<xsl:template match="archetype/*">
    <xsl:variable name="local" select="local-name(.)" />
    <xsl:apply-templates select="." mode="archetype-fact">
        <xsl:with-param name="title">
            <xsl:apply-templates select="../../../boilerplate/archetypetitle[@key=$local]" />
        </xsl:with-param>
        <xsl:with-param name="lead">
            <xsl:apply-templates select="../../../boilerplate/archetypelead[@key=$local]" />
        </xsl:with-param>
    </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>

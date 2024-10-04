<?xml version="1.0" encoding="UTF-8"?>

<!-- This file is part of the book                -->
<!--                                              -->
<!--      A First Course in Linear Algebra        -->
<!--                                              -->
<!-- Copyright (C) 2004-2017  Robert A. Beezer    -->
<!-- See the file COPYING for copying conditions. -->

<!-- FCLA customizations for HTML runs -->
<!-- 2024-10-04: this is Runestone-specific, and only -->
<!-- necessary because the CLI wants to locate extra  -->
<!-- XSL in a different location ("core").  Once this -->
<!-- changes (soon?) this particular extra XSL can be -->
<!-- removed.  Coordinate with HTML-only version.     -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Assumes current file is in mathbook/user, so it must be copied there -->
<xsl:import href="../xsl/pretext-html.xsl" />
<!-- Assumes next file can be found in mathbook/user, so it must be copied there -->
<xsl:import href="fcla-common.xsl" />

<!-- This is formatting for the title and     -->
<!-- lead-in for a "fact" within the write-up -->
<!-- of an Archetype.  This is the abstract   -->
<!-- template called by the generic template  -->
<!-- in fcla-common.xsl for an enclosing      -->
<!-- "archetype" element                      -->

<!-- #160 = Unicode "White Large Square"      -->
<!-- "copy-of" is key to making this work     -->
<!-- Facts have xrefs that open in knowls,    -->
<!-- the div gives them a close place to open -->
<xsl:template match="*" mode="archetype-fact">
    <xsl:param name="title" />
    <xsl:param name="lead" />
    <div>
      <xsl:text>&#x2b1c;&#160;&#160;</xsl:text>
      <b><xsl:copy-of select="$title" /></b>
      <xsl:text>&#160;&#160;</xsl:text>
      <xsl:copy-of select="$lead" />
      <xsl:text> </xsl:text>
      <xsl:apply-templates />
    </div>
</xsl:template>

</xsl:stylesheet>

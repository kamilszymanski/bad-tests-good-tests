<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
  <xsl:import href="/home/tomek/bin/asciidoc-8.6.5/docbook-xsl/fo.xsl"/>
  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>
    <!--
		         <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-->
    <fo:block>
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>
        <xsl:when test="$sequence = 'blank'">
          <!-- nothing -->
        </xsl:when>
        <xsl:when test="$position='left'">
          <!-- Same for odd, even, empty, and blank sequences -->
          <xsl:call-template name="draft.text"/>
        </xsl:when>
        <xsl:when test="($sequence='odd' or $sequence='even') and $position='center'">
          <!--
		<xsl:apply-templates select="." mode="titleabbrev.markup"/>
-->
          <xsl:apply-templates select="." mode="object.title.markup"/>
          <!--
		     <xsl:if test="$pageclass != 'titlepage'">
            <xsl:choose>
              <xsl:when test="ancestor::book and ($double.sided != 0)">
                <fo:retrieve-marker retrieve-class-name="section.head.marker" retrieve-position="first-including-carryover" retrieve-boundary="page-sequence"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="." mode="titleabbrev.markup"/>
              </xsl:otherwise>
            </xsl:choose>
	  </xsl:if>
-->
        </xsl:when>
        <xsl:when test="$position='center'">
          <!-- nothing for empty and blank sequences -->
        </xsl:when>
        <xsl:when test="$position='right'">
          <!-- Same for odd, even, empty, and blank sequences -->
          <xsl:call-template name="draft.text"/>
        </xsl:when>
        <xsl:when test="$sequence = 'first'">
          <!-- nothing for first pages -->
        </xsl:when>
        <xsl:when test="$sequence = 'blank'">
          <!-- nothing for blank pages -->
        </xsl:when>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  <xsl:param name="body.font.master">11</xsl:param>
  <!-- 1.2 section -->
  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.9"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <!-- 1.2.3 section -->
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.6"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <!-- 1.2.3.4 section -->
  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.36"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
    <!--
    <xsl:attribute name="border-top">0.5pt solid black</xsl:attribute>
    <xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0pt</xsl:attribute>
    <xsl:attribute name="space-before.optimum">0pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0pt</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0pt</xsl:attribute>
    <xsl:attribute name="space-before.precedence">force</xsl:attribute>
    <xsl:attribute name="space-after.precedence">force</xsl:attribute>
    <xsl:attribute name="padding-top">0pt</xsl:attribute>
    <xsl:attribute name="padding-top">0pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
-->
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level5.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level6.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>

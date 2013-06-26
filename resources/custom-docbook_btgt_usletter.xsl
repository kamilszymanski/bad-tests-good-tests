<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
  <xsl:import href="/home/tomek/bin/asciidoc-8.6.5/docbook-xsl/fo.xsl"/>
  <xsl:template name="front.cover">
    <xsl:call-template name="page.sequence">
      <xsl:with-param name="master-reference">my-titlepage</xsl:with-param>
      <xsl:with-param name="content">
        <fo:block text-align="center">
		<fo:external-graphic src="url(images/cover/cover_btgt_usletter.jpg)" content-height="11in"/>
        </fo:block>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="user.pagemasters">
    <!-- my title page -->
    <fo:simple-page-master master-name="my-titlepage" page-width="{$page.width}" page-height="{$page.height}" margin-top="0" margin-bottom="0" margin-left="0" margin-right="0">
      <xsl:if test="$axf.extensions != 0">
        <xsl:call-template name="axf-page-master-properties">
          <xsl:with-param name="page.master">my-titlepage</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <fo:region-body margin-bottom="{$body.margin.bottom}" margin-top="0" column-gap="{$column.gap.titlepage}" column-count="{$column.count.titlepage}">
</fo:region-body>
    </fo:simple-page-master>
    </xsl:template>
    
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

</xsl:stylesheet>

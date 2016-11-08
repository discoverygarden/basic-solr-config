<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:dc="http://purl.org/dc/elements/1.1/">

  <!-- Match QDC DS with arbitrary root node. -->
  <xsl:template match="foxml:datastream[@ID='QDC']/foxml:datastreamVersion[last()]">
    <xsl:param name="content"/>
    <xsl:param name="prefix">qdc_</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>
    <xsl:call-template name="slurp_qdc">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="slurp_qdc">
    <xsl:param name="content"/>
    <xsl:param name="prefix">qdc_</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>
    <xsl:for-each select="$content/*/*">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, local-name(), $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </field>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>

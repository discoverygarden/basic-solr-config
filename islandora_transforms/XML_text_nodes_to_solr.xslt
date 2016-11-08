<?xml version="1.0" encoding="UTF-8"?>
<!-- for all inline xml glob all the text nodes into one field-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml='info:fedora/fedora-system:def/foxml#'>
  <!-- have the template match whatever datastream needs this type of processing -->
  <xsl:template match="foxml:datastream[@ID='HOCR']/foxml:datastreamVersion[last()]" name="index_text_nodes_as_a_text_field">
    <xsl:param name="content"/>
    <xsl:param name="prefix">text_nodes_</xsl:param>
    <xsl:param name="suffix">_hlt</xsl:param>

    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($prefix, ../@ID , $suffix)"/>
      </xsl:attribute>
      <xsl:apply-templates select="$content" mode="index_text_nodes_as_a_text_field"/>
    </field>
  </xsl:template>

  <!-- Only output non-empty text nodes (followed by a single space) -->
  <xsl:template match="text()" mode="index_text_nodes_as_a_text_field">
    <xsl:variable name="text" select="normalize-space(.)"/>
    <xsl:if test="$text">
      <xsl:value-of select="$text"/>
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- datastream_ids -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
     exclude-result-prefixes="foxml">

  <xsl:template match="foxml:datastream" mode="index_object_datastreams">
    <field name="fedora_datastreams_ms">
      <xsl:value-of select="@ID"/>
    </field>
    <xsl:apply-templates mode="index_object_datastreams"/>
    <xsl:call-template name="fedora_datastream_version">
      <xsl:with-param name="version" select="foxml:datastreamVersion[last()]"/>
      <xsl:with-param name="fedora_datastream_latest"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="foxml:datastreamVersion">
    <xsl:call-template name="fedora_datastream_version"/>
  </xsl:template>

  <xsl:template name="fedora_datastream_version">
    <xsl:param name="version" select="."/>
    <xsl:param name="prefix">fedora_datastream</xsl:param>

    <xsl:variable name="id" select="$version/../@ID"/>
    <xsl:for-each select="$version/@*">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="$prefix"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="$id"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="local-name()"/>
          <xsl:text>_ms</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

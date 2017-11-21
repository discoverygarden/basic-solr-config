<?xml version="1.0" encoding="UTF-8"?>
<!-- JSON converted into XML -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#">
  <xsl:template match="foxml:datastream/foxml:datastreamVersion[last()][@MIMETYPE='application/json']" name="index_converted_json">
    <xsl:param name="content"/>
    <xsl:param name="prefix" select="concat('json_', ../@ID, '_')"/>
    <xsl:param name="suffix">ms</xsl:param>
    <xsl:param name="root_node">json</xsl:param>

    <xsl:apply-templates mode="index_converted_json" select="$content/*[local-name() = $root_node]">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--
       No-op on the root element of the doc; just need to pass the params
       along.
  -->
  <xsl:template match="/" mode="index_converted_json">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>

    <xsl:apply-templates mode="index_converted_json">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Build up the list prefix with the element context. -->
  <xsl:template match="*" mode="index_converted_json">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>

    <xsl:variable name="this_prefix" select="concat($prefix, local-name(), '_')"/>
    <xsl:variable name="textValue" select="normalize-space(text())"/>

    <xsl:if test="$textValue">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
    </xsl:if>

    <xsl:apply-templates mode="index_converted_json">
      <xsl:with-param name="prefix" select="$this_prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Avoid using text alone. -->
  <xsl:template match="text()" mode="index_converted_json"/>
</xsl:stylesheet>

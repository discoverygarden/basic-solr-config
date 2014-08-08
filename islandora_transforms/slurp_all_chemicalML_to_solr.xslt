<?xml version="1.0" encoding="UTF-8"?>
<!-- CML -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:cml="http://www.xml-cml.org/schema"
    exclude-result-prefixes="cml">
  <xsl:template match="foxml:datastream[@ID='CML']/foxml:datastreamVersion[last()]" name="index_CML">
    <xsl:param name="content"/>
    <xsl:param name="prefix">cml_</xsl:param>
    <xsl:param name="suffix">ms</xsl:param>

    <xsl:apply-templates mode="slurping_CML" select="$content//cml:molecule">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Build up the list prefix with the element context. -->
  <xsl:template match="*" mode="slurping_CML">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>

    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz_'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ '" />

    <xsl:variable name="this_prefix">
      <xsl:value-of select="concat($prefix, local-name(), '_')"/>
      <xsl:if test="@type">
        <xsl:value-of select="concat(@type, '_')"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="textValue">
      <xsl:value-of select="normalize-space(text())"/>
    </xsl:variable>

    <xsl:if test="$textValue">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
      <!-- Fields are duplicated for authority because searches across authorities are common. -->
      <xsl:if test="@authority">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($this_prefix, 'authority_', translate(@authority, $uppercase, $lowercase), '_', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$textValue"/>
        </field>
      </xsl:if>
    </xsl:if>

    <xsl:apply-templates mode="slurping_CML">
      <xsl:with-param name="prefix" select="$this_prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
    <xsl:if test="@authority">
      <xsl:apply-templates mode="slurping_CML">
        <xsl:with-param name="prefix" select="concat($this_prefix, 'authority_', translate(@authority, $uppercase, $lowercase), '_')"/>
        <xsl:with-param name="suffix" select="$suffix"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- Avoid using text alone. -->
  <xsl:template match="text()" mode="slurping_CML"/>

</xsl:stylesheet>

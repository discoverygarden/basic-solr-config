<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="ead">

    <xsl:template match="mods:relatedItem[@type='host' and @xlink:href and @xlink:role='islandora-manuscript-finding-aid']" mode="slurping_MODS">
      <xsl:variable name="xlink" select='@xlink:href'/>
      <xsl:variable name="pid" select='substring-before(substring-after($xlink, "/"), "/")'/>
      <xsl:variable name="ref" select='substring-after($xlink, "#")'/>
      <xsl:apply-templates select="document(concat($PROT, '://', encoder:encode($FEDORAUSER), ':', encoder:encode($FEDORAPASS), '@', $HOST, ':', $PORT, '/fedora/objects/', $pid, '/datastreams/EAD/content'))//ead:*[@id=$ref]" mode="dereffed_component"/>
    </xsl:template>

    <xsl:template match="ead:archdesc" mode="dereffed_component">
      <xsl:apply-templates select="*[not(self::ead:dsc)]" mode="dereffed_component_output">
        <xsl:with-param name="prefix" select="@level"/>
      </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ead:dsc" mode="dereffed_component">
      <xsl:apply-templates select=".." mode="dereffed_component"/>
    </xsl:template>

    <xsl:template match="ead:c | ead:c01 | ead:c02 | ead:c03 | ead:c04 | ead:c05" mode="dereffed_component">
      <xsl:apply-templates select=".." mode="dereffed_component"/>
      <xsl:apply-templates select="ead:did | ead:scopecontent" mode="dereffed_component_output">
        <xsl:with-param name="prefix" select="@level"/>
      </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ead:container" mode="dereffed_component_output"/>
    <xsl:template match="ead:did" mode="dereffed_component_output">
      <xsl:apply-templates mode="dereffed_component_output">
        <xsl:with-param name="prefix" select="../@level"/>
      </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ead:*[ead:p] | ead:*" mode="dereffed_component_output">
      <xsl:param name="prefix">unknown</xsl:param>

      <field>
        <xsl:attribute name="name">
          <xsl:text>dereffed_ead_</xsl:text>
          <xsl:value-of select="$prefix"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="local-name()"/>
          <xsl:text>_ms</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:template>
    <xsl:template match="text()" mode="deref_component"/>
    <xsl:template match="text()" mode="dereffed_component"/>
    <xsl:template match="text()" mode="dereffed_component_output"/>
</xsl:stylesheet>

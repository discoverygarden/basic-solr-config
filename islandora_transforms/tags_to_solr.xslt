<?xml version="1.0" encoding="UTF-8"?>
<!-- tags -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
     exclude-result-prefixes="foxml">

    <xsl:template match="foxml:datastream[@ID='TAGS']/foxml:datastreamVersion[last()]" name='index_tags'>
        <xsl:param name="content"/>

      <xsl:for-each select="$content//tag">
        <field>
          <xsl:attribute name="name">tag</xsl:attribute>
          <xsl:value-of select="text()"/>
        </field>
        <field>
          <xsl:attribute name="name">tagUser</xsl:attribute>
          <xsl:value-of select="@creator"/>
        </field>
      </xsl:for-each>
      
    </xsl:template>
 
</xsl:stylesheet>
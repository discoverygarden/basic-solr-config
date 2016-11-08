<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
  xmlns:dc="http://purl.org/dc/elements/1.1/">

  <xsl:template match="foxml:datastream[@ID='DC' or @ID='QDC']/foxml:datastreamVersion[last()]">
    <xsl:param name="content"/>
    <xsl:param name="prefix">dc.</xsl:param>
    <xsl:param name="suffix"></xsl:param>
    <xsl:apply-templates select="$content/oai_dc:dc">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="oai_dc:dc">
    <xsl:param name="prefix">dc.</xsl:param>
    <xsl:param name="suffix"></xsl:param>
    <!-- Create fields for the set of selected elements, named according to the 'local-name' and containing the 'text' -->
    <xsl:for-each select="./*">

      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, local-name(), $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </field>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>

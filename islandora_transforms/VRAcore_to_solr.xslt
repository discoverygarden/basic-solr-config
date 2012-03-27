<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: demoFoxmlToLucene.xslt 5734 2006-11-28 11:20:15Z gertsp $ -->
<!-- BASIC VRACORE -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:vra="http://www.vraweb.org/vracore4.htm">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="vra:vra" name="index_vra">
        <xsl:param name="content"/>
    <xsl:param name="prefix">vra_</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>

    <xsl:for-each select="./vra:vra/vra:work/vra:inscriptionSet/vra:inscription/vra:text[@type='signature']">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, 'inscription_signature', $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </field>
    </xsl:for-each>

    <xsl:for-each select="./vra:vra/vra:work/vra:inscriptionSet/vra:inscription/vra:text[@type='mark']">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, 'inscription_mark', $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </field>
    </xsl:for-each>

    <xsl:for-each select="./vra:vra/vra:work/vra:inscriptionSet/vra:inscription/vra:text[@type='text']">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, 'inscription_text', $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </field>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

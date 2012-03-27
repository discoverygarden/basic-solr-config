<?xml version="1.0" encoding="UTF-8"?>
<!-- for all inline xml glob all the text nodes into one field-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
  <xsl:template match="*" name="index_text_nodes_as_one_text_field">
        <xsl:param name="content"/>
    <xsl:param name="datastream">datastream_not_passed_</xsl:param>
    <xsl:param name="prefix">text_nodes_</xsl:param>
    <xsl:param name="suffix">_t</xsl:param>

    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($datastream, $prefix, local-name(), $suffix)"/>
      </xsl:attribute>
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  -->
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<!-- datastream_ids 
@todo: get the mime type into a field:

                    <xsl:variable name="name" select="translate(@ID, $irregular, $normalized)"></xsl:variable>

                    <xsl:call-template name="field">
                        <xsl:with-param name="prefix">dsm.</xsl:with-param>
                        <xsl:with-param name="name" select="concat($name, '_', 'created')"></xsl:with-param>
                        <xsl:with-param name="value" select="foxml:datastreamVersion[last()]/@CREATED"></xsl:with-param>
                    </xsl:call-template>

-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
     exclude-result-prefixes="foxml">
  
  <xsl:template match="/foxml:digitalObject" mode="index_object_datastreams">
        <!-- records that there is a datastream -->
      <xsl:for-each select="foxml:datastream">
        <field name="fedora_datastreams_ms">
            <xsl:value-of select="@ID"/>
        </field>
      </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
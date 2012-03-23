<?xml version="1.0" encoding="UTF-8"?>
<!-- TEI -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
     exclude-result-prefixes="tei foxml">

<xsl:template match="foxml:datastream[@ID='TEI']/foxml:datastreamVersion[last()]/foxml:xmlContent" name="index_tei">

    <xsl:variable name="TEI"
    select="document(concat($PROT, '://', $FEDORAUSERNAME, ':', $FEDORAPASSWORD, '@', $HOST, ':', $PORT, '/fedora/objects/', $PID, '/datastreams/', 'TEI', '/content'))" />
    
    <!-- surname -->
    <xsl:for-each select="$TEI//tei:surname[text()]">
    <field>
    <xsl:attribute name="name">
                <xsl:value-of select="concat('tei_', 'surname_s')" />
                </xsl:attribute>
    <xsl:value-of select="normalize-space(text())" />
    </field>
    </xsl:for-each>
    
    <!-- place name -->
    <xsl:for-each select="$TEI//tei:placeName/*[text()]">
    <field>
    <xsl:attribute name="name">
                <xsl:value-of select="concat('tei_', 'placeName_s')" />
              </xsl:attribute>
    <xsl:value-of select="normalize-space(text())" />
    </field>
    </xsl:for-each>
    
    
    <!-- organization name -->
    <xsl:for-each select="$TEI//tei:orgName[text()]">
    <field>
    <xsl:attribute name="name">
              <xsl:value-of select="concat('tei_', 'orgName_s')" />
            </xsl:attribute>
    <xsl:value-of select="normalize-space(text())" />
    </field>
    </xsl:for-each>

   </xsl:template>
   
   </xsl:stylesheet>
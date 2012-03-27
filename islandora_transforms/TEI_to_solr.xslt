<?xml version="1.0" encoding="UTF-8"?>
<!-- TEI -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
     exclude-result-prefixes="tei foxml">

	<xsl:template match="foxml:datastream[@ID='TEI']/foxml:datastreamVersion[last()]" name="index_TEI">
	    <xsl:param name="content"/>
	    <xsl:param name="prefix">TEI_</xsl:param>
	    <xsl:param name="suffix">_ms</xsl:param>
	    
	    <!-- surname -->
	    <xsl:for-each select="$content//tei:surname[text()]">
		    <field>
			    <xsl:attribute name="name">
	                <xsl:value-of select="concat($prefix, 'surname', $suffix)" />
	            </xsl:attribute>
			    <xsl:value-of select="normalize-space(text())" />
		    </field>
	    </xsl:for-each>
	    
	    <!-- place name -->
	    <xsl:for-each select="$content//tei:placeName/*[text()]">
		    <field>
			    <xsl:attribute name="name">
	                <xsl:value-of select="concat($prefix, 'placeName', $suffix)" />
	            </xsl:attribute>
			    <xsl:value-of select="normalize-space(text())" />
		    </field>
	    </xsl:for-each>
	    
	    
	    <!-- organization name -->
	    <xsl:for-each select="$content//tei:orgName[text()]">
		    <field>
			    <xsl:attribute name="name">
	                <xsl:value-of select="concat($prefix, 'orgName', $suffix)" />
	            </xsl:attribute>
			    <xsl:value-of select="normalize-space(text())" />
		    </field>
	    </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>
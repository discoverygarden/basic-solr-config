<?xml version="1.0" encoding="UTF-8"?>
<!-- Basic WORKFLOW -->
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:foxml="info:fedora/fedora-system:def/foxml#">
    <xsl:template  match="foxml:datastream[@ID='WORKFLOW']/foxml:datastreamVersion[last()]" name="index_WORKFLOW">
        <xsl:param name="content"/>
        <xsl:param name="prefix">workflow_</xsl:param>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:for-each select="$content//cwrc/workflow//*">
            <xsl:if test="text() [normalize-space(.) ]">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix,local-name(),$suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="text()"/>
                </field>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$content//cwrc/workflow/activity/@*">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix,'activity_',local-name(),$suffix)"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </field>
        </xsl:for-each>
        <xsl:for-each select="$content//cwrc/workflow/assigned/@*">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix,'assigned_',local-name(),$suffix)"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </field>
        </xsl:for-each>
        <xsl:for-each select="$content//cwrc/workflow/@*">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix,local-name(),$suffix)"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </field>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

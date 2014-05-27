<?xml version="1.0" encoding="UTF-8"?>
<!-- RELS-EXT -->
<xsl:stylesheet version="1.0"
    xmlns:java="http://xml.apache.org/xalan/java"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:foxml="info:fedora/fedora-system:def/foxml#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="rdf java">

    <xsl:variable name="single_valued_hashset_for_rels_ext" select="java:java.util.HashSet.new()"/>
    <xsl:template match="foxml:datastream[@ID='RELS-EXT']/foxml:datastreamVersion[last()]"
        name="index_RELS-EXT">
        <xsl:param name="content"/>
        <xsl:param name="prefix">RELS_EXT_</xsl:param>
        <xsl:param name="suffix">_ms</xsl:param>

        <xsl:for-each
            select="$content//rdf:Description/*[@rdf:resource] | $content//rdf:description/*[@rdf:resource]">
            <!-- Prevent multiple generating multiple instances of single-valued fields
            by tracking things in a HashSet -->
            <!-- The method java.util.HashSet.add will return false when the value is
            already in the set. -->
            <xsl:choose>
                <xsl:when
                    test="java:add($single_valued_hashset_for_rels_ext, concat($prefix, local-name(), '_uri_s'))">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, local-name(), '_uri_s')"/>
                        </xsl:attribute>
                        <xsl:value-of select="@rdf:resource"/>
                    </field>
                    <xsl:if test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#int'">
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of select="concat($prefix, local-name(), '_uri_l')"/>
                            </xsl:attribute>
                            <xsl:value-of select="@rdf:resource"/>
                        </field>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, local-name(), '_uri', $suffix)"/>
                        </xsl:attribute>
                        <xsl:value-of select="@rdf:resource"/>
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each
            select="$content//rdf:Description/*[not(@rdf:resource)][normalize-space(text())] | $content//rdf:description/*[not(@rdf:resource)][normalize-space(text())]">
            <!-- Prevent multiple generating multiple instances of single-valued fields
            by tracking things in a HashSet -->
            <!-- The method java.util.HashSet.add will return false when the value is
            already in the set. -->
            <xsl:choose>
                <xsl:when
                    test="java:add($single_valued_hashset_for_rels_ext, concat($prefix, local-name(), '_literal_s'))">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, local-name(), '_literal_s')"/>
                        </xsl:attribute>
                        <xsl:value-of select="text()"/>
                    </field>
                    <xsl:if test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#int'">
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of select="concat($prefix, local-name(), '_literal_l')"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </field>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of
                                select="concat($prefix, local-name(), '_literal', $suffix)"/>
                        </xsl:attribute>
                        <xsl:value-of select="text()"/>
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

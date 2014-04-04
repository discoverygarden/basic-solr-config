<?xml version="1.0" encoding="UTF-8"?>
<!-- Basic WORKFLOW -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:foxml="info:fedora/fedora-system:def/foxml#">
    <xsl:template match="foxml:datastream[@ID='WORKFLOW']/foxml:datastreamVersion[last()]"
        name="index_WORKFLOW">
        <xsl:param name="content"/>
        <xsl:param name="prefix">workflow_</xsl:param>
        <xsl:param name="suffix">_ms</xsl:param>
        <xsl:variable name="superceded" select="'_superceded'"/>
        <xsl:variable name="current" select="'_current'"/>
        <xsl:variable name="newest">
            <xsl:for-each select="$content//cwrc/workflow/@workflowID">
                <xsl:sort data-type="text" order="descending"/>
                <xsl:if test="position()=1">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:for-each select="$content//cwrc/workflow/*">
            <xsl:if test="text() [normalize-space(.) ]">
                <xsl:choose>
                    <xsl:when test="./@workflowID=$newest">
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of
                                    select="concat($prefix,local-name(),$current, $suffix)"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </field>
                    </xsl:when>
                    <xsl:otherwise>
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of
                                    select="concat($prefix,local-name(),$superceded, $suffix)"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </field>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="$content//cwrc/workflow/activity/@*">
            <xsl:choose>
                <xsl:when test="../../@workflowID=$newest">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of
                                select="concat($prefix,'activity_',local-name(), $current, $suffix)"
                            />
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>
                </xsl:when>
                <xsl:otherwise>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of
                                select="concat($prefix,'activity_',local-name(), $superceded, $suffix)"
                            />
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$content//cwrc/workflow/assigned/@*">

            <xsl:choose>
                <xsl:when test="../../@workflowID=$newest">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of
                                select="concat($prefix,'assigned_',local-name(), $current, $suffix)"
                            />
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>
                </xsl:when>
                <xsl:otherwise>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of
                                select="concat($prefix,'assigned_',local-name(), $superceded, $suffix)"
                            />
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

        <xsl:for-each select="$content//cwrc/workflow/@*">
            <xsl:choose>
                <xsl:when test="../@workflowID=$newest">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix,local-name(), $current, $suffix)"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>
                </xsl:when>
                <xsl:otherwise>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of
                                select="concat($prefix,local-name(), $superceded, $suffix)"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

        <xsl:for-each select="$content//cwrc/workflow/*/note">
            <xsl:if test="text() [normalize-space(.) ]">
                <xsl:choose>
                    <xsl:when test="../../@workflowID=$newest">
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of
                                    select="concat($prefix, name(..), '_', name(.), $current, $suffix)"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </field>
                    </xsl:when>
                    <xsl:otherwise>
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of
                                    select="concat($prefix, name(../..), '_', name(.), $superceded, $suffix)"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </field>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$content//cwrc/workflow/*/message/*">
            <xsl:if test="text() [normalize-space(.) ]">
                <xsl:choose>
                    <xsl:when test="../../../@workflowID=$newest">
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of
                                    select="concat($prefix, name(../..), '_', name(.), $current, $suffix)"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </field>
                    </xsl:when>
                    <xsl:otherwise>
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of
                                    select="concat($prefix, name(../..), '_', name(.), $superceded, $suffix)"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </field>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$content//cwrc/workflow/*/message/recipient/@*">
            <xsl:choose>
                <xsl:when test="../../../../@workflowID=$newest">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of
                                select="concat($prefix, name(../../..), '_', 'recipient', $current, $suffix)"
                            />
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>
                </xsl:when>
                <xsl:otherwise>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of
                                select="concat($prefix, name(../../..), '_', 'recipient', $superceded, $suffix)"
                            />
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

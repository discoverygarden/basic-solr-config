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

        <!-- Clearing hash in case the template is ran more than once. -->
        <xsl:variable name="return_from_clear" select="java:clear($single_valued_hashset_for_rels_ext)"/>

        <xsl:apply-templates select="$content//rdf:Description/* | $content//rdf:description/*" mode="rels_ext_element">
          <xsl:with-param name="prefix" select="$prefix"/>
          <xsl:with-param name="suffix" select="$suffix"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- Match elements, call underlying template. -->
    <xsl:template match="*[@rdf:resource]" mode="rels_ext_element">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>

      <xsl:call-template name="rels_ext_fields">
        <xsl:with-param name="prefix" select="$prefix"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="type">uri</xsl:with-param>
        <xsl:with-param name="value" select="@rdf:resource"/>
      </xsl:call-template>
    </xsl:template>
    <xsl:template match="*[normalize-space(.)]" mode="rels_ext_element">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>

      <xsl:call-template name="rels_ext_fields">
        <xsl:with-param name="prefix" select="$prefix"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="type">literal</xsl:with-param>
        <xsl:with-param name="value" select="text()"/>
      </xsl:call-template>
    </xsl:template>

    <!-- Fork between fields without and with the namespace URI in the field
      name. -->
    <xsl:template name="rels_ext_fields">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>
      <xsl:param name="type"/>
      <xsl:param name="value"/>

      <xsl:call-template name="rels_ext_field">
        <xsl:with-param name="prefix" select="$prefix"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="value" select="$value"/>
      </xsl:call-template>
      <xsl:call-template name="rels_ext_field">
        <xsl:with-param name="prefix" select="concat($prefix, namespace-uri())"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="value" select="$value"/>
      </xsl:call-template>
    </xsl:template>

    <!-- Actually create a field. -->
    <xsl:template name="rels_ext_field">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>
      <xsl:param name="type"/>
      <xsl:param name="value"/>

      <!-- Prevent multiple generating multiple instances of single-valued fields
      by tracking things in a HashSet -->
      <!-- The method java.util.HashSet.add will return false when the value is
      already in the set. -->
      <xsl:choose>
        <xsl:when
          test="java:add($single_valued_hashset_for_rels_ext, concat($prefix, local-name(), '_', $type, '_s'))">
          <field>
            <xsl:attribute name="name">
              <xsl:value-of select="concat($prefix, local-name(), '_', $type, '_s')"/>
            </xsl:attribute>
            <xsl:value-of select="$value"/>
          </field>
          <xsl:choose>
            <xsl:when test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#int'">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="concat($prefix, local-name(), '_', $type, '_l')"/>
                </xsl:attribute>
                <xsl:value-of select="$value"/>
              </field>
            </xsl:when>
            <xsl:when test="floor($value) = $value">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="concat($prefix, local-name(), '_', $type, '_intDerivedFromString_l')"/>
                </xsl:attribute>
                <xsl:value-of select="$value"/>
              </field>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <field>
            <xsl:attribute name="name">
              <xsl:value-of select="concat($prefix, local-name(), '_', $type, $suffix)"/>
            </xsl:attribute>
            <xsl:value-of select="$value"/>
          </field>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:string="xalan://java.lang.String"
    exclude-result-prefixes="ead string">

    <xsl:template match="mods:relatedItem[@type='host' and @xlink:href and @xlink:role='islandora-manuscript-finding-aid']" mode="slurping_MODS">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>
      <xsl:param name="pid">not provided</xsl:param>
      <xsl:param name="datastream">not provided</xsl:param>

      <!-- Kick off our dereferencing from the EAD -->
      <xsl:variable name="xlink" select='@xlink:href'/>
      <xsl:variable name="finding_aid_pid" select='substring-before(substring-after($xlink, "/"), "/")'/>
      <xsl:variable name="ref" select='substring-after($xlink, "#")'/>
      <xsl:apply-templates select="document(concat($PROT, '://', encoder:encode($FEDORAUSER), ':', encoder:encode($FEDORAPASS), '@', $HOST, ':', $PORT, '/fedora/objects/', $finding_aid_pid, '/datastreams/EAD/content'))//ead:*[@id=$ref]" mode="dereffed_component"/>

      <!-- Continue with the normal slurp process -->
      <xsl:apply-templates mode="slurping_MODS">
        <xsl:with-param name="prefix">
          <xsl:value-of select="concat($prefix, local-name(), '_')"/>
          <xsl:if test="@type">
            <xsl:value-of select="concat(@type, '_')"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="pid" select="$pid"/>
        <xsl:with-param name="datastream" select="$datastream"/>
      </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="mods:relatedItem[@type='host' and @xlink:href and @xlink:role='islandora-manuscript-finding-aid']/mods:part/mods:detail[@type]" mode="slurping_MODS">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>
      <xsl:param name="pid">not provided</xsl:param>
      <xsl:param name="datastream">not provided</xsl:param>
      <xsl:apply-templates mode="slurping_MODS">
        <xsl:with-param name="prefix">
          <xsl:value-of select="concat($prefix, local-name(), '_')"/>
          <!--
            Minor normalization for type attribute... "Box", "Boxes", "box",
            "boxes", "Folder", "Folders", "folder" and "folders" are possible.

            Here, we normalize to singular and lowercase ("box"  or "folder",
            respectively).
          -->
          <xsl:variable name="type" select="string:toLowerCase(string(@type))"/>
          <xsl:choose>
            <xsl:when test="starts-with($type, 'box')">
              <xsl:text>box_</xsl:text>
            </xsl:when>
            <xsl:when test="starts-with($type, 'folder')">
              <xsl:text>folder_</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(@type, '_')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="pid" select="$pid"/>
        <xsl:with-param name="datastream" select="$datastream"/>
      </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ead:archdesc" mode="dereffed_component">
      <xsl:apply-templates select="*[not(self::ead:dsc)]" mode="dereffed_component_output">
        <xsl:with-param name="prefix" select="@level"/>
      </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ead:dsc" mode="dereffed_component">
      <xsl:apply-templates select=".." mode="dereffed_component"/>
    </xsl:template>

    <xsl:template match="ead:c | ead:c01 | ead:c02 | ead:c03 | ead:c04 | ead:c05" mode="dereffed_component">
      <xsl:apply-templates select=".." mode="dereffed_component"/>
      <xsl:if test="@id">
        <field name="dereffed_ead_component_id_ms">
          <xsl:value-of select="@id"/>
        </field>
      </xsl:if>
      <xsl:apply-templates select="ead:did | ead:scopecontent" mode="dereffed_component_output">
        <xsl:with-param name="prefix" select="@level"/>
      </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ead:container" mode="dereffed_component_output"/>

    <xsl:template match="ead:did" mode="dereffed_component_output">
      <xsl:apply-templates mode="dereffed_component_output">
        <xsl:with-param name="prefix" select="../@level"/>
      </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="ead:*[ead:p] | ead:*" mode="dereffed_component_output">
      <xsl:param name="prefix">unknown</xsl:param>

      <field>
        <xsl:attribute name="name">
          <xsl:text>dereffed_ead_</xsl:text>
          <xsl:value-of select="$prefix"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="local-name()"/>
          <xsl:text>_ms</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:template>
    <xsl:template match="text()" mode="deref_component"/>
    <xsl:template match="text()" mode="dereffed_component"/>
    <xsl:template match="text()" mode="dereffed_component_output"/>
</xsl:stylesheet>

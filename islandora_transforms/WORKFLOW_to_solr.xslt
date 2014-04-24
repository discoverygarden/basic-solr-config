<xsl:stylesheet version="1.0" xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Match Workflow Datastream -->
  <!-- Uncomment this line if this ntemplate is not included anywhere else on your site - it cannot be declared twice.
 </xsl:stylesheet>  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/library/xslt-date-template.xslt"/>
  -->
  <xsl:template match="foxml:datastream[@ID='WORKFLOW']/foxml:datastreamVersion[last()]" name="index_WORKFLOW">
    <xsl:param name="content"/>
    <xsl:param name="newest"/>
    <xsl:param name="prefix"/>
    <xsl:param name="suffix">ms</xsl:param>
    <xsl:for-each select="$content//cwrc/workflow">
      <xsl:apply-templates mode="slurping_WORKFLOW" select=".">
        <xsl:with-param name="prefix" select="$prefix"/>
        <xsl:with-param name="suffix">
          <xsl:choose>
            <xsl:when test="position() = last()">
              <xsl:value-of select="concat('current_', $suffix)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('superceded_', $suffix)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="date_suffix">
          <xsl:choose>
            <xsl:when test="position() = last()">
              <xsl:value-of select="concat('current_', 'dt')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('superceded_', $suffix)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>
  <!-- Build up the list prefix with the element / attribute context. -->
  <xsl:template match="*" mode="slurping_WORKFLOW">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:param name="date_suffix"/>
    <xsl:variable name="this_prefix" select="concat($prefix, local-name(), '_')"/>
    <!-- Index Attributes -->
    <xsl:for-each select="@*">
      <xsl:choose>
        <xsl:when test="name()='date'">
          <!--  modify date -->

          <xsl:variable name="textValue">
            <xsl:call-template name="get_ISO8601_date">
              <xsl:with-param name='date' select="concat(., 'T',ancestor::node()/@time)" />
              <xsl:with-param name="pid" select="'not provided'"/>
              <xsl:with-param name="datastream" select="'not provided'"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:call-template name="indexField">
            <xsl:with-param name="name" select="concat($this_prefix, local-name(), '_', $date_suffix)"/>
            <xsl:with-param name="value" select="$textValue"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="indexField">
            <xsl:with-param name="name" select="concat($this_prefix, local-name(), '_', $suffix)"/>
            <xsl:with-param name="value" select="."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <!-- Index Text Value if Found -->
    <xsl:if test="normalize-space(text())">
      <xsl:call-template name="indexField">
        <xsl:with-param name="name" select="concat($this_prefix, $suffix)"/>
        <xsl:with-param name="value" select="normalize-space(text())"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates mode="slurping_WORKFLOW">
      <xsl:with-param name="prefix" select="$this_prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- Index the given field name and value -->
  <xsl:template name="indexField">
    <xsl:param name="name"/>
    <xsl:param name="value"/>
    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="$name"/>
      </xsl:attribute>
      <xsl:value-of select="$value"/>
    </field>
  </xsl:template>
  <!-- Avoid using text alone. -->
  <xsl:template match="text()" mode="slurping_WORKFLOW"/>
</xsl:stylesheet>
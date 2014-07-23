<?xml version="1.0" encoding="UTF-8"?>
  <!-- Basic EAC-CPF -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:eaccpf="urn:isbn:1-931666-33-4"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:java="http://xml.apache.org/xalan/java"
  xmlns:xlink="http://www.w3.org/1999/xlink">

  <!-- HashSet to track single-valued fields. -->
  <xsl:variable name="eaccpf_single_valued_hashset" select="java:java.util.HashSet.new()"/>

  <xsl:template match="foxml:datastream[@ID='EAC-CPF']/foxml:datastreamVersion[last()]" name="index_EAC-CPF">
    <xsl:param name="content"/>
	<xsl:param name="prefix">eaccpf_</xsl:param>
	<xsl:param name="suffix">et</xsl:param> <!-- 'edged' (edge n-gram) text, for auto-completion -->

    <!--
      Add in an extra parser, as we've encountered some odd values in the wild...
      both a +/- offset /and/ "Z"...  Weird stuff.
    -->
    <xsl:variable name="date_format">y-M-d'T'H:m:sZ'Z'</xsl:variable>
    <xsl:value-of select="java:ca.discoverygarden.gsearch_extensions.JodaAdapter.addDateParser($date_format)"/>

    <xsl:apply-templates select="$content//eaccpf:eac-cpf/*" mode="slurp_EACCPF">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>

    <!-- Drop our parser. -->
    <xsl:value-of select="java:ca.discoverygarden.gsearch_extensions.JodaAdapter.resetParsers()"/>
  </xsl:template>

  <xsl:template match="text()" mode="slurp_EACCPF"/>

  <xsl:template match="eaccpf:*" mode="slurp_EACCPF">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>

    <xsl:variable name="this_prefix">
      <xsl:value-of select="concat($prefix, local-name(),  '_')"/>
      <xsl:for-each select="@*[not(namespace-uri())]">
        <xsl:sort select="name()"/>
        <xsl:value-of select="concat(local-name(), '_')"/>
        <xsl:value-of select="concat(., '_')"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="textValue" select="normalize-space(text())"/>

    <xsl:if test="$textValue">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="$this_prefix"/>
          <xsl:choose>
            <xsl:when test="java:add($eaccpf_single_valued_hashset, concat($this_prefix, 's'))">s</xsl:when>
            <xsl:otherwise>ms</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
    </xsl:if>

    <xsl:apply-templates mode="slurp_EACCPF">
	  <xsl:with-param name="prefix" select="$this_prefix"/>
	  <xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>
  </xsl:template>

  <xsl:template match="eaccpf:cpfDescription/eaccpf:identity" mode="slurp_EACCPF">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
	<xsl:variable name="name_prefix">eaccpf_name_</xsl:variable>
	<!-- ensure that the primary is first -->
	<xsl:apply-templates select=".//eaccpf:nameEntry[@localType='primary']">
	  <xsl:with-param name="prefix" select="$name_prefix"/>
	  <xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>

	<!-- place alternates (non-primaries) later -->
	<xsl:apply-templates select=".//eaccpf:nameEntry[not(@localType='primary')]">
	  <xsl:with-param name="prefix" select="$name_prefix"/>
	  <xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>

    <xsl:variable name="this_prefix">
      <xsl:value-of select="concat($prefix, local-name(),  '_')"/>
      <xsl:for-each select="@*[not(namespace-uri())]">
        <xsl:sort select="name()"/>
        <xsl:value-of select="concat(local-name(), '_')"/>
        <xsl:value-of select="concat(., '_')"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="textValue" select="normalize-space(text())"/>

    <xsl:if test="$textValue">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
    </xsl:if>

    <xsl:apply-templates mode="slurp_EACCPF">
	  <xsl:with-param name="prefix" select="concat($prefix, local-name(), '_')"/>
	  <xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>
  </xsl:template>

  <xsl:template match="eaccpf:fromDate | eaccpf:toDate | eaccpf:eventDateTime" mode="slurp_EACCPF">
    <xsl:param name="prefix"/>
    <xsl:variable name="suffix">mdt</xsl:variable>

    <xsl:variable name="value">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="normalize-space(text())"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="normalize-space($value)">
      <xsl:variable name="this_prefix">
        <xsl:value-of select="concat($prefix, local-name(),  '_')"/>
        <xsl:for-each select="@*[not(namespace-uri())]">
          <xsl:sort select="name()"/>
          <xsl:value-of select="concat(local-name(), '_')"/>
          <xsl:value-of select="concat(., '_')"/>
        </xsl:for-each>
      </xsl:variable>
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="$this_prefix"/>
          <xsl:choose>
            <xsl:when test="java:add($eaccpf_single_valued_hashset, concat($this_prefix, 'dt'))">dt</xsl:when>
            <xsl:otherwise>mdt</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="$value"/>
      </field>
    </xsl:if>
  </xsl:template>

   <xsl:template match="eaccpf:nameEntry">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>

    <xsl:if test="@localType='variant'">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, 'all_variant_parts_', $suffix)"/>
        </xsl:attribute>
        <xsl:copy-of select="eaccpf:part/text()"/>
      </field>
    </xsl:if>

    <!-- fore/first name -->
    <xsl:for-each select="eaccpf:part[@localType='forename']">
	    <field>
	      <xsl:attribute name="name">
	        <xsl:value-of select="concat($prefix, 'given_', $suffix)"/>
	      </xsl:attribute>
	      <xsl:choose>
	        <xsl:when test="eaccpf:part[@localType='middle']">
	          <xsl:value-of select="normalize-space(concat(../eaccpf:part[@localType='forename'], ' ', ../eaccpf:part[@localType='middle']))"/>
	        </xsl:when>
	        <xsl:otherwise>
	          <xsl:value-of select="normalize-space(../eaccpf:part[@localType='forename'])"/>
	        </xsl:otherwise>
	      </xsl:choose>
	    </field>
    </xsl:for-each>

    <!-- sur/last name -->
    <xsl:for-each select="eaccpf:part[@localType='surname']">
	    <field>
	      <xsl:attribute name="name">
	        <xsl:value-of select="concat($prefix, 'family_', $suffix)"/>
	      </xsl:attribute>
	      <xsl:value-of select="normalize-space(../eaccpf:part[@localType='surname'])"/>
	    </field>
    </xsl:for-each>

    <!-- id -->
    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($prefix, 'id_', $suffix)"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="concat($PID, '/', @id)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($PID,'/name_position:', position())"/>
        </xsl:otherwise>
      </xsl:choose>
    </field>

    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($prefix, 'complete_', $suffix)"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="normalize-space(eaccpf:part[@localType='fullname'])">
          <xsl:value-of select="normalize-space(eaccpf:part)"/>
        </xsl:when>
        <xsl:when test="normalize-space(eaccpf:part[@localType='middle'])">
          <xsl:value-of select="normalize-space(concat(eaccpf:part[@localType='surname'], ', ', eaccpf:part[@localType='forename'], ' ', eaccpf:part[@localType='middle']))"/>
        </xsl:when>
        <xsl:when test="normalize-space(eaccpf:part[@localType='surname'])">
          <xsl:value-of select="normalize-space(concat(eaccpf:part[@localType='surname'], ', ', eaccpf:part[@localType='forename']))"/>
        </xsl:when>
        <xsl:when test="normalize-space(eaccpf:part[@localType='forename'])">
          <xsl:value-of select="normalize-space(eaccpf:part[@localType='forename'])"/>
        </xsl:when>
        <!-- sometimes there is no localType -->
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(eaccpf:part)"/>
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>

</xsl:stylesheet>

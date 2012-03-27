<?xml version="1.0" encoding="UTF-8"?>
  <!-- Basic EAC-CPF -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:eaccpf="urn:isbn:1-931666-33-4"
  xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:template match="eaccpf:eac-cpf">
        <xsl:param name="content"/>
	<xsl:param name="pid" select="$PID"/>
	<xsl:param name="dsid" select="'EAC-CPF'"/>
	<xsl:param name="prefix" select="'eaccpf_'"/>
	<xsl:param name="suffix" select="'_et'"/> <!-- 'edged' (edge n-gram) text, for auto-completion -->

	<xsl:variable name="cpfDesc" select="eaccpf:cpfDescription"/>
	<xsl:variable name="identity" select="$cpfDesc/eaccpf:identity"/>
	<xsl:variable name="name_prefix" select="concat($prefix, 'name_')"/>
	<!-- ensure that the primary is first -->
	<xsl:apply-templates select="$identity/eaccpf:nameEntry[@localType='primary']">
	  <xsl:with-param name="pid" select="$pid"/>
	  <xsl:with-param name="prefix" select="$name_prefix"/>
	  <xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>

	<!-- place alternates (non-primaries) later -->
	<xsl:apply-templates select="$identity/eaccpf:nameEntry[not(@localType='primary')]">
	  <xsl:with-param name="pid" select="$pid"/>
	  <xsl:with-param name="prefix" select="$name_prefix"/>
	  <xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>
  </xsl:template>

  <xsl:template match="eaccpf:nameEntry">
    <xsl:param name="pid"/>
    <xsl:param name="prefix">eaccpf_name_</xsl:param>
    <xsl:param name="suffix">_et</xsl:param>

    <!-- fore/first name -->
    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($prefix, 'given', $suffix)"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="part[@localType='middle']">
          <xsl:value-of select="normalize-space(concat(eaccpf:part[@localType='forename'], ' ', eaccpf:part[@localType='middle']))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(eaccpf:part[@localType='forename'])"/>
        </xsl:otherwise>
      </xsl:choose>
    </field>

    <!-- sur/last name -->
    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($prefix, 'family', $suffix)"/>
      </xsl:attribute>
      <xsl:value-of select="normalize-space(eaccpf:part[@localType='surname'])"/>
    </field>

    <!-- id -->
    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($prefix, 'id', $suffix)"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="concat($pid, '/', @id)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($pid,'/name_position:', position())"/>
        </xsl:otherwise>
      </xsl:choose>
    </field>

    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($prefix, 'complete', $suffix)"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="normalize-space(part[@localType='middle'])">
          <xsl:value-of select="normalize-space(concat(eaccpf:part[@localType='surname'], ', ', eaccpf:part[@localType='forename'], ' ', eaccpf:part[@localType='middle']))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(concat(eaccpf:part[@localType='surname'], ', ', eaccpf:part[@localType='forename']))"/>
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>

</xsl:stylesheet>

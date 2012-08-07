<?xml version="1.0" encoding="UTF-8"?>
  <!-- Basic EAC-CPF -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:eaccpf="urn:isbn:1-931666-33-4"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:template match="foxml:datastream[@ID='EAC-CPF']/foxml:datastreamVersion[last()]" name="index_EAC-CPF">
  <xsl:param name="content"/>
	<xsl:param name="prefix" select="'eaccpf_'"/>
	<xsl:param name="suffix" select="'_et'"/> <!-- 'edged' (edge n-gram) text, for auto-completion -->

	<xsl:variable name="cpfDesc" select="$content//eaccpf:cpfDescription"/>
	<xsl:variable name="identity" select="$cpfDesc/eaccpf:identity"/>
	<xsl:variable name="name_prefix" select="concat($prefix, 'name_')"/>

	<!-- ensure that the primary is first -->
	<xsl:apply-templates select="$identity/eaccpf:nameEntry[@localType='primary']">
	  <xsl:with-param name="prefix" select="$name_prefix"/>
	  <xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>

	<!-- place alternates (non-primaries) later -->
	<xsl:apply-templates select="$identity/eaccpf:nameEntry[not(@localType='primary')]">
	  <xsl:with-param name="prefix" select="$name_prefix"/>
	  <xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>
  </xsl:template>

   <xsl:template match="eaccpf:nameEntry">
    <xsl:param name="prefix">eaccpf_name_</xsl:param>
    <xsl:param name="suffix">_et</xsl:param>

    <!-- fore/first name -->
    <xsl:for-each select="eaccpf:part[@localType='forename']">
	    <field>
	      <xsl:attribute name="name">
	        <xsl:value-of select="concat($prefix, 'given', $suffix)"/>
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
	        <xsl:value-of select="concat($prefix, 'family', $suffix)"/>
	      </xsl:attribute>
	      <xsl:value-of select="normalize-space(../eaccpf:part[@localType='surname'])"/>
	    </field>
    </xsl:for-each>

    <!-- id -->
    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat($prefix, 'id', $suffix)"/>
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
        <xsl:value-of select="concat($prefix, 'complete', $suffix)"/>
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

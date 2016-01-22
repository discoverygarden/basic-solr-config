<?xml version="1.0" encoding="UTF-8"?>
<!-- CML -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:cmls="http://www.xml-cml.org/schema"
  xmlns:java="http://xml.apache.org/xalan/java"
  xmlns:mods="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="cmls">

  <xsl:variable name="single_valued_hashset_for_cml" select="java:java.util.HashSet.new()"/>

  <xsl:template match="foxml:datastream[@ID='CML']/foxml:datastreamVersion[last()]" name="index_CML">
    <xsl:param name="content"/>
    <xsl:param name="prefix"></xsl:param>
    <xsl:param name="suffix"></xsl:param>
    <!-- Clearing hash in case the template is ran more than once. -->
    <xsl:variable name="return_from_clear" select="java:clear($single_valued_hashset_for_cml)"/>
    <xsl:apply-templates mode="writing_cml" select="$content/cmls:module"/>
    <xsl:apply-templates mode="slurping_cml" select="$content//cmls:metadataList[@convention = 'islandora:sp_chem_CM']"/>
  </xsl:template>

  <!-- Match on individual fields. -->
  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:multipole"]/cmls:list/cmls:array[@dictRef="cc:hexadecapole"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">multipole_hexadecapole_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:multipole"]/cmls:list/cmls:array[@dictRef="cc:octapole"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">multipole_octapole_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:multipole"]/cmls:list/cmls:array[@dictRef="cc:quadrupole"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">multipole_quadrupole_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:multipole"]/cmls:list/cmls:scalar[@dictRef="x:dipole"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">multipole_x_dipole_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:multipole"]/cmls:list/cmls:array[@dictRef="cc:dipole"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">dipole_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:rmsd"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">rmsd_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:hfenergy"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">hfenergy_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:electronicstate"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">electronicstate_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:molecule/cmls:property[@dictRef="id:smiles_H"]/cmls:scalar' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'smiles_h_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">smiles_h_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:molecule/cmls:property[@dictRef="id:smiles"]/cmls:scalar' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'smiles_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">smiles_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:jobdatetime.end"]/cmls:scalar' mode="writing_cml">
    <xsl:variable name="textValue">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">jobtime_end_mdt</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:value-of select="$textValue"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:jobtime"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">jobtime_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:array[@dictRef="cc:rotconst"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">rotconst_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="cc:largestconciseabelian"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'largestconciseabelian_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">largestconciseabelian_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="cc:largestabelian"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'largestabelian_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">largestabelian_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="cc:operatorcount"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'operatorcount_i')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">operatorcount_i</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="g:stoichiometry"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'stoichiometry_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">stoichiometry_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:molecule/cmls:property[@dictRef="cml:molmass"]/cmls:scalar' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'molmass_d')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">molmass_d</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:molecule/cmls:property[@dictRef="cml:molmass"]/cmls:scalar/@units' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'molmass_unit_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">molmass_unit_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="cc:title"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">title_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:scalar[@dictRef="g:control"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">control_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module//cmls:array[@dictRef="g:kk"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">kk_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="cc:pointgroup"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">pointgroup_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="x:S2A"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 's2a_f')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">s2a_f</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="x:S2-1"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 's21_f')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">s21_f</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="x:S2"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 's2_f')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">s2_f</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:scalar[@dictRef="g:zmat"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'zmat_i')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">zmat_i</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="g:spindipole.yz"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'spindipol_yz_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">spindipole_yz_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="g:spindipole.xz"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'spindipol_xz_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">spindipole_xz_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="g:spindipole.xy"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'spindipol_xy_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">spindipole_xy_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="g:spindipole.zz"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'spindipol_zz_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">spindipole_zz_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="g:spindipole.yy"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'spindipol_yy_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">spindipole_yy_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="g:spindipole.xx"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'spindipol_xx_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">spindipole_xx_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="cc:coupling"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">coupling_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="x:isotopeNumber"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">isotope_number_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="x:elementType"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">element_type_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module/cmls:list/cmls:array[@dictRef="cc:serial"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'serial_s')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">serial_s</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:initialization"]/cmls:parameterList/cmls:parameter[@dictRef="g:keyword"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">keyword_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:initialization"]/cmls:parameterList/cmls:parameter[@dictRef="g:operation"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">operation_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:initialization"]/cmls:parameterList/cmls:parameter[@dictRef="cc:method"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">method_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:initialization"]/cmls:parameterList/cmls:parameter[@dictRef="cc:pointgroup"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">initialization_pointgroup_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:initialization"]/cmls:parameterList/cmls:parameter[@dictRef="cc:frameworkgroup"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">frameworkgroup_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:initialization"]/cmls:parameterList/cmls:parameter[@dictRef="cc:degfreedom"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">degfreedom_mi</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:initialization"]/cmls:parameterList/cmls:parameter[@dictRef="cc:basis"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">basis_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:initialization"]/cmls:parameterList/cmls:parameter[@dictRef="cc:diffuse"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">diffuse_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:environment"]/cmls:parameterList/cmls:parameter[@dictRef="cc:program.date"]/cmls:scalar' mode="writing_cml">
    <xsl:variable name="textValue">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">program_date_mdt</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:value-of select="$textValue"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:environment"]/cmls:parameterList/cmls:parameter[@dictRef="cc:run.date"]/cmls:scalar' mode="writing_cml">
    <xsl:variable name="textValue">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">run_date_mdt</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:value-of select="$textValue"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:environment"]/cmls:parameterList/cmls:parameter[@dictRef="cc:version"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">version_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:environment"]/cmls:parameterList/cmls:parameter[@dictRef="cc:date"]/cmls:scalar' mode="writing_cml">
    <xsl:variable name="textValue">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">date_mdt</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:value-of select="$textValue"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:environment"]/cmls:parameterList/cmls:parameter[@dictRef="cc:jobname"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">jobname_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:environment"]/cmls:parameterList/cmls:parameter[@dictRef="cc:hostname"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">hostname_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:environment"]/cmls:parameterList/cmls:parameter[@dictRef="cc:program"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">program_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:molecule/@spinMultiplicity' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">molecule_spin_multiplicity_i</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:molecule/@id' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">molecule_id_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:formula/@formalCharge' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">formal_charge_i</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:formula/@concise' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">concise_formula_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='mods:note[@type="functional fragment"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">functional_fragment_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='mods:note[@type="molecular weight"]' mode="writing_cml">
    <xsl:if test="java:add($single_valued_hashset_for_cml, 'molecular_weight_f')">
      <xsl:apply-templates mode="writing_cml_field" select=".">
        <xsl:with-param name="field_name">molecular_weight_f</xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='mods:note[@type="formula"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">formula_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='mods:identifier[@type="inchikey"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">inchikey_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='mods:note[@type="inchi"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">inchi_s</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="g:l601.pol.exact"]/cmls:array' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">l601_pol_exact_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="g:l601.pol.approx"]/cmls:array' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">l601_pol_approx_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="g:l716.lowfreq"]/cmls:array' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">l716_lowfreq_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:diagvib"]/cmls:array' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">diagvib_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:frequencies"]/cmls:table/cmls:array[@dictRef="cc:irrep"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">force_matrix_irrep_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:frequencies"]/cmls:table/cmls:array[@dictRef="x:serial"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">force_matrix_serial_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:frequencies"]/cmls:table/cmls:array[@dictRef="cc:frequency"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">force_matrix_frequency_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:frequencies"]/cmls:table/cmls:array[@dictRef="cc:redmass"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">force_matrix_redmass_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:frequencies"]/cmls:table/cmls:array[@dictRef="cc:forceconst"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">force_matrix_force_constant_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:frequencies"]/cmls:table/cmls:array[@dictRef="cc:irintensity"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">force_matrix_ir_intensity_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:scalar[@dictRef="cc:temp"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">temp_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:scalar[@dictRef="cc:press"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">press_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:scalar[@dictRef="cc:molmass"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">molmass_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:scalar[@dictRef="cc:symmnumber"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">symmnumber_mi</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:list/cmls:array[@dictRef="cc:serial"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">mass_serial_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:list/cmls:array[@dictRef="x:elementType"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">element_type_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:list/cmls:array[@dictRef="cc:atomicmass"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">atomicmass_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:array[@dictRef="cc:rottemp"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">rottemp_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:array[@dictRef="cc:rotconst"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">rotconst_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:scalar[@dictRef="cc:zpe"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">zpe_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry"]/cmls:list/cmls:array[@dictRef="cc:vibtemp"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">vibtemp_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry.energies"]/cmls:list/cmls:scalar[@dictRef="cc:ZeroPointEnergy"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">zero_point_energy_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry.energies"]/cmls:list/cmls:scalar[@dictRef="cc:thermalCorrectionToEnergy"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">thermal_correction_to_energy_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry.energies"]/cmls:list/cmls:scalar[@dictRef="cc:thermalCorrectionToEnthalpy"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">thermal_correction_to_enthalpy_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry.energies"]/cmls:list/cmls:scalar[@dictRef="cc:thermalCorrectionToGibbsEnergy"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">thermal_correction_to_gibbs_energy_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry.energies"]/cmls:list/cmls:scalar[@dictRef="cc:Energy_0K"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">energy_0k_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry.energies"]/cmls:list/cmls:scalar[@dictRef="cc:Energy_T"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">energy_t_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry.energies"]/cmls:list/cmls:scalar[@dictRef="cc:Enthalpy_T"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">enthalpy_t_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:thermochemistry.energies"]/cmls:list/cmls:scalar[@dictRef="cc:GibbsEnergy_T"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">gibbs_energy_t_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:popanal"]/cmls:module/cmls:module/cmls:scalar[@dictRef="g:l601.state"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">l601_state_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:popanal"]/cmls:module/cmls:array[@dictRef="g:alphaocc"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">alphaocc_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:popanal"]/cmls:module/cmls:array[@dictRef="g:alphavirt"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">alphavirt_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:popanal"]/cmls:module/cmls:module/cmls:module/cmls:scalar[@dictRef="g:title"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">mulliken_title_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:popanal"]/cmls:module/cmls:module/cmls:module/cmls:scalar[@dictRef="cc:serial"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">mulliken_serial_mi</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:popanal"]/cmls:module/cmls:module/cmls:module/cmls:list/cmls:array[@dictRef="cc:serial"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">mulliken_row_serial_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:popanal"]/cmls:module/cmls:module/cmls:module/cmls:list/cmls:array[@dictRef="cc:elementType"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">mulliken_row_element_type_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:popanal"]/cmls:module/cmls:module/cmls:module/cmls:list/cmls:list/cmls:scalar[@dictRef="cc:mulliken"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">mulliken_row_mulliken_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:popanal"]/cmls:module/cmls:module/cmls:scalar[@dictRef="g:charge"]' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">mulliken_charge_md</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:rmsf"]/cmls:scalar' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">rmsf_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='cmls:module[@dictRef="cc:finalization"]/cmls:propertyList/cmls:property[@dictRef="cc:virtualorbs"]/cmls:array' mode="writing_cml">
    <xsl:apply-templates mode="writing_cml_field" select=".">
      <xsl:with-param name="field_name">virtualorbs_ms</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <!-- Writes a Solr field. -->
  <xsl:template match="*" mode="writing_cml_field">
    <xsl:param name="field_name"></xsl:param>
    <xsl:param name="value">not_a_date_i_promise</xsl:param>
    <xsl:if test="$value">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat('cml_', $field_name)"/>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="$value!='not_a_date_i_promise'">
            <xsl:value-of select="$value"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </field>
    </xsl:if>
  </xsl:template>
  <!-- Avoid using text alone. -->
  <xsl:template match="text()" mode="writing_cml"/>
  <xsl:template match="text()" mode="writing_cml_field"/>

  <!-- SLURP MODS Metadata -->
  <xsl:template match="*" mode="slurping_cml">
    <xsl:param name="prefix" select="'cml_molecule_'"></xsl:param>
    <xsl:param name="suffix" select="'ms'"/>
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz_'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ '" />
    <xsl:variable name="this_prefix">
      <xsl:value-of select="concat($prefix, local-name(), '_')"/>
      <xsl:if test="@type">
        <xsl:value-of select="concat(@type, '_')"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="textValue">
      <xsl:value-of select="normalize-space(text())"/>
    </xsl:variable>

    <xsl:if test="$textValue">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
      <!-- Fields are duplicated for authority because searches across authorities are common. --> 
      <xsl:if test="@authority">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($this_prefix, 'authority_', translate(@authority, $uppercase, $lowercase), '_', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$textValue"/>
        </field>
      </xsl:if>
    </xsl:if>

    <xsl:apply-templates mode="slurping_cml">
      <xsl:with-param name="prefix" select="$this_prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
    <xsl:if test="@authority">
      <xsl:apply-templates mode="slurping_cml">
        <xsl:with-param name="prefix" select="concat($this_prefix, 'authority_', translate(@authority, $uppercase, $lowercase), '_')"/>
        <xsl:with-param name="suffix" select="$suffix"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- Avoid using text alone. -->
  <xsl:template match="text()" mode="slurping_cml"/>

</xsl:stylesheet>

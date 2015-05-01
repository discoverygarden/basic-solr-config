<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:mods="http://www.loc.gov/mods/v3"  xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="mods">
  <xsl:variable name="modsPrefix">mods_</xsl:variable>
  <xsl:variable name="modsSuffix">_ms</xsl:variable>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/slurp_all_MODS_to_solr.xslt"/>
  <!--
    SECTION 1:

    Our root MODS processing template; this is where we split out specific MODS
    collections that need special metadata field templates. Not all collections
    will need this; if they don't, the generic stuff below takes care of them.
    
    Collections being given special treatment in here should also have templates
    in the second and third sections below.
  -->

  <xsl:template match="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]" name="index_MODS_UCLA">
    <xsl:param name="content"/>

    <!-- encode the whole mods record into a solr field -->
    <field name="mods_xml">
      <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
      <xsl:copy-of select="$content"/>
      <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
    </field>

    <!-- xslt 1.0 doesn't allow use of multiple modes; we need wrapper code -->
    <xsl:for-each select="$content//mods:mods">
      <xsl:choose>
        <xsl:when
          test="starts-with($PID, 'edu.ucla.library.specialCollections.losAngelesDailyNews')
          or starts-with($PID, 'edu.ucla.library.universityArchives.historicPhotographs')
          or starts-with($PID, 'edu.ucla.library.specialCollections.latimes')">
          <xsl:apply-templates select="mods:*" mode="CollectingLA"/>
        </xsl:when>
        <xsl:when test="starts-with($PID, 'edu.ucla.library.dep.tahrir')">
          <xsl:apply-templates select="mods:*" mode="Tahrir"/>
        </xsl:when>
        <xsl:when test="starts-with($PID, 'livingstone')">
          <xsl:apply-templates select="mods:*" mode="Livingstone"/>
          <field name="creator_s">
            <xsl:variable name="creator_text">
              <xsl:for-each select="mods:name">
                  <xsl:if test="mods:role/mods:roleTerm[@type='text']/text() = 'creator'">
                      <xsl:value-of select="mods:namePart/text()"/>
                      <xsl:text>; </xsl:text>
                  </xsl:if>                  
              </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="replace($creator_text,'(^.*)\p{P}$', '$1')"/>
          </field>
          <field name="addressee_s">
            <xsl:variable name="addressee_text">
              <xsl:for-each select="mods:name">
                  <xsl:if test="mods:role/mods:roleTerm[@type='text']/text() = 'addressee'">
                      <xsl:value-of select="mods:namePart/text()"/>
                      <xsl:text>; </xsl:text>
                  </xsl:if>                  
              </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="replace($addressee_text,'(^.*)\p{P}$', '$1')"/>
          </field>
          <field name="repository_s">
              <xsl:for-each select="mods:relatedItem[@type='original']">
                  <xsl:if test="mods:name/mods:role/mods:roleTerm[@type='text']/text() = 'repository'">
                      <xsl:value-of select="mods:name/mods:namePart/text()"/>
                      <xsl:if test="mods:location/mods:shelfLocator">
                          <xsl:text>, </xsl:text>   
                        <xsl:value-of select="mods:location/mods:shelfLocator/text()"/>  
                         <xsl:text>. </xsl:text> 
                      </xsl:if>                                                            
                  </xsl:if> 
              </xsl:for-each>
          </field>
          <field name="genre_s">
            <xsl:variable name="genre_text">
              <xsl:for-each select="mods:genre[@authority='aat']">
                  <xsl:value-of select="text()"/>
                      <xsl:text>; </xsl:text>
              </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="replace($genre_text,'(^.*)\p{P}$', '$1')"/>
          </field>
          <field name="otherVersions_s">
              <xsl:for-each select="mods:relatedItem[@type='otherVersion']">
                  <xsl:value-of select="mods:identifier/text()"/>
                      <xsl:text>. </xsl:text>
              </xsl:for-each>
          </field>
        </xsl:when>
      </xsl:choose>
      <!-- We always get the generic treatment -->
      <xsl:apply-templates mode="slurping_MODS" select="current()">
	 <xsl:with-param name="suffix" select="'ms'"/>
      	 <xsl:with-param name="pid" select="$PID"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>

  <!--
   SECTION 2:

   Below this are processing templates used by collections that have special
   metadata processing needs.
  -->

  <!-- We pull out cla topics for the visualization index -->
  <xsl:template match="mods:subject[@authority='cla_topic']" mode="CollectingLA">
    <!-- cla_topic_mt field is created automatically from submitted _ms one -->
    <field name="cla_topic_ms">
      <xsl:value-of select="mods:topic"/>
    </field>
  </xsl:template>
  
   <!-- Livingstone Browse By Standard Catalogue Number needs filter of attribute display Label -->
  <xsl:template match="mods:identifier[@type='local' and  @displayLabel='Canonical Catalog Number']" mode="Livingstone">
    
    <field name="mods_identifier_local_Canonical_Catalog_Number_s">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
   <xsl:template match="mods:identifier[@type='local' and  @displayLabel='master_id']" mode="Livingstone">    
    <field name="mods_identifier_local_master_id_s">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  <xsl:template match="mods:identifier[@type='local' and  @displayLabel='NLS copy identifier']" mode="Livingstone">    
    <field name="mods_identifier_local_NLS_copy_identifier_s">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  <xsl:template match="mods:extent[@unit='pages']" mode="Livingstone">    
    <field name="mods_physicalDescription_extent_pages_s">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
<xsl:template match="mods:extent[@unit='mm']" mode="Livingstone">    
    <field name="mods_physicalDescription_extent_mm_s">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>   
  <xsl:template match="mods:originInfo[mods:dateCreated[@encoding='iso8601']]" mode="CollectingLA">
    <xsl:variable name="dateStart"
      select="java:edu.ucla.library.IsoToSolrDateConverter.getStartDateFromIsoDateString(normalize-space(mods:dateCreated[@encoding='iso8601']))" />
    <xsl:variable name="dateEnd"
      select="java:edu.ucla.library.IsoToSolrDateConverter.getEndDateFromIsoDateString(normalize-space(mods:dateCreated[@encoding='iso8601']))" />
    <field name="mods_dateCreated_dt">
      <xsl:value-of select="$dateStart"/>
    </field>
    <field name="mods_dateCreated_start_dt">
      <xsl:value-of select="$dateStart"/>
    </field>
    <field name="mods_dateCreated_end_dt">
      <xsl:value-of select="$dateEnd"/>
    </field>
  </xsl:template>
  
  <!-- Temporary workaround to allow us to separate out the Arabic subjects -->
  <xsl:template match="mods:subject[@authority='local']" mode="Tahrir">
    <!-- mods_topic_ar_mt is created automatically for us -->
    <field name="mods_topic_ar_ms">
      <xsl:value-of select="mods:topic"/>
    </field>
  </xsl:template>

  <!--
    SECTION 3:
    
    Below this are collection level mode switches (needed b/c we use xslt 1.0).
    These basically handle the non-special fields in a collection that is being
    given special treatment...  It switches them to use the generic templates.
  -->

  <xsl:template match="mods:*" mode="CollectingLA">
    <xsl:apply-templates select="self::mods:*"/>
  </xsl:template>
  
  <xsl:template match="mods:*" mode="Tahrir">
    <xsl:apply-templates select="self::mods:*"/>
  </xsl:template>
</xsl:stylesheet>


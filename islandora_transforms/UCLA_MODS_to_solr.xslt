<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:mods="http://www.loc.gov/mods/v3"  xmlns:java="http://xml.apache.org/xalan/java" 
  xmlns:copyrightMD="http://www.cdlib.org/inside/diglib/copyrightMD"  exclude-result-prefixes="mods">
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
        <xsl:when test="starts-with($PID, 'greenmovement')">
          <xsl:apply-templates select="mods:*" mode="GreenMovement"/>
        </xsl:when>		
       <xsl:when test="starts-with($PID, 'palmu')">
          <xsl:apply-templates select="mods:*" mode="palmu"/>
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
            <xsl:value-of select="substring($creator_text,0,string-length($creator_text)-1)"/>
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
            <xsl:value-of select="substring($addressee_text,0,string-length($addressee_text)-1)"/>
          </field>
         
          <xsl:for-each select="mods:name">
              <xsl:if test="mods:role/mods:roleTerm[@type='text']/text() = 'addressee'">
                   <field name="addressee_description_ms">                  
                  <xsl:value-of select="mods:namePart/text()"/> : <xsl:value-of select="mods:description/text()"/>
                 </field> 
              </xsl:if>
          </xsl:for-each>
           
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
            <xsl:value-of select="substring($genre_text,0,string-length($genre_text)-1)"/>
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
      <xsl:apply-templates mode="slurping_MODS_IDEP" select="mods:*"/>
      <xsl:apply-templates mode="slurping_MODS" select="current()">
	 <xsl:with-param name="suffix" select="'ms'"/>
      	 <xsl:with-param name="pid" select="$PID"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>
  
  
  <!-- BSP REQUEST 2018 DEP-636 -->
  <!-- this is causing duplicate values in Solr documents
  <xsl:template match="mods:title[@lang='arm' and @type='alternative']" mode="ArmeniaPosters">    
    <field name="mods_titleInfo_title_alternative_ms">
       <xsl:value-of select="text()"/>
    </field>	
  </xsl:template> -->
  <xsl:template match="mods:part" mode="slurping_MODS_IDEP">    
    <xsl:for-each select="mods:detail">
      <xsl:if test="boolean(@type='volume')">
        <field name="mods_part_detail_volume_number_s">
          <xsl:value-of select="mods:number/text()"/>
        </field>
      </xsl:if>
      
      <xsl:if test="boolean(@type='issue')">
        <field name="mods_part_detail_issue_number_s">
          <xsl:value-of select="mods:number/text()"/>
        </field>
      </xsl:if>
    </xsl:for-each>
    
    <xsl:if test="boolean(mods:date)">
      <field name="mods_part_date_s">
        <xsl:value-of select="mods:date/text()"/>
      </field>
    </xsl:if>
    
  </xsl:template>
  <xsl:template match="mods:dateCreated[@encoding='iso8601' and not(@point)]" mode="slurping_MODS_IDEP">    
    <field name="bs_dateStart_s">
      <xsl:value-of select="text()"/>
    </field>	
	<field name="bs_dateEnd_s">
      <xsl:value-of select="text()"/>
    </field>	
  </xsl:template>
  
  <xsl:template match="mods:dateCreated[@encoding='iso8601' and @point='start']" mode="slurping_MODS_IDEP">    
    <field name="bs_dateStart_s">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  
  <xsl:template match="mods:dateCreated[@encoding='iso8601' and @point='end']" mode="slurping_MODS_IDEP">    
    <field name="bs_dateEnd_s">
      <xsl:value-of select="text()"/>
    </field>	
  </xsl:template>
  
  <xsl:template match="mods:dateIssued[@encoding='iso8601' and not(@point)]" mode="slurping_MODS_IDEP">    
    <field name="bs_dateStart_s">
      <xsl:value-of select="text()"/>
    </field>	
    <field name="bs_dateEnd_s">
      <xsl:value-of select="text()"/>
    </field>	
  </xsl:template>
  
  <xsl:template match="mods:dateIssued[@encoding='iso8601' and @point='start']" mode="slurping_MODS_IDEP">    
    <field name="bs_dateStart_s">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  
  <xsl:template match="mods:dateIssued[@encoding='iso8601' and @point='end']" mode="slurping_MODS_IDEP">    
    <field name="bs_dateEnd_s">
      <xsl:value-of select="text()"/>
    </field>	
  </xsl:template>
  
  <xsl:template match="mods:identifier[@type='local' and  @displayLabel='File name']" mode="slurping_MODS_IDEP">    
    <field name="mods_identifier_local_filename_s">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
     
  <xsl:template match="copyrightMD:copyright[@copyright.status and @publication.status]" mode="slurping_MODS_IDEP">  
	<field name="mods_accessCondition_copyrightstatus_s">
      <xsl:value-of select="@copyright.status"/>
    </field>	  
    <field name="mods_accessCondition_publicationstatus_s">
      <xsl:value-of select="@publication.status"/>
    </field>		 
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
  
   <!-- Add displayLabel to the solr fields  -->
  <xsl:template match="mods:identifier[type='uri']" mode="palmu">
    <!-- Thumbnail Image -->
    <xsl:if test="boolean(@displayLabel='Preview Image')">
        <field name="mods_identifier_uri_preview_image_s">
          <xsl:value-of select="text()"/>
        </field>
      </xsl:if>
      <!-- Display Image -->
      <xsl:if test="boolean(@displayLabel='Display Image')">
        <field name="mods_identifier_uri_display_image_s">
          <xsl:value-of select="text()"/>
        </field>
      </xsl:if>
      <!-- Location -->
      <xsl:if test="boolean(@displayLabel='View Record')">
        <field name="mods_identifier_uri_view_record_s">
          <xsl:value-of select="text()"/>
        </field>
      </xsl:if>
   </xsl:template>
  
  <!-- display label addition to greenmovment -->
  <xsl:template match="mods:note[@lang='per' and  @displayLabel='Keywords/Chants/Slogans']" mode="GreenMovement">    
    <field name="mods_note_per_keywords_chants_slogans_ms">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  <xsl:template match="mods:note[@lang='eng' and  @displayLabel='Keywords/Chants/Slogans']" mode="GreenMovement">    
    <field name="mods_note_eng_keywords_chants_slogans_ms">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  
  <xsl:template match="mods:note[@transliteration='unspecified' and  @displayLabel='Names']" mode="GreenMovement">    
    <field name="mods_note_unspecified_names_ms">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  
  <xsl:template match="mods:note[@lang='per' and  @displayLabel='Names']" mode="GreenMovement">    
    <field name="mods_note_per_names_ms">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  
  <xsl:template match="mods:note[@lang='eng' and  @displayLabel='Names']" mode="GreenMovement">    
    <field name="mods_note_eng_names_ms">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  
  
  <!-- end -->
  
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


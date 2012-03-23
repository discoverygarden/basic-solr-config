<?xml version="1.0" encoding="UTF-8"?>
<!-- We need all lower level namespaces to be declared here for exclude-result-prefixes attributes
     to be effective -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:zs="http://www.loc.gov/zing/srw/"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:rel="info:fedora/fedora-system:def/relations-external#"
  xmlns:fedora-model="info:fedora/fedora-system:def/model#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
  xmlns:fedora="info:fedora/fedora-system:def/relations-external#"
  xmlns:dwc="http://rs.tdwg.org/dwc/xsd/simpledarwincore/"
  xmlns:uvalibdesc="http://dl.lib.virginia.edu/bin/dtd/descmeta/descmeta.dtd"
  xmlns:uvalibadmin="http://dl.lib.virginia.edu/bin/admin/admin.dtd/"
  xmlns:res="http://www.w3.org/2001/sw/DataAccess/rf1/result"
  xmlns:eaccpf="urn:isbn:1-931666-33-4"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:mods="http://www.loc.gov/mods/v3">
  
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <!-- should verify what gets passed into this -->
  <xsl:param name="REPOSITORYNAME" select="repositoryName"/>
  <xsl:param name="FEDORASOAP" select="repositoryName"/>
  <xsl:param name="FEDORAUSER" select="repositoryUserName"/>
  <xsl:param name="FEDORAPASS" select="repositoryPassword"/>
  <xsl:param name="TRUSTSTOREPATH" select="repositoryName"/>
  <xsl:param name="TRUSTSTOREPASS" select="repositoryName"/>
  
  <!-- These values are accessable in included xslts-->
  <xsl:variable name="PROT">http</xsl:variable>
  <xsl:variable name="FEDORAUSERNAME">fedoraAdmin</xsl:variable>
  <xsl:variable name="FEDORAPASSWORD">nothingtoseeheremovealong</xsl:variable>
  <xsl:variable name="HOST">mr.host.bsc</xsl:variable>
  <xsl:variable name="PORT">8080</xsl:variable>
  <xsl:variable name="PID" select="/foxml:digitalObject/@PID"/>


<!--
	 This xslt stylesheet generates the IndexDocument consisting of IndexFields
     from a FOXML record. The IndexFields are:
       - from the root element = PID
       - from foxml:property   = type, state, contentModel, ...
       - from oai_dc:dc        = title, creator, ...
     The IndexDocument element gets a PID attribute, which is mandatory,
     while the PID IndexField is optional.
-->

<!-- These includes are for transformations on individual datastreams;
     disable the ones you do not want to perform -->
  <xsl:include href="./islandora_transforms/inline_XML_to_one_solr_field.xslt"/>
  <xsl:include href="./islandora_transforms/inline_XML_text_nodes_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/RELS-EXT_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/RELS-INT_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/FOXML_properties_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/datastream_id_to_solr.xslt"/>
  
  
  <xsl:include href="./islandora_transforms/MODS_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/EACCPF_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/VRAcore_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/rights_metadata_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/tags_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/TEI_to_solr.xslt"/>
  <xsl:include href="./islandora_transforms/OCR_to_solr.xslt"/>

<!-- Decide which objects to modify the index of -->
  <xsl:template match="/">
	  <update>
	      <!-- The following allows only active and data oriented FedoraObjects to be indexed. -->
	      <xsl:if test="foxml:digitalObject/foxml:objectProperties/foxml:property[@NAME='info:fedora/fedora-system:def/model#state' and @VALUE='Active']">
	        <xsl:if test="not(foxml:digitalObject/foxml:datastream[@ID='METHODMAP' or @ID='DS-COMPOSITE-MODEL'])">
	            <add>
	              <xsl:apply-templates select="/foxml:digitalObject" mode="activeFedoraObject">
	                <xsl:with-param name="PID" select="$PID"/>
	              </xsl:apply-templates>
	            </add>
	        </xsl:if>
	      </xsl:if>
	  </update>
  </xsl:template>

<!-- Index an object -->
  <xsl:template match="/foxml:digitalObject" mode="activeFedoraObject">
    <xsl:param name="PID"/>

    <doc>
    <!-- put the object pid into a field -->
      <field name="PID" boost="2.5">
        <xsl:value-of select="$PID"/>
      </field>

      <xsl:apply-templates select="foxml:objectProperties/foxml:property"/>
      <xsl:apply-templates select="/foxml:digitalObject"/>
      
     <!-- THIS IS SPARTA!!!  -->
     <!-- This crazy line trys to call a matching template on every datastream id so that you only have to edit included files-->
     <!-- managed datastreams may need a different callout -->   
     <xsl:apply-templates select="foxml:datastream/foxml:datastreamVersion[last()]/foxml:xmlContent"/>

<!-- this is an example of using template modes to have multiple ways of indexing the same stream -->
<!-- 
      <xsl:apply-templates select="foxml:datastream[@ID='EAC-CPF']/foxml:datastreamVersion[last()]/foxml:xmlContent//eaccpf:eac-cpf">
        <xsl:with-param name="pid" select="$PID"/>
      </xsl:apply-templates>

      <xsl:apply-templates mode="fjm" select="foxml:datastream[@ID='EAC-CPF']/foxml:datastreamVersion[last()]/foxml:xmlContent//eaccpf:eac-cpf">
        <xsl:with-param name="pid" select="$PID"/>
        <xsl:with-param name="suffix">_s</xsl:with-param>
      </xsl:apply-templates>
      
-->

    </doc>
  </xsl:template>
  
  <!-- This prevents text from just being printed to the doc without field elements JUST TRY COMMENTING IT OUT -->
  <xsl:template match="text()"/>
  
</xsl:stylesheet>

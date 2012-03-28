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
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:exts="xalan://dk.defxws.fedoragsearch.server.GenericOperationsImpl"
  xmlns:islandora-exts="xalan://ca.upei.roblib.DataStreamForXSLT"
            exclude-result-prefixes="exts">
  
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <!-- gsearch magik @TODO: see if any of the explicit variables can be replaced by these-->
  <xsl:param name="REPOSITORYNAME" select="repositoryName"/>
  <xsl:param name="FEDORASOAP" select="repositoryName"/>
  <xsl:param name="FEDORAUSER" select="repositoryName"/>
  <xsl:param name="FEDORAPASS" select="repositoryName"/>
  <xsl:param name="TRUSTSTOREPATH" select="repositoryName"/>
  <xsl:param name="TRUSTSTOREPASS" select="repositoryName"/>
  
  <!-- These values are accessible in included xslts-->
  <xsl:variable name="PROT">http</xsl:variable>
  <xsl:variable name="FEDORAUSERNAME">fedoraAdmin</xsl:variable>
  <xsl:variable name="FEDORAPASSWORD">nothingtoseeheremovealong</xsl:variable>
  <xsl:variable name="HOST">localhost</xsl:variable>
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
     disable the ones you do not want to perform;
     the paths may need to be updated if the standard install was not followed
     TODO: look into a way to make these paths relative-->
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/XML_to_one_solr_field.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/XML_text_nodes_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/RELS-EXT_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/RELS-INT_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/FOXML_properties_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/datastream_id_to_solr.xslt"/>
  
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/MODS_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/EACCPF_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/VRAcore_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/rights_metadata_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/tags_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/TEI_to_solr.xslt"/>
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/OCR_to_solr.xslt"/>

<!-- Decide which objects to modify the index of -->
    <xsl:template match="/">
	    <update>
	        <!-- The following allows only active and data oriented FedoraObjects to be indexed. -->
	        <xsl:if test="not(foxml:digitalObject/foxml:datastream[@ID='METHODMAP' or @ID='DS-COMPOSITE-MODEL'])">
	            <xsl:choose>
	                <xsl:when test="foxml:digitalObject/foxml:objectProperties/foxml:property[@NAME='info:fedora/fedora-system:def/model#state' and @VALUE='Active']">
	                    <add>
	                        <xsl:apply-templates select="/foxml:digitalObject" mode="indexFedoraObject">
	                            <xsl:with-param name="PID" select="$PID"/>
	                        </xsl:apply-templates>
	                    </add>
	                </xsl:when>
	                <xsl:otherwise>
	                    <xsl:apply-templates select="/foxml:digitalObject" mode="unindexFedoraObject"/>
	                </xsl:otherwise>
	            </xsl:choose>
	        </xsl:if>
	    </update>
    </xsl:template>

<!-- Index an object -->
  <xsl:template match="/foxml:digitalObject" mode="indexFedoraObject">
    <xsl:param name="PID"/>

    <doc>
    <!-- put the object pid into a field -->
      <field name="PID" boost="2.5">
        <xsl:value-of select="$PID"/>
      </field>
        
        <!-- These templates are in the islandora_transforms -->
      <xsl:apply-templates select="foxml:objectProperties/foxml:property"/>
      <xsl:apply-templates select="/foxml:digitalObject" mode="index_object_datastreams"/>
      
     <!-- THIS IS SPARTA!!!
        These lines call a matching template on every datastream id so that you only have to edit included files
        handles inline and managed datastreams
        The datastream level element is used for matching, 
        making it imperative to use the $content parameter for xpaths in templates 
        if they are to support managed datstreams-->
     
    <!-- TODO: would like to get rid of the need for the content param-->
    <xsl:for-each select="foxml:datastream">
		    <xsl:choose>
		        <xsl:when test="@CONTROL_GROUP='X'">
		           <xsl:apply-templates select="foxml:datastreamVersion[last()]">
		              <xsl:with-param name="content" select="foxml:datastreamVersion[last()]/foxml:xmlContent"/>
		           </xsl:apply-templates>
		        </xsl:when>
		        <xsl:when test="@CONTROL_GROUP='M'">
		        <!-- TODO: should do something about mime type filtering 
			            text/plain should use the getDatastreamText extension because document will only work for xml docs
			            xml files should use the document function
			            other mimetypes should not be being sent -->
		           <xsl:apply-templates select="foxml:datastreamVersion[last()]">
			          <xsl:with-param name="content" select="document(concat($PROT, '://', $FEDORAUSERNAME, ':', $FEDORAPASSWORD, '@', $HOST, ':', $PORT, '/fedora/objects/', $PID, '/datastreams/', @ID, '/content'))"/>
			         <!-- <xsl:with-param name="content" select="normalize-space(exts:getDatastreamText($PID, $REPOSITORYNAME, @ID, $FEDORASOAP, $FEDORAUSER, $FEDORAPASS, $TRUSTSTOREPATH, $TRUSTSTOREPASS))"/> -->
			       </xsl:apply-templates>
                </xsl:when>
		    </xsl:choose>
    </xsl:for-each>

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

<!-- Delete the solr doc of an object -->
<xsl:template match="/foxml:digitalObject" mode="unindexFedoraObject">
        <xsl:comment> name="PID" This is a hack, because the code requires that to be present </xsl:comment>
        <delete>
            <id>
                <xsl:value-of select="$PID"/>
            </id>
        </delete>
</xsl:template>
  
  <!-- This prevents text from just being printed to the doc without field elements JUST TRY COMMENTING IT OUT -->
  <xsl:template match="text()"/>
  
</xsl:stylesheet>

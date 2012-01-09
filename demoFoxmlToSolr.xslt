<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: demoFoxmlToLucene.xslt 5734 2006-11-28 11:20:15Z gertsp $ -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exts="xalan://dk.defxws.fedoragsearch.server.GenericOperationsImpl"
	exclude-result-prefixes="exts" xmlns:zs="http://www.loc.gov/zing/srw/"
	xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:mods="http://www.loc.gov/mods/v3" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:fedora="info:fedora/fedora-system:def/relations-external#"
	xmlns:relsModel="info:fedora/fedora-system:def/model#" xmlns:rel="info:fedora/fedora-system:def/relations-external#"
	xmlns:fractions="http://vre.upei.ca/fractions/" xmlns:compounds="http://vre.upei.ca/compounds/"
	xmlns:critters="http://vre.upei.ca/critters/" xmlns:fedora-model="info:fedora/fedora-system:def/model#"
	xmlns:eac="urn:isbn:1-931666-33-4" xmlns:uvalibdesc="http://dl.lib.virginia.edu/bin/dtd/descmeta/descmeta.dtd"
	xmlns:uvalibadmin="http://dl.lib.virginia.edu/bin/admin/admin.dtd/">
	<xsl:output method="xml" indent="yes" encoding="UTF-8" />

	<!-- This xslt stylesheet generates the Solr doc element consisting of field 
		elements from a FOXML record. The PID field is mandatory. Options for tailoring: 
		- generation of fields from other XML metadata streams than DC - generation 
		of fields from other datastream types than XML - from datastream by ID, text 
		fetched, if mimetype can be handled currently the mimetypes text/plain, text/xml, 
		text/html, application/pdf can be handled. -->

	<xsl:param name="REPOSITORYNAME" select="repositoryName" />
	<xsl:param name="FEDORASOAP" select="repositoryName" />
	<xsl:param name="FEDORAUSER" select="repositoryName" />
	<xsl:param name="FEDORAPASS" select="repositoryName" />
	<xsl:param name="TRUSTSTOREPATH" select="repositoryName" />
	<xsl:param name="TRUSTSTOREPASS" select="repositoryName" />
	<xsl:variable name="PID" select="/foxml:digitalObject/@PID" />
	<xsl:variable name="docBoost" select="1.4*2.5" /> <!-- or any other calculation, default boost is 1.0 -->

	<xsl:template match="/">
		<add>
			<doc>
				<xsl:attribute name="boost">
				<xsl:value-of select="$docBoost" />
			</xsl:attribute>
				<!-- The following allows only active demo FedoraObjects to be indexed. -->
				<xsl:if
					test="foxml:digitalObject/foxml:objectProperties/foxml:property[@NAME='info:fedora/fedora-system:def/model#state' and @VALUE='Active']">
					<xsl:if
						test="not(foxml:digitalObject/foxml:datastream[@ID='METHODMAP'] or foxml:digitalObject/foxml:datastream[@ID='DS-COMPOSITE-MODEL'])">
						<xsl:if test="starts-with($PID,'')">
							<xsl:apply-templates mode="activeDemoFedoraObject" />
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</doc>
		</add>
	</xsl:template>

	<xsl:template match="/foxml:digitalObject" mode="activeDemoFedoraObject">
		<field name="PID" boost="2.5">
			<xsl:value-of select="$PID" />
		</field>
		<xsl:for-each select="foxml:objectProperties/foxml:property">
			<field>
				<xsl:attribute name="name"> 
						<xsl:value-of select="concat('fgs.', substring-after(@NAME,'#'))" />
					</xsl:attribute>
				<xsl:value-of select="@VALUE" />
			</field>
		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream/foxml:datastreamVersion[last()]/foxml:xmlContent/oai_dc:dc/*">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('dc.', substring-after(name(),':'))" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='RIGHTSMETADATA']/foxml:datastreamVersion[last()]/foxml:xmlContent//access/human/person">
			<field>
				<xsl:attribute name="name">access.person</xsl:attribute>
				<xsl:value-of select="text()" />
			</field>
		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='RIGHTSMETADATA']/foxml:datastreamVersion[last()]/foxml:xmlContent//access/human/group">
			<field>
				<xsl:attribute name="name">access.group</xsl:attribute>
				<xsl:value-of select="text()" />
			</field>
		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='TAGS']/foxml:datastreamVersion[last()]/foxml:xmlContent//tag">
			<!--<xsl:for-each select="foxml:datastream/foxml:datastreamVersion[last()]/foxml:xmlContent//tag"> -->
			<field>
				<xsl:attribute name="name">tag</xsl:attribute>
				<xsl:value-of select="text()" />
			</field>
			<field>
				<xsl:attribute name="name">tagUser</xsl:attribute>
				<xsl:value-of select="@creator" />
			</field>
		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='RELS-EXT']/foxml:datastreamVersion[last()]/foxml:xmlContent//rdf:description/*">
			<field>
				<xsl:attribute name="name">
						<xsl:value-of select="concat('rels.', substring-after(name(),':'))" />
					</xsl:attribute>
				<xsl:variable name="VALUE">
					<xsl:value-of select="@rdf:resource" />
				</xsl:variable>
				<xsl:value-of select="substring-after($VALUE,'/')" />
			</field>
		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='RELS-EXT']/foxml:datastreamVersion[last()]/foxml:xmlContent//rdf:description/relsModel:hasModel">
			<field>
				<xsl:attribute name="name">
					<xsl:value-of select="concat('rels.', name())" />
				</xsl:attribute>
				<xsl:variable name="VALUE">
					<xsl:value-of select="@rdf:resource" />
				</xsl:variable>
				<xsl:value-of select="substring-after($VALUE,'/')" />
			</field>
		</xsl:for-each>



		<!--***********************************************************MODS modified 
			for********************************************************************************** -->
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:mods/mods:titleInfo/mods:title">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'title_s')" />
				</xsl:attribute>
					<xsl:value-of select="../mods:nonSort/text()" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:mods/mods:titleInfo/mods:title[@type='alternative']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'titleAlt_s')" />
					</xsl:attribute>
					<xsl:value-of select="../mods:nonSort/text()" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<!-- Subject -->
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name//mods:role[mods:roleTerm = 'subject']/../../mods:name/mods:namePart">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
            <xsl:value-of select="concat('mods_', 'subjectName_s')" />         
          </xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>

		<!--Creator -->
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name//mods:role[mods:roleTerm = 'creator']/../../mods:name/mods:namePart">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'creator_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name[@type='personal']//mods:role[mods:roleTerm = 'creator']/../../mods:name/mods:namePart[@type='family']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'creatorFamilyName_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name[@type='personal']//mods:role[mods:roleTerm = 'creator']/../../mods:name/mods:namePart[@type='given']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'creatorGivenName_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name[@type='personal']//mods:role[mods:roleTerm = 'creator']/../../mods:name/mods:namePart[@type='termsOfAddress']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'creatorTA_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name[@type='corporate']//mods:role[mods:roleTerm = 'creator']/../../mods:name/mods:namePart">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'creatorCorporate_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<!--Creator -->
		<!--Contributor -->
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name[@type='personal']//mods:role[mods:roleTerm = 'contributor']/../../mods:name/mods:namePart">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'contributor_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name[@type='personal']//mods:role[mods:roleTerm = 'contributor']/../../mods:name/mods:namePart[@type='family']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'contributorFamilyName_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name[@type='personal']//mods:role[mods:roleTerm = 'contributor']/../../mods:name/mods:namePart[@type='given']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'contributorGivenName_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name[@type='personal']//mods:role[mods:roleTerm = 'contributor']/../../mods:name/mods:namePart[@type='termsOfAddress']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'contributorTA_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:name[@type='corporate']//mods:role[mods:roleTerm = 'contributor']/../../mods:name/mods:namePart[@type='termsOfAddress']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'contributorTA_s')" />					
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<!--Contributor -->
		<!--orginInfo -->
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:originInfo/mods:place/mods:placeTerm">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_s', 'placeOfPublication_s')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>


		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:physicalDescription/*">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'physicalDescription_s')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>


		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:originInfo/mods:publisher">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'publisher_s')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:originInfo/mods:dateCreated[@keyDate='yes']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'dateCreated_dt')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:dateCaptured">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'dateDigitized_dt')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:originInfo/mods:dateIssued">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'dateIssued_dt')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:originInfo/mods:copyrightDate">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'dateCopyright_dt')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<!--orginInfo> -->
		<!--physicalDescription -->
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:physicalDescription/mods:extent">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'extent_t')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:physicalDescription/mods:form">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mod_', 'form_s')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:physicalDescription/mods:digitalOrigin">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'digitalOrigin_s')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:physicalDescription/mods:note">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'notePhysical_t')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<!--physicalDescription -->

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:language/languageTerm[@type='text']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'language_s')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:subTitle">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'subTitle_s')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>


		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:abstract">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'description_t')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>


		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:genre">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'genre_s')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>


		</xsl:for-each>


		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:note[@type='statement of responsibility']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'sor_t')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:note[@type='admin']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'noteAdmin_t')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<!--subjects -->
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:subject/mods:topic">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'topic_s')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:subject/mods:name[@type='corporate']/mods:namePart">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
				<xsl:value-of select="concat('mods_', 'organization_s')" />
			</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>


		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:subject/mods:name[@type='personal']/mods:namePart">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
				<xsl:value-of select="concat('mods_', 'people_s')" />
			</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:subject/mods:temporal">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
				<xsl:value-of select="concat('mods_', 'dates_dt')" />
			</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:subject/mods:geographic">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
				<xsl:value-of select="concat('mods_', 'geographic_s')" />
			</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>
		<!--subject -->

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:country">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
				<xsl:value-of select="concat('mods_', 'country_s')" />
			</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>


		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:county">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'county_s')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:region">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'region_s')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:city">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'city_s')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:citySection">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'city_s')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:originInfo/mods:edition">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'edition_s')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>



		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:accessCondition[@type='useAndReproduction']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'rightsStatement_t')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>



		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:originInfo/mods:issuance">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'issuance_t')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>



		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:relatedItem[@type='host']//title">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'hostObject_t')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:relatedItem[@type='constituent']//title">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'constituentObject_t')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:relatedItem[@type='series']//title">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'series_s')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:identifier[@type='local']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'localIdentifier_s')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:identifier[@type='isbn']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
					<xsl:value-of select="concat('mods_', 'isbn_')" />
				</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:identifier[@type='issn']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'issn_')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:location/url[@usage='primary display']">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'handle_')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>

		</xsl:for-each>

		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:recordInfo//languageOfCataloging/languageTerm">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('mods_', 'languageOfCataloging_s')" />
					</xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>


			<!-- this is for coordinates, will be used for map pins -->
		</xsl:for-each>
		<xsl:for-each
			select="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]/foxml:xmlContent//mods:subject/mods:cartographics/mods:coordinates">
			<xsl:if test="text() [normalize-space(.) ]"><!--don't bother with empty space -->
				<field>
					<xsl:attribute name="name">
            <xsl:value-of select="concat('mods_', 'coordinates_s')" />          
          </xsl:attribute>
					<xsl:value-of select="text()" />
				</field>
			</xsl:if>
		</xsl:for-each>

		<!-- an example of handling a managed datastream-->
		<!--<xsl:template name="TEI">
  
    <xsl:variable name="PROT">
      http
    </xsl:variable>
    <xsl:variable name="FEDORAUSERNAME">
      fedoraAdmin
    </xsl:variable>
    <xsl:variable name="FEDORAPASSWORD">
      anonymous
    </xsl:variable>
    <xsl:variable name="HOST">
      test.testy.edu
    </xsl:variable>
    <xsl:variable name="PORT">
      8080
    </xsl:variable>
    <xsl:variable name="TEI"
      select="document(concat($PROT, '://', $FEDORAUSERNAME, ':', $FEDORAPASSWORD, '@', $HOST, ':', $PORT, '/fedora/objects/', $PID, '/datastreams/', 'TEI', '/content'))" />

    <xsl:for-each select="$TEI//tei:surname[text()]">
      <field>
        <xsl:attribute name="name">
            <xsl:value-of select="concat('tei_', 'surname_s')" />
            </xsl:attribute>
        <xsl:value-of select="normalize-space(text())" />
      </field>
    </xsl:for-each>
    <xsl:for-each select="$TEI//tei:placeName/*[text()]">
      <field>
        <xsl:attribute name="name">
            <xsl:value-of select="concat('tei_', 'placeName_s')" />
          </xsl:attribute>
        <xsl:value-of select="normalize-space(text())" />
      </field>
    </xsl:for-each>
    <xsl:for-each select="$TEI//tei:orgName[text()]">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat('tei_', 'orgName_s')" />
        </xsl:attribute>
        <xsl:value-of select="normalize-space(text())" />
      </field>
    </xsl:for-each>

  </xsl:template>-->
	</xsl:template>
</xsl:stylesheet>	

<?xml version="1.0" encoding="UTF-8"?>
<!-- Set of commonly used fields suffixed with "all" -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:xlink="http://www.w3.org/1999/xlink"
     exclude-result-prefixes="mods">

     <xsl:template match="mods:mods/mods:titleInfo/mods:title" mode="slurp_all_suffix">
       <xsl:call-template name="mods_all_suffix">
         <xsl:with-param name="field_name" select="'titleInfo_title_all'"/>
         <xsl:with-param name="content" select="normalize-space()"/>
       </xsl:call-template>
     </xsl:template>
     <xsl:template match="mods:mods/mods:subject//*" mode="slurp_all_suffix">
       <xsl:call-template name="mods_all_suffix">
         <xsl:with-param name="field_name" select="'subject_descendants_all'"/>
         <xsl:with-param name="content" select="normalize-space()"/>
       </xsl:call-template>
     </xsl:template>
     <xsl:template match="mods:mods/mods:genre" mode="slurp_all_suffix">
       <xsl:call-template name="mods_all_suffix">
         <xsl:with-param name="field_name" select="'genre_all'"/>
         <xsl:with-param name="content" select="normalize-space()"/>
       </xsl:call-template>
     </xsl:template>
     <xsl:template match="mods:mods/mods:name[mods:role/mods:roleTerm[@authority= 'marcrelator' and @type = 'text']][. = 'contributor']/mods:namePart" mode="slurp_all_suffix">
       <xsl:call-template name="mods_all_suffix">
         <xsl:with-param name="field_name" select="'name_contributor_namePart_all'"/>
         <xsl:with-param name="content" select="normalize-space()"/>
       </xsl:call-template>
     </xsl:template>
     <xsl:template match="mods:mods/mods:name[mods:role/mods:roleTerm[@authority= 'marcrelator' and @type = 'text']][. = 'creator']/mods:namePart" mode="slurp_all_suffix">
       <xsl:call-template name="mods_all_suffix">
         <xsl:with-param name="field_name" select="'name_creator_namePart_all'"/>
         <xsl:with-param name="content" select="normalize-space()"/>
       </xsl:call-template>
     </xsl:template>
     <xsl:template match="mods:mods/mods:name[mods:role/mods:roleTerm[@authority= 'marcrelator' and @type = 'text']][. = 'author']/mods:namePart" mode="slurp_all_suffix">
       <xsl:call-template name="mods_all_suffix">
         <xsl:with-param name="field_name" select="'name_author_namePart_all'"/>
         <xsl:with-param name="content" select="normalize-space()"/>
       </xsl:call-template>
     </xsl:template>
     <xsl:template match="mods:mods/mods:physicalDescription/mods:form" mode="slurp_all_suffix">
       <xsl:call-template name="mods_all_suffix">
         <xsl:with-param name="field_name" select="'physicalDescription_form_all'"/>
         <xsl:with-param name="content" select="normalize-space()"/>
       </xsl:call-template>
     </xsl:template>
     <xsl:template match="mods:mods/mods:identifier" mode="slurp_all_suffix">
       <xsl:call-template name="mods_all_suffix">
         <xsl:with-param name="field_name" select="'indentifier_all'"/>
         <xsl:with-param name="content" select="normalize-space()"/>
       </xsl:call-template>
     </xsl:template>

   <!-- Writes a Solr field. -->
     <xsl:template name="mods_all_suffix">
       <xsl:param name="field_name"/>
       <xsl:param name="content"/>
       <xsl:if test="not(normalize-space($content) = '')">
         <field>
           <xsl:attribute name="name">
             <xsl:value-of select="concat('mods_', $field_name, '_ms')"/>
           </xsl:attribute>
           <xsl:value-of select="$content"/>
         </field>
       </xsl:if>
     </xsl:template>
</xsl:stylesheet>

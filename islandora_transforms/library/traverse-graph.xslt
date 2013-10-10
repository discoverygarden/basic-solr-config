<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:res="http://www.w3.org/2001/sw/DataAccess/rf1/result"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:set="http://exslt.org/sets"
  xmlns:encoder="xalan://java.net.URLEncoder">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:param name="debug" select="true"/>

  <!-- traverse the graph -->
  <xsl:template name="_traverse_graph">
    <xsl:param name="risearch">http://localhost:8080/fedora/risearch</xsl:param>
    <xsl:param name="to_traverse_in"/>
    <xsl:param name="traversed_in"/>
    <xsl:param name="query"/>
    
    <xsl:variable name="traverse" select="xalan:nodeset($to_traverse_in)"/>
    <xsl:if test="$debug">
      <xsl:message>Traverse:
  <xsl:for-each select="$traverse//*[@uri]">
    <xsl:value-of select="name()"/>:<xsl:value-of select="@uri"/>
  </xsl:for-each>
      </xsl:message>
    </xsl:if>
    <xsl:variable name="traversed" select="xalan:nodeset($traversed_in)"/>
    <xsl:if test="$debug">
      <xsl:message>Traversed:
  <xsl:for-each select="$traversed//*[@uri]">
    <xsl:value-of select="name()"/>:<xsl:value-of select="@uri"/>
  </xsl:for-each>
      </xsl:message>
    </xsl:if>
    <xsl:variable name="difference" select="xalan:nodeset(set:difference($traverse, $traversed))"/>
    <xsl:if test="$debug">
      <xsl:message>Difference:
  <xsl:value-of select="count($difference/res:result/res:obj)"/>
  <xsl:for-each select="$difference//*[@uri]">
    <xsl:value-of select="name()"/>:<xsl:value-of select="@uri"/>
  </xsl:for-each>
      </xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count($difference/res:result/res:obj) = 0">
  <!-- There is nothing to traverse which has not already been traversed... -->
  <xsl:if test="$debug">
    <xsl:message>
      To index:
      <xsl:for-each select="$traversed//*[@uri]">
        <xsl:value-of select="@uri"/>
      </xsl:for-each>
    </xsl:message>
  </xsl:if>
  <xsl:copy-of select="$traversed/res:result/res:obj"/>
      </xsl:when>
      <xsl:otherwise>
  <xsl:variable name="to_traverse">
    <res:result>
      <xsl:for-each select="$difference/res:result/res:obj">
        <xsl:if test="$debug">
    <xsl:message>diff: <xsl:value-of select="@uri"/></xsl:message>
        </xsl:if>
        <xsl:variable name="query_results">
    <xsl:call-template name="perform_traversal_query">
                  <xsl:with-param name="risearch" select="$risearch"/>
      <xsl:with-param name="query">
        <xsl:value-of select="substring-before($query, '%PID_URI%')"/>
        <xsl:value-of select="@uri"/>
        <xsl:value-of select="substring-after($query, '%PID_URI%')"/>
      </xsl:with-param>
      <xsl:with-param name="lang">sparql</xsl:with-param>
    </xsl:call-template>
        </xsl:variable>
        <xsl:copy-of select="xalan:nodeset($query_results)/res:sparql/res:results/res:result/res:obj"/>
      </xsl:for-each>
    </res:result>
  </xsl:variable>

  <xsl:call-template name="_traverse_graph">
          <xsl:with-param name="risearch" select="$risearch"/>
    <xsl:with-param name="to_traverse_in" select="set:distinct(xalan:nodeset($to_traverse))"/>
    <xsl:with-param name="traversed_in">
      <res:result>
        <xsl:copy-of select="$traversed/res:result/res:obj | $difference/res:result/res:obj"/>
      </res:result>
    </xsl:with-param>
    <xsl:with-param name="query" select="$query"/>
  </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="perform_traversal_query">
      <xsl:param name="risearch">http://localhost:8080/fedora/risearch</xsl:param>
      <xsl:param name="query"/>
      <xsl:param name="lang">itql</xsl:param>
      <xsl:param name="additional_params"/>
      
      <xsl:variable name="encoded_query" select="encoder:encode(normalize-space($query))"/>
      
      <xsl:variable name="query_url" select="concat($risearch, '?query=', $encoded_query, '&amp;lang=', $lang, $additional_params)"/>
      <xsl:copy-of select="document($query_url)"/>
  </xsl:template>
</xsl:stylesheet>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Some parameters used in the main foxmlToSolr.xslt. -->
  <!--
    "index_ancestors": "false()" to disable "ancestors_ms" indexing, "true()" to enable it.
  -->
  <xsl:param name="index_ancestors" select="false()"/>
</xsl:stylesheet>

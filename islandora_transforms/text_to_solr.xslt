<?xml version="1.0" encoding="UTF-8"?>
<!-- OCR glob into one field for indexing-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- Datastreams: OCR, TEXT, FULL_TEXT, ocr, text, full_text, fullText
        will probably need to have many templates match and feed into one?
    -->
    <xsl:template match="foxml:datastream[@ID='OCR']/foxml:datastreamVersion[last()]" name="index_text">
    <xsl:variable name="OCR"
    select="document(concat($PROT, '://', $FEDORAUSERNAME, ':', $FEDORAPASSWORD, '@', $HOST, ':', $PORT, '/fedora/objects/', $PID, '/datastreams/', 'OCR', '/content'))" />
    
    </xsl:template>

</xsl:stylesheet>
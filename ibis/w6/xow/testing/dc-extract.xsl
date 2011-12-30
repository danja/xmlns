<xsl:stylesheet 
    xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:h    ="http://www.w3.org/1999/xhtml"
    xmlns      ="http://www.w3.org/1999/xhtml"
    xmlns:DubC ="http://purl.org/dc/elements/1.1/"
    xmlns:rdf  ="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

<h:p>$Id: dc-extract.xsl,v 1.3 2004/01/16 23:23:35 connolly Exp $</h:p>


<xsl:output method="xml" indent="yes"/>

  <xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

  <xsl:variable name="lc">abcdefghijklmnopqrstuvwxyz</xsl:variable>


<xsl:template match="h:html">
 <rdf:RDF>
   <rdf:Description rdf:about="">
     <xsl:apply-templates/>
   </rdf:Description>
 </rdf:RDF>
</xsl:template>

<xsl:template match="h:meta[starts-with(@name, 'DC.')]">
  <xsl:element name="{translate(substring-after(@name, '.'),$uc,$lc)}" namespace='http://purl.org/dc/elements/1.1/' >
    <xsl:value-of select='@content'/>
  </xsl:element>
</xsl:template>

<!-- don't pass text thru -->
<xsl:template match="text()|@*">
</xsl:template>


</xsl:stylesheet>

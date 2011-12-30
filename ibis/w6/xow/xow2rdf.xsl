<?xml version='1.0'?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:w6="http://purl.org/ibis/w6#">
			
<xsl:output indent="yes" method="xml" />
  
<!-- HTML -->
<xsl:template match="xhtml:html">
	<rdf:RDF>
		<xsl:apply-templates/>
	</rdf:RDF>
</xsl:template>
  
<!-- HEAD -->
<xsl:template match="xhtml:head">
	<rdf:Description rdf:about="">
		<xsl:apply-templates/>
	</rdf:Description>
</xsl:template>
  
<!-- TITLE -->
<xsl:template match="xhtml:title">
	<xsl:element name="dc:title">
		<xsl:value-of select="text()"/>
	</xsl:element>
	
	<xsl:apply-templates/>
  </xsl:template>
  
<!-- BODY -->
<xsl:template match="xhtml:body">
	<xsl:apply-templates/>
</xsl:template>
  
<!-- UL -->
<xsl:template match="xhtml:ul | xhtml:ol">
	<xsl:element name="w6:Idea" > 	
		<xsl:attribute name="rdf:nodeID">	
			<xsl:value-of select="@id" />
		</xsl:attribute>
		<xsl:element name="dc:title">
       			<xsl:value-of select="@title"/>
		</xsl:element>
		<xsl:apply-templates/>
	</xsl:element>
</xsl:template>

<!-- LI -->  
<xsl:template match="xhtml:li">
	<xsl:element name="w6:{current()/@class}" >
		<xsl:choose>
			<!-- if there's a link, use it as a resource -->	
			<xsl:when test="xhtml:a/@href">    	
				<xsl:attribute name="rdf:resource">	
					<xsl:value-of select="xhtml:a/@href" />
				</xsl:attribute>
				<xsl:element name="dc:title">
       					<xsl:value-of select="xhtml:a/text()"/>
				</xsl:element>
			</xsl:when>
				<!-- if there are no child elements, use the text as the title of a blank node -->
					<xsl:when test="count(./*) = 0">
						<xsl:attribute name="rdf:parseType">Resource</xsl:attribute>
						<xsl:element name="dc:title">
       							<xsl:value-of select="text()"/>
						</xsl:element>
					</xsl:when>
				<!-- if there is a  P child node, use the contained text as the title of a blank node -->
					<xsl:when test="count(./*) = 1">
						<xsl:if test="./xhtml:p">
							<xsl:attribute name="rdf:parseType">Resource</xsl:attribute>
							<xsl:element name="dc:title">
       								<xsl:value-of select="*/text()"/>
							</xsl:element>
						</xsl:if>
					</xsl:when>
		</xsl:choose>
		<!-- xsl:value-of select="text()" / -->
		<xsl:apply-templates select="xhtml:ul" />
	</xsl:element>
</xsl:template>


 
<!-- eat text --> 
<xsl:template match="text()">
 <!-- yummy! -->
</xsl:template>
  
</xsl:stylesheet>

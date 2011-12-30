<?xml version='1.0'?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:w6="http://purl.org/ibis/w6#">
			
<xsl:output indent="no" method="text" />
<xsl:strip-space elements="*" />  
<!-- HTML -->
<xsl:template match="xhtml:html">&lt;!DOCTYPE NETSCAPE-Bookmark-file-1&gt;
	&lt;TITLE&gt;Bookmarks&lt;/TITLE&gt;
	&lt;H1&gt;Bookmarks generated from XOW&lt;/H1&gt;
	&lt;DL&gt;&lt;DT>&lt;H3&gt;XOW Bookmarks Folder&lt;/H3&gt;
	<xsl:apply-templates/>
	&lt;/DL&gt;
</xsl:template>
  
<!-- HEAD -->
<xsl:template match="xhtml:head">
	<!-- nothing to see here -->
		<xsl:apply-templates/>
</xsl:template>
  
<!-- TITLE -->
<xsl:template match="xhtml:title">
	&lt;title&gt;<xsl:value-of select="text()"/>&lt;/title&gt;
	<xsl:apply-templates/>
  </xsl:template>
  
<!-- BODY -->
<xsl:template match="xhtml:body">
	<xsl:apply-templates/>
</xsl:template>
  
<!-- UL -->
<xsl:template match="xhtml:ul | xhtml:ol">
		&lt;DL&gt;&lt;p&gt;&lt;DT&gt;&lt;H3&gt;<xsl:value-of select="@title"/>&lt;/H3&gt;
		<xsl:apply-templates/>
		&lt;/DL&gt;&lt;p&gt;
</xsl:template>

<!-- LI -->  
<xsl:template match="xhtml:li">
	<xsl:text>&lt;DT&gt;</xsl:text>
	<xsl:choose>
			<!-- if there's a link, use it as a resource -->	
			<xsl:when test="xhtml:a"> 
			&lt;a href="<xsl:value-of select="xhtml:a/@href" />"&gt;<xsl:value-of select="xhtml:a/text()" />&lt;/a&gt;
			</xsl:when>
				<!-- if there are no child elements, stick the text in -->
					<xsl:when test="count(./*) = 0">
       							<xsl:value-of select="text()"/>
					</xsl:when>
				<!-- if there is a  P child node, use the contained text as the title of a blank node -->
					<xsl:when test="count(./*) = 1">
						<xsl:if test="./xhtml:p">
							<xsl:copy-of select="xhtml:p" />
						</xsl:if>
					</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="xhtml:ul" />

</xsl:template>


 
<!-- eat text --> 
<xsl:template match="text()">
 <!-- yummy! -->
</xsl:template>
  
</xsl:stylesheet>

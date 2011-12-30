<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:res="http://www.w3.org/2005/sparql-results#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="res xsl rdf xhtml">

  <xsl:output
    method="html" 
    encoding="UTF-8" 
/>

  <xsl:template match="/res:sparql">
    <html>
      <head profile="http://www.w3.org/2006/03/hcard">
	<title>hCard</title>
	<style type="text/css">
	 body {
	background-color: #fff;
	font-size: small;
	margin: 0;
	padding: 1em 1em 2em 1em;	
	font-family: "Trebuchet MS", sans-serif;
	font-weight: 500;
	letter-spacing: 0.07em;
	line-height: 140%;
	color: #000; 
}

a {color: #b06030; text-decoration : none; }
.tel:before {
	content: "Telephone: ";
	color:  #000;
	background-color: transparent;
}

.vcard {	
	display: block;
	padding: 5px 5px 5px 0.5em;
	border: 1px solid #c0c0c0;
	width: 20%;
	min-width: 220px;
     min-height: 70px;
	background-color: #F5F5F5;
	}
img { float:left; margin-right:4px;  height:5em }

/* CSS in part derived from http://www.crowley.nl/hcard.html */
	</style>
      </head>
      <body>
	<xsl:apply-templates select="res:results" />
      </body>
    </html>
  </xsl:template>


  <xsl:template match="/res:sparql/res:results">
    <xsl:for-each select="res:result">

<!-- only show the first -->
 <xsl:if test="not(res:binding[@name='homepage']/res:uri=preceding::res:binding[@name='homepage']/res:uri)">

<br/>	
      <xsl:variable name="name" select="res:binding[@name='name']/res:literal" />	
      <xsl:variable name="homepage" select="res:binding[@name='homepage']/res:uri" />	
	<xsl:variable name="photo" select="res:binding[@name='photo']/res:uri" />	
<xsl:variable name="mbox" select="res:binding[@name='mbox']/res:uri" />	
	
<div class="vcard">
<xsl:if test="res:binding[@name='photo']/res:uri">
  <img src="{$photo}" alt="{$name}" class="photo"/>
</xsl:if>
<xsl:choose>
<xsl:when test="res:binding[@name='homepage']/res:uri">
 <a class="url fn" href="{$homepage}"><xsl:value-of select="$name" /></a>
 </xsl:when>
 <xsl:otherwise>
 <xsl:value-of select="$name" />
  </xsl:otherwise>
  </xsl:choose>
</div>

 </xsl:if>
    </xsl:for-each>
</xsl:template>

<xsl:template match="text()"/>
</xsl:stylesheet>

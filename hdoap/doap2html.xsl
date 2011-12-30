<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns="http://www.w3.org/1999/xhtml"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
				xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
				xmlns:dc="http://purl.org/dc/elements/1.1/"
				xmlns:foaf="http://xmlns.com/foaf/0.1/"
				xmlns:doap="http://usefulinc.com/ns/doap#"
				>
  
  <xsl:output method="xml" indent="yes" encoding="utf-8" />
  
  <xsl:template match="/"> 
	<xsl:apply-templates select="/rdf:RDF/doap:Project|/doap:Project" />
  </xsl:template> 
  
  <xsl:template match="/rdf:RDF/doap:Project|/doap:Project"> 
	<html>
	  <head profile="http://purl.org/stuff/hdoap/profile">
		<title><xsl:value-of select="doap:name/text()"/></title>
		<link rel="transformation" href="http://purl.org/stuff/hdoap/hdoap2doap.xsl" />  
		<link href="http://purl.org/stuff/hdoap/hdoap.css" rel="stylesheet" type="text/css" />	  
	  </head>
	  <body>
		<div class="Project">
		  <h1>Project: <xsl:value-of select="doap:name/text()"/></h1>
		  <div class="project-details">
			<xsl:apply-templates select="*[count(*)=0]" />
		  </div>
		  <xsl:apply-templates select="doap:release"/>
		  <xsl:apply-templates select="doap:repository" />
		  <xsl:apply-templates select="doap:maintainer" />
		</div>
		<xsl:apply-templates select="/rdf:RDF/rdf:Description" /> 
	  </body>
	</html>
  </xsl:template>
  
  <!--  Properties with Literal subjects -->
  <xsl:template match="doap:name|doap:created|doap:shortdesc|doap:description|doap:revision|foaf:name|foaf:mbox_sha1sum|doap:anon-root|doap:module">
	<p>
	  <span class="literal-label"><xsl:value-of select="local-name()" /></span> :  
	  <span class="literal-value">
		<xsl:attribute name="class"><xsl:value-of select="local-name()" /></xsl:attribute>
		<xsl:if test="@xml:lang">
		  <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang" /></xsl:attribute>
		</xsl:if> 
		<xsl:value-of select="text()" />
	  </span>
	</p>
  </xsl:template>
  
  <!-- Properties with Resource subjects -->
  <xsl:template match="doap:homepage|doap:mailing-list|doap:download-page|doap:download-mirror|doap:category|doap:license|rdfs:seeAlso|doap:browse|foaf:mbox|foaf:homepage">
	<p>
	  <span class="resource-label"><xsl:value-of select="local-name()" /></span> :  
	  <span class="resource-value">
	  <a>
		<xsl:attribute name="class"><xsl:value-of select="local-name()" /></xsl:attribute>
		<xsl:attribute name="href"><xsl:value-of select="@rdf:resource" /></xsl:attribute>
		<xsl:value-of select="@rdf:resource" />  
	  </a>
	  </span>
	</p>
  </xsl:template>
  
  <!-- Release subsection -->
  <xsl:template match="doap:release">
	<div class="release">
	  <h2>Release</h2>
	  <div class="Version">
		<xsl:apply-templates select="./doap:Version/*" />
	  </div>
	</div>
  </xsl:template>
  
  <!-- Maintainer subsection -->
  <xsl:template match="doap:maintainer">
	<div class="maintainer">
	  <h2>Maintainer</h2>
	  <div class="Person">
		<xsl:apply-templates select="./foaf:Person/*" />
	  </div>
	</div>
  </xsl:template>
  
  <!-- Repository subsection -->
  <xsl:template match="doap:repository">
	<div class="repository">
	  <h2>Repository</h2>
	  <div>
		<xsl:attribute name="class"><xsl:value-of select="local-name(./*)"/></xsl:attribute>
		<xsl:apply-templates select="./*/*" />
	  </div>
	</div>
  </xsl:template>
  
  <!-- Maker subsection -->
  <xsl:template match="/rdf:RDF/rdf:Description/foaf:maker">
	<div class="maker">
	  <h3>Maker of DOAP Profile</h3>
	  <div class="Person">
		<xsl:apply-templates select="./foaf:Person/*" />
	  </div>
	</div>
  </xsl:template>
  
</xsl:stylesheet>
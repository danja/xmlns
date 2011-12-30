<?xml version='1.0'?>
<!--
     OpenSocial Person Data Atomishness to RDF/XML
     first pass : danja : 2007-11-02
-->
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:awol="http://purl.org/stuff/Atom#"
		xmlns:georss='http://www.georss.org/georss' 
		xmlns:gd='http://schemas.google.com/g/2005'
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:gml="http://www.opengis.net/gml"
		xmlns ="http://xmlns.com/foaf/0.1/"

>
<xsl:output method="xml" media-type="application/rdf+xml" indent="yes" />

<xsl:template match="/">
  <rdf:RDF>
    <xsl:apply-templates />
  </rdf:RDF>
</xsl:template>

<!-- *** RFC 4287 : 4.1. Container Elements ***-->

  <xsl:template match="atom:entry">
    <Person>
	<xsl:apply-templates/>
    </Person>
  </xsl:template>

  <xsl:template match="atom:id">
   <primaryTopicOf rdf:resource="{text()}" />
  </xsl:template>

  <xsl:template match="atom:updated">
   <dc:modified><xsl:value-of select="text()" /></dc:modified>
  </xsl:template>

  <xsl:template match="atom:title">
   <name><xsl:value-of select="text()" /></name>
  </xsl:template>

  <xsl:template match="atom:link">
      <xsl:if test="@rel='thumbnail'">
	<depiction>
	  <Image><!-- this would be the big version -->
	    <thumbnail rdf:resource="{@href}" />
	  </Image>
	</depiction>
      </xsl:if>
      <xsl:if test="@rel='alternate'"><!-- tempted to use rdfs:seeAlso, but erring on the side of caution -->
	  <dc:related rdf:resource="{@href}" />
      </xsl:if>
      <xsl:if test="@rel='self'">
	  <dc:source rdf:resource="{@href}" />
      </xsl:if>
  </xsl:template>

  <xsl:template match="georss:where">
    <based_near>
      <xsl:copy-of select="gml:Point" />
    </based_near>
  </xsl:template>

<!-- stuff below is from Atom2RDF, may or may not be useful later... -->

  <xsl:template match="atom:content">
    <content>
      <Content>
	<xsl:if test="@type">
	  <type><xsl:value-of select="@type"/></type>
	</xsl:if>
	<body rdf:parseType="Literal">
	  <xsl:copy-of select="child::node()" />
	  <!-- TODO <xsl:value-of select="@base"/> -->
	  <!-- TODO <xsl:value-of select="@lang"/> -->
	</body>
      </Content>
    </content>
  </xsl:template>

  <!-- *** RFC 4287 : 3.2. Person Constructs *** -->
  
  <xsl:template match="atom:name">
    <name><xsl:value-of select="text()" /></name>
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="atom:uri">
    <uri rdf:resource="{text()}" />
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="atom:email">
    <email rdf:resource="mailto:{text()}" />
      <xsl:apply-templates/>
  </xsl:template>

<!-- *** RFC 4287 : 4.2. Metadata Elements *** -->

  <xsl:template match="atom:author">
    <author>
      <Person>
	<xsl:apply-templates/>
      </Person>
    </author>
  </xsl:template>

  <xsl:template match="atom:category">
    <!-- TODO should this concatenate scheme+term? -->
  </xsl:template>

  <xsl:template match="atom:contributor">
    <contributor>
      <Person>
	<xsl:apply-templates/>
      </Person>
    </contributor>
  </xsl:template>

  <xsl:template match="atom:generator">
    <generator>
      <Generator>
	<xsl:apply-templates />
      </Generator>
    </generator>
  </xsl:template>

<xsl:template match="atom:version">
  <generatorVersion><xsl:value-of select="@version"/></generatorVersion>
</xsl:template>

  <xsl:template match="atom:icon">
    <!-- TODO -->
  </xsl:template>



  <xsl:template match="atom:logo">
    <!-- TODO -->
  </xsl:template>

  <xsl:template match="atom:published">
    <published><xsl:value-of select="text()"/></published>
  </xsl:template>

  <xsl:template match="atom:rights">
   <rights><xsl:value-of select="text()"/></rights>
  </xsl:template>

  <xsl:template match="atom:source">
       <source rdf:resource="{text()}"/>
  </xsl:template>

  <xsl:template match="atom:subtitle">
   :subtitle """<xsl:value-of select="text()" />""" ;
      <!-- TODO <xsl:value-of select="@type" /> -->
  </xsl:template>

  <xsl:template match="atom:summary">
    <!-- TODO -->
  </xsl:template>


 
  <xsl:template match="text()" />

</xsl:stylesheet>

<?xml version='1.0'?>
<!--
      Transforms Atom Syndication Format [1]
      into RDF/XML according to Atom/OWL [2]

      XSLT 1.0

      [1] http://www.ietf.org/rfc/rfc4287.txt
      [2] http://bblfish.net/work/atom-owl/2006-06-06/AtomOwl.html

      Danny Ayers, 2007-09-19

-->
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:awol="http://purl.org/stuff/Atom#"
		xmlns="http://purl.org/stuff/Atom#"
>
<xsl:output method="xml" media-type="application/rdf+xml" indent="yes" />

<xsl:template match="/">
  <rdf:RDF>
    <xsl:apply-templates />
  </rdf:RDF>
</xsl:template>

<!-- *** RFC 4287 : 4.1. Container Elements ***-->

  <xsl:template match="atom:feed">
   <Feed rdf:about="">
	<xsl:apply-templates />
   </Feed>
  </xsl:template>

  <xsl:template match="atom:entry">
    <entry>
      <Entry>
	<!-- for RSS 1.0 style IDs -->
	<!-- Entry rdf:about="{atom:id}" -->
	<xsl:apply-templates/>
      </Entry>
    </entry>
  </xsl:template>

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

  <xsl:template match="atom:id">
   <id rdf:resource="{text()}" />
  </xsl:template>

  <xsl:template match="atom:link">
      <!-- longwinded, but don't really want lots of "" values -->
      <xsl:if test="@href">
	<link>
	  <Link>
	    <rel>iana:alternate</rel>
	    <to rdf:parseType="Resource">
	      <src rdf:resource="{@href}" />
	    </to>
	  </Link>
	</link>
      </xsl:if>

      <xsl:if test="@hreflang">
	 <!-- TODO <xsl:value-of select="@hreflang"/> -->
      </xsl:if>
      <xsl:if test="@rel">
	 <!-- TODO 	  <xsl:value-of select="@rel"/> -->
      </xsl:if>
      <xsl:if test="@type">
	 <!-- TODO  <xsl:value-of select="@type"/> -->
      </xsl:if>
      <xsl:if test="@length">
         <!--  TODO <xsl:value-of select="@length"/> -->
      </xsl:if>
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

  <xsl:template match="atom:title">
   <title><xsl:value-of select="text()" /></title>
      <!-- TODO <xsl:value-of select="@type" /> - how??? -->
  </xsl:template>

  <xsl:template match="atom:updated">
   <updated><xsl:value-of select="text()"/></updated>
  </xsl:template>
 
  <xsl:template match="text()" />

</xsl:stylesheet>

<?xml version='1.0'?>
<!--
      Transforms Atom Syndication Format [1]
      into Turtle/N3 according to Atom/OWL [2]

      XSLT 1.0

      [1] http://www.ietf.org/rfc/rfc4287.txt
      [2] http://bblfish.net/work/atom-owl/2006-06-06/AtomOwl.html

      Danny Ayers, 2006-11-26

-->
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:awol="http://purl.org/stuff/Atom#"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
>
<xsl:output method="text" media-type="text/rdf+n3" />

<xsl:template match="/">
@prefix : &lt;http://bblfish.net/work/atom-owl/2006-06-06/#&gt; .
@prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt; .
@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
@prefix foaf: &lt;http://xmlns.com/foaf/0.1/&gt; .
@prefix iana: &lt;http://www.iana.org/assignments/relation/&gt; .
@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt; .
      <xsl:apply-templates />
  </xsl:template>

<!-- *** RFC 4287 : 4.1. Container Elements ***-->

  <xsl:template match="atom:feed">
   [] a :Feed ;
	<xsl:apply-templates />
  .
  </xsl:template>

  <xsl:template match="atom:entry">
    :entry [  a :Entry;
      <xsl:apply-templates/>
    ]
  </xsl:template>

  <xsl:template match="atom:content">
    :content [ a :Content;
    <xsl:if test="@type">
        :type "<xsl:value-of select="@type"/>";
    </xsl:if>
        :body """
            <xsl:copy-of select="child::node()" />
              """
       <!-- TODO <xsl:value-of select="@base"/> -->
       <!-- TODO <xsl:value-of select="@lang"/> -->
     ] ;
  </xsl:template>

<!-- *** RFC 4287 : 3.2. Person Constructs *** -->

  <xsl:template match="atom:name">
    :name "<xsl:value-of select="text()" />" ;
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="atom:uri">
    :uri "<xsl:value-of select="text()" />" ;
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="atom:email">
    :email &lt;mailto:<xsl:value-of select="text()" />&gt; ;
      <xsl:apply-templates/>
  </xsl:template>

<!-- *** RFC 4287 : 4.2. Metadata Elements *** -->

  <xsl:template match="atom:author">
 :author [ a :Person;
      <xsl:apply-templates/>
    ] ;
  </xsl:template>

  <xsl:template match="atom:category">
    <!-- TODO -->
  </xsl:template>

  <xsl:template match="atom:contributor">
 :contributor [ a :Person;
      <xsl:apply-templates/>
    ] ;
  </xsl:template>

  <xsl:template match="atom:generator">
 :generator [ a :Generator;
               :uri &lt;<xsl:value-of select="@uri"/>&gt;;
               :generatorVersion "<xsl:value-of select="@version"/>";
               :name """
    <xsl:value-of select="text()"/>
  """];
  </xsl:template>

  <xsl:template match="atom:icon">
    <!-- TODO -->
  </xsl:template>

  <xsl:template match="atom:id">
   :id "<xsl:value-of select="text()" />"^^xsd:anyURI;
  </xsl:template>

  <xsl:template match="atom:link">
      <!-- longwinded, but don't really want lots of "" values -->
      <xsl:if test="@href">
    :link [ a :Link;
           :rel iana:alternate ;
           :to [ :src &lt;<xsl:value-of select="@href"/>&gt;;]
           ];
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
   :published "<xsl:value-of select="text()"/>"^^xsd:dateTime;
  </xsl:template>

  <xsl:template match="atom:rights">
   :rights "<xsl:value-of select="text()"/>" ;
  </xsl:template>

  <xsl:template match="atom:source">
    <!-- TODO -->
  </xsl:template>

  <xsl:template match="atom:subtitle">
   :subtitle """<xsl:value-of select="text()" />""" ;
      <!-- TODO <xsl:value-of select="@type" /> -->
  </xsl:template>

  <xsl:template match="atom:summary">
    <!-- TODO -->
  </xsl:template>

  <xsl:template match="atom:title">
   :title "<xsl:value-of select="text()" />" ;
      <!-- TODO <xsl:value-of select="@type" /> -->
  </xsl:template>

  <xsl:template match="atom:updated">
   :updated "<xsl:value-of select="text()"/>"^^xsd:dateTime;
  </xsl:template>







 
  <xsl:template match="text()" />

</xsl:stylesheet>

<?xml version='1.0'?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pets="http://purl.org/stuff/hedwig/"
	xml:base ="http://purl.org/stuff/hedwig/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:owl="http://www.w3.org/2002/07/owl"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:skosmap="http://www.w3c.rl.ac.uk/2003/11/21-skos-mapping"
	xmlns:wn="http://xmlns.com/wordnet/1.6/">
	
  <xsl:output indent="yes" method="html"/>
 
   <xsl:template match="rdf:RDF[owl:Ontology and owl:Class and (owl:DatatypeProperty or owl:ObjectProperty)]">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Hedwig Pet Vocabulary Specification</title>
     <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
       
    <div id="RDF">
     Base : <xsl:value-of select="@xml:base"/>
      <xsl:apply-templates/>
    </div>
    </body>
    </html>
  </xsl:template>
   
  <xsl:template match="rdfs:subClassOf">
    <div id="subClassOf">
    Subclass of : <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="skosmap:exactMatch">
    <div id="exactMatch">
    Exact match to : <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="owl:unionOf[owl:Class]">
    <div id="unionOf">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="owl:Class[(rdfs:comment or rdfs:label) and (rdfs:isDefinedBy or rdfs:seeAlso) and (owl:unionOf or skosmap:exactMatch)]">
    <div id="about">
	About : <xsl:value-of select="@rdf:about"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="dc:date">
	<div id="date">
     Date : <xsl:value-of select="."/>
     <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="dc:creator">
<div id="creator">
Creator : <xsl:value-of select="."/>
      <xsl:apply-templates/>
</div>
  </xsl:template>
  
  <xsl:template match="label">
  <div id="label">
    <xsl:value-of select="."/>
    </div>
      <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="rdfs:isDefinedBy">
    <div id="isDefinedBy">
      Defined by : <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="Ontology[title and creator and date and description and language and subject and seeAlso and imports and versionInfo]">
<div id="Ontology">
Ontology :         
	<xsl:value-of select="@rdf:about"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="dc:description">
	<div id="description">
	Description : <xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="dc:language">
    <div id="language">
    	Language : <xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="dc:subject">
    <div id="subject">
    Subject : <xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="owl:ObjectProperty">
    <div id="ObjectProperty">
      ObjectProperty = <xsl:value-of select="@rdf:ID"/>
      <!-- xsl:value-of select="@ID"/ -->
<br/>
 <!-- xsl:value-of select="@rdf:about"/ -->
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="owl:imports">
    <div id="imports">
Imports : <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="dc:title">
    <div id="title">
    Title : <xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="rdfs:comment">
    <div id="comment">
     Comment : <xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="owl:versionInfo">
    <div id="versionInfo">
      Version info : <xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="rdfs:domain">
    <div id="domain">
      Domain :
        <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="owl:DatatypeProperty[rdfs:label and rdfs:comment]">
    <div id="DatatypeProperty">
    DatatypeProperty :
        <xsl:value-of select="@rdf:about"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="rdfs:seeAlso">
    <div id="seeAlso">
    See also :
        <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  

  
  <xsl:template match="rdfs:range">
    <div id="range">
  Range :
        <xsl:value-of select="@rdf:resource"/>

      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="rdfs:subPropertyOf">
    <div id="subPropertyOf">
     Subproperty Of :   <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="owl:disjointWith">
    <div id="disjointWith">
Disjoint with : <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="rdfs:range">
    <div id="range">
     Range : <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
</xsl:stylesheet>

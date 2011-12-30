<?xml version='1.0'?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pet="http://purl.org/stuff/hedwig/"
	xml:base ="http://purl.org/stuff/hedwig/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:owl="http://www.w3.org/2002/07/owl"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:skosmap="http://www.w3c.rl.ac.uk/2003/11/21-skos-mapping"
	xmlns:wn="http://xmlns.com/wordnet/1.6/"
	xmlns:admin="http://webns.net/mvcb/">
	
  <xsl:output indent="yes" method="html"/>
  
    <xsl:template match="rdf:RDF[foaf:PersonalProfileDocument and pet:Pet]">
 <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>A Pet</title>
     <link href="pet.css" rel="stylesheet" type="text/css" />
    </head>
    <body>   
    
    <div id="RDF">
      <xsl:apply-templates/>
    </div>
    
    </body>
    </html>
  </xsl:template>
  
 <xsl:template match="pet:name">
 <div id="content2">
    <div id="petname">
     <h2><xsl:apply-templates/></h2>
    </div>
    </div>
  </xsl:template>
  
  
  <xsl:template match="foaf:maker">
   <div id="content3">
    <div id="foafmaker">
      <xsl:attribute name="rdf:nodeID">
        <xsl:value-of select="@rdf:nodeID"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:peculiarities">
  <div id="content1">
    <div id="petpeculiarities">
    Peculiarities : 
      <xsl:apply-templates/>
    </div></div>
  </xsl:template>
  
  <xsl:template match="admin:errorReportsTo">
   <div id="content3">
    <div id="adminerrorReportsTo">
      Admin contact :
        <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:hasID">
   <div id="content2">
    <div id="pethasID">
     ID : <xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="foaf:depiction">
  <div id="content2">
    <div id="foafdepiction">
    <img>
      <xsl:attribute name="src">
        <xsl:value-of select="@rdf:resource"/>
      </xsl:attribute>
     </img>
      <xsl:apply-templates/>
    </div></div>
  </xsl:template>
  
  <xsl:template match="pet:gender">
    <div id="content2">
    <div id="petgender">
      <xsl:apply-templates/>
    </div></div>
  </xsl:template>
  
  <xsl:template match="pet:fedBy[foaf:Person]">
   <div id="content2">
    <div id="petfedBy">
    Fed by : <xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div></div>
  </xsl:template>
  
  <xsl:template match="pet:favoriteFood">
   <div id="content1">
    <div id="petfavoriteFood">
       Favourite Food : 
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:neutered">
   <div id="content2">
    <div id="petneutered">
     Neutered :
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:primaryColor">
   <div id="content2">
    <div id="petprimaryColor">
    Primary color :
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:dislikes">
   <div id="content1">
    <div id="petdislikes">
  Dislikes : 
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:secondaryColors">
   <div id="content2">
    <div id="petsecondaryColors">
  Secondary colors :
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="foaf:mbox_sha1sum">
   <div id="content3">
    <div id="foafmbox_sha1sum">
    mbox_sha1sum : 
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:species">
   <div id="content2">
    <div id="petspecies">
    Species :  
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:furStyle">
   <div id="content2">
    <div id="petfurStyle">
      Fur Style : 
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:primaryTopic">
   <div id="content3">
    <div id="petprimaryTopic">
    Primary Topic (?) :
        <xsl:value-of select="@rdf:nodeID"/>
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="admin:generatorAgent">
   <div id="content3">
    <div id="admingeneratorAgent">
     Generator Agent :
        <xsl:value-of select="@rdf:resource"/>
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:breed">
   <div id="content2">
    <div id="petbreed">
      Breed :
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
 
  
  <xsl:template match="pet:Pet[pet:name and pet:gender and pet:fedBy and pet:hasID and foaf:depiction and pet:primaryColor and pet:secondaryColors and pet:species and pet:breed and pet:furStyle and pet:neutered and pet:favoriteFood and pet:likes and pet:dislikes and pet:peculiarities]">
  <div id="contentA">
    <div id="petPet">
        <!-- xsl:value-of select="@rdf:nodeID"/ -->
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="foaf:PersonalProfileDocument[foaf:maker and foaf:primaryTopic and admin:generatorAgent and admin:errorReportsTo]">
     <div id="contentB">
    <div id="foafPersonalProfileDocument">
      About :
        <xsl:value-of select="@rdf:about"/>
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="pet:likes">
   <div id="content1">
    <div id="petlikes">
        Likes :<xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="foaf:Person[foaf:mbox_sha1sum]">
   <div id="content3">
    <div id="foafPerson">
        Person :<xsl:value-of select="."/>
      <xsl:apply-templates/>
    </div>
     </div>
  </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:dc="http://purl.org/dc/elements/1.1/" 
			   xmlns:rss="http://purl.org/rss/1.0/" 
			   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
			   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
			   xmlns:foaf="http://xmlns.com/foaf/0.1/" 
			   xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
			   xmlns:admin="http://webns.net/mvcb/"
			   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output indent="yes" omit-xml-declaration="yes" method="xml"/>

  <xsl:variable name="term-ns" select="'http://pragmatron.org/tags/'" />	
  <xsl:variable name="owner" select="/opml/head/ownerName/text()" />

  <xsl:template match="/opml">
	<rdf:RDF>
	  <xsl:apply-templates select="head" mode="headers" />
	  <xsl:apply-templates select="body" mode="schema"/>
	  <xsl:apply-templates select="body" mode="data"/>
	</rdf:RDF>
  </xsl:template>
  
  <xsl:template match="head" mode="headers">
	<foaf:Document rdf:about="">
	  <!-- xsl:attribute name="rdf:about"><xsl:value-of select="$term-ns" /><xsl:value-of select="$owner" />/scheme</xsl:attribute -->
	  <dc:title><xsl:value-of select="title" /></dc:title>
	  <dc:subject><xsl:value-of select="title" /></dc:subject>
	  <foaf:maker><!--  rdf:nodeID="maker" -->
		<foaf:Person>
		  <foaf:name><xsl:value-of select="ownerName"/></foaf:name>
		  <foaf:mbox>
		  <xsl:attribute name="rdf:resource">mailto:<xsl:value-of select="ownerEmail"/></xsl:attribute>
		  </foaf:mbox>
		</foaf:Person>
	  </foaf:maker>
	  <admin:generatorAgent rdf:resource="http://pragmatron.org/sparqlsphere?version=0.1"/>

	</foaf:Document>
  </xsl:template>
  
  <xsl:template match="outline" mode="data">
	<xsl:choose><!-- @@TODO boolean shouldn't be needed - testme --> 
	  <xsl:when test="boolean(./@htmlUrl)">
		<foaf:Agent>
		  <foaf:weblog>
			<xsl:if test="@htmlUrl">
			  <foaf:Document rdf:about="{@htmlUrl}">
				<dc:title>
				  <xsl:value-of select="@title"/>
				</dc:title>
				<rdfs:seeAlso>
				  <rss:channel rdf:about="{@xmlUrl}"/>
				</rdfs:seeAlso>
				<xsl:for-each select="ancestor::*">
				  <xsl:if test="@title">
					<dc:subject>
					  <xsl:value-of select="@title" />
					</dc:subject>
					<dc:subject>
					  <xsl:attribute name="rdf:resource"><xsl:value-of select="$term-ns" /><xsl:value-of select="$owner" />/<xsl:value-of select="@title" /></xsl:attribute>
					</dc:subject>
				  </xsl:if>
				</xsl:for-each>
			  </foaf:Document>
			</xsl:if>
		  </foaf:weblog>
		</foaf:Agent>
	  </xsl:when>

	  <!-- gnomedex style blogroll -->
	  <xsl:when test="./@url">
		<xsl:if test="./@type='link'">
		  <foaf:Group>
			<foaf:name><xsl:value-of select="/opml/head/title"/></foaf:name>
			<foaf:member>
			  <foaf:Person>
				<foaf:name><xsl:value-of select="@text" /></foaf:name>
				<foaf:homepage>
				  <xsl:attribute name="rdf:resource"><xsl:value-of select="@url" /></xsl:attribute>
				</foaf:homepage>
			  </foaf:Person>
			</foaf:member>
		  </foaf:Group>	
		</xsl:if>
	  </xsl:when>

	  <xsl:otherwise>
		<xsl:comment>debug note : outline nesting changed here</xsl:comment>
	  </xsl:otherwise>
	  
	</xsl:choose>
	<xsl:apply-templates select="outline" mode="data"/>
  </xsl:template>
  
  <xsl:template match="outline" mode="schema">
	<xsl:if test="count(@*)=1">
	  <xsl:if test="@title">	
		<skos:ConceptScheme>
		  <xsl:attribute name="rdf:about"><xsl:value-of select="$term-ns" /><xsl:value-of select="$owner" />/scheme</xsl:attribute>
		  <dc:title><xsl:value-of select="$owner" />'s Categories</dc:title>
		</skos:ConceptScheme>
		
		<skos:Concept>
		  <skos:prefLabel><xsl:value-of select="$owner" />'s Top Category</skos:prefLabel>
		  <rdfs:label><xsl:value-of select="$owner" />'s Top Category</rdfs:label>
		  <xsl:apply-templates select="." mode="terms"/>	  
		</skos:Concept>
	  </xsl:if>
	</xsl:if>
	
  </xsl:template>
  
  <xsl:template match="outline" mode="terms">
	<xsl:if test="not(string(@xmlUrl))">
	  <skos:narrower>
		<skos:Concept>
		  <skos:prefLabel><xsl:value-of select="@title"/></skos:prefLabel>
		  <rdfs:label><xsl:value-of select="@title"/></rdfs:label>
		  <skos:inScheme>
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$term-ns" /><xsl:value-of select="$owner" />/scheme</xsl:attribute>
		  </skos:inScheme>
		  
		  <xsl:apply-templates select="outline" mode="terms"/>
		  
		</skos:Concept>
	  </skos:narrower>
	</xsl:if>
  </xsl:template>
</xsl:transform>

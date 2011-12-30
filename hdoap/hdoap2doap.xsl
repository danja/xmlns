<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:dc="http://purl.org/dc/elements/1.1/" 
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
xmlns:foaf="http://xmlns.com/foaf/0.1/" 
xmlns:xhtml="http://www.w3.org/1999/xhtml" 
xmlns:owl="http://www.w3.org/2002/07/owl#" 
xmlns="http://usefulinc.com/ns/doap#"

xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output indent="yes" omit-xml-declaration="yes" method="xml"/>


<xsl:template match="/xhtml:html/xhtml:body">
  <rdf:RDF>
	<xsl:apply-templates />
  </rdf:RDF>
</xsl:template>

<xsl:template match="*[@class='Project']">
  <Project>
    <name><xsl:value-of select="//*[@class='name'][1]/text()"/></name>

    <homepage rdf:resource="{//*[@class='homepage'][1]/@href}" />

    <created>
      <xsl:value-of select="//*[@class='created'][1]/text()"/>
    </created>

    <shortdesc xml:lang="{//*[@class='shortdesc'][1]/@xml:lang}">
      <xsl:value-of select="//*[@class='shortdesc'][1]/text()"/>
	</shortdesc>

	<description  xml:lang="{//*[@class='shortdesc'][1]/@xml:lang}">
	  <xsl:value-of select="//*[@class='description'][1]/text()"/>
	</description>

	<xsl:apply-templates select="//*[@class='release']"  mode="release" />

	<xsl:for-each select="//*[@class='mailing-list']">
	  <mailing-list rdf:resource="{@href}" />
	</xsl:for-each>

	<download-page rdf:resource="{//*[@class='download-page'][1]/@href}" />

	<xsl:for-each select="//*[@class='download-mirror']">
	  <download-mirror rdf:resource="{@href}" />
	</xsl:for-each>

	<xsl:apply-templates select="//*[@class='maintainer']"  mode="maintainer" />

	<xsl:for-each select="//*[@class='category']">
	  <category rdf:resource="{@href}" />
	</xsl:for-each>

	<xsl:for-each select="//*[@class='license']">
	  <license rdf:resource="{@href}" />
	</xsl:for-each>

	<xsl:apply-templates select="//*[@class='repository']"  mode="repository" />

  </Project>

</xsl:template>

<xsl:template match="*" mode="release">
  <xsl:for-each select="*">
	<release>
	  <Version>
		<name><xsl:value-of select=".//*[@class='name'][1]/text()"/></name>
		<created><xsl:value-of select=".//*[@class='created'][1]/text()"/></created>
		<revision><xsl:value-of select=".//*[@class='revision'][1]/text()"/></revision>
	  </Version>
	</release>
  </xsl:for-each>
</xsl:template>

<xsl:template match="*" mode="maintainer">
  <maintainer>
	<foaf:Person>
	  <foaf:name><xsl:value-of select=".//*[@class='name'][1]/text()"/></foaf:name>
	  <foaf:mbox_sha1sum><xsl:value-of select=".//*[@class='mbox_sha1sum'][1]/text()"/></foaf:mbox_sha1sum>
	  <rdfs:seeAlso rdf:resource="{.//*[@class='seeAlso'][1]/@href}" />
	</foaf:Person>
  </maintainer>
</xsl:template>

<xsl:template match="*" mode="repository">
  <repository>
	<xsl:choose>
	  <xsl:when test=".//*[@class='SVNRepository']">
		<SVNRepository>
		  <xsl:call-template name="inside-repository"/>
		</SVNRepository>
	  </xsl:when>
	  <xsl:when test=".//*[@class='BKRepository']">
		<BKRepository>
		  <xsl:call-template name="inside-repository"/>
		</BKRepository>
	  </xsl:when>
	  <xsl:when test=".//*[@class='CVSRepository']">
		<CVSRepository>
		  <xsl:call-template name="inside-repository"/>
		</CVSRepository>
	  </xsl:when>
	  <xsl:when test=".//*[@class='ArchRepository']">
		<ArchRepository>
		  <xsl:call-template name="inside-repository"/>
		</ArchRepository>
	  </xsl:when>
	  <xsl:otherwise>
		<Repository>
		  <xsl:call-template name="inside-repository"/>
		</Repository>
	  </xsl:otherwise>
	</xsl:choose>
  </repository>
</xsl:template>

<xsl:template name="inside-repository">
  <anon-root><xsl:value-of select=".//*[@class='anon-root'][1]/text()"/></anon-root>
  <module><xsl:value-of select=".//*[@class='module'][1]/text()"/></module>
  <browse rdf:resource="{.//*[@class='browse'][1]/@href}" />
</xsl:template>

<xsl:template match="text()" />

</xsl:transform>
<!--  mode="Project" -->
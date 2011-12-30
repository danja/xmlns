<?xml version="1.0"?>
<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:content="http://purl.org/rss/1.0/modules/content/"
  xmlns:r="http://backend.userland.com/rss2"
  xmlns="http://purl.org/rss/1.0/"
  xmlns:rev="http://www.purl.org/stuff/rev/"
  version="1.0">

<xsl:output indent="yes" cdata-section-elements="content:encoded" />



<!-- general element conversions -->

<xsl:template match="/">
  <rdf:RDF>
    <xsl:apply-templates/>
  </rdf:RDF>
</xsl:template>

<xsl:template match="*">
  <xsl:choose>
    <xsl:when test="namespace-uri()='' or namespace-uri()='http://backend.userland.com/rss2'">
      <xsl:element name="{name()}" namespace="http://purl.org/rss/1.0/">
        <xsl:apply-templates select="*|@*|text()" />
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:apply-templates select="*|@*|text()" />
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*">
  <!--<xsl:copy><xsl:value-of select="." /></xsl:copy>-->
</xsl:template>


<xsl:template match="text()">
  <xsl:value-of select="normalize-space(.)" />
</xsl:template>

<xsl:template match="rss|r:rss">
  <xsl:copy-of select="namespace::*" />
  <xsl:apply-templates select="channel|r:channel" />
  <xsl:apply-templates select="channel/item[guid|link]|r:channel/r:item[r:guid|r:link]" mode="rdfitem" />
</xsl:template>

<xsl:template match="channel|r:channel">
  <channel rdf:about="{link|r:link}">
    <xsl:apply-templates/>
    <items>
      <rdf:Seq>
        <xsl:apply-templates select="item|r:item" mode="li" />
      </rdf:Seq>
    </items>
  </channel>
</xsl:template>


<!-- channel content conversions -->

<xsl:template match="title|r:title">
  <dc:title><xsl:value-of select="." /></dc:title>
</xsl:template>

<xsl:template match="description|r:description">
  <dc:description><xsl:value-of select="." /></dc:description>
</xsl:template>

<xsl:template match="language|r:language">
  <dc:language><xsl:value-of select="." /></dc:language>
</xsl:template>

<xsl:template match="copyright|r:copyright">
  <dc:rights><xsl:value-of select="." /></dc:rights>
</xsl:template>

<xsl:template match="lastBuildDate|pubdate|r:lastBuildDate|r:pubdate">
  <dc:date><xsl:call-template name="date" /></dc:date>
</xsl:template>

<xsl:template match="managingEditor|r:managingEditor">
  <dc:creator><xsl:value-of select="." /></dc:creator>
</xsl:template>

<!-- elements from 0.94 not converted:
	webMaster
	category
	generator
	docs
	cloud
	ttl
	image
	textInput
	skipHours
	skipDays
-->

<!-- item content conversions -->

<xsl:template match="item/description|r:item/r:description">
  <dc:description><xsl:call-template name="removeTags" /></dc:description>
  <xsl:if test="not(../content:encoded)">
    <content:encoded><xsl:value-of select="." /></content:encoded>
  </xsl:if>
</xsl:template>

<xsl:template match="pubDate|r:pubDate">
  <dc:date><xsl:call-template name="date" /></dc:date>
</xsl:template>

<xsl:template match="source|r:source">
  <dc:source><xsl:value-of select="@url" /></dc:source>
</xsl:template>

<xsl:template match="author|r:author">
  <dc:creator><xsl:value-of select="." /></dc:creator>
</xsl:template>

<!-- elements from 0.94 not converted:
	category
	comments
	enclosure
-->

<!-- item templates -->

<xsl:template match="item|r:item" mode="li">
  <xsl:choose>
    <xsl:when test="link|r:link">
      <rdf:li rdf:resource="{link|r:link}" />
    </xsl:when>
    <xsl:when test="guid|r:guid">
      <rdf:li rdf:resource="{guid|r:guid}" />
    </xsl:when>
    <xsl:otherwise>
      <rdf:li rdf:parseType="Resource">
        <xsl:apply-templates />
      </rdf:li>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="item[link]|r:item[r:link]" mode="rdfitem">
  <item rdf:about="{link|r:link}">
    <xsl:apply-templates/>
  </item>
</xsl:template>

<xsl:template match="item[guid][not(link)]|r:item[r:guid][not(r:link)]" mode="rdfitem">
  <item rdf:about="{r:guid|guid}">
    <xsl:apply-templates/>
  </item>
</xsl:template>


<!-- utility templates -->

<xsl:template match="channel/link|r:channel/r:link" />
<xsl:template match="channel/item|r:channel/r:item" />
<xsl:template match="item/guid|r:item/r:guid" />
<xsl:template match="item/link|r:item/r:link" />

<xsl:template name="date">
  <xsl:variable name="m" select="substring(., 9, 3)" />
  <xsl:value-of select="substring(., 13, 4)" 
  />-<xsl:choose>
    <xsl:when test="$m='Jan'">01</xsl:when>
    <xsl:when test="$m='Feb'">02</xsl:when>
    <xsl:when test="$m='Mar'">03</xsl:when>
    <xsl:when test="$m='Apr'">04</xsl:when>
    <xsl:when test="$m='May'">05</xsl:when>
    <xsl:when test="$m='Jun'">06</xsl:when>
    <xsl:when test="$m='Jul'">07</xsl:when>
    <xsl:when test="$m='Aug'">08</xsl:when>
    <xsl:when test="$m='Sep'">09</xsl:when>
    <xsl:when test="$m='Oct'">10</xsl:when>
    <xsl:when test="$m='Nov'">11</xsl:when>
    <xsl:when test="$m='Dec'">12</xsl:when>
    <xsl:otherwise>00</xsl:otherwise>
  </xsl:choose>-<xsl:value-of select="substring(., 6, 2)" 
  />T<xsl:value-of select="substring(., 18, 8)" />
</xsl:template>

<xsl:template name="removeTags">
  <xsl:param name="html" select="." />
  <xsl:choose>
    <xsl:when test="contains($html,'&lt;')">
      <xsl:call-template name="removeEntities">
        <xsl:with-param name="html" select="substring-before($html,'&lt;')" />
      </xsl:call-template>
      <xsl:call-template name="removeTags">
        <xsl:with-param name="html" select="substring-after($html, '&gt;')" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="removeEntities">
        <xsl:with-param name="html" select="$html" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="removeEntities">
  <xsl:param name="html" select="." />
  <xsl:choose>
    <xsl:when test="contains($html,'&amp;')">
      <xsl:value-of select="substring-before($html,'&amp;')" />
      <xsl:variable name="c" select="substring-before(substring-after($html,'&amp;'),';')" />
      <xsl:choose>
        <xsl:when test="$c='nbsp'">&#160;</xsl:when>
        <xsl:when test="$c='lt'">&lt;</xsl:when>
        <xsl:when test="$c='gt'">&gt;</xsl:when>
        <xsl:when test="$c='amp'">&amp;</xsl:when>
        <xsl:when test="$c='quot'">&quot;</xsl:when>
        <xsl:when test="$c='apos'">&apos;</xsl:when>
        <xsl:otherwise>?</xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="removeTags">
        <xsl:with-param name="html" select="substring-after($html, ';')" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$html" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:transform>
<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xhtml="http://www.w3.org/1999/xhtml">
			
  <xsl:output indent="yes" method="xml"/>
  
  <xsl:template match="xhtml:head[title and link and script]">
    <head>
      <xsl:attribute name="profile">
        <xsl:value-of select="@profile"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </head>
  </xsl:template>
  
   <xsl:template match="xhtml:title">
    <title>
      <xsl:apply-templates/>
    </title>
  </xsl:template>
  <xsl:template match="xhtml:html[head and body]">
    <html>
      <xsl:apply-templates/>
    </html>
  </xsl:template>
  
  <xsl:template match="xhtml:link">
    <link>
      <xsl:attribute name="href">
        <xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:attribute name="rel">
        <xsl:value-of select="@rel"/>
      </xsl:attribute>
      <xsl:attribute name="type">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </link>
  </xsl:template>
  <xsl:template match="xhtml:ul">
    <ul>
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="@title"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  <xsl:template match="xhtml:li">
    <li>
      <xsl:attribute name="class">
        <xsl:value-of select="@class"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xsl:template match="xhtml:body[ul]">
    <body>
      <xsl:apply-templates/>
    </body>
  </xsl:template>
  <xsl:template match="xhtml:script">
    <script>
      <xsl:attribute name="language">
        <xsl:value-of select="@language"/>
      </xsl:attribute>
      <xsl:attribute name="src">
        <xsl:value-of select="@src"/>
      </xsl:attribute>
      <xsl:attribute name="space">
        <xsl:value-of select="@space"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </script>
  </xsl:template>
 
  
</xsl:stylesheet>

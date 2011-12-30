<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:h="http://www.w3.org/1999/xhtml" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
   xmlns:awol="http://www.w3.org/2005/Atom#"
  exclude-result-prefixes="dc xsl rdf rdfs h">
  
  <xsl:output
    method="xml" 
    encoding="UTF-8" 
    indent="yes"
/>

<!--
    Extracts HTML document links as RDF
  -->

<xsl:output method="xml" indent="yes"/>

<xsl:param name="subjectURI"></xsl:param>

<!-- Common semantics -->

<xsl:template match="/">
  <rdf:RDF>
      <rdf:Description>
	<xsl:attribute name="rdf:about"><xsl:value-of select="$subjectURI" /></xsl:attribute>
	<dc:title><xsl:value-of select="/h:html/h:head/h:title"/></dc:title>

	<xsl:apply-templates select="//h:a[@href]|//h:link[@href]" />
	
  	<xsl:call-template name="rel-attributes" />
      </rdf:Description>
  </rdf:RDF>
</xsl:template>
  
  <xsl:template match="h:a|h:link">
  	<awol:link><!-- the link itself, reified using Atom/OWL vocab -->
  		<awol:Link>
  			<awol:subject rdf:resource="" />
  			<awol:to rdf:resource="{@href}" />
  				<xsl:if test="@title">
					<dc:title><xsl:value-of select="@title" /></dc:title>
					<awol:title><xsl:value-of select="@title" /></awol:title>
				</xsl:if>
				<xsl:if test="@rel">
					<awol:rel><xsl:value-of select="@rel" /></awol:rel>
				</xsl:if>
		</awol:Link>
	</awol:link>
	
    <dc:relation><!-- basic here-there relationship -->
      <rdf:Description rdf:about="{@href}">
	<xsl:if test="string-length(text()) > 0">
	<dc:description><xsl:value-of select="text()" /></dc:description>
	</xsl:if>
      </rdf:Description>
    </dc:relation>
  </xsl:template>

      <!--  Basic HTML link types (@rel)
            http://www.w3.org/TR/html401/types.html#type-links

  We take the liberty of treating link relationship names
  from the HTML spec as RDF property names in the 
   http://www.w3.org/1999/xhtml namespace

   approach taken from DanC's grokXFN.xsl -->
 			
<xsl:template name="rel-attributes">
      <xsl:call-template name='typedLinks'>         
	<xsl:with-param name='rel' select='"alternate"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"stylesheet"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"start"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"next"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"prev"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"contents"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"index"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"glossary"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"copyright"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"chapter"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"section"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"subsection"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"appendix"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"help"'/>
      </xsl:call-template>
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"bookmark"'/>
      </xsl:call-template>

<!-- GRDDL's own! -->
      <xsl:call-template name='typedLinks'>
	<xsl:with-param name='rel' select='"transformation"'/>
      </xsl:call-template>
</xsl:template>

<xsl:template name='typedLinks'>
  <xsl:param name='rel'/>
  <xsl:for-each select=".//h:a[contains(concat(' ', @rel, ' '),
			concat(' ', $rel, ' '))]">
    <xsl:element name='{$rel}' namespace='http://www.w3.org/1999/xhtml#'>
    <xsl:attribute name="rdf:resource"><xsl:value-of select="@href" /></xsl:attribute>
    </xsl:element>
  </xsl:for-each>
  
  <xsl:for-each select=".//h:link[contains(concat(' ', @rel, ' '),
			concat(' ', $rel, ' '))]">
    <xsl:element name='{$rel}' namespace='http://www.w3.org/1999/xhtml#'>
    <xsl:attribute name="rdf:resource"><xsl:value-of select="@href" /></xsl:attribute>
    </xsl:element>
  </xsl:for-each>
    
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 

  	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml" >

	<xsl:template match="xhtml:link">
		<xsl:variable name="propertyName">
			<xsl:value-of select="substring-after(@rel, '.')" />
		</xsl:variable>

		<xsl:variable name="propertyPrefix">
			<xsl:value-of select="substring-before(@rel, '.')" />
		</xsl:variable>
		

		<xsl:variable name="propertyNamespaceUri">
			<xsl:value-of select="../../xhtml:link[@rel=concat('schema.', $propertyPrefix)]/@href" />
		</xsl:variable>

		<xsl:element name="{$propertyName}" namespace="{$propertyNamespaceUri}" rdf:resource="{@href}">
			<xsl:attribute name="resource" namespace="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				<xsl:value-of select="@href" />
			</xsl:attribute>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>
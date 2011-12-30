<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

<xsl:output indent="yes" method="xml"/>

<xsl:template match="/">
<classList>
	<xsl:for-each select="/classList/class">
	<class name="{@name}">
		<studentList>
		<xsl:call-template name="output-tokens">
			<xsl:with-param name="list"><xsl:value-of select="studentList" /></xsl:with-param>
		</xsl:call-template>

		</studentList>
	</class>
	</xsl:for-each>
</classList>
</xsl:template>

<xsl:template name="output-tokens">
    <xsl:param name="list" />
    <xsl:variable name="newlist" select="concat(normalize-space($list), ' ')" />
    <xsl:variable name="first" select="substring-before($newlist, ' ')" />
    <xsl:variable name="remaining" select="substring-after($newlist, ' ')" />

    <id><xsl:value-of select="$first" /></id>
    <xsl:if test="$remaining">
        <xsl:call-template name="output-tokens">
            <xsl:with-param name="list" select="$remaining" />
        </xsl:call-template>
    </xsl:if>
</xsl:template>
</xsl:stylesheet>



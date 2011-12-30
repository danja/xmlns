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

<xsl:template match="item/rev:type">
  <rev:hasReview>
    <rev:Review>
      <xsl:copy-of select=".|../rev:rating|../dc:creator" />
    </rev:Review>
  </rev:hasReview>
</xsl:template>

<xsl:template match="rev:type" />
<xsl:template match="rev:rating"  />
<xsl:template match="dc:creator" />

</xsl:transform>
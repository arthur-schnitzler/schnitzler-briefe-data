<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="no"/>
    <!--<xsl:strip-space elements="*"/>-->
    <!-- Dieses Template löscht allen whitespace aus physDesc und body. 
        Achtung, relevant ist auch strip-space! 
    aus mir nicht ganz ersichtlichem Grund muss es mehrmals laufen
    -->
    <xsl:template
        match="text()[ancestor::tei:div[parent::tei:body] or ancestor::tei:p[parent::tei:physDesc]]">
        <xsl:choose>
            <xsl:when test="starts-with(., ' ') and ends-with(., ' ')">
                <xsl:text/>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text/>
            </xsl:when>
            <xsl:when test="starts-with(., ' ')">
                <xsl:text/>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="ends-with(., ' ')">
                <xsl:text/>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>

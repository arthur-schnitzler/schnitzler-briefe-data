<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="no"/>
    <xsl:template match="text()[not(ancestor::tei:teiHeader)]">
        <xsl:choose>
            <xsl:when test="(starts-with(., ' ')) and (ends-with(., ' '))">
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="starts-with(., ' ')">
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="ends-with(., ' ')">
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:pb[not(starts-with(@facs, 'http')) and ends-with(@facs, '.pdf')]">
        <xsl:element name="tei:pb"/>
    </xsl:template>
</xsl:stylesheet>
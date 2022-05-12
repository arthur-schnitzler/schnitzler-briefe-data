<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="text()" name="repNL">
        <xsl:param name="pText" select="."/>
        <xsl:copy-of select="substring-before(concat($pText, 'ſſ'), 'ſſ')"/>
        <xsl:choose>
            <xsl:when test="contains($pText, 'ſſ')">
                <xsl:element name="c">
                    <xsl:attribute name="rendition">
                        <xsl:text>#langesS</xsl:text>
                    </xsl:attribute>
                    <xsl:text>s</xsl:text>
                </xsl:element>
                <xsl:element name="c">
                    <xsl:attribute name="rendition">
                        <xsl:text>#langesS</xsl:text>
                    </xsl:attribute>
                    <xsl:text>s</xsl:text>
                </xsl:element>
                <xsl:call-template name="repNL">
                    <xsl:with-param name="pText" select="substring-after($pText, 'ſſ')"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="text()" name="repNL">
        <xsl:param name="pText" select="."/>
        <!-- Sonderfall, langes s am Wortanfang! -->
        <xsl:copy-of select="substring-before(concat($pText,' ſ'),' ſ')"/>
        <xsl:if test="contains($pText, ' ſ')">
            <xsl:element name="tei:space">
                <xsl:attribute name="unit">
                    <xsl:text>chars</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="quantity">
                    <xsl:text>1</xsl:text>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </xsl:element>
            <xsl:element name="c">
                <xsl:attribute name="rendition">
                    <xsl:text>#langesS</xsl:text>
                </xsl:attribute>
                <xsl:text>s</xsl:text>
            </xsl:element>
            <xsl:call-template name="repNL">
                <xsl:with-param name="pText" select="substring-after($pText, ' ſ')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
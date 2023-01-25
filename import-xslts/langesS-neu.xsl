<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="text()">
        <xsl:analyze-string select="." regex="\sſ">
            <xsl:matching-substring>
                <xsl:element name="space">
                    <xsl:attribute name="unit">
                        <xsl:text>chars</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="quantity">
                        <xsl:text>1</xsl:text>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="c">
                    <xsl:attribute name="rendition">
                        <xsl:text>#langesS</xsl:text>
                    </xsl:attribute>
                    <xsl:text>s</xsl:text>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
        <xsl:analyze-string select="." regex="ſſ">
            <xsl:matching-substring>
                <xsl:element name="c">
                    <xsl:attribute name="rendition">
                        <xsl:text>#langesS</xsl:text>
                    </xsl:attribute>
                    <xsl:text>s</xsl:text>
                </xsl:element><xsl:element name="c">
                    <xsl:attribute name="rendition">
                        <xsl:text>#langesS</xsl:text>
                    </xsl:attribute>
                    <xsl:text>s</xsl:text>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="ſ">
                    <xsl:matching-substring>
                        <xsl:element name="c">
                            <xsl:attribute name="rendition">
                                <xsl:text>#langesS</xsl:text>
                            </xsl:attribute>
                            <xsl:text>s</xsl:text>
                        </xsl:element>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>

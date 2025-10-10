<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">

    <xsl:output method="xml" indent="yes" encoding="utf-8"/>
    <xsl:strip-space elements="*"/>

    <!-- Identity template: copy everything by default -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Adapt the title element to allow when-iso and n attributes -->
    <xsl:template match="xs:element[@name='title']/xs:complexType">
        <xs:complexType mixed="true">
            <xsl:apply-templates select="xs:choice"/>
            <xsl:apply-templates select="xs:attribute[@name='ref']"/>
            <xsl:apply-templates select="xs:attribute[@name='level']"/>
            <xsl:apply-templates select="xs:attribute[@name='type']"/>
            <!-- Add when-iso attribute -->
            <xs:attribute name="when-iso" type="xs:string"/>
            <!-- Add n attribute -->
            <xs:attribute name="n" type="xs:string"/>
        </xs:complexType>
    </xsl:template>

    <!-- Adapt the c element to allow mixed content (text nodes) -->
    <xsl:template match="xs:element[@name='c']/xs:complexType">
        <xs:complexType mixed="true">
            <xsl:apply-templates select="@*[name() != 'mixed']"/>
            <xsl:apply-templates select="node()"/>
        </xs:complexType>
    </xsl:template>

</xsl:stylesheet>

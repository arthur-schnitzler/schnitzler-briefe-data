<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    
    <!-- adds a title-element with iso-date, e.g.
    <title type="iso-date" when="1914-08-23">23. 8. 1914</title>
       
       Die Werte werden aus der correspAction[@type='sent'] bezogen, @from, @notBefore werden zu @when
    -->
    
    <xsl:template match="tei:title[@level='s']">
        <xsl:variable name="correspDate" as="node()" select="ancestor::tei:TEI/descendant::tei:correspDesc/tei:correspAction[@type='sent']/tei:date"/>
        <xsl:variable name="when">
            <xsl:choose>
                <xsl:when test="$correspDate/@when">
                    <xsl:value-of select="$correspDate/@when"/>
                </xsl:when>
                <xsl:when test="$correspDate/@from">
                    <xsl:value-of select="$correspDate/@from"/>
                </xsl:when>
                <xsl:when test="$correspDate/@notBefore">
                    <xsl:value-of select="$correspDate/@notBefore"/>
                </xsl:when>
                <xsl:when test="$correspDate/@to">
                    <xsl:value-of select="$correspDate/@to"/>
                </xsl:when>
                <xsl:when test="$correspDate/@notAfter">
                    <xsl:value-of select="$correspDate/@notAfter"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select="."/>
        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">
                <xsl:text>iso-date</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="when">
                <xsl:value-of select="$when"/>
            </xsl:attribute>
            <xsl:value-of select="$correspDate/text()"/>
        </xsl:element>
    </xsl:template>
  
</xsl:stylesheet>
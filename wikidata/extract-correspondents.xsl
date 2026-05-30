<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0">

    <xsl:output method="xml" indent="yes"/>

    <!-- Loaded relative to this stylesheet's location (wikidata/ -> data/indices/) -->
    <xsl:variable name="persons" select="doc('../data/indices/listperson.xml')"/>

    <xsl:key name="person-by-id" match="tei:person" use="@xml:id"/>

    <xsl:template match="/">
        <correspondents>
            <xsl:for-each select="//tei:personGrp[not(@ana) and @xml:id != 'correspondence_null']">
                <xsl:variable name="mainRef" select="tei:persName[@role='main']/@ref"/>
                <xsl:variable name="pmbId" select="substring-after($mainRef, '#')"/>
                <xsl:variable name="person" select="key('person-by-id', $pmbId, $persons)"/>
                <xsl:variable name="wikidataUrl"
                              select="normalize-space($person/tei:idno[@subtype='wikidata'][1])"/>
                <xsl:if test="$wikidataUrl != ''">
                    <person qid="{substring-after($wikidataUrl, '/entity/')}"
                            name="{normalize-space(tei:persName[@role='main'])}"
                            pmb="{$pmbId}"/>
                </xsl:if>
            </xsl:for-each>
        </correspondents>
    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="no"/>
    
    <xsl:template match="text()[normalize-space(.)='' and ancestor::tei:div[parent::tei:body] or ancestor::tei:p[parent::tei:physDesc]]"/>
    
    
</xsl:stylesheet>

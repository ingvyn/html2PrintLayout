<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:output method="xml"/>
    <xsl:template match="/">
        <xsl:text>&#xA;</xsl:text>
        <Identifikator>
            <xsl:apply-templates/>
        </Identifikator>
    </xsl:template>
    <xsl:template match="Graphics">
        <Ident>
            <xsl:text>&#xA;</xsl:text>
            <xsl:copy>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('file:///T:/VenturaOut/ENCIKLOP\CurrYear/Kirpichi_All/', text())"/>
                </xsl:attribute>            
            </xsl:copy>
            <xsl:text>&#xA;</xsl:text>
            <xsl:choose>
                <xsl:when test="@href">
                    <crossRef href="{@href}">c. 0000</crossRef>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:when>
            </xsl:choose>
        </Ident>
    </xsl:template>
</xsl:stylesheet>
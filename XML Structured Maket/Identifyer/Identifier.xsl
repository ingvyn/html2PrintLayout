<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/"
    version="1.0">
    <xsl:output method="xml"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <Identifier xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/">
            <xsl:apply-templates/>
        </Identifier>
    </xsl:template>
    <xsl:template match="Ident">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
        <xsl:if test="following-sibling::Ident">
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="Firma1 | PageNum | LekForm">
        <xsl:copy>
            <xsl:attribute name="aid:pstyle">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    <xsl:template match="TorgNazv">
        <xsl:copy>
            <xsl:attribute name="aid:pstyle">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>    
    <xsl:template match="Picture">
        <xsl:copy>
            <xsl:attribute name="aid:pstyle">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of select="text()"/>
            </xsl:attribute>
        </xsl:copy>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    <xsl:template match="Logof">
        <xsl:copy>
            <xsl:attribute name="aid:pstyle">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of select="concat('T:\VenturaOut\ENCIKLOP\CurrYear\IDENT_LOGOF\',text())"/>
            </xsl:attribute>
        </xsl:copy>
        <xsl:text>&#xA;</xsl:text>        
    </xsl:template>    
</xsl:stylesheet>
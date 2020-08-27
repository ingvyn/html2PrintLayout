<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/"
    version="1.0">
    <xsl:output method="xml" indent="no"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <IdentCollection xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/">
            <xsl:apply-templates/>
        </IdentCollection>
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
            <xsl:apply-templates select="text() | *" mode="character-style-range"/>
        </xsl:copy>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    <xsl:template match="TorgNazv">
        <xsl:copy>
            <xsl:attribute name="aid:pstyle">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:apply-templates select="text() | *" mode="character-style-range"/>
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
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>

    
    <xsl:template match="sub" mode="character-style-range">
        <CStyleSubscript aid:cstyle="CStyleSubscript">
            <xsl:value-of select="."/>
        </CStyleSubscript>
    </xsl:template>
    
    <xsl:template match="sup" mode="character-style-range">
        <CStyleSuperscript aid:cstyle="CStyleSuperscript">
            <xsl:value-of select="."/>
        </CStyleSuperscript>
    </xsl:template>
  
    <xsl:template match="br" mode="character-style-range">
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    

</xsl:stylesheet>
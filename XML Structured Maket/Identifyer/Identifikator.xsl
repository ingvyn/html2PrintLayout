<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:output method="xml"/>
    <xsl:param name="ident-folder">file:///T:/VenturaOut/ENCIKLOP\CurrYear/Kirpichi_All/</xsl:param> <!-- параметр с местонахождением папки "кирпичей" -->
    <xsl:template match="/">
        <xsl:text>&#xA;</xsl:text>
        <Identifikator>
            <xsl:apply-templates/>
        </Identifikator>
    </xsl:template>
    <xsl:template match="Graphics">
        <Ident>
            <xsl:text>&#xA;</xsl:text>
            <xsl:if test="@name">
                <anchorCR name="{@name}"/>
                <xsl:text>&#xA;</xsl:text>                
            </xsl:if>            
            <xsl:copy> <!-- в выходной файл переносится тег Graphics -->
                <xsl:attribute name="href"> <!-- атрибуту href тега присваивается имя файла eps с путем -->
                    <xsl:value-of select="concat($ident-folder, text())"/>
                </xsl:attribute>            
            </xsl:copy>
            <xsl:text>&#xA;</xsl:text>
            <xsl:if test="@href"> <!-- по наличию в теге Graphics атрибутa href формируется дочерний тег с соответствующим атрибутом -->
                <crossRef href="{@href}">c. 0000</crossRef>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
      </Ident>
    </xsl:template>
</xsl:stylesheet>
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
    <!-- Inline templates -->
    <!-- набор шаблонов с рекурсивным вызовом, обрабатывающих текст и стилевые теги внутри тегов p.
      Шаблоны имеют параметр inherited-character-style, формирующий название будущего стилевого тега
      по шаблону CStyle + (Italic)(Bold) и пр.. Рекурсивный вызов прекращается при обработке шаблона text() и шаблона a[href]-
     самых нижних узлов в дереве html-->    
    <xsl:template match="em | i" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:apply-templates select="* | text()" mode="character-style-range">
            <xsl:with-param name="inherited-character-style">
                <xsl:value-of select="concat($inherited-character-style, 'Italic')"/>     
            </xsl:with-param>        
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="sub" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:apply-templates select="* | text()" mode="character-style-range">
            <xsl:with-param name="inherited-character-style">
                <xsl:value-of select="concat($inherited-character-style, 'Subscript')"/>     
            </xsl:with-param>        
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="sup" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:apply-templates select="* | text()" mode="character-style-range">
            <xsl:with-param name="inherited-character-style">
                <xsl:value-of select="concat($inherited-character-style, 'Superscript')"/>     
            </xsl:with-param>        
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="span[@class]" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:apply-templates select="* | text()" mode="character-style-range">
            <xsl:with-param name="inherited-character-style">
                <xsl:value-of select="concat($inherited-character-style, @class)"/>     
            </xsl:with-param>        
        </xsl:apply-templates>
    </xsl:template>
<!--   
    <xsl:template match="font[@face]" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:apply-templates select="* | text()" mode="character-style-range">
            <xsl:with-param name="inherited-character-style">
                <xsl:choose>
                    <xsl:when test="contains(@face, ' ')">
                        <xsl:value-of select="replace(@face, ' ', '')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@face"/> 
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>        
        </xsl:apply-templates>
    </xsl:template>
 --> 
    <xsl:template match="strong | b" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:apply-templates select="* | text()" mode="character-style-range">
            <xsl:with-param name="inherited-character-style">
                <xsl:value-of select="concat($inherited-character-style,'Bold')"/>     
            </xsl:with-param>        
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="br" mode="character-style-range">
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="a[@href]" mode="character-style-range">   <!-- шаблон обрабатывает одиночные и последовательные цепочки тегов <a>, каждый из которых может быть заключен в стилевые inline теги  -->
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:variable name="curr-paragraph-context" select="ancestor::p"/>
        <xsl:choose> <!-- шаблон настроен на концепцию обработки тегов ссылок, которые при трансформации в xml приводятся в соответствующие теги xml, а с учетом отображения в макете добавляются 
                      наполнители 0000 для будущих перекрестных ссылок и знаки препинания; запускаемый в макете скрипт путем поиска ссылочных тегов с одинаковыми аттрибутами href и name актуализирует перекрестные ссылки-->
            <xsl:when test="not(preceding::a[ancestor::p=$curr-paragraph-context])">
                <xsl:text>&#x09;</xsl:text> <!-- добавляется табуляция, если ссылочный тег первый в цепочке (внимание: каждый ссылочный тег может быть внутри стилевого тега b, i etc.)  -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose> <!-- код для вставки знаков препинания перед оставшимися после первого в цепочке ссылочных тегов -->
                    <xsl:when test="count(preceding::a[ancestor::p=$curr-paragraph-context]) mod 2 = 1">
                        <xsl:text>&#x2C;&#x20;</xsl:text> <!-- запятая с пробелом, если предыдущих ссылочных тегов нечетное количество -->                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#xA;</xsl:text> <!-- перевод строки, если предыдущих ссылочных тегов четное количество -->
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$inherited-character-style=''"> <!-- в случае если ссылочный тег обернут в стилевые, добавляется соотв. стилевой тег xml -->
                <crossRef href="{@href}">0000</crossRef> <!-- может быть необходимо вставить какой-то нормальный стиль, например CStyleRegular? -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="concat('CStyle', $inherited-character-style)"/><xsl:text> aid:cstyle="</xsl:text><xsl:value-of select="concat('CStyle', $inherited-character-style)"/><xsl:text>"</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
                <crossRef href="{@href}">0000</crossRef> <!-- и соответсвующий тег для последующей генерации перекрестной ссылки в макете -->
                <xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="concat('CStyle', $inherited-character-style)"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="a[@name]" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:choose>
            <xsl:when test="$inherited-character-style=''">
                <anchorCR name="{@name}"></anchorCR>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="concat('CStyle', $inherited-character-style)"/><xsl:text> aid:cstyle="</xsl:text><xsl:value-of select="concat('CStyle', $inherited-character-style)"/><xsl:text>"</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
                <anchorCR name="{@name}"></anchorCR>
                <xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="concat('CStyle', $inherited-character-style)"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:choose>
            <xsl:when test="$inherited-character-style=''">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="concat('CStyle', $inherited-character-style)"/><xsl:text> aid:cstyle="</xsl:text><xsl:value-of select="concat('CStyle', $inherited-character-style)"/><xsl:text>"</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
                <xsl:value-of select="."/>
                <xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="concat('CStyle', $inherited-character-style)"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
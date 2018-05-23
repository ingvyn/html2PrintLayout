<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
        xpath-default-namespace="http://www.w3.org/1999/xhtml"
    version="2.0">
    <!-- Ширина большинства таблиц задается здесь в пунктах -->
    <xsl:param name="table-width">504.567</xsl:param>


    <xsl:template match="body">
        <xsl:text>&#xA;</xsl:text>
        <Chapter xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/">
            <xsl:apply-templates select="*"/>
        </Chapter>
    </xsl:template>
    
    <xsl:template match="hr">
        <xsl:choose>
            <xsl:when test="@align">
                <UKPR_FIRM_PREPBEGIN xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="UKPR_FIRM_PREPBEGIN"></UKPR_FIRM_PREPBEGIN>                
            </xsl:when>
            <xsl:otherwise>
                <UKPR_FIRM_BEGIN xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="UKPR_FIRM_BEGIN"></UKPR_FIRM_BEGIN>                
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="p[@class]"> <!-- формируются теги с названиями по значениям атрибутов class тегов абзацев p -->
        <xsl:if test="@class='OPIS_LARGETON' or @class='Opis_DV_Opis'">
            <xsl:choose>
                <xsl:when test="preceding-sibling::p[@class='OPIS_LARGETON' or @class='Opis_DV_Opis']">
                    <!-- Закрывается тег </OPIS> и открывается новый <OPIS> для всех описаний кроме первого, когда встечается класс OPIS_LARGETON или Opis_DV_Opis -->
                    <xsl:text disable-output-escaping="yes"><![CDATA[</OPIS>]]></xsl:text>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:text disable-output-escaping="yes"><![CDATA[<OPIS>]]></xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Открывается тег <OPIS> для первого описания -->
                    <xsl:text disable-output-escaping="yes"><![CDATA[<OPIS>]]></xsl:text>                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if> 
        <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="@class"/><xsl:text> aid:pstyle="</xsl:text><xsl:value-of select="@class"/><xsl:text>"</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
            <xsl:apply-templates select="text() | *" mode="character-style-range"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="@class"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
        <xsl:choose>
            <xsl:when test="following-sibling::p or following-sibling::img">
                <!-- в частности, перевод строки в формирующемся xml не должен всавтляться перед закрывающим тегом Cell, в разбираемомо html соотв. </td> -->
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="img"> <!-- обработка тегов со ссылками на рисунки: html-описания содержат рисунки 2-х типов -рисунки, связанные с применением препарата, и структурные формулы действующих веществ -->
        <xsl:variable name="uriimg">
             <xsl:value-of select="concat('C:/Users/%D0%B8%D0%BD%D0%B8%D0%BA%D0%B8%D1%82%D0%B8%D0%BD/Documents/ENCIKLOP%20InDesign/Logo/', substring-before(@src, '.gif'), '.eps')"/>
                        <!-- первый аргумент concat содержит URI-ссылку на папку, содержащую рисунки -->

        </xsl:variable>
        <Graphics xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="Graphics" href="file:///{$uriimg}"/>
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

<!-- Обработка таблиц -->
    <xsl:template match="table">
                <xsl:variable name="BodyRowCount" select="count(descendant::tr)"/>
                <xsl:variable name="maxcol_row"> <!-- блок, осуществляющий подсчет максимального количества столбцов в таблице методом перебора строк осуществляется вызов шаблона с рекурсивным вызовом -->
                    <xsl:call-template name="Table_calc_columns"/>
                </xsl:variable>
                <xsl:variable name="colcount_inmaxcol_row"
                    select="count(descendant::tr[position() = $maxcol_row]/td)"/>
                <xsl:variable name="columnWidth"
                    select="$table-width div $colcount_inmaxcol_row"/>
                <xsl:variable name="header-row-count">
                    <xsl:call-template name="Table_HeaderRowCount"/> <!-- подсчет числа строк в заголовке таблицы: берется максимальный среди всех ячеек первой строки атрибут rowspan -->          
                </xsl:variable>
                <xsl:variable name="table-style">
                    <xsl:choose>
                        <xsl:when test="count(descendant::td)=2">
                            <xsl:value-of select="'TableMono_0Line'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'Table_YellowStrip'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="cell-style">
                    <xsl:choose>
                        <xsl:when test="count(descendant::td)=2">
                            <xsl:value-of select="'CellMono_0Line'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'Cell_YellowStrip'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <Table_padding xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="Table_padding"/>
                <xsl:text>&#xA;</xsl:text>                    
                <!-- До и после таблиц вставляются абзацы-отбивки, иначе сложный макет ломается: внесение исправлений в текст трехколонника влечет съезжание таблиц, крепко сцеленных друг с другом (если абзацы table идут друг за другом) -->                    
                <table xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="table"><Table aid:table="table" aid:trows="{$BodyRowCount}" aid:tcols="{$colcount_inmaxcol_row}" aid5:tablestyle="{$table-style}">
                <xsl:text>&#xA;</xsl:text>
                    <xsl:for-each select="descendant::tr">
                        <xsl:choose>
                            <xsl:when test="position() &lt;= $header-row-count"> <!-- формирование тегов ячееек строк заголовка таблицы -->
                                <xsl:for-each select="td">
                                    <xsl:variable name="cell-row-span">
                                        <xsl:choose>
                                            <xsl:when
                                                test="@rowspan">
                                                <xsl:value-of
                                                    select="@rowspan"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="1"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:variable name="cell-col-span">
                                        <xsl:choose>
                                            <xsl:when
                                                test="@colspan">
                                                <xsl:value-of
                                                    select="@colspan"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="1"/>
                                            </xsl:otherwise>
                                        </xsl:choose>                                            
                                    </xsl:variable>
                                    <Cell aid:table="cell" aid:theader="" aid:crows="{$cell-row-span}" aid:ccols="{$cell-col-span}" aid:ccolwidth="{$columnWidth}" aid5:cellstyle="{$cell-style}">
                                        <xsl:apply-templates/>
                                    </Cell>
                                    <xsl:text>&#xA;</xsl:text>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise> <!-- формирование тегов ячеек обычных незаголовочных строк таблицы-->
                                <xsl:for-each select="td">
                                    <xsl:variable name="cell-row-span">
                                        <xsl:choose>
                                            <xsl:when
                                                test="@rowspan">
                                                <xsl:value-of
                                                    select="@rowspan"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="1"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:variable name="cell-col-span">
                                        <xsl:choose>
                                            <xsl:when
                                                test="@colspan">
                                                <xsl:value-of
                                                    select="@colspan"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="1"/>
                                            </xsl:otherwise>
                                        </xsl:choose>                                        
                                    </xsl:variable>
                                    <Cell aid:table="cell" aid:crows="{$cell-row-span}" aid:ccols="{$cell-col-span}" aid:ccolwidth="{$columnWidth}">
                                        <xsl:apply-templates/>
                                    </Cell>
                                    <xsl:text>&#xA;</xsl:text>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </Table></table>
                <xsl:text>&#xA;</xsl:text>                    
                <Table_padding xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="Table_padding"/>
                <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <!-- Вспомогательные шаблоны -->
    <!-- шаблон с рекурсивным вызовом самого себя для подсчета максимального количества столбцов в таблице-->
    <xsl:template name="Table_calc_columns">
        <xsl:param name="column_max" select="1"/>
        <xsl:param name="column_max_row" select="1"/>
        <xsl:param name="row_num" select="1"/>
        <xsl:choose>
            <xsl:when test="$row_num = count(descendant::tr) + 1">
                <xsl:value-of select="$column_max_row"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$column_max &lt; count(descendant::tr[$row_num]/td)">
                        <xsl:call-template name="Table_calc_columns">
                            <xsl:with-param name="column_max" select="count(descendant::tr[$row_num]/td)"/>
                            <xsl:with-param name="column_max_row" select="$row_num"/>
                            <xsl:with-param name="row_num" select="$row_num + 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="Table_calc_columns">
                            <xsl:with-param name="column_max" select="$column_max"/>
                            <xsl:with-param name="column_max_row" select="$column_max_row"/>
                            <xsl:with-param name="row_num" select="$row_num + 1"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="Table_HeaderRowCount">
        <xsl:param name="header-rowNum" select="1"/> <!--  параметр, в котором на протяжении рекурсивного вызова шаблона откладывается макисмальный среди всех ячеек первой строки атрибут ячейки rowspan-->
        <xsl:param name="col_num" select="1"/> <!-- текущий номер столбца -->
        <xsl:variable name="currRowSpan"> <!-- переменная с rowspan текущей ячейки перволй строки-->
            <xsl:choose>
                <xsl:when test="descendant::tr[1]/td[$col_num]/@rowspan">
                    <xsl:value-of select="descendant::tr[1]/td[$col_num]/@rowspan"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$col_num = count(descendant::tr[1]/td) + 1"> <!-- почему-то сложилась такая запись: обычная проверка счетчика столбцов на превышение их числа -->
                <xsl:value-of select="$header-rowNum"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$header-rowNum &lt; $currRowSpan">
                        <xsl:call-template name="Table_HeaderRowCount">
                            <xsl:with-param name="header-rowNum" select="$currRowSpan"/>
                            <xsl:with-param name="col_num" select="$col_num + 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="Table_HeaderRowCount">
                            <xsl:with-param name="header-rowNum" select="$header-rowNum"/>
                            <xsl:with-param name="col_num" select="$col_num + 1"/>
                        </xsl:call-template>            
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>


<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
        xpath-default-namespace="http://www.w3.org/1999/xhtml"
    version="2.0">
<!-- Версия 2.0 преобразований отличается от ветки версий 1.x успешной работой при объявлении этого преобразования как XSLT 2.0
      Кроме того, все описания (начинаются с OPIS_LARGETON или Opis_DV_Opis) оборачиваются тегами <OPIS></OPIS>,а весь материал тегами <Chapter></Chapter>
      Завершающий тег </OPIS> ставится после </OPIS_END> - это не всегда удобно, так как в других главах абзац со стилем OPIS_END присутствует вне контекста повторяющихся описаний
      В старших версиях преобразования завершающий тег </OPIS> будет ставиться перед открывающимся, если описание не первое-->
    <!-- Ширина большинства таблиц задается здесь в пунктах -->
    <xsl:param name="table-width">161.575</xsl:param>
    <!-- Default Rule: Match everything, ignore it,  and keep going "down". -->

    <xsl:template match="body">
        <xsl:text>&#xA;</xsl:text>
        <Chapter xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/">
            <xsl:apply-templates select="*"/>
        </Chapter>
    </xsl:template>
    
    <xsl:template match="hr">
        <OPIS_END xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="OPIS_END"></OPIS_END>
            <xsl:text disable-output-escaping="yes"><![CDATA[</OPIS>]]></xsl:text>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="p[@class]"> <!-- формируются теги с названиями по значениям атрибутов class тегов абзацев p -->
        <xsl:if test="@class='OPIS_LARGETON' or @class='Opis_DV_Opis'">
            <xsl:text disable-output-escaping="yes"><![CDATA[<OPIS>]]></xsl:text>
        </xsl:if> 
        <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="@class"/><xsl:text> aid:pstyle="</xsl:text><xsl:value-of select="@class"/><xsl:text>"</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
            <xsl:apply-templates select="text() | *" mode="character-style-range"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="@class"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
        <xsl:if test="@class='OPIS_LARGETON' or @class='Opis_DV_Opis'">
            <xsl:text>&#xA;</xsl:text>
            <COLONT_Opis xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="COLONT_Opis"><xsl:value-of select="."/></COLONT_Opis> <!-- для формирования колонтитулов в макете по значениям абзацев со стилями, проверяемыми во сравнении, добавляется дублирующий абзац со стилем COLONT_Opis -->
        </xsl:if>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="img"> <!-- обработка тегов со ссылками на рисунки: html-описания содержат рисунки 2-х типов -рисунки, связанные с применением препарата, и структурные формулы действующих веществ -->
        <xsl:variable name="uriimg">
            <xsl:choose>
                <xsl:when test="@vent"> <!-- теги с атрибутом vent содержат рисунки, связанные с применением препарата -->
                    <xsl:value-of 
                        select="concat('C:/Users/%D0%B8%D0%BD%D0%B8%D0%BA%D0%B8%D1%82%D0%B8%D0%BD/Documents/ENCIKLOP%20InDesign/Pictures/', substring-before(@src, '.jpg'), '.eps')"/>
                        <!-- первый аргумент concat содержит URI-ссылку на папку, содержащую рисунки -->
                </xsl:when>
                <xsl:otherwise> <!-- теги без атрибута vent обычно содержат структурные формулы-->
                    <xsl:value-of
                        select="concat('C:/Users/%D0%B8%D0%BD%D0%B8%D0%BA%D0%B8%D1%82%D0%B8%D0%BD/Documents/ENCIKLOP%20InDesign/Struf_DV/', substring-before(substring-after(@src, '\\DISKSTATION\NetBackup\BOOK\Struf_DV\'), '.gif'), '.tif')"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Image href="file:///{$uriimg}"/>
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
        <xsl:choose>
            <xsl:when test="@tab_name"> <!-- обработка всех именованных таблиц. Обычно находятся внутри полей описания, но не в поле СОСТАВ -->
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
                <table xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="table"><Table aid:table="table" aid:trows="{$BodyRowCount}" aid:tcols="{$colcount_inmaxcol_row}" aid5:tablestyle="TableMono_1ThinLine">
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
                                    <xsl:variable name="get-para-style">
                                        <xsl:choose>
                                            <xsl:when test="@class">
                                                <xsl:value-of
                                                    select="@class"/>
                                            </xsl:when>
                                            <xsl:when
                                                test="p/@class">
                                                <xsl:value-of
                                                    select="p/@class"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'Table_Left'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <Cell aid:table="cell" aid:theader="" aid:crows="{$cell-row-span}" aid:ccols="{$cell-col-span}" aid:ccolwidth="{$columnWidth}">
                                        <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="$get-para-style"/><xsl:text> aid:pstyle="</xsl:text><xsl:value-of select="$get-para-style"/><xsl:text>"</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
                                        <xsl:apply-templates select="text() | *" mode="character-style-range"/>
                                        <xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="$get-para-style"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
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
                                    <xsl:variable name="get-para-style">
                                        <xsl:choose>
                                            <xsl:when test="@class">
                                                <xsl:value-of
                                                    select="@class"/>
                                            </xsl:when>
                                            <xsl:when
                                                test="p/@class">
                                                <xsl:value-of
                                                    select="p/@class"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'Table_Left'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <Cell aid:table="cell" aid:crows="{$cell-row-span}" aid:ccols="{$cell-col-span}" aid:ccolwidth="{$columnWidth}">
                                        <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="$get-para-style"/><xsl:text> aid:pstyle="</xsl:text><xsl:value-of select="$get-para-style"/><xsl:text>"</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
                                        <xsl:apply-templates select="text() | *" mode="character-style-range"/>
                                        <xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="$get-para-style"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
                                    </Cell>
                                    <xsl:text>&#xA;</xsl:text>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </Table></table>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:otherwise> <!-- обработка таблиц без аттрибута tab_name. Обычно находятся в поле СОСТАВ и имеют два столбца. В макет выводятся не в табличном виде, а виде обычных абзацев -->
                <xsl:for-each select="descendant::tr">
                    <xsl:variable name="get-para-style"> <!-- переменная снимает значение аттрибута class для стиля абзаца только из первой ячейки строки -->
                        <xsl:choose>
                            <xsl:when test="child::td[position() = 1]/@class">
                                <xsl:value-of select="child::td[position() = 1]/@class"/>
                            </xsl:when>
                            <xsl:when test="child::td[position() = 1]/p/@class">
                                <xsl:value-of select="child::td[position() = 1]/p/@class"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'Table_Left'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="cell1-is-empty" select="child::td[1]"/> <!-- В дальнейшем осуществляется проверка на непустоту первой и второй ячейки строки -->
                    <xsl:variable name="cell2-is-empty" select="child::td[2]"/> <!-- по текущему состоянию входного xhtml ячейка считается пустой, если содержит только элемент &nbsp; (неразрывный пробел)-->
                    <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="$get-para-style"/><xsl:text> aid:pstyle="</xsl:text><xsl:value-of select="$get-para-style"/><xsl:text>"</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
                    <xsl:if test="$cell1-is-empty != '&#xA0;'"> <!-- сравнение на &nbsp; (неразрывный пробел) A0 hex-code &nbsp; -->
                        <xsl:apply-templates select="child::td[position() = 1]" mode="character-style-range"/>
                        <xsl:if test="$cell2-is-empty != '&#xA0;'">
                                      <xsl:copy-of select="'&#x9;'"/> <!-- если вторая ячейка пуста, в нашем макете добавляется табуляция для отточия -->
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="$cell2-is-empty != '&#xA0;'">
                        <xsl:apply-templates select="child::td[position() = 2]" mode="character-style-range"/>
                    </xsl:if>
                    <xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="$get-para-style"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
                    <xsl:text>&#xA;</xsl:text>                                        
                    
                </xsl:for-each>                
            </xsl:otherwise>
        </xsl:choose>
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


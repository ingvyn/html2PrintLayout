<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
        xpath-default-namespace="http://www.w3.org/1999/xhtml"
    version="2.0">
    <!-- Версия 2.1 завершающий тег </UKPR> ставится перед открывающимся, если описание не первое 
    Теги UKPR расставляются перед тегом UKPR_FIRM_BEGIN, который соотв. тегу hr в xhtml без аттр. align и с аттр. color
    к сожалению, при такой расстановке тегов в родительские UKPR кроме всего, что относится к фирме, иногда попадает тег UKPR_FIRSTLETTER,
    но избежать этого трудно, а польза от родительских тегов большая - возможна перестановка фирм, импорт-замена фирмы с помощью тегов UKPR
    
    Вводятся переменные(sequence) в блоке обработки таблиц (по смыслу как массивы с величинами ширины столбцов,
    чтобы при обработке ячеек необходимому атрибуту присваивалась соотв. ширина столбца)
    
    Версия 2.2 Генерация дополнительного абзаца COLONT_UKPR после UKPR_F_NAME для формирования колонтитулов в макете
    происходит с применением регулярного выражения (только в xslt 2.0)
    -->
    <xsl:strip-space elements="*"/> <!-- Инструкция удаляет все пробельные узлы из исходного дерева xhtml -->
    <xsl:param name="logo-folder">C:/enc2021/</xsl:param>
    
    <xsl:template match="body">
        <xsl:text>&#xA;</xsl:text>
        <Chapter xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/">
            <xsl:apply-templates select="*"/>
            <!-- Если в обрабатываемом файле есть абзацы с классом UKPR_F_NAME, перед закрывающимся тегом </Chapter> ставится принудительно закрывающийся тег </UKPR> для закрытия последнего описания фирмы-->
            <xsl:choose>
                <xsl:when test="descendant::p[@class='UKPR_F_NAME']">
                    <xsl:text disable-output-escaping="yes"><![CDATA[</UKPR>]]></xsl:text> 
                </xsl:when>
            </xsl:choose>           
        </Chapter>
    </xsl:template>
    
    <xsl:template match="hr"> <!-- для двух типов линеек в макете вводятся два стиля, которые присваиваются в зависимости от атрибутов тега hr 
                                Кроме того, по факту hr без аттр. align вводятся обрамляющие теги UKPR/ - подробнее выше-->
        <xsl:choose>
            <xsl:when test="@align">
                <UKPR_FIRM_PREPBEGIN xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="UKPR_FIRM_PREPBEGIN"></UKPR_FIRM_PREPBEGIN>                
            </xsl:when>
            <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="preceding::p[@class='UKPR_F_NAME']">
                            <!-- Закрывается тег </UKPR> и открывается новый <UKPR> для всех описаний фирм кроме первого, когда встечается класс UKPR_F_NAME -->
                            <xsl:text disable-output-escaping="yes"><![CDATA[</UKPR>]]></xsl:text>
                            <xsl:text disable-output-escaping="yes"><![CDATA[<UKPR>]]></xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Открывается тег <UKPR> для первого описания фирмы-->
                            <xsl:text disable-output-escaping="yes"><![CDATA[<UKPR>]]></xsl:text>                    
                        </xsl:otherwise>
                    </xsl:choose>
                <UKPR_FIRM_BEGIN xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="UKPR_FIRM_BEGIN"></UKPR_FIRM_BEGIN>                
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="p[@class]"> <!-- формируются теги с названиями по значениям атрибутов class тегов абзацев p -->
        <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="@class"/><xsl:text> aid:pstyle="</xsl:text><xsl:value-of select="@class"/><xsl:text>"</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
            <xsl:apply-templates select="text() | *" mode="character-style-range"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="@class"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
        <xsl:if test="@class='UKPR_F_NAME'"> <!-- генерация дополнительного абзаца COLONT_UKPR после UKPR_F_NAME для формирования колонтитулов в макете-->
            <xsl:text>&#xA;</xsl:text>
            <COLONT_UKPR xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="COLONT_UKPR">
                <xsl:analyze-string select="." regex="([^(]+)(\s+\(.+\))">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/> <!-- Выбираем первую группу символов - те, которые стоят до открывающей круглой скобки -->
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </COLONT_UKPR> <!-- для формирования колонтитулов в макете по значениям абзацев со стилями, проверяемыми во сравнении, добавляется дублирующий абзац со стилем COLONT_UKPR -->
        </xsl:if>
        <xsl:choose>
            <xsl:when test="following-sibling::p or following-sibling::img">
                <!-- в частности, перевод строки в формирующемся xml не должен вставляться перед закрывающим тегом Cell, в разбираемомо html соотв. </td> -->
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="img"> <!-- обработка тегов со ссылками на логотипы -->
        <xsl:variable name="uriimg">
             <xsl:value-of select="concat($logo-folder, substring-before(@src, '.gif'), '.eps')"/>
                        <!-- первый аргумент concat содержит URI-ссылку на папку, содержащую рисунки -->

        </xsl:variable>
        <Graphics xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/" aid:pstyle="Graphics" href="file:///{$uriimg}"/>
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

    <xsl:template match="span[@style]" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:variable name="font-face">
            <xsl:value-of select="substring-before(substring-after(@style, 'font-family:'), ';')"/>
        </xsl:variable>
        <xsl:apply-templates select="* | text()" mode="character-style-range">
            <xsl:with-param name="inherited-character-style">
                <xsl:choose>
                    <xsl:when test="contains($font-face, ' ')">
                        <xsl:value-of select="replace($font-face, ' ', '')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@face"/> 
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>        
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="u" mode="character-style-range">
        <xsl:param name="inherited-character-style" select="''"/>
        <xsl:apply-templates select="* | text()" mode="character-style-range">
            <xsl:with-param name="inherited-character-style">
                <xsl:value-of select="concat($inherited-character-style, 'Underline')"/>     
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
        <xsl:variable name="curr-paragraph-context-id" select="generate-id(ancestor::p[1])"/>
        <xsl:choose> <!-- шаблон настроен на концепцию обработки тегов ссылок, которые при трансформации в xml приводятся в соответствующие теги xml, а с учетом отображения в макете добавляются 
                      наполнители 0000 для будущих перекрестных ссылок и знаки препинания; запускаемый в макете скрипт путем поиска ссылочных тегов с одинаковыми аттрибутами href и name актуализирует перекрестные ссылки-->
            <xsl:when test="not(preceding::a[generate-id(ancestor::p[1])=$curr-paragraph-context-id])"> <!-- если нет предшествующих тегов <a..> под общим первым предком p, идентичность которого проверяется с помощью generate-id()-->
                <xsl:text>&#x09;</xsl:text> <!-- добавляется табуляция, если ссылочный тег первый в цепочке (внимание: каждый ссылочный тег может быть внутри стилевого тега b, i etc.)  -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose> <!-- код для вставки знаков препинания перед оставшимися после первого в цепочке ссылочных тегов -->
                    <xsl:when test="count(preceding::a[generate-id(ancestor::p[1])=$curr-paragraph-context-id]) mod 2 = 1">
                        <xsl:text>&#x2C;&#x20;</xsl:text> <!-- запятая с пробелом, если предыдущих ссылочных тегов нечетное количество -->                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#x2C;&#xA;</xsl:text> <!-- запятая с переводом строки, если предыдущих ссылочных тегов четное количество -->
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

    <xsl:template match="img" mode="character-style-range"> <!-- обработка рисунков, стоящих внутри тега p вместе с текстом - привязанных к абзацу Inline рисунков  -->
        <xsl:variable name="uriimg">
            <xsl:value-of select="concat($logo-folder, substring-before(@src, '.gif'), '.eps')"/>
            <!-- первый аргумент concat содержит URI-ссылку на папку, содержащую логотипы -->
        </xsl:variable>
        <Image href="file:///{$uriimg}"/>
    </xsl:template>

<!-- Обработка таблиц -->
    <xsl:template match="table">
                <xsl:variable name="BodyRowCount" select="count(descendant::tr)"/>
                <xsl:variable name="maxcol_row"> <!-- блок, осуществляющий подсчет максимального количества столбцов в таблице методом перебора строк осуществляется вызов шаблона с рекурсивным вызовом -->
                    <xsl:call-template name="Table_calc_columns"/>
                </xsl:variable>
                <xsl:variable name="colcount_inmaxcol_row"
                    select="count(descendant::tr[position() = $maxcol_row]/td)"/>
                <xsl:variable name="arrColWidth" as="xs:integer*"> <!-- В зависимости от количества столбцов формируются переменные-последовательности, состоящие из величин ширины столбцов -->
                    <xsl:choose>
                        <xsl:when test="count(descendant::td)=2">
                            <xsl:sequence select="(174, 300)"/> <!-- величины ширины столбцов для таблицы, содержащей логотип и название фирмы с адресом -->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="(120, 121, 111, 113, 39)"/> <!-- величины ширины столбцов для таблицы, содержащей информацию о препаратах в текущем указателе -->
                        </xsl:otherwise>
                    </xsl:choose>                    
                </xsl:variable>
                <xsl:variable name="header-row-count">
                    <xsl:call-template name="Table_HeaderRowCount"/> <!-- подсчет числа строк в заголовке таблицы: берется максимальный среди всех ячеек первой строки атрибут rowspan -->          
                </xsl:variable>
                <xsl:variable name="table-style"> <!-- В зависимости от количества столбцов определяется стиль таблицы: в макете их всего два -->
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
                                    <xsl:variable name="columnWidth" select="subsequence($arrColWidth, position(),1)"/> <!-- Определяется ширина столбца путем выкусывания величины из определенной выше последовательности по номеру столбца-->
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
                                    <xsl:variable name="columnWidth" select="subsequence($arrColWidth, position(),1)"/> <!-- Определяется ширина столбца путем выкусывания величины из определенной выше последовательности по номеру столбца-->                                    
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


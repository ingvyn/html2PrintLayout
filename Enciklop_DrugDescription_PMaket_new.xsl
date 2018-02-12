<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!-- 
Базовое преобразование заимствовано из разработки ickmull https://code.google.com/archive/p/ickmull/downloads
Преобразование tkbr2icml-v043.xsl
v. 0.4, Dec 2009

This script is copyright 2009 by John W. Maxwell, Meghan MacDonald, 
and Travis Nicholson at Simon Fraser University's Master of Publishing
program.

Our intent is that this script be free licensed; you are hereby free to
use, study, modify, share, and redistribute this software as needed. 
This script would be GNU GPL-licensed, except that small parts of it come 
directly from Adobe's excellent IDML Cookbook and SDK and so aren't ours
to license. That said, the point of the thing is educational, so go to it.
See also http://www.adobe.com/devnet/indesign/

This script is not meant to be comprehensive or perfect. It was written
and tested in the context of the CCSP's Book Publishing 1 title, and content
from out ZWiki-based webCM system. To make it work with your content, you
will probably need to make modifications. That said, it is a working 
proof-of-concept and a foundation for further work. - JMax June 5, 2009.

CHANGES
===========
v0.2 - JMax: Nov 2009. Tweaks to make this work with TinyMCE's content rather than the HTML that ZWiki's ReStructured Text creates.
v0.2.5 - Meghan: Dec 2009. Added handlers for crude p-level metadata
v0.3 - JMax: merged 0.2 and 0.25, tweaked support for "a" links
v0.4 - Keith Fahlgren: Refactored XSLT for clarity, organization, and extensibility; added support for hyperlinks
v0.4.3 - John's minor tweaks anf bugfixes: start para, ignored para, etc. some image-handling hacks
-->
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xhtml" version="1.0">
  <!-- Пока ширина большинства таблиц задается здесь в пунктах -->
  <xsl:param name="table-width">161.575</xsl:param>

  <!-- Fixed strings used to indicate ICML and software version -->
  <xsl:variable name="icml-decl-pi">
    <xsl:text>style="50" type="snippet" readerVersion="6.0" featureSet="257" product="6.0(352)"</xsl:text>
    <!-- product string will change with specific InDesign builds (but probably doesn't matter) -->
  </xsl:variable>
  <xsl:variable name="snippet-type-pi">
    <xsl:text>SnippetType="InCopyInterchange"</xsl:text>
  </xsl:variable>

  <!-- Default Rule: Match everything, ignore it,  and keep going "down". -->
  <xsl:template match="@* | node()">
    <xsl:apply-templates select="@* | node()"/>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Document root generation and boilerplate. -->
  <!-- ==================================================================== -->
  <xsl:template match="body">
    <xsl:processing-instruction name="aid"><xsl:value-of select="$icml-decl-pi"/></xsl:processing-instruction>
    <xsl:processing-instruction name="aid"><xsl:value-of select="$snippet-type-pi"/></xsl:processing-instruction>
    <Document DOMVersion="6.0" Self="xhtml2icml_document">
      <xsl:text>&#xA;</xsl:text>
      <!-- Далее перечисляются базовые стили символов, абзацев, таблиц, ячеек таблиц и объектов,
	 которые не создаются сами в результате преобразования -->
      <RootCharacterStyleGroup Self="xhtml2icml_character_styles">
        <xsl:text>&#xA;</xsl:text>
        <CharacterStyle Self="CharacterStyle/[No character style]" Name="[No character style]"/>
        <xsl:text>&#xA;</xsl:text>
        <CharacterStyle Self="CharacterStyle/link" Name="link"/>
        <xsl:text>&#xA;</xsl:text>
        <CharacterStyle Self="CharacterStyle/i" Name="i"/>
        <xsl:text>&#xA;</xsl:text>
        <CharacterStyle Self="CharacterStyle/b" Name="b"/>
        <xsl:text>&#xA;</xsl:text>
        <!-- Generate the rest of the CharacterStyles using the @class value -->
        <xsl:apply-templates select="//span[@class]" mode="character-style"/>
        <xsl:apply-templates select="//font[@face]" mode="character-style"/>
      </RootCharacterStyleGroup>
      <xsl:text>&#xA;</xsl:text>
      <RootParagraphStyleGroup Self="xhtml2icml_paragraph_styles">
        <xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/OPIS_END" Name="OPIS_END"/>
        <ParagraphStyle Self="ParagraphStyle/table" Name="table"/>
        <ParagraphStyle Self="ParagraphStyle/IDENT" Name="IDENT"/>
        <xsl:text>&#xA;</xsl:text>
        <!-- Generate the rest of the ParagraphStyles using the @class value -->
        <xsl:apply-templates select="//p[@class]" mode="paragraph-style"/>
        <xsl:apply-templates select="//td[@class]" mode="paragraph-style"/>
      </RootParagraphStyleGroup>
      <xsl:text>&#xA;</xsl:text>
      <RootCellStyleGroup Self="u78">
        <xsl:text>&#xA;</xsl:text>
        <CellStyle Self="CellStyle/$ID/[None]"
          AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" Name="$ID/[None]"/>
        <xsl:text>&#xA;</xsl:text>
        <CellStyle Self="CellStyle/Cell_Sost_Val" GraphicLeftInset="0" GraphicTopInset="0"
          GraphicRightInset="0" GraphicBottomInset="0" TextTopInset="1" TextLeftInset="0"
          TextBottomInset="1" TextRightInset="0"
          AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" TopInset="1" LeftInset="1"
          BottomInset="1" RightInset="1" VerticalJustification="BottomAlign"
          LeftEdgeStrokeWeight="0" TopEdgeStrokeWeight="0" RightEdgeStrokeWeight="0"
          BottomEdgeStrokeWeight="0" KeyboardShortcut="0 0" Name="Cell_Sost_Val">
          <xsl:text>&#xA;</xsl:text>
          <Properties>
            <BasedOn type="string">$ID/[None]</BasedOn>
          </Properties>
          <xsl:text>&#xA;</xsl:text>
        </CellStyle>
        <xsl:text>&#xA;</xsl:text>
        <CellStyle Self="CellStyle/CellMono_0Line" GraphicLeftInset="0" GraphicTopInset="0"
          GraphicRightInset="0" GraphicBottomInset="0" TextTopInset="1" TextLeftInset="0"
          TextBottomInset="1" TextRightInset="0"
          AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" TopInset="1" LeftInset="1"
          BottomInset="1" RightInset="1" LeftEdgeStrokeWeight="0"
          LeftEdgeStrokeType="StrokeStyle/$ID/Solid" LeftEdgeStrokeColor="Color/Paper"
          TopEdgeStrokeWeight="0" TopEdgeStrokeType="StrokeStyle/$ID/Solid"
          TopEdgeStrokeColor="Color/Paper" RightEdgeStrokeWeight="0"
          RightEdgeStrokeType="StrokeStyle/$ID/Solid" RightEdgeStrokeColor="Color/Paper"
          BottomEdgeStrokeWeight="0" BottomEdgeStrokeType="StrokeStyle/$ID/Solid"
          BottomEdgeStrokeColor="Color/Paper" KeyboardShortcut="0 0" Name="CellMono_0Line">
          <xsl:text>&#xA;</xsl:text>
          <Properties>
            <BasedOn type="string">$ID/[None]</BasedOn>
          </Properties>
          <xsl:text>&#xA;</xsl:text>
        </CellStyle>
        <xsl:text>&#xA;</xsl:text>
        <CellStyle Self="CellStyle/CellMono_1ThinLine" GraphicLeftInset="0" GraphicTopInset="0"
          GraphicRightInset="0" GraphicBottomInset="0" TextTopInset="1.4173228346456694"
          TextLeftInset="1.4173228346456694" TextBottomInset="1.4173228346456694"
          TextRightInset="1.4173228346456694"
          AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]"
          TopInset="1.4173228346456694" LeftInset="1.4173228346456694"
          BottomInset="1.4173228346456694" RightInset="1.4173228346456694"
          LeftEdgeStrokeWeight="0.25" LeftEdgeStrokeType="StrokeStyle/$ID/Solid"
          LeftEdgeStrokeColor="Color/Black" TopEdgeStrokeWeight="0.25"
          TopEdgeStrokeType="StrokeStyle/$ID/Solid" TopEdgeStrokeColor="Color/Black"
          RightEdgeStrokeWeight="0.25" RightEdgeStrokeType="StrokeStyle/$ID/Solid"
          RightEdgeStrokeColor="Color/Black" BottomEdgeStrokeWeight="0.25"
          BottomEdgeStrokeType="StrokeStyle/$ID/Solid" BottomEdgeStrokeColor="Color/Black"
          KeyboardShortcut="0 0" Name="CellMono_1ThinLine">
          <xsl:text>&#xA;</xsl:text>
          <Properties>
            <BasedOn type="string">$ID/[None]</BasedOn>
          </Properties>
          <xsl:text>&#xA;</xsl:text>
        </CellStyle>
        <xsl:text>&#xA;</xsl:text>
      </RootCellStyleGroup>
      <xsl:text>&#xA;</xsl:text>
      <RootTableStyleGroup Self="u7a">
        <xsl:text>&#xA;</xsl:text>
        <TableStyle Self="TableStyle/TableMono_0Line" Name="TableMono_0Line"
          TopBorderStrokeWeight="0" TopBorderStrokeColor="Color/Paper" LeftBorderStrokeWeight="0"
          LeftBorderStrokeColor="Color/Paper" BottomBorderStrokeWeight="0"
          BottomBorderStrokeColor="Color/Paper" RightBorderStrokeWeight="0"
          RightBorderStrokeColor="Color/Paper" SpaceAfter="3.999685039370079"
          HeaderRegionSameAsBodyRegion="false" FooterRegionSameAsBodyRegion="false"
          LeftColumnRegionSameAsBodyRegion="false" RightColumnRegionSameAsBodyRegion="false"
          HeaderRegionCellStyle="CellStyle/CellMono_0Line"
          FooterRegionCellStyle="CellStyle/CellMono_0Line"
          LeftColumnRegionCellStyle="CellStyle/CellMono_0Line"
          RightColumnRegionCellStyle="CellStyle/Cell_Sost_Val"
          BodyRegionCellStyle="CellStyle/CellMono_0Line" KeyboardShortcut="0 0">
          <xsl:text>&#xA;</xsl:text>
          <Properties>
            <BasedOn type="string">$ID/[No table style]</BasedOn>
          </Properties>
          <xsl:text>&#xA;</xsl:text>
        </TableStyle>
        <xsl:text>&#xA;</xsl:text>
        <TableStyle Self="TableStyle/TableMono_1ThinLine" Name="TableMono_1ThinLine"
          TopBorderStrokeWeight="0.25" LeftBorderStrokeWeight="0.25" BottomBorderStrokeWeight="0.25"
          RightBorderStrokeWeight="0.25" SpaceAfter="3.999685039370079"
          BodyRegionCellStyle="CellStyle/CellMono_1ThinLine" KeyboardShortcut="0 0">
          <xsl:text>&#xA;</xsl:text>
          <Properties>
            <BasedOn type="string">$ID/[No table style]</BasedOn>
          </Properties>
          <xsl:text>&#xA;</xsl:text>
        </TableStyle>
        <xsl:text>&#xA;</xsl:text>
        <TableStyle Self="TableStyle/$ID/[No table style]" GraphicLeftInset="0" GraphicTopInset="0"
          GraphicRightInset="0" GraphicBottomInset="0" ClipContentToGraphicCell="false"
          TextTopInset="4" TextLeftInset="4" TextBottomInset="4" TextRightInset="4"
          ClipContentToTextCell="false" Name="$ID/[No table style]" StrokeOrder="BestJoins"
          TopBorderStrokeWeight="1" TopBorderStrokeType="StrokeStyle/$ID/Solid"
          TopBorderStrokeColor="Color/Black" TopBorderStrokeTint="100"
          TopBorderStrokeOverprint="false" TopBorderStrokeGapColor="Color/Paper"
          TopBorderStrokeGapTint="100" TopBorderStrokeGapOverprint="false"
          LeftBorderStrokeWeight="1" LeftBorderStrokeType="StrokeStyle/$ID/Solid"
          LeftBorderStrokeColor="Color/Black" LeftBorderStrokeTint="100"
          LeftBorderStrokeOverprint="false" LeftBorderStrokeGapColor="Color/Paper"
          LeftBorderStrokeGapTint="100" LeftBorderStrokeGapOverprint="false"
          BottomBorderStrokeWeight="1" BottomBorderStrokeType="StrokeStyle/$ID/Solid"
          BottomBorderStrokeColor="Color/Black" BottomBorderStrokeTint="100"
          BottomBorderStrokeOverprint="false" BottomBorderStrokeGapColor="Color/Paper"
          BottomBorderStrokeGapTint="100" BottomBorderStrokeGapOverprint="false"
          RightBorderStrokeWeight="1" RightBorderStrokeType="StrokeStyle/$ID/Solid"
          RightBorderStrokeColor="Color/Black" RightBorderStrokeTint="100"
          RightBorderStrokeOverprint="false" RightBorderStrokeGapColor="Color/Paper"
          RightBorderStrokeGapTint="100" RightBorderStrokeGapOverprint="false" SpaceBefore="4"
          SpaceAfter="-4" SkipFirstAlternatingStrokeRows="0" SkipLastAlternatingStrokeRows="0"
          StartRowStrokeCount="0" StartRowStrokeColor="Color/Black" StartRowStrokeWeight="1"
          StartRowStrokeType="StrokeStyle/$ID/Solid" StartRowStrokeTint="100"
          StartRowStrokeGapOverprint="false" StartRowStrokeGapColor="Color/Paper"
          StartRowStrokeGapTint="100" StartRowStrokeOverprint="false" EndRowStrokeCount="0"
          EndRowStrokeColor="Color/Black" EndRowStrokeWeight="0.25"
          EndRowStrokeType="StrokeStyle/$ID/Solid" EndRowStrokeTint="100"
          EndRowStrokeOverprint="false" EndRowStrokeGapColor="Color/Paper" EndRowStrokeGapTint="100"
          EndRowStrokeGapOverprint="false" SkipFirstAlternatingStrokeColumns="0"
          SkipLastAlternatingStrokeColumns="0" StartColumnStrokeCount="0"
          StartColumnStrokeColor="Color/Black" StartColumnStrokeWeight="1"
          StartColumnStrokeType="StrokeStyle/$ID/Solid" StartColumnStrokeTint="100"
          StartColumnStrokeOverprint="false" StartColumnStrokeGapColor="Color/Paper"
          StartColumnStrokeGapTint="100" StartColumnStrokeGapOverprint="false"
          EndColumnStrokeCount="0" EndColumnStrokeColor="Color/Black" EndColumnStrokeWeight="0.25"
          EndColumnLineStyle="StrokeStyle/$ID/Solid" EndColumnStrokeTint="100"
          EndColumnStrokeOverprint="false" EndColumnStrokeGapColor="Color/Paper"
          EndColumnStrokeGapTint="100" EndColumnStrokeGapOverprint="false"
          ColumnFillsPriority="false" SkipFirstAlternatingFillRows="0"
          SkipLastAlternatingFillRows="0" StartRowFillColor="Color/Black" StartRowFillCount="0"
          StartRowFillTint="20" StartRowFillOverprint="false" EndRowFillCount="0"
          EndRowFillColor="Swatch/None" EndRowFillTint="100" EndRowFillOverprint="false"
          SkipFirstAlternatingFillColumns="0" SkipLastAlternatingFillColumns="0"
          StartColumnFillCount="0" StartColumnFillColor="Color/Black" StartColumnFillTint="20"
          StartColumnFillOverprint="false" EndColumnFillCount="0" EndColumnFillColor="Swatch/None"
          EndColumnFillTint="100" EndColumnFillOverprint="false" HeaderRegionSameAsBodyRegion="true"
          FooterRegionSameAsBodyRegion="true" LeftColumnRegionSameAsBodyRegion="true"
          RightColumnRegionSameAsBodyRegion="true" HeaderRegionCellStyle="n"
          FooterRegionCellStyle="n" LeftColumnRegionCellStyle="n" RightColumnRegionCellStyle="n"
          BodyRegionCellStyle="CellStyle/$ID/[None]"/>
        <xsl:text>&#xA;</xsl:text>
      </RootTableStyleGroup>
      <xsl:text>&#xA;</xsl:text>
      <RootObjectStyleGroup Self="u83">
        <ObjectStyle Self="ObjectStyle/$ID/[Normal Graphics Frame]" EmitCss="true"
          EnableTextFrameAutoSizingOptions="false" EnableExportTagging="false"
          EnableObjectExportAltTextOptions="false" EnableObjectExportTaggedPdfOptions="false"
          EnableObjectExportEpubOptions="false" Name="$ID/[Normal Graphics Frame]"
          AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]"
          ApplyNextParagraphStyle="false" EnableFill="true" EnableStroke="true"
          EnableParagraphStyle="false" EnableTextFrameGeneralOptions="false"
          EnableTextFrameBaselineOptions="false" EnableStoryOptions="false"
          EnableTextWrapAndOthers="false" EnableAnchoredObjectOptions="false" CornerRadius="12"
          FillColor="Swatch/None" FillTint="-1" StrokeWeight="0" MiterLimit="4" EndCap="ButtEndCap"
          EndJoin="MiterEndJoin" StrokeType="StrokeStyle/$ID/Solid" LeftLineEnd="None"
          RightLineEnd="None" StrokeColor="Swatch/None" StrokeTint="-1" GapColor="Swatch/None"
          GapTint="-1" StrokeAlignment="CenterAlignment" Nonprinting="false" GradientFillAngle="0"
          GradientStrokeAngle="0" AppliedNamedGrid="n" KeyboardShortcut="0 0"
          TopLeftCornerOption="None" TopRightCornerOption="None" BottomLeftCornerOption="None"
          BottomRightCornerOption="None" TopLeftCornerRadius="12" TopRightCornerRadius="12"
          BottomLeftCornerRadius="12" BottomRightCornerRadius="12" EnableFrameFittingOptions="true"
          CornerOption="None" EnableStrokeAndCornerOptions="true" ArrowHeadAlignment="InsidePath"
          LeftArrowHeadScale="100" RightArrowHeadScale="100" EnableTextFrameFootnoteOptions="false">
          <Properties>
            <BasedOn type="string">$ID/[None]</BasedOn>
          </Properties>
          <ObjectExportOption EpubType="$ID/" SizeType="DefaultSize" CustomSize="$ID/"
            PreserveAppearanceFromLayout="PreserveAppearanceDefault"
            AltTextSourceType="SourceXMLStructure" ActualTextSourceType="SourceXMLStructure"
            CustomAltText="$ID/" CustomActualText="$ID/" ApplyTagType="TagFromStructure"
            ImageConversionType="JPEG" ImageExportResolution="Ppi300"
            GIFOptionsPalette="AdaptivePalette" GIFOptionsInterlaced="true"
            JPEGOptionsQuality="High" JPEGOptionsFormat="BaselineEncoding"
            ImageAlignment="AlignLeft" ImageSpaceBefore="0" ImageSpaceAfter="0"
            UseImagePageBreak="false" ImagePageBreak="PageBreakBefore" CustomImageAlignment="false"
            SpaceUnit="CssPixel" CustomLayout="false" CustomLayoutType="AlignmentAndSpacing">
            <Properties>
              <AltMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
              <ActualMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
            </Properties>
          </ObjectExportOption>
          <TextFramePreference TextColumnCount="1" TextColumnGutter="12" TextColumnFixedWidth="144"
            UseFixedColumnWidth="false" FirstBaselineOffset="AscentOffset"
            MinimumFirstBaselineOffset="0" VerticalJustification="TopAlign" VerticalThreshold="0"
            IgnoreWrap="false" UseFlexibleColumnWidth="false" TextColumnMaxWidth="0"
            AutoSizingType="Off" AutoSizingReferencePoint="CenterPoint"
            UseMinimumHeightForAutoSizing="false" MinimumHeightForAutoSizing="0"
            UseMinimumWidthForAutoSizing="false" MinimumWidthForAutoSizing="0"
            UseNoLineBreaksForAutoSizing="false" VerticalBalanceColumns="false">
            <Properties>
              <InsetSpacing type="list">
                <ListItem type="unit">0</ListItem>
                <ListItem type="unit">0</ListItem>
                <ListItem type="unit">0</ListItem>
                <ListItem type="unit">0</ListItem>
              </InsetSpacing>
            </Properties>
          </TextFramePreference>
          <BaselineFrameGridOption UseCustomBaselineFrameGrid="false"
            StartingOffsetForBaselineFrameGrid="0" BaselineFrameGridRelativeOption="TopOfInset"
            BaselineFrameGridIncrement="12">
            <Properties>
              <BaselineFrameGridColor type="enumeration">LightBlue</BaselineFrameGridColor>
            </Properties>
          </BaselineFrameGridOption>
          <AnchoredObjectSetting AnchoredPosition="InlinePosition" SpineRelative="false"
            LockPosition="false" PinPosition="true" AnchorPoint="BottomRightAnchor"
            HorizontalAlignment="LeftAlign" HorizontalReferencePoint="TextFrame"
            VerticalAlignment="BottomAlign" VerticalReferencePoint="LineBaseline" AnchorXoffset="0"
            AnchorYoffset="0" AnchorSpaceAbove="0"/>
          <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false" TextWrapSide="BothSides"
            TextWrapMode="None">
            <Properties>
              <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
            </Properties>
            <ContourOption ContourType="SameAsClipping" IncludeInsideEdges="false"
              ContourPathName="$ID/"/>
          </TextWrapPreference>
          <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="Unknown"
            StoryOrientation="Unknown" StoryDirection="UnknownDirection"/>
          <FrameFittingOption AutoFit="true" LeftCrop="0" TopCrop="0" RightCrop="0" BottomCrop="0"
            FittingOnEmptyFrame="Proportionally" FittingAlignment="CenterAnchor"/>
          <ObjectStyleObjectEffectsCategorySettings EnableTransparency="true"
            EnableDropShadow="true" EnableFeather="true" EnableInnerShadow="true"
            EnableOuterGlow="true" EnableInnerGlow="true" EnableBevelEmboss="true"
            EnableSatin="true" EnableDirectionalFeather="true" EnableGradientFeather="true"/>
          <ObjectStyleStrokeEffectsCategorySettings EnableTransparency="true"
            EnableDropShadow="true" EnableFeather="true" EnableInnerShadow="true"
            EnableOuterGlow="true" EnableInnerGlow="true" EnableBevelEmboss="true"
            EnableSatin="true" EnableDirectionalFeather="true" EnableGradientFeather="true"/>
          <ObjectStyleFillEffectsCategorySettings EnableTransparency="true" EnableDropShadow="true"
            EnableFeather="true" EnableInnerShadow="true" EnableOuterGlow="true"
            EnableInnerGlow="true" EnableBevelEmboss="true" EnableSatin="true"
            EnableDirectionalFeather="true" EnableGradientFeather="true"/>
          <ObjectStyleContentEffectsCategorySettings EnableTransparency="true"
            EnableDropShadow="true" EnableFeather="true" EnableInnerShadow="true"
            EnableOuterGlow="true" EnableInnerGlow="true" EnableBevelEmboss="true"
            EnableSatin="true" EnableDirectionalFeather="true" EnableGradientFeather="true"/>
          <TextFrameFootnoteOptionsObject EnableOverrides="false" SpanFootnotesAcross="false"
            MinimumSpacingOption="12" SpaceBetweenFootnotes="6"/>
        </ObjectStyle>
        <ObjectStyle Self="ObjectStyle/$ID/[None]" EmitCss="true" Name="$ID/[None]"
          AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" CornerRadius="12"
          FillColor="Swatch/None" FillTint="-1" StrokeWeight="0" MiterLimit="4" EndCap="ButtEndCap"
          EndJoin="MiterEndJoin" StrokeType="StrokeStyle/$ID/Solid" LeftLineEnd="None"
          RightLineEnd="None" StrokeColor="Swatch/None" StrokeTint="-1" GapColor="Swatch/None"
          GapTint="-1" StrokeAlignment="CenterAlignment" Nonprinting="false" GradientFillAngle="0"
          GradientStrokeAngle="0" AppliedNamedGrid="n" TopLeftCornerOption="None"
          TopRightCornerOption="None" BottomLeftCornerOption="None" BottomRightCornerOption="None"
          TopLeftCornerRadius="12" TopRightCornerRadius="12" BottomLeftCornerRadius="12"
          BottomRightCornerRadius="12" CornerOption="None" ArrowHeadAlignment="InsidePath"
          LeftArrowHeadScale="100" RightArrowHeadScale="100">
          <ObjectExportOption EpubType="$ID/" SizeType="DefaultSize" CustomSize="$ID/"
            PreserveAppearanceFromLayout="PreserveAppearanceDefault"
            AltTextSourceType="SourceXMLStructure" ActualTextSourceType="SourceXMLStructure"
            CustomAltText="$ID/" CustomActualText="$ID/" ApplyTagType="TagFromStructure"
            ImageConversionType="JPEG" ImageExportResolution="Ppi300"
            GIFOptionsPalette="AdaptivePalette" GIFOptionsInterlaced="true"
            JPEGOptionsQuality="High" JPEGOptionsFormat="BaselineEncoding"
            ImageAlignment="AlignLeft" ImageSpaceBefore="0" ImageSpaceAfter="0"
            UseImagePageBreak="false" ImagePageBreak="PageBreakBefore" CustomImageAlignment="false"
            SpaceUnit="CssPixel" CustomLayout="false" CustomLayoutType="AlignmentAndSpacing">
            <Properties>
              <AltMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
              <ActualMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
            </Properties>
          </ObjectExportOption>
          <TextFramePreference TextColumnCount="1" TextColumnGutter="12" TextColumnFixedWidth="144"
            UseFixedColumnWidth="false" FirstBaselineOffset="AscentOffset"
            MinimumFirstBaselineOffset="0" VerticalJustification="TopAlign" VerticalThreshold="0"
            IgnoreWrap="false" UseFlexibleColumnWidth="false" TextColumnMaxWidth="0"
            AutoSizingType="Off" AutoSizingReferencePoint="CenterPoint"
            UseMinimumHeightForAutoSizing="false" MinimumHeightForAutoSizing="0"
            UseMinimumWidthForAutoSizing="false" MinimumWidthForAutoSizing="0"
            UseNoLineBreaksForAutoSizing="false" VerticalBalanceColumns="false">
            <Properties>
              <InsetSpacing type="list">
                <ListItem type="unit">0</ListItem>
                <ListItem type="unit">0</ListItem>
                <ListItem type="unit">0</ListItem>
                <ListItem type="unit">0</ListItem>
              </InsetSpacing>
            </Properties>
          </TextFramePreference>
          <BaselineFrameGridOption UseCustomBaselineFrameGrid="false"
            StartingOffsetForBaselineFrameGrid="0" BaselineFrameGridRelativeOption="TopOfInset"
            BaselineFrameGridIncrement="12">
            <Properties>
              <BaselineFrameGridColor type="enumeration">LightBlue</BaselineFrameGridColor>
            </Properties>
          </BaselineFrameGridOption>
          <AnchoredObjectSetting AnchoredPosition="InlinePosition" SpineRelative="false"
            LockPosition="false" PinPosition="true" AnchorPoint="BottomRightAnchor"
            HorizontalAlignment="LeftAlign" HorizontalReferencePoint="TextFrame"
            VerticalAlignment="BottomAlign" VerticalReferencePoint="LineBaseline" AnchorXoffset="0"
            AnchorYoffset="0" AnchorSpaceAbove="0"/>
          <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false" TextWrapSide="BothSides"
            TextWrapMode="None">
            <Properties>
              <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
            </Properties>
            <ContourOption ContourType="SameAsClipping" IncludeInsideEdges="false"
              ContourPathName="$ID/"/>
          </TextWrapPreference>
          <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12"
            FrameType="TextFrameType" StoryOrientation="Horizontal"
            StoryDirection="UnknownDirection"/>
          <FrameFittingOption AutoFit="false" LeftCrop="0" TopCrop="0" RightCrop="0" BottomCrop="0"
            FittingOnEmptyFrame="None" FittingAlignment="TopLeftAnchor"/>
          <TextFrameFootnoteOptionsObject EnableOverrides="false" SpanFootnotesAcross="false"
            MinimumSpacingOption="12" SpaceBetweenFootnotes="6"/>
        </ObjectStyle>
      </RootObjectStyleGroup>
      <xsl:text>&#xA;</xsl:text>
      <TextVariable Self="dTextVariablen&lt;?AID 001b?&gt;TV XRefPageNumber" Name="&lt;?AID 001b?&gt;TV XRefPageNumber" VariableType="XrefPageNumberType" />
      <xsl:text>&#xA;</xsl:text>
      <CrossReferenceFormat Self="u91" Name="Page Number" AppliedCharacterStyle="n">
        <BuildingBlock Self="u91BuildingBlock0" BlockType="CustomStringBuildingBlock" AppliedCharacterStyle="n" CustomText="&#x9;" AppliedDelimiter="$ID/" IncludeDelimiter="false" />
        <BuildingBlock Self="u91BuildingBlock1" BlockType="PageNumberBuildingBlock" AppliedCharacterStyle="n" CustomText="$ID/" AppliedDelimiter="$ID/" IncludeDelimiter="false" />
      </CrossReferenceFormat>
      <xsl:text>&#xA;</xsl:text>      
      <Story Self="xhtml2icml_default_story" AppliedTOCStyle="n" TrackChanges="false"
        StoryTitle="MyStory" AppliedNamedGrid="n">
        <xsl:text>&#xA;</xsl:text>
        <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12"
          FrameType="TextFrameType" StoryOrientation="Horizontal"
          StoryDirection="LeftToRightDirection"/>
        <xsl:text>&#xA;</xsl:text>
        <InCopyExportOption IncludeGraphicProxies="true" IncludeAllResources="false"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates/>
      </Story>
      <xsl:apply-templates select=".//a" mode="hyperlinks"/>
    </Document>
  </xsl:template>

  <!-- Headings -->
  <xsl:template match="
      h1 |
      h2 |
      h3 |
      h4 |
      h5 |
      h6">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name" select="name()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="hr">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name" select="'OPIS_END'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Paras and block-level elements -->
  <!-- ==================================================================== -->

  <!-- == Initial-vs-subsequent paragraph treatment == 
       The more I think about it (and muse on Bringhurst's elegant simplicity), 
       the more I think that the right way to treat this is to say that the 
       default paragraph treatment should use the 'p' style and the 
       *special case* is a "normal" (@class-less) paragraph that immediately 
       follows another normal paragraph. Use the 'pFollowsP' for that case. -->

  <!-- Normal initial paragraphs -->
  <xsl:template match="p[not(@class)]">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">p</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Paragraphs that follow paragraphs -->
  <xsl:template
    match="
      p[not(@class)]
      [preceding-sibling::*[1][self::p[not(@class)] or @class = 'start']]
      ">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">pFollowsP</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Dynamically-style-named paragraphs -->
  <xsl:template match="p[@class and not(starts-with(@class, 'dc-'))]">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name" select="@class"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Document metadata paragraphs have a @class starting with 'dc-' -->
  <xsl:template match="p[@class = 'dc-creator']">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">author</xsl:with-param>
      <xsl:with-param name="prefix-content">by </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Quotes (also available from <p class="quote">) -->
  <xsl:template match="blockquote/p">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">quote</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- p class = 'ignore': strip out entirely -->
  <xsl:template match="p[@class = 'ignore']"> </xsl:template>

  <!-- ==================================================================== -->
  <!-- Lists -->
  <!-- ==================================================================== -->
  <!-- TODO: What about other children of the li? What about multiple children
       on a single li? -->
  <!--  <xsl:template match="ol/li[*]|
                       ul/li[*]">
    <xsl:if test="count(*) &gt; 1">
      <xsl:message terminate="yes">Multi-element list items not handled!
</xsl:message>
    </xsl:if>
    <xsl:if test="*[not(self::p)]">
      <xsl:message terminate="yes">Non-paragraph list children not handled!
</xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template> -->
  <xsl:template match="
      ol/li/p |
      ol/li[not(*)]">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">ol</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="
      ul/li/p |
      ul/li[not(*)]">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">ul</xsl:with-param>
    </xsl:call-template>
  </xsl:template>



  <!-- ==================================================================== -->
  <!-- Tables -->
  <!-- ==================================================================== -->

  <xsl:template match="table">
    <xsl:choose>
      <xsl:when test="@tab_name">
        <!-- блок, осуществляющий подсчет максимального количества столбцов в таблице методом перебора строк 
	осуществляется вызов шаблона с рекурсивным вызовом -->
        <xsl:variable name="maxcol_row">
          <xsl:call-template name="Table_calc_columns"/>
        </xsl:variable>
        <xsl:variable name="colcount_inmaxcol_row"
          select="count(descendant::tr[position() = $maxcol_row]/td)"/>
        <!--конец блока, осуществляющего подсчет максимального количества столбцов -->
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/table">
          <xsl:text>&#xA;</xsl:text>
          <CharacterStyleRange>
            <xsl:text>&#xA;</xsl:text>
            <Table HeaderRowCount="0" FooterRowCount="0" TableDirection="LeftToRightDirection">
              <xsl:attribute name="AppliedTableStyle">
                <xsl:value-of select="'TableStyle/TableMono_1ThinLine'"/>
              </xsl:attribute>
              <xsl:attribute name="BodyRowCount">
                <xsl:value-of select="count(descendant::tr)"/>
              </xsl:attribute>
              <xsl:attribute name="ColumnCount">
                <xsl:value-of select="$colcount_inmaxcol_row"/>
              </xsl:attribute>
              <xsl:text>&#xA;</xsl:text>
              <xsl:variable name="columnWidth"
                select="$table-width div count(descendant::tr[position() = $maxcol_row]/td)"/>
              <xsl:for-each select="descendant::tr[position() = $maxcol_row]/td">
                <Column Name="{position() - 1}" SingleColumnWidth="{$columnWidth}"/>
                <xsl:text>&#xA;</xsl:text>
              </xsl:for-each>
              <!-- в переменной осуществляется формирование вх. строки флажков из нулей для первого вызова рекурсивных шаблонов,
          в которых формируются все теги ячеек таблицы в выходной поток-->
              <xsl:variable name="InpStr4Table">
                <xsl:call-template name="SetFirstInpString">
                  <xsl:with-param name="colNumber" select="$colcount_inmaxcol_row"/>
                  <xsl:with-param name="FirstInpString" select="''"/>
                </xsl:call-template>
              </xsl:variable>
              <!--вызова рекурсивных шаблонов, в которых формируются все теги ячеек таблицы в выходной поток-->
              <xsl:call-template name="SpannedTableRow_Build">
                <xsl:with-param name="cell-idLine" select="$InpStr4Table"/>
                <xsl:with-param name="rowpos" select="1"/>
              </xsl:call-template>
            </Table>
            <xsl:text>&#xA;</xsl:text>
            <Br/>
            <xsl:text>&#xA;</xsl:text>
          </CharacterStyleRange>
          <xsl:text>&#xA;</xsl:text>
        </ParagraphStyleRange>
        <xsl:text>&#xA;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="descendant::tr">
          <xsl:variable name="get-para-style">
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
          <xsl:variable name="cell1-is-empty" select="child::td[1]"/>
          <xsl:variable name="cell2-is-empty" select="child::td[2]"/>
          <ParagraphStyleRange>
            <xsl:attribute name="AppliedParagraphStyle">
              <xsl:value-of select="concat('ParagraphStyle/', $get-para-style)"/>
            </xsl:attribute>
            <xsl:if test="$cell1-is-empty != '&#xA0;'">
              <xsl:apply-templates select="child::td[position() = 1]" mode="character-style-range"/>
              <xsl:if test="$cell2-is-empty != '&#xA0;'">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/[No character style]"
                  Position="Normal">
                  <Content>
                    <xsl:copy-of select="'&#x9;'"/>
                  </Content>
                </CharacterStyleRange>
              </xsl:if>
            </xsl:if>
            <xsl:if test="$cell2-is-empty != '&#xA0;'">
              <xsl:apply-templates select="child::td[position() = 2]" mode="character-style-range"/>
            </xsl:if>
          </ParagraphStyleRange>
          <Br/>
          <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
я закомментировал этот блок
  <xsl:template match="tr">
    <xsl:if test="position() &gt; 2">
      <Br/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="td">
    <xsl:if test="position() &gt; 2">
      <Br/>
    </xsl:if>
  </xsl:template>
  я закомментировал этот блок
-->
  <!-- ==================================================================== -->
  <!-- Images -->
  <!-- ==================================================================== -->
  <xsl:template match="img">
    <xsl:variable name="halfwidth">
      <xsl:choose>
        <xsl:when test="@vent">
          <xsl:value-of select="80.77"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="36.83"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="halfheight">
      <xsl:choose>
        <xsl:when test="@vent">
          <xsl:value-of select="51"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="24"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="uriimg">
    <xsl:choose>
        <xsl:when test="@vent">
      <xsl:value-of
        select="concat('C:/Users/%D0%B8%D0%BD%D0%B8%D0%BA%D0%B8%D1%82%D0%B8%D0%BD/Documents/ENCIKLOP%20InDesign/Pictures/', substring-before(@src, '.jpg'), '.eps')"/>
      </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="concat('C:/Users/%D0%B8%D0%BD%D0%B8%D0%BA%D0%B8%D1%82%D0%B8%D0%BD/Documents/ENCIKLOP%20InDesign/Struf_DV/', substring-before(substring-after(@src, '\\DISKSTATION\NetBackup\BOOK\Struf_DV\'), '.gif'), '.tif')"
          />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="anchored-graphics-Pstyle">
<!--      <xsl:choose>
        <xsl:when test="@vent"> -->
          <xsl:value-of select="'OPIS_POLE_ABZ'"/>
<!--        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'IDENT'"/>
        </xsl:otherwise>
      </xsl:choose> -->
    </xsl:variable>
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/{$anchored-graphics-Pstyle}">
      <xsl:text>&#xA;</xsl:text>
      <CharacterStyleRange>
        <xsl:text>&#xA;</xsl:text>
        <Rectangle ContentType="GraphicType"
          AppliedObjectStyle="ObjectStyle/$ID/[Normal Graphics Frame]" Visible="true"
          ItemTransform="1 0 0 1 {$halfwidth} -{$halfheight}">
          <xsl:text>&#xA;</xsl:text>
          <Properties>
            <xsl:text>&#xA;</xsl:text>
            <PathGeometry>
              <xsl:text>&#xA;</xsl:text>
              <GeometryPathType PathOpen="false">
                <xsl:text>&#xA;</xsl:text>
                <PathPointArray>
                  <xsl:text>&#xA;</xsl:text>
                  <PathPointType Anchor="-{$halfwidth} -{$halfheight}"
                    LeftDirection="-{$halfwidth} -{$halfheight}"
                    RightDirection="-{$halfwidth} -{$halfheight}"/>
                  <xsl:text>&#xA;</xsl:text>
                  <PathPointType Anchor="-{$halfwidth} {$halfheight}"
                    LeftDirection="-{$halfwidth} {$halfheight}"
                    RightDirection="-{$halfwidth} {$halfheight}"/>
                  <xsl:text>&#xA;</xsl:text>
                  <PathPointType Anchor="{$halfwidth} {$halfheight}"
                    LeftDirection="{$halfwidth} {$halfheight}"
                    RightDirection="{$halfwidth} {$halfheight}"/>
                  <xsl:text>&#xA;</xsl:text>
                  <PathPointType Anchor="{$halfwidth} -{$halfheight}"
                    LeftDirection="{$halfwidth} -{$halfheight}"
                    RightDirection="{$halfwidth} -{$halfheight}"/>
                  <xsl:text>&#xA;</xsl:text>
                </PathPointArray>
                <xsl:text>&#xA;</xsl:text>
              </GeometryPathType>
              <xsl:text>&#xA;</xsl:text>
            </PathGeometry>
            <xsl:text>&#xA;</xsl:text>
          </Properties>
          <xsl:text>&#xA;</xsl:text>
          <AnchoredObjectSetting AnchoredPosition="AboveLine" SpineRelative="false"
            LockPosition="false" PinPosition="true" AnchorPoint="BottomRightAnchor"
            HorizontalAlignment="CenterAlign" HorizontalReferencePoint="TextFrame"
            VerticalAlignment="TopAlign" VerticalReferencePoint="LineBaseline" AnchorXoffset="0"
            AnchorYoffset="-5.164724409448819" AnchorSpaceAbove="5.164724409448819"/>
          <xsl:text>&#xA;</xsl:text>
          <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false" TextWrapSide="BothSides"
            TextWrapMode="None">
            <xsl:text>&#xA;</xsl:text>
            <Properties>
              <xsl:text>&#xA;</xsl:text>
              <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
              <xsl:text>&#xA;</xsl:text>
            </Properties>
            <xsl:text>&#xA;</xsl:text>
            <ContourOption ContourType="SameAsClipping" IncludeInsideEdges="false"
              ContourPathName="$ID/"/>
            <xsl:text>&#xA;</xsl:text>
          </TextWrapPreference>
          <xsl:text>&#xA;</xsl:text>
          <FrameFittingOption AutoFit="true" FittingOnEmptyFrame="Proportionally"/>
          <Image ItemTransform="1 0 0 1 -{$halfwidth} -{$halfheight}">
            <xsl:text>&#xA;</xsl:text>
            <Properties>
              <xsl:text>&#xA;</xsl:text>
              <Profile type="string">$ID/Embedded</Profile>
              <xsl:text>&#xA;</xsl:text>
              <GraphicBounds Left="0" Top="0" Right="{2*$halfwidth}" Bottom="{2*$halfheight}"/>
              <xsl:text>&#xA;</xsl:text>
            </Properties>
            <xsl:text>&#xA;</xsl:text>
            <Link Self="ueb" LinkResourceURI="file:{$uriimg}"/>
            <xsl:text>&#xA;</xsl:text>
          </Image>
          <xsl:text>&#xA;</xsl:text>
        </Rectangle>
        <xsl:text>&#xA;</xsl:text>
        <Br/>
        <xsl:text>&#xA;</xsl:text>
      </CharacterStyleRange>
      <xsl:text>&#xA;</xsl:text>
    </ParagraphStyleRange>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>



  <!-- ==================================================================== -->
  <!-- Links -->
  <!-- ==================================================================== -->
  <xsl:template match="a[@href]" mode="character-style-range">
    <xsl:param name="inherited-font-style" select="'Regular'"/>
    <xsl:param name="inherited-position" select="'Normal'"/>
    <xsl:param name="inherited-character-style" select="'[No character style]'"/>    
    <xsl:variable name="crossref-IDREF">
      <xsl:value-of select="concat('u', @href)"/>
    </xsl:variable>
    <xsl:variable name="crossref-nameREF">
      <xsl:value-of select="concat('hyper', @href)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(preceding-sibling::a or preceding-sibling::*/a)">
        <CharacterStyleRange>
          <xsl:attribute name="AppliedCharacterStyle">
            <xsl:value-of select="'[No Character style]'"/>
          </xsl:attribute>
          <xsl:attribute name="FontStyle">
            <xsl:value-of select="'Regular'"/>
          </xsl:attribute>
          <xsl:attribute name="Position">
            <xsl:value-of select="'Normal'"/>
          </xsl:attribute>        
          <Content><xsl:text>&#x09;</xsl:text></Content> <!-- табуляция -->
        </CharacterStyleRange>        
      </xsl:when>
    </xsl:choose>
    <CrossReferenceSource Self="{$crossref-IDREF}" AppliedFormat="u91" Name="{$crossref-nameREF}" Hidden="false" AppliedCharacterStyle="n">
        <CharacterStyleRange PageNumberType="TextVariable">
          <xsl:attribute name="AppliedCharacterStyle">
            <xsl:value-of select="concat('CharacterStyle/', $inherited-character-style)"/>
          </xsl:attribute>
          <xsl:choose>
            <!-- у текста со тилем Regular значение аттрибута FontStyle опускается для того, чтобы те стили абзаца,
         которые имеют стиль написания, отличный от заданного в html, работали-->
            <xsl:when test="$inherited-font-style != 'Regular'">
              <xsl:attribute name="FontStyle">
                <xsl:value-of select="$inherited-font-style"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:attribute name="Position">
            <xsl:value-of select="$inherited-position"/>
          </xsl:attribute>        
          <TextVariableInstance Self="u29b44" Name="&lt;?AID 001b?&gt;TV XRefPageNumber" ResultText="1" AssociatedTextVariable="dTextVariablen&lt;?AID 001b?&gt;TV XRefPageNumber" />
        </CharacterStyleRange>
     </CrossReferenceSource>
    <xsl:choose>
      <xsl:when test="following-sibling::a or following-sibling::*/a">
        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
          <xsl:attribute name="AppliedCharacterStyle">
            <xsl:value-of select="'[No Character style]'"/>
          </xsl:attribute>
          <xsl:attribute name="FontStyle">
            <xsl:value-of select="'Regular'"/>
          </xsl:attribute>
          <xsl:attribute name="Position">
            <xsl:value-of select="'Normal'"/>
          </xsl:attribute>           
          <Content><xsl:text>&#x2C;&#x20;</xsl:text></Content> <!-- запятая пробел -->
        </CharacterStyleRange>        
      </xsl:when>
    </xsl:choose>    
      <xsl:text>&#xA;</xsl:text>
  </xsl:template>
  
  <xsl:template match="a[@name]" mode="character-style-range">
    <xsl:param name="inherited-font-style" select="'Regular'"/>
    <xsl:param name="inherited-position" select="'Normal'"/>
    <xsl:param name="inherited-character-style" select="'[No character style]'"/>    
     <xsl:variable name="crossref-nameREF">
      <xsl:value-of select="concat('hyper', @name)"/>
    </xsl:variable>
    <CharacterStyleRange>
      <xsl:attribute name="AppliedCharacterStyle">
        <xsl:value-of select="concat('CharacterStyle/', $inherited-character-style)"/>
      </xsl:attribute>
      <xsl:choose>
        <!-- у текста со тилем Regular значение аттрибута FontStyle опускается для того, чтобы те стили абзаца,
         которые имеют стиль написания, отличный от заданного в html, работали-->
        <xsl:when test="$inherited-font-style != 'Regular'">
          <xsl:attribute name="FontStyle">
            <xsl:value-of select="$inherited-font-style"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:attribute name="Position">
        <xsl:value-of select="$inherited-position"/>
      </xsl:attribute>
      <xsl:text>&#xA;</xsl:text>      
      <HyperlinkTextDestination Self="HyperlinkTextDestination/{$crossref-nameREF}" Name="{$crossref-nameREF}" Hidden="false" DestinationUniqueKey="{@name}" />
      <Content>
        <xsl:value-of select="."/>
      </Content>
    </CharacterStyleRange>    
  </xsl:template>
  
  <xsl:template match="a[@name]" mode="hyperlinks">
    <xsl:variable name="crossref-ID">
      <xsl:value-of select="concat('u', @name)"/>
    </xsl:variable>
    <xsl:variable name="crossref-nameREF">
      <xsl:value-of select="concat('hyper', @name)"/>
    </xsl:variable>
    <Hyperlink Name="{$crossref-nameREF}" Source="{$crossref-ID}" Visible="false" Highlight="None" Width="Thin" BorderStyle="Solid" Hidden="false" DestinationUniqueKey="{@name}">
      <Properties>
        <BorderColor type="enumeration">Black</BorderColor>
        <Destination type="object">
          <xsl:value-of select="concat('HyperlinkTextDestination/', $crossref-nameREF)"/>>
        </Destination>
      </Properties>
    </Hyperlink>    
  </xsl:template>
  
  <!-- ==================================================================== -->
  <!-- Inlines -->
  <!-- ==================================================================== -->
  <xsl:template match="em | i" mode="character-style-range">
    <xsl:param name="inherited-font-style" select="'Regular'"/>
    <xsl:param name="inherited-position" select="'Normal'"/>
    <xsl:param name="inherited-character-style" select="'[No character style]'"/>
    <xsl:apply-templates select="* | text()" mode="character-style-range">
      <xsl:with-param name="inherited-font-style">
        <xsl:choose>
          <xsl:when test="$inherited-font-style = 'Regular'">
            <xsl:value-of select="'Italic'"/>
          </xsl:when>
          <xsl:when test="$inherited-font-style = 'Bold'">
            <xsl:value-of select="'Bold Italic'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'Italic'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="inherited-position" select="$inherited-position"/>
      <xsl:with-param name="inherited-character-style" select="$inherited-character-style"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="strong | b" mode="character-style-range">
    <xsl:param name="inherited-font-style" select="'Regular'"/>
    <xsl:param name="inherited-position" select="'Normal'"/>
    <xsl:param name="inherited-character-style" select="'[No character style]'"/>
    <xsl:apply-templates select="* | text()" mode="character-style-range">
      <xsl:with-param name="inherited-font-style">
        <xsl:choose>
          <xsl:when test="$inherited-font-style = 'Regular'">
            <xsl:value-of select="'Bold'"/>
          </xsl:when>
          <xsl:when test="$inherited-font-style = 'Italic'">
            <xsl:value-of select="'Bold Italic'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'Bold'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="inherited-position" select="$inherited-position"/>
      <xsl:with-param name="inherited-character-style" select="$inherited-character-style"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="span[@class]" mode="character-style-range">
    <xsl:param name="inherited-font-style" select="'Regular'"/>
    <xsl:param name="inherited-position" select="'Normal'"/>
    <xsl:param name="inherited-character-style" select="'[No character style]'"/>
    <xsl:apply-templates select="* | text()" mode="character-style-range">
      <xsl:with-param name="inherited-font-style" select="$inherited-font-style"/>
      <xsl:with-param name="inherited-position" select="$inherited-position"/>
      <xsl:with-param name="inherited-character-style" select="@class"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="text()" mode="character-style-range">
    <xsl:param name="inherited-font-style" select="'Regular'"/>
    <xsl:param name="inherited-position" select="'Normal'"/>
    <xsl:param name="inherited-character-style" select="'[No character style]'"/>
    <CharacterStyleRange>
      <xsl:attribute name="AppliedCharacterStyle">
        <xsl:value-of select="concat('CharacterStyle/', $inherited-character-style)"/>
      </xsl:attribute>
      <xsl:choose>
        <!-- у текста со тилем Regular значение аттрибута FontStyle опускается для того, чтобы те стили абзаца,
         которые имеют стиль написания, отличный от заданного в html, работали-->
        <xsl:when test="$inherited-font-style != 'Regular'">
          <xsl:attribute name="FontStyle">
            <xsl:value-of select="$inherited-font-style"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:attribute name="Position">
        <xsl:value-of select="$inherited-position"/>
      </xsl:attribute>
      <xsl:text>&#xA;</xsl:text>
      <Content>
        <xsl:value-of select="."/>
      </Content>
      <xsl:text>&#xA;</xsl:text>
    </CharacterStyleRange>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="br" mode="character-style-range">
    <Br/>
    <!-- TODO: Is this always going to appear in an acceptable location? -->
  </xsl:template>

  <xsl:template match="sub" mode="character-style-range">
    <xsl:param name="inherited-font-style" select="'Regular'"/>
    <xsl:param name="inherited-position" select="'Normal'"/>
    <xsl:param name="inherited-character-style" select="'[No character style]'"/>
    <xsl:apply-templates select="* | text()" mode="character-style-range">
      <xsl:with-param name="inherited-font-style" select="$inherited-font-style"/>
      <xsl:with-param name="inherited-position">Subscript</xsl:with-param>
      <xsl:with-param name="inherited-character-style" select="$inherited-character-style"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="sup" mode="character-style-range">

    <xsl:param name="inherited-font-style" select="'Regular'"/>
    <xsl:param name="inherited-position" select="'Normal'"/>
    <xsl:param name="inherited-character-style" select="'[No character style]'"/>
    <xsl:apply-templates select="* | text()" mode="character-style-range">
      <xsl:with-param name="inherited-font-style" select="$inherited-font-style"/>
      <xsl:with-param name="inherited-position">Superscript</xsl:with-param>
      <xsl:with-param name="inherited-character-style" select="$inherited-character-style"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="font[@face]" mode="character-style-range">
    <xsl:param name="inherited-font-style" select="'Regular'"/>
    <xsl:param name="inherited-position" select="'Normal'"/>
    <xsl:param name="inherited-character-style" select="'[No character style]'"/>
    <xsl:apply-templates select="* | text()" mode="character-style-range">
      <xsl:with-param name="inherited-font-style" select="$inherited-font-style"/>
      <xsl:with-param name="inherited-position" select="$inherited-position"/>
      <xsl:with-param name="inherited-character-style" select="@face"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Footnotes -->
  <!-- ==================================================================== -->


  <!-- Ignore the target anchors in the footnote "body" and insert the
       footnote markup at the point in the text where the superscripted/boxed
       footnote anchor appears. 

       Additionally, we must ignore the footnoe content paragraphs where they
       actually appear in the document. -->

  <!-- == OpenOffice.org footnotes == -->

  <!-- The paragraphs that contain the footnotes at the end of the document
       should be ignored in the default mode, as above. -->
  <xsl:template
    match="
      *[a[contains(@name, 'sdfootnote') or
      contains(@name, 'sdendnote')]]"
    priority="1"/>

  <!-- The second paragraphs of two-paragraph footnotes should be ignored as well. -->
  <xsl:template
    match="
      *[not(a[contains(@name, 'sdfootnote') or
      contains(@name, 'sdendnote')])]
      [preceding-sibling::*[1]
      [a[contains(@name, 'sdfootnote') or
      contains(@name, 'sdendnote')]]]"
    priority="1"/>

  <!-- The third paragraphs of multi-paragraph footnotes should generate a
       warning. This XPath is horrific, sorry. 

       Find <p>s that do not have a footnote marker and whose immediate
       predecessors also do not have a footnote marker but that are immediately 
       preceded by an element that DOES have a footnote marker. This will 
       always match the third <p> that follows a "normal" start of footnote 
       paragraph. -->
  <xsl:template
    match="
      p[not(a[contains(@name, 'sdfootnote') or
      contains(@name, 'sdendnote')])]
      [preceding-sibling::*[1]
      [not(a[contains(@name, 'sdfootnote') or
      contains(@name, 'sdendnote')])]]
      [preceding-sibling::*[2]
      [a[contains(@name, 'sdfootnote') or
      contains(@name, 'sdendnote')]]]"
    priority="1">
    <xsl:message>WARNING: Footnotes with more than 2 paragraphs are not supported. Extra paragraphs
      will appear at the end of the document! Problematic text starts with: <xsl:value-of select="."
      />
    </xsl:message>
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">p</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- The hardcoded anchors that used to link the footnotes together should
       also be omitted, as InDesign will generate auto-numbered foonote Markers. -->
  <xsl:template
    match="
      */a[contains(@name, 'sdfootnote') or
      contains(@name, 'sdendnote')]"
    mode="character-style-range"/>

  <xsl:template
    match="
      sup[a[contains(@name, 'sdfootnote') or
      contains(@name, 'sdendnote')]]"
    mode="character-style-range">
    <xsl:variable name="marker-name"
      select="
        a[contains(@name, 'sdfootnote') or
        contains(@name, 'sdendnote')]/@name"/>
    <xsl:variable name="target" select="concat('#', $marker-name)"/>
    <xsl:call-template name="process-footnote">
      <xsl:with-param name="content">
        <xsl:apply-templates select="//*[a[@href = $target]]" mode="character-style-range"/>

        <!-- Check if there are extra paragraphs hanging around after this one -->
        <xsl:if
          test="
            //*[not(a[contains(@name, 'sdfootnote') or
            contains(@name, 'sdendnote')])]
            [preceding-sibling::*[1]
            [a[@href = $target]]]">
          <!-- This is how we fake InDesign into separating "multi-paragraph"
               footnotes (they are actually one paragraph). -->
          <CharacterStyleRange>
            <Br/>
          </CharacterStyleRange>
          <!-- The content from the second paragraph itself is matched. Note
               that any more than two paragraphs is unsupported. -->
          <xsl:apply-templates
            select="
              //*[not(a[contains(@name, 'sdfootnote') or
              contains(@name, 'sdendnote')])]
              [preceding-sibling::*[1]
              [a[@href = $target]]]"
            mode="character-style-range"/>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- == Word footnotes == -->
  <!-- The paragraphs that contain the footnotes at the end of the document
       should be ignored in the default mode, as above. -->
  <xsl:template match="*[a[contains(@href, '#_ftnref')]]" priority="1"/>

  <!-- The second paragraphs of two-paragraph footnotes should be ignored as well. -->
  <xsl:template
    match="
      *[not(a[contains(@href, '#_ftnref')])]
      [preceding-sibling::*[1]
      [a[contains(@href, '#_ftnref')]]]"
    priority="1"/>

  <!-- The third paragraphs of multi-paragraph footnotes should warn. See
       above for explanation of this horrific XPath. -->
  <xsl:template
    match="
      p[not(a[contains(@href, '#_ftnref')])]
      [preceding-sibling::*[1]
      [not(a[contains(@href, '#_ftnref')])]]
      [preceding-sibling::*[2]
      [a[contains(@href, '#_ftnref')]]]"
    priority="1">
    <xsl:message>WARNING: Footnotes with more than 2 paragraphs are not supported. Extra paragraphs
      will appear at the end of the document! Problematic text starts with: <xsl:value-of select="."
      />
    </xsl:message>
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">p</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- The hardcoded anchors that used to link the footnotes together should
       also be omitted, as InDesign will generate auto-numbered foonote Markers. -->
  <xsl:template match="*/a[contains(@href, '#_ftnref')]" mode="character-style-range"/>

  <xsl:template match="a[contains(@id, '_ftnref')]" mode="character-style-range">
    <xsl:variable name="marker-name" select="@id"/>
    <xsl:variable name="target" select="concat('#', $marker-name)"/>
    <xsl:call-template name="process-footnote">
      <xsl:with-param name="content">
        <xsl:apply-templates select="//*[a[@href = $target]]" mode="character-style-range"/>
        <!-- Check if there are extra paragraphs hanging around after this one -->
        <xsl:if
          test="
            //*[not(a[contains(@href, '#_ftnref')])]
            [preceding-sibling::*[1]
            [a[@href = $target]]]">
          <!-- This is how we fake InDesign into separating "multi-paragraph"
               footnotes (they are actually one paragraph). -->
          <CharacterStyleRange>
            <xsl:text>&#xA;</xsl:text>
            <Br/>
            <xsl:text>&#xA;</xsl:text>
          </CharacterStyleRange>
          <xsl:text>&#xA;</xsl:text>
          <xsl:apply-templates
            select="
              //*[not(a[contains(@href, '#_ftnref')])]
              [preceding-sibling::*[1]
              [a[@href = $target]]]"
            mode="character-style-range"/>
        </xsl:if>

      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- == Docutils footnotes (legacy) == -->
  <xsl:template match="table[@class = 'docutils footnote']/tbody/tr">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/footnote">
      <xsl:text>&#xA;</xsl:text>
      <xsl:for-each select="td">
        <xsl:choose>
          <xsl:when test="self::td[@class = 'label']">
            <CharacterStyleRange>
              <xsl:text>&#xA;</xsl:text>
              <Content><xsl:value-of select="substring-before(substring-after(., '['), ']')"/>. </Content>
              <xsl:text>&#xA;</xsl:text>
            </CharacterStyleRange>
            <xsl:text>&#xA;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <Content>
              <xsl:text>&#xA;</xsl:text>
              <xsl:value-of select="."/>
              <xsl:text>&#xA;</xsl:text>
            </Content>
            <xsl:text>&#xA;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </ParagraphStyleRange>
    <xsl:text>&#xA;</xsl:text>
    <Br/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>
  <xsl:template match="div[@class = 'footnotes']/p">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/footnote">
      <xsl:text>&#xA;</xsl:text>
      <CharacterStyleRange>
        <xsl:text>&#xA;</xsl:text>
        <Content>
          <xsl:text>&#xA;</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>&#xA;</xsl:text>
        </Content>
        <xsl:text>&#xA;</xsl:text>
        <Br/>
        <xsl:text>&#xA;</xsl:text>
      </CharacterStyleRange>
      <xsl:text>&#xA;</xsl:text>
    </ParagraphStyleRange>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- StyleGroup boilerplate -->
  <!-- ==================================================================== -->

  <!-- Grab only the first instance of each @class -->
  <xsl:template match="p[@class]" mode="paragraph-style">
    <xsl:variable name="c" select="@class"/>
    <xsl:if test="not(following::p[@class = $c])">
      <xsl:choose>
        <xsl:when test="@class = 'quote'">
          <!-- Ignore; already hardcoded because of <blockquote> -->
        </xsl:when>
        <xsl:when test="@class = 'dc-creator'">
          <xsl:call-template name="generate-paragraph-style">
            <xsl:with-param name="style-name">author</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="generate-paragraph-style">
            <xsl:with-param name="style-name" select="@class"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="td[@class]" mode="paragraph-style">
    <xsl:variable name="c" select="@class"/>
    <xsl:if test="not(following::p[@class = $c])">
      <xsl:call-template name="generate-paragraph-style">
        <xsl:with-param name="style-name" select="@class"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="span[@class]" mode="character-style">
    <xsl:variable name="c" select="@class"/>
    <xsl:if test="not(following::span[@class = $c])">
      <xsl:call-template name="generate-character-style">
        <xsl:with-param name="style-name" select="@class"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="font[@face]" mode="character-style">
    <xsl:variable name="c" select="@face"/>
    <xsl:if test="not(following::span[@face = $c])">
      <xsl:call-template name="generate-character-style">
        <xsl:with-param name="style-name" select="@face"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Named templates -->
  <!-- ==================================================================== -->
  <xsl:template name="para-style-range">
    <!-- The name of the paragraph style in InDesign -->
    <xsl:param name="style-name"/>
    <!-- A string of text that will precede the paragraph's actual content (ex: 'by ')-->
    <xsl:param name="prefix-content" select="''"/>
    <ParagraphStyleRange>
      <xsl:attribute name="AppliedParagraphStyle">
        <xsl:value-of select="concat('ParagraphStyle/', $style-name)"/>
      </xsl:attribute>
      <xsl:text>&#xA;</xsl:text>
      <xsl:if test="$prefix-content != ''">
        <CharacterStyleRange>
          <xsl:text>&#xA;</xsl:text>
          <Content>
            <xsl:value-of select="$prefix-content"/>
          </Content>
          <xsl:text>&#xA;</xsl:text>
        </CharacterStyleRange>
        <xsl:text>&#xA;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="text() | *" mode="character-style-range"/>
    </ParagraphStyleRange>
    <xsl:text>&#xA;</xsl:text>
    <Br/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="para-style-range-in-table">
    <!-- The name of the paragraph style in InDesign -->
    <xsl:param name="style-name"/>
    <!-- A string of text that will precede the paragraph's actual content (ex: 'by ')-->
    <xsl:param name="prefix-content" select="''"/>
    <ParagraphStyleRange>
      <xsl:attribute name="AppliedParagraphStyle">
        <xsl:value-of select="concat('ParagraphStyle/', $style-name)"/>
      </xsl:attribute>
      <xsl:text>&#xA;</xsl:text>
      <xsl:if test="$prefix-content != ''">
        <CharacterStyleRange>
          <xsl:text>&#xA;</xsl:text>
          <Content>
            <xsl:value-of select="$prefix-content"/>
          </Content>
          <xsl:text>&#xA;</xsl:text>
        </CharacterStyleRange>
        <xsl:text>&#xA;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="text() | *" mode="character-style-range"/>
    </ParagraphStyleRange>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>


  <xsl:template name="char-style-range">
    <!-- The name of the character style in InDesign -->
    <xsl:param name="style-name"/>
    <xsl:param name="vertical-position" select="0"/>

    <CharacterStyleRange>
      <xsl:attribute name="AppliedCharacterStyle">
        <xsl:value-of select="concat('CharacterStyle/', $style-name)"/>
      </xsl:attribute>
      <xsl:if test="$vertical-position != 0">
        <xsl:attribute name="Position">
          <xsl:value-of select="$vertical-position"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:text>&#xA;</xsl:text>
      <Content>
        <xsl:value-of select="."/>
      </Content>
      <xsl:text>&#xA;</xsl:text>
    </CharacterStyleRange>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="process-footnote">
    <xsl:param name="content"/>
    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]"
      Position="Superscript">
      <xsl:text>&#xA;</xsl:text>
      <Footnote>
        <xsl:text>&#xA;</xsl:text>
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/footnote">
          <xsl:text>&#xA;</xsl:text>
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
            <xsl:text>&#xA;</xsl:text>
            <!-- InDesign magical footnote character -->
            <Content>
              <xsl:processing-instruction name="ACE">4</xsl:processing-instruction>
            </Content>
            <xsl:text>&#xA;</xsl:text>
          </CharacterStyleRange>
          <xsl:text>&#xA;</xsl:text>
          <xsl:copy-of select="$content"/>
        </ParagraphStyleRange>
        <xsl:text>&#xA;</xsl:text>
      </Footnote>
      <xsl:text>&#xA;</xsl:text>
    </CharacterStyleRange>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="generate-paragraph-style">
    <xsl:param name="style-name"/>
    <ParagraphStyle>
      <xsl:attribute name="Self">
        <xsl:value-of select="concat('ParagraphStyle/', $style-name)"/>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:value-of select="$style-name"/>
      </xsl:attribute>
    </ParagraphStyle>
  </xsl:template>

  <xsl:template name="generate-character-style">
    <xsl:param name="style-name"/>
    <CharacterStyle>
      <xsl:attribute name="Self">
        <xsl:value-of select="concat('CharacterStyle/', $style-name)"/>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:value-of select="$style-name"/>
      </xsl:attribute>
    </CharacterStyle>
  </xsl:template>

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
  <!-- блок шаблонов с рекурсивным вызовом себя для построения таблиц с объединенными ячейками-->
  <xsl:template name="SpannedTableRow_Build">
    <xsl:param name="cell-idLine"/>
    <xsl:param name="rowpos"/>
    <xsl:choose>
      <xsl:when test="$rowpos &lt;= count(descendant::tr)">
        <!-- вызов шаблона. Шаблон формирует все теги строки ячеек в выходной поток на основе вх. строки флажков, несущей информацию
        о rowspann'енных ячейках в предыдущей строке-->
        <xsl:call-template name="SpannedTable_CellBuild">
          <xsl:with-param name="Row" select="$rowpos"/>
          <xsl:with-param name="span_shift" select="0"/>
          <xsl:with-param name="span_InString" select="$cell-idLine"/>
          <xsl:with-param name="cellpos" select="1"/>
        </xsl:call-template>
        <!-- в след. переменной формируется строка флажков, несущая информацию о rowspann'енных ячейках в текущей строке для формирования
          послед. строки ячеек в выходной поток-->
        <xsl:variable name="idLine">
          <xsl:call-template name="SpannedTable_ID_CellBuild">
            <xsl:with-param name="Row" select="$rowpos"/>
            <xsl:with-param name="span_shift" select="0"/>
            <xsl:with-param name="span_InString" select="$cell-idLine"/>
            <xsl:with-param name="span_OuString" select="''"/>
            <xsl:with-param name="cellpos" select="1"/>
          </xsl:call-template>
        </xsl:variable>
        <!-- на каждом след. шаге рекурсии формируется послед. строка ячеек в выходной поток-->
        <xsl:call-template name="SpannedTableRow_Build">
          <xsl:with-param name="cell-idLine" select="$idLine"/>
          <xsl:with-param name="rowpos" select="$rowpos + 1"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--  типовой шаблон для генерации строки ячеек с абсолютными позициями столбца и строки за счета входного параметра строки флажков,
      генерируемого шаблоном SpannedTable_ID_CellBuild-->
  <xsl:template name="SpannedTable_CellBuild">
    <xsl:param name="Row"/>
    <!-- в параметре span_shift передается информация о сдвиге, который необходимо добавить к порядковому номеру <tr> в Html,
чтобы ячейка корректно отображалась в таблице в InDesign'e  -->
    <xsl:param name="span_shift"/>
    <!-- span_InString входная строка флажков: по замыслу алгоритма строка состоит из n символов (0 - если в текущей позиции абсолютного столбца предыдущей строки
          параметр rowspan=1 или отсутствует; либо значение rowspan-1). n=кол-ву столбцов. Строка подается на вход перед формированием сроки ячеек. Для первой
          строки таблицы шаблон SetInpString формирует строку из нулей. Для следущих строк входная строка формируется в шаблоне SpannedTable_ID_CellBuild.
          На каждом шаге рекурсии (число шагов = числу символов во вх. строке) от вх. строки откусывается первый символ. Остаток передается след. шагу-->
    <xsl:param name="span_InString"/>
    <xsl:param name="cellpos"/>
    <xsl:choose>
      <!-- первый when по порядку обрабатывает ситуацию, когда вх. строка пуста. Тогда рекурсия заканчивается - результат достигнут.
      второй when обрабатывает ту самую ситуацию, когда первый символ вх. строки > 0. Тогда ячейку в выходной поток не записываем.
      Двигаемся дальше по строке, записывая сдвиг для след. позиций ячеек 1, откусывая поз. от вх. строки.
      Также важно понимать, что в шаблоне-побратиме SpannedTable_ID_CellBuild выходную строку сразу же дополняется
      значением взятым их вх. строки -1. Шаблон, единый по сути, пришлось разбивать на два, потому что вызов того, который формирует
      строку флажков, осуществляется из блока объявления переменной: в этом случае выходной поток не формируется и некорректно
      воздействует на формирование переменной-->
      <xsl:when test="string-length($span_InString) &gt; 0">
        <xsl:variable name="spSH">
          <xsl:choose>
            <xsl:when test="number(substring($span_InString, 1, 1)) &gt; 0">
              <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="0"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$spSH &gt; 0">
            <xsl:call-template name="SpannedTable_CellBuild">
              <xsl:with-param name="Row" select="$Row"/>
              <xsl:with-param name="span_shift" select="$span_shift + $spSH"/>
              <xsl:with-param name="span_InString">
                <xsl:call-template name="SetInpString">
                  <xsl:with-param name="InputString" select="$span_InString"/>
                  <xsl:with-param name="take-col-span" select="1"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="cellpos" select="$cellpos"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- добавляем сдвиг -->
            <xsl:variable name="colNum" select="$cellpos + $span_shift"/>
            <!-- формируем атрибуты стиля абзаца -->
            <xsl:variable name="get-para-style">
              <xsl:choose>
                <xsl:when test="descendant::tr[position() = $Row]/td[position() = $cellpos]/@class">
                  <xsl:value-of
                    select="descendant::tr[position() = $Row]/td[position() = $cellpos]/@class"/>
                </xsl:when>
                <xsl:when
                  test="descendant::tr[position() = $Row]/td[position() = $cellpos]/p/@class">
                  <xsl:value-of
                    select="descendant::tr[position() = $Row]/td[position() = $cellpos]/p/@class"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'Table_Left'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- формируем атрибуты Colspan -->
            <xsl:variable name="get-col-span">
              <xsl:choose>
                <xsl:when
                  test="descendant::tr[position() = $Row]/td[position() = $cellpos]/@colspan">
                  <xsl:value-of
                    select="descendant::tr[position() = $Row]/td[position() = $cellpos]/@colspan"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="1"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- Colspan ячейки присваивается 2, если в стиля ячейки имеет в своем названии частицу _Clear, так как след. ячейка в строке пустая.
              Это для таблиц, в которых указывается состав препарата. Специфика формирования html описаний-->
            <xsl:variable name="assign-col-span">
              <xsl:choose>
                <xsl:when
                  test="descendant::tr[position() = $Row]/td[position() = $cellpos]/@colspan">
                  <xsl:value-of
                    select="descendant::tr[position() = $Row]/td[position() = $cellpos]/@colspan"/>
                </xsl:when>
                <xsl:when
                  test="contains(descendant::tr[position() = $Row]/td[position() = $cellpos]/@class, '_Clear')">
                  <xsl:value-of select="2"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="1"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- формируем атрибуты Rowspan -->
            <xsl:variable name="get-row-span">
              <xsl:choose>
                <xsl:when
                  test="descendant::tr[position() = $Row]/td[position() = $cellpos]/@rowspan">
                  <xsl:value-of
                    select="descendant::tr[position() = $Row]/td[position() = $cellpos]/@rowspan"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="1"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!--  выходной поток, в котором формируется описание ячейки для InDesign -->
            <Cell Name="{$colNum - 1}:{$Row - 1}" RowSpan="{$get-row-span}"
              ColumnSpan="{$assign-col-span}" AppliedCellStyle="CellStyle/$ID/[None]"
              AppliedCellStylePriority="0">
              <xsl:text>&#xA;</xsl:text>
              <ParagraphStyleRange>
                <xsl:attribute name="AppliedParagraphStyle">
                  <xsl:value-of select="concat('ParagraphStyle/', $get-para-style)"/>
                </xsl:attribute>
                <xsl:text>&#xA;</xsl:text>
                <xsl:apply-templates
                  select="descendant::tr[position() = $Row]/td[position() = $cellpos]"
                  mode="character-style-range"/>
              </ParagraphStyleRange>
              <xsl:text>&#xA;</xsl:text>
            </Cell>
            <xsl:text>&#xA;</xsl:text>
            <!-- конец вых. потока для ячейки -->
            <!-- следующий шаг рекурсии формирует сдвиг для формирования абсолютной позиции ячейки и откусывает
              от вх. строки число позиций, равное значению параметра colspan текущей ячейки.-->
            <xsl:call-template name="SpannedTable_CellBuild">
              <xsl:with-param name="Row" select="$Row"/>
              <xsl:with-param name="span_shift" select="$span_shift + $get-col-span - 1"/>
              <xsl:with-param name="span_InString">
                <xsl:call-template name="SetInpString">
                  <xsl:with-param name="InputString" select="$span_InString"/>
                  <xsl:with-param name="take-col-span" select="$get-col-span"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="cellpos" select="$cellpos + 1"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--  типовой шаблон для генерации строки флажков, обознающих актуальность в (текущем столбце, следующей строке) сдвига ячейки за счет присутствия
      в текущей считываемой строке rowspan-->
  <xsl:template name="SpannedTable_ID_CellBuild">
    <xsl:param name="Row"/>
    <!-- в параметре span_shift передается информация о сдвиге, который необходимо добавить к порядковому номеру <tr> в Html,
    чтобы ячейка корректно отображалась в таблице в InDesign'e  -->
    <xsl:param name="span_shift"/>
    <xsl:param name="span_InString"/>
    <xsl:param name="span_OuString"/>
    <xsl:param name="cellpos"/>
    <xsl:choose>
      <xsl:when test="string-length($span_InString) &gt; 0">
        <xsl:variable name="spSH">
          <xsl:choose>
            <xsl:when test="number(substring($span_InString, 1, 1)) &gt; 0">
              <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="0"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$spSH &gt; 0">
            <xsl:call-template name="SpannedTable_ID_CellBuild">
              <xsl:with-param name="Row" select="$Row"/>
              <xsl:with-param name="span_shift" select="$span_shift + $spSH"/>
              <xsl:with-param name="span_InString">
                <xsl:call-template name="SetInpString">
                  <xsl:with-param name="InputString" select="$span_InString"/>
                  <xsl:with-param name="take-col-span" select="1"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="span_OuString"
                select="concat($span_OuString, substring($span_InString, 1, 1) - 1)"/>
              <xsl:with-param name="cellpos" select="$cellpos"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="colNum" select="$cellpos + $span_shift"/>
            <!-- добавляем сдвиг -->

            <xsl:variable name="get-para-style">
              <xsl:choose>
                <xsl:when test="descendant::tr[position() = $Row]/td[position() = $cellpos]/@class">
                  <xsl:value-of
                    select="descendant::tr[position() = $Row]/td[position() = $cellpos]/@class"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'NormalParagraphStyle'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="get-col-span">
              <xsl:choose>
                <xsl:when
                  test="descendant::tr[position() = $Row]/td[position() = $cellpos]/@colspan">
                  <xsl:value-of
                    select="descendant::tr[position() = $Row]/td[position() = $cellpos]/@colspan"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="1"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <!-- комментим лишние блоки: они не нужны для генерации строки флажков, а строка ячеек уже сформирована            
            <xsl:variable name="assign-col-span">
              <xsl:choose>
                <xsl:when test="descendant::tr[position() = $Row]/td[position() = $cellpos]/@colspan">
                  <xsl:value-of select="descendant::tr[position() = $Row]/td[position() = $cellpos]/@colspan"/>
                </xsl:when>
                <xsl:when
                  test="contains(descendant::tr[position() = $Row]/td[position() = $cellpos]/@colspan, '_Clear')">
                  <xsl:value-of select="2"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="1"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>   -->

            <xsl:variable name="get-row-span">
              <xsl:choose>
                <xsl:when
                  test="descendant::tr[position() = $Row]/td[position() = $cellpos]/@rowspan">
                  <xsl:value-of
                    select="descendant::tr[position() = $Row]/td[position() = $cellpos]/@rowspan"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="1"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <!--            <Cell Name="{$colNum - 1}:{$Row - 1}" RowSpan="{$get-row-span}"
              ColumnSpan="{$assign-col-span}" AppliedCellStyle="CellStyle/$ID/[None]"
              AppliedCellStylePriority="0">
              <xsl:text>&#xA;</xsl:text>
              <ParagraphStyleRange>
                <xsl:attribute name="AppliedParagraphStyle">
                  <xsl:value-of select="concat('ParagraphStyle/', $get-para-style)"/>
                </xsl:attribute>
                <xsl:text>&#xA;</xsl:text>
                <xsl:apply-templates select="descendant::tr[position() = $Row]/td[position() = $cellpos]"
                  mode="character-style-range"/>
              </ParagraphStyleRange>
              <xsl:text>&#xA;</xsl:text>
            </Cell>
            <xsl:text>&#xA;</xsl:text>  -->

            <!-- следующий шаг рекурсии формирует сдвиг для формирования абсолютной позиции ячейки и откусывает
              от вх. строки число позиций, равное значению параметра colspan текущей ячейки. Выходная строка дополняется
            числом позиций, равным значению параметра colspan текущей ячейки. В эти позиции записывается значение параметра
            rowspan тек. ячейки - 1 -->
            <xsl:call-template name="SpannedTable_ID_CellBuild">
              <xsl:with-param name="Row" select="$Row"/>
              <xsl:with-param name="span_shift" select="$span_shift + $get-col-span - 1"/>
              <xsl:with-param name="span_InString">
                <xsl:call-template name="SetInpString">
                  <xsl:with-param name="InputString" select="$span_InString"/>
                  <xsl:with-param name="take-col-span" select="$get-col-span"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="span_OuString">
                <xsl:call-template name="SetSpanIdString">
                  <xsl:with-param name="spanIdString" select="$span_OuString"/>
                  <xsl:with-param name="take-curr-row-span" select="$get-row-span"/>
                  <xsl:with-param name="take-col-span" select="$get-col-span"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="cellpos" select="$cellpos + 1"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$span_OuString"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="SetInpString">
    <xsl:param name="InputString"/>
    <xsl:param name="take-col-span"/>
    <xsl:variable name="Id-String">
      <xsl:choose>
        <xsl:when test="string-length($InputString) &gt; 1">
          <xsl:value-of select="substring($InputString, 2)"/>
        </xsl:when>
        <xsl:when test="string-length($InputString) = 1">
          <xsl:value-of select="''"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$take-col-span &gt; 1">
        <xsl:call-template name="SetInpString">
          <xsl:with-param name="InputString" select="$Id-String"/>
          <xsl:with-param name="take-col-span" select="$take-col-span - 1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$Id-String"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="SetSpanIdString">
    <xsl:param name="spanIdString"/>
    <xsl:param name="take-curr-row-span"/>
    <xsl:param name="take-col-span"/>
    <xsl:variable name="Id-String">
      <xsl:value-of select="concat($spanIdString, $take-curr-row-span - 1)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$take-col-span &gt; 1">
        <xsl:call-template name="SetSpanIdString">
          <xsl:with-param name="spanIdString" select="$Id-String"/>
          <xsl:with-param name="take-curr-row-span" select="$take-curr-row-span"/>
          <xsl:with-param name="take-col-span" select="$take-col-span - 1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$Id-String"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="SetFirstInpString">
    <xsl:param name="colNumber"/>
    <xsl:param name="FirstInpString"/>
    <xsl:choose>
      <xsl:when test="$colNumber &gt; 0">
        <xsl:call-template name="SetFirstInpString">
          <xsl:with-param name="colNumber" select="$colNumber - 1"/>
          <xsl:with-param name="FirstInpString" select="concat(0, $FirstInpString)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$FirstInpString"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

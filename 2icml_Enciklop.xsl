<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!-- 
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
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                exclude-result-prefixes="xhtml"
                version="1.0">

  <xsl:param name="table-width">161.575</xsl:param>

  <!-- Fixed strings used to indicate ICML and software version -->
  <xsl:variable name="icml-decl-pi">
    <xsl:text>style="50" type="snippet" readerVersion="6.0" featureSet="257" product="6.0(352)"</xsl:text> <!-- product string will change with specific InDesign builds (but probably doesn't matter) -->
  </xsl:variable>  
  <xsl:variable name="snippet-type-pi">
    <xsl:text>SnippetType="InCopyInterchange"</xsl:text>
  </xsl:variable>  


  <!-- Default Rule: Match everything, ignore it,  and keep going "down". -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Document root generation and boilerplate. -->
  <!-- ==================================================================== -->
  <xsl:template match="body">
    <xsl:processing-instruction name="aid"><xsl:value-of select="$icml-decl-pi"/></xsl:processing-instruction>
    <xsl:processing-instruction name="aid"><xsl:value-of select="$snippet-type-pi"/></xsl:processing-instruction>
    <Document DOMVersion="6.0" Self="xhtml2icml_document"><xsl:text>&#xA;</xsl:text>
      <RootCharacterStyleGroup Self="xhtml2icml_character_styles"><xsl:text>&#xA;</xsl:text>
		<CharacterStyle Self="CharacterStyle/[No character style]" Name="[No character style]"/><xsl:text>&#xA;</xsl:text>	  
        <CharacterStyle Self="CharacterStyle/link" Name="link"/><xsl:text>&#xA;</xsl:text>
        <CharacterStyle Self="CharacterStyle/i" Name="i"/><xsl:text>&#xA;</xsl:text>
        <CharacterStyle Self="CharacterStyle/b" Name="b"/><xsl:text>&#xA;</xsl:text>
        <!-- Generate the rest of the CharacterStyles using the @class value -->
        <xsl:apply-templates select="//span[@class]" mode='character-style'/>
        <xsl:apply-templates select="//font[@face]" mode='character-style'/>		
      </RootCharacterStyleGroup><xsl:text>&#xA;</xsl:text>
      <RootParagraphStyleGroup Self="xhtml2icml_paragraph_styles"><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/h1" Name="h1"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/h2" Name="h2"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/h3" Name="h3"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/h4" Name="h4"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/h5" Name="h5"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/h6" Name="h6"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/p" Name="p"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/pFollowsP" Name="pFollowsP"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/ul" Name="ul"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/ol" Name="ol"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/table" Name="table"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/quote" Name="quote"/><xsl:text>&#xA;</xsl:text>
        <ParagraphStyle Self="ParagraphStyle/footnote" Name="footnote"/><xsl:text>&#xA;</xsl:text>
        <!-- Generate the rest of the ParagraphStyles using the @class value -->
        <xsl:apply-templates select="//p[@class]" mode='paragraph-style'/>
		<xsl:apply-templates select="//td[@class]" mode='paragraph-style'/>
      </RootParagraphStyleGroup><xsl:text>&#xA;</xsl:text>
	<RootCellStyleGroup Self="u78"><xsl:text>&#xA;</xsl:text>
		<CellStyle Self="CellStyle/$ID/[None]" AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" Name="$ID/[None]" /><xsl:text>&#xA;</xsl:text>
		<CellStyle Self="CellStyle/Cell_Sost_Val" GraphicLeftInset="0" GraphicTopInset="0" GraphicRightInset="0" GraphicBottomInset="0" TextTopInset="1" TextLeftInset="0" TextBottomInset="1" TextRightInset="0" AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" TopInset="1" LeftInset="1" BottomInset="1" RightInset="1" VerticalJustification="BottomAlign" LeftEdgeStrokeWeight="0" TopEdgeStrokeWeight="0" RightEdgeStrokeWeight="0" BottomEdgeStrokeWeight="0" KeyboardShortcut="0 0" Name="Cell_Sost_Val"><xsl:text>&#xA;</xsl:text>
			<Properties>
				<BasedOn type="string">$ID/[None]</BasedOn>
			</Properties><xsl:text>&#xA;</xsl:text>
		</CellStyle><xsl:text>&#xA;</xsl:text>
		<CellStyle Self="CellStyle/CellMono_0Line" GraphicLeftInset="0" GraphicTopInset="0" GraphicRightInset="0" GraphicBottomInset="0" TextTopInset="1" TextLeftInset="0" TextBottomInset="1" TextRightInset="0" AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" TopInset="1" LeftInset="1" BottomInset="1" RightInset="1" LeftEdgeStrokeWeight="0" LeftEdgeStrokeType="StrokeStyle/$ID/Solid" LeftEdgeStrokeColor="Color/Paper" TopEdgeStrokeWeight="0" TopEdgeStrokeType="StrokeStyle/$ID/Solid" TopEdgeStrokeColor="Color/Paper" RightEdgeStrokeWeight="0" RightEdgeStrokeType="StrokeStyle/$ID/Solid" RightEdgeStrokeColor="Color/Paper" BottomEdgeStrokeWeight="0" BottomEdgeStrokeType="StrokeStyle/$ID/Solid" BottomEdgeStrokeColor="Color/Paper" KeyboardShortcut="0 0" Name="CellMono_0Line"><xsl:text>&#xA;</xsl:text>
			<Properties>
				<BasedOn type="string">$ID/[None]</BasedOn>
			</Properties><xsl:text>&#xA;</xsl:text>
		</CellStyle><xsl:text>&#xA;</xsl:text>
		<CellStyle Self="CellStyle/CellMono_1ThinLine" GraphicLeftInset="0" GraphicTopInset="0" GraphicRightInset="0" GraphicBottomInset="0" TextTopInset="1.4173228346456694" TextLeftInset="1.4173228346456694" TextBottomInset="1.4173228346456694" TextRightInset="1.4173228346456694" AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" TopInset="1.4173228346456694" LeftInset="1.4173228346456694" BottomInset="1.4173228346456694" RightInset="1.4173228346456694" LeftEdgeStrokeWeight="0.25" LeftEdgeStrokeType="StrokeStyle/$ID/Solid" LeftEdgeStrokeColor="Color/Black" TopEdgeStrokeWeight="0.25" TopEdgeStrokeType="StrokeStyle/$ID/Solid" TopEdgeStrokeColor="Color/Black" RightEdgeStrokeWeight="0.25" RightEdgeStrokeType="StrokeStyle/$ID/Solid" RightEdgeStrokeColor="Color/Black" BottomEdgeStrokeWeight="0.25" BottomEdgeStrokeType="StrokeStyle/$ID/Solid" BottomEdgeStrokeColor="Color/Black" KeyboardShortcut="0 0" Name="CellMono_1ThinLine"><xsl:text>&#xA;</xsl:text>
			<Properties>
				<BasedOn type="string">$ID/[None]</BasedOn>
			</Properties><xsl:text>&#xA;</xsl:text>
		</CellStyle><xsl:text>&#xA;</xsl:text>
	</RootCellStyleGroup><xsl:text>&#xA;</xsl:text>
	<RootTableStyleGroup Self="u7a"><xsl:text>&#xA;</xsl:text>
		<TableStyle Self="TableStyle/TableMono_0Line" Name="TableMono_0Line" TopBorderStrokeWeight="0" TopBorderStrokeColor="Color/Paper" LeftBorderStrokeWeight="0" LeftBorderStrokeColor="Color/Paper" BottomBorderStrokeWeight="0" BottomBorderStrokeColor="Color/Paper" RightBorderStrokeWeight="0" RightBorderStrokeColor="Color/Paper" SpaceAfter="3.999685039370079" HeaderRegionSameAsBodyRegion="false" FooterRegionSameAsBodyRegion="false" LeftColumnRegionSameAsBodyRegion="false" RightColumnRegionSameAsBodyRegion="false" HeaderRegionCellStyle="CellStyle/CellMono_0Line" FooterRegionCellStyle="CellStyle/CellMono_0Line" LeftColumnRegionCellStyle="CellStyle/CellMono_0Line" RightColumnRegionCellStyle="CellStyle/Cell_Sost_Val" BodyRegionCellStyle="CellStyle/CellMono_0Line" KeyboardShortcut="0 0"><xsl:text>&#xA;</xsl:text>
			<Properties>
				<BasedOn type="string">$ID/[No table style]</BasedOn>
			</Properties><xsl:text>&#xA;</xsl:text>
		</TableStyle><xsl:text>&#xA;</xsl:text>
		<TableStyle Self="TableStyle/TableMono_1ThinLine" Name="TableMono_1ThinLine" TopBorderStrokeWeight="0.25" LeftBorderStrokeWeight="0.25" BottomBorderStrokeWeight="0.25" RightBorderStrokeWeight="0.25" SpaceAfter="3.999685039370079" BodyRegionCellStyle="CellStyle/CellMono_1ThinLine" KeyboardShortcut="0 0"><xsl:text>&#xA;</xsl:text>
			<Properties>
				<BasedOn type="string">$ID/[No table style]</BasedOn>
			</Properties><xsl:text>&#xA;</xsl:text>
		</TableStyle><xsl:text>&#xA;</xsl:text>
		<TableStyle Self="TableStyle/$ID/[No table style]" GraphicLeftInset="0" GraphicTopInset="0" GraphicRightInset="0" GraphicBottomInset="0" ClipContentToGraphicCell="false" TextTopInset="4" TextLeftInset="4" TextBottomInset="4" TextRightInset="4" ClipContentToTextCell="false" Name="$ID/[No table style]" StrokeOrder="BestJoins" TopBorderStrokeWeight="1" TopBorderStrokeType="StrokeStyle/$ID/Solid" TopBorderStrokeColor="Color/Black" TopBorderStrokeTint="100" TopBorderStrokeOverprint="false" TopBorderStrokeGapColor="Color/Paper" TopBorderStrokeGapTint="100" TopBorderStrokeGapOverprint="false" LeftBorderStrokeWeight="1" LeftBorderStrokeType="StrokeStyle/$ID/Solid" LeftBorderStrokeColor="Color/Black" LeftBorderStrokeTint="100" LeftBorderStrokeOverprint="false" LeftBorderStrokeGapColor="Color/Paper" LeftBorderStrokeGapTint="100" LeftBorderStrokeGapOverprint="false" BottomBorderStrokeWeight="1" BottomBorderStrokeType="StrokeStyle/$ID/Solid" BottomBorderStrokeColor="Color/Black" BottomBorderStrokeTint="100" BottomBorderStrokeOverprint="false" BottomBorderStrokeGapColor="Color/Paper" BottomBorderStrokeGapTint="100" BottomBorderStrokeGapOverprint="false" RightBorderStrokeWeight="1" RightBorderStrokeType="StrokeStyle/$ID/Solid" RightBorderStrokeColor="Color/Black" RightBorderStrokeTint="100" RightBorderStrokeOverprint="false" RightBorderStrokeGapColor="Color/Paper" RightBorderStrokeGapTint="100" RightBorderStrokeGapOverprint="false" SpaceBefore="4" SpaceAfter="-4" SkipFirstAlternatingStrokeRows="0" SkipLastAlternatingStrokeRows="0" StartRowStrokeCount="0" StartRowStrokeColor="Color/Black" StartRowStrokeWeight="1" StartRowStrokeType="StrokeStyle/$ID/Solid" StartRowStrokeTint="100" StartRowStrokeGapOverprint="false" StartRowStrokeGapColor="Color/Paper" StartRowStrokeGapTint="100" StartRowStrokeOverprint="false" EndRowStrokeCount="0" EndRowStrokeColor="Color/Black" EndRowStrokeWeight="0.25" EndRowStrokeType="StrokeStyle/$ID/Solid" EndRowStrokeTint="100" EndRowStrokeOverprint="false" EndRowStrokeGapColor="Color/Paper" EndRowStrokeGapTint="100" EndRowStrokeGapOverprint="false" SkipFirstAlternatingStrokeColumns="0" SkipLastAlternatingStrokeColumns="0" StartColumnStrokeCount="0" StartColumnStrokeColor="Color/Black" StartColumnStrokeWeight="1" StartColumnStrokeType="StrokeStyle/$ID/Solid" StartColumnStrokeTint="100" StartColumnStrokeOverprint="false" StartColumnStrokeGapColor="Color/Paper" StartColumnStrokeGapTint="100" StartColumnStrokeGapOverprint="false" EndColumnStrokeCount="0" EndColumnStrokeColor="Color/Black" EndColumnStrokeWeight="0.25" EndColumnLineStyle="StrokeStyle/$ID/Solid" EndColumnStrokeTint="100" EndColumnStrokeOverprint="false" EndColumnStrokeGapColor="Color/Paper" EndColumnStrokeGapTint="100" EndColumnStrokeGapOverprint="false" ColumnFillsPriority="false" SkipFirstAlternatingFillRows="0" SkipLastAlternatingFillRows="0" StartRowFillColor="Color/Black" StartRowFillCount="0" StartRowFillTint="20" StartRowFillOverprint="false" EndRowFillCount="0" EndRowFillColor="Swatch/None" EndRowFillTint="100" EndRowFillOverprint="false" SkipFirstAlternatingFillColumns="0" SkipLastAlternatingFillColumns="0" StartColumnFillCount="0" StartColumnFillColor="Color/Black" StartColumnFillTint="20" StartColumnFillOverprint="false" EndColumnFillCount="0" EndColumnFillColor="Swatch/None" EndColumnFillTint="100" EndColumnFillOverprint="false" HeaderRegionSameAsBodyRegion="true" FooterRegionSameAsBodyRegion="true" LeftColumnRegionSameAsBodyRegion="true" RightColumnRegionSameAsBodyRegion="true" HeaderRegionCellStyle="n" FooterRegionCellStyle="n" LeftColumnRegionCellStyle="n" RightColumnRegionCellStyle="n" BodyRegionCellStyle="CellStyle/$ID/[None]" /><xsl:text>&#xA;</xsl:text>
	</RootTableStyleGroup><xsl:text>&#xA;</xsl:text>
	<RootObjectStyleGroup Self="u83">
		<ObjectStyle Self="ObjectStyle/$ID/[Normal Graphics Frame]" EmitCss="true" EnableTextFrameAutoSizingOptions="false" EnableExportTagging="false" EnableObjectExportAltTextOptions="false" EnableObjectExportTaggedPdfOptions="false" EnableObjectExportEpubOptions="false" Name="$ID/[Normal Graphics Frame]" AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" ApplyNextParagraphStyle="false" EnableFill="true" EnableStroke="true" EnableParagraphStyle="false" EnableTextFrameGeneralOptions="false" EnableTextFrameBaselineOptions="false" EnableStoryOptions="false" EnableTextWrapAndOthers="false" EnableAnchoredObjectOptions="false" CornerRadius="12" FillColor="Swatch/None" FillTint="-1" StrokeWeight="0" MiterLimit="4" EndCap="ButtEndCap" EndJoin="MiterEndJoin" StrokeType="StrokeStyle/$ID/Solid" LeftLineEnd="None" RightLineEnd="None" StrokeColor="Swatch/None" StrokeTint="-1" GapColor="Swatch/None" GapTint="-1" StrokeAlignment="CenterAlignment" Nonprinting="false" GradientFillAngle="0" GradientStrokeAngle="0" AppliedNamedGrid="n" KeyboardShortcut="0 0" TopLeftCornerOption="None" TopRightCornerOption="None" BottomLeftCornerOption="None" BottomRightCornerOption="None" TopLeftCornerRadius="12" TopRightCornerRadius="12" BottomLeftCornerRadius="12" BottomRightCornerRadius="12" EnableFrameFittingOptions="true" CornerOption="None" EnableStrokeAndCornerOptions="true" ArrowHeadAlignment="InsidePath" LeftArrowHeadScale="100" RightArrowHeadScale="100" EnableTextFrameFootnoteOptions="false">
			<Properties>
				<BasedOn type="string">$ID/[None]</BasedOn>
			</Properties>
			<ObjectExportOption EpubType="$ID/" SizeType="DefaultSize" CustomSize="$ID/" PreserveAppearanceFromLayout="PreserveAppearanceDefault" AltTextSourceType="SourceXMLStructure" ActualTextSourceType="SourceXMLStructure" CustomAltText="$ID/" CustomActualText="$ID/" ApplyTagType="TagFromStructure" ImageConversionType="JPEG" ImageExportResolution="Ppi300" GIFOptionsPalette="AdaptivePalette" GIFOptionsInterlaced="true" JPEGOptionsQuality="High" JPEGOptionsFormat="BaselineEncoding" ImageAlignment="AlignLeft" ImageSpaceBefore="0" ImageSpaceAfter="0" UseImagePageBreak="false" ImagePageBreak="PageBreakBefore" CustomImageAlignment="false" SpaceUnit="CssPixel" CustomLayout="false" CustomLayoutType="AlignmentAndSpacing">
				<Properties>
					<AltMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/" />
					<ActualMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/" />
				</Properties>
			</ObjectExportOption>
			<TextFramePreference TextColumnCount="1" TextColumnGutter="12" TextColumnFixedWidth="144" UseFixedColumnWidth="false" FirstBaselineOffset="AscentOffset" MinimumFirstBaselineOffset="0" VerticalJustification="TopAlign" VerticalThreshold="0" IgnoreWrap="false" UseFlexibleColumnWidth="false" TextColumnMaxWidth="0" AutoSizingType="Off" AutoSizingReferencePoint="CenterPoint" UseMinimumHeightForAutoSizing="false" MinimumHeightForAutoSizing="0" UseMinimumWidthForAutoSizing="false" MinimumWidthForAutoSizing="0" UseNoLineBreaksForAutoSizing="false" VerticalBalanceColumns="false">
				<Properties>
					<InsetSpacing type="list">
						<ListItem type="unit">0</ListItem>
						<ListItem type="unit">0</ListItem>
						<ListItem type="unit">0</ListItem>
						<ListItem type="unit">0</ListItem>
					</InsetSpacing>
				</Properties>
			</TextFramePreference>
			<BaselineFrameGridOption UseCustomBaselineFrameGrid="false" StartingOffsetForBaselineFrameGrid="0" BaselineFrameGridRelativeOption="TopOfInset" BaselineFrameGridIncrement="12">
				<Properties>
					<BaselineFrameGridColor type="enumeration">LightBlue</BaselineFrameGridColor>
				</Properties>
			</BaselineFrameGridOption>
			<AnchoredObjectSetting AnchoredPosition="InlinePosition" SpineRelative="false" LockPosition="false" PinPosition="true" AnchorPoint="BottomRightAnchor" HorizontalAlignment="LeftAlign" HorizontalReferencePoint="TextFrame" VerticalAlignment="BottomAlign" VerticalReferencePoint="LineBaseline" AnchorXoffset="0" AnchorYoffset="0" AnchorSpaceAbove="0" />
			<TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false" TextWrapSide="BothSides" TextWrapMode="None">
				<Properties>
					<TextWrapOffset Top="0" Left="0" Bottom="0" Right="0" />
				</Properties>
				<ContourOption ContourType="SameAsClipping" IncludeInsideEdges="false" ContourPathName="$ID/" />
			</TextWrapPreference>
			<StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="Unknown" StoryOrientation="Unknown" StoryDirection="UnknownDirection" />
			<FrameFittingOption AutoFit="true" LeftCrop="0" TopCrop="0" RightCrop="0" BottomCrop="0" FittingOnEmptyFrame="Proportionally" FittingAlignment="CenterAnchor" />
			<ObjectStyleObjectEffectsCategorySettings EnableTransparency="true" EnableDropShadow="true" EnableFeather="true" EnableInnerShadow="true" EnableOuterGlow="true" EnableInnerGlow="true" EnableBevelEmboss="true" EnableSatin="true" EnableDirectionalFeather="true" EnableGradientFeather="true" />
			<ObjectStyleStrokeEffectsCategorySettings EnableTransparency="true" EnableDropShadow="true" EnableFeather="true" EnableInnerShadow="true" EnableOuterGlow="true" EnableInnerGlow="true" EnableBevelEmboss="true" EnableSatin="true" EnableDirectionalFeather="true" EnableGradientFeather="true" />
			<ObjectStyleFillEffectsCategorySettings EnableTransparency="true" EnableDropShadow="true" EnableFeather="true" EnableInnerShadow="true" EnableOuterGlow="true" EnableInnerGlow="true" EnableBevelEmboss="true" EnableSatin="true" EnableDirectionalFeather="true" EnableGradientFeather="true" />
			<ObjectStyleContentEffectsCategorySettings EnableTransparency="true" EnableDropShadow="true" EnableFeather="true" EnableInnerShadow="true" EnableOuterGlow="true" EnableInnerGlow="true" EnableBevelEmboss="true" EnableSatin="true" EnableDirectionalFeather="true" EnableGradientFeather="true" />
			<TextFrameFootnoteOptionsObject EnableOverrides="false" SpanFootnotesAcross="false" MinimumSpacingOption="12" SpaceBetweenFootnotes="6" />
		</ObjectStyle>
		<ObjectStyle Self="ObjectStyle/$ID/[None]" EmitCss="true" Name="$ID/[None]" AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" CornerRadius="12" FillColor="Swatch/None" FillTint="-1" StrokeWeight="0" MiterLimit="4" EndCap="ButtEndCap" EndJoin="MiterEndJoin" StrokeType="StrokeStyle/$ID/Solid" LeftLineEnd="None" RightLineEnd="None" StrokeColor="Swatch/None" StrokeTint="-1" GapColor="Swatch/None" GapTint="-1" StrokeAlignment="CenterAlignment" Nonprinting="false" GradientFillAngle="0" GradientStrokeAngle="0" AppliedNamedGrid="n" TopLeftCornerOption="None" TopRightCornerOption="None" BottomLeftCornerOption="None" BottomRightCornerOption="None" TopLeftCornerRadius="12" TopRightCornerRadius="12" BottomLeftCornerRadius="12" BottomRightCornerRadius="12" CornerOption="None" ArrowHeadAlignment="InsidePath" LeftArrowHeadScale="100" RightArrowHeadScale="100">
			<ObjectExportOption EpubType="$ID/" SizeType="DefaultSize" CustomSize="$ID/" PreserveAppearanceFromLayout="PreserveAppearanceDefault" AltTextSourceType="SourceXMLStructure" ActualTextSourceType="SourceXMLStructure" CustomAltText="$ID/" CustomActualText="$ID/" ApplyTagType="TagFromStructure" ImageConversionType="JPEG" ImageExportResolution="Ppi300" GIFOptionsPalette="AdaptivePalette" GIFOptionsInterlaced="true" JPEGOptionsQuality="High" JPEGOptionsFormat="BaselineEncoding" ImageAlignment="AlignLeft" ImageSpaceBefore="0" ImageSpaceAfter="0" UseImagePageBreak="false" ImagePageBreak="PageBreakBefore" CustomImageAlignment="false" SpaceUnit="CssPixel" CustomLayout="false" CustomLayoutType="AlignmentAndSpacing">
				<Properties>
					<AltMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/" />
					<ActualMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/" />
				</Properties>
			</ObjectExportOption>
			<TextFramePreference TextColumnCount="1" TextColumnGutter="12" TextColumnFixedWidth="144" UseFixedColumnWidth="false" FirstBaselineOffset="AscentOffset" MinimumFirstBaselineOffset="0" VerticalJustification="TopAlign" VerticalThreshold="0" IgnoreWrap="false" UseFlexibleColumnWidth="false" TextColumnMaxWidth="0" AutoSizingType="Off" AutoSizingReferencePoint="CenterPoint" UseMinimumHeightForAutoSizing="false" MinimumHeightForAutoSizing="0" UseMinimumWidthForAutoSizing="false" MinimumWidthForAutoSizing="0" UseNoLineBreaksForAutoSizing="false" VerticalBalanceColumns="false">
				<Properties>
					<InsetSpacing type="list">
						<ListItem type="unit">0</ListItem>
						<ListItem type="unit">0</ListItem>
						<ListItem type="unit">0</ListItem>
						<ListItem type="unit">0</ListItem>
					</InsetSpacing>
				</Properties>
			</TextFramePreference>
			<BaselineFrameGridOption UseCustomBaselineFrameGrid="false" StartingOffsetForBaselineFrameGrid="0" BaselineFrameGridRelativeOption="TopOfInset" BaselineFrameGridIncrement="12">
				<Properties>
					<BaselineFrameGridColor type="enumeration">LightBlue</BaselineFrameGridColor>
				</Properties>
			</BaselineFrameGridOption>
			<AnchoredObjectSetting AnchoredPosition="InlinePosition" SpineRelative="false" LockPosition="false" PinPosition="true" AnchorPoint="BottomRightAnchor" HorizontalAlignment="LeftAlign" HorizontalReferencePoint="TextFrame" VerticalAlignment="BottomAlign" VerticalReferencePoint="LineBaseline" AnchorXoffset="0" AnchorYoffset="0" AnchorSpaceAbove="0" />
			<TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false" TextWrapSide="BothSides" TextWrapMode="None">
				<Properties>
					<TextWrapOffset Top="0" Left="0" Bottom="0" Right="0" />
				</Properties>
				<ContourOption ContourType="SameAsClipping" IncludeInsideEdges="false" ContourPathName="$ID/" />
			</TextWrapPreference>
			<StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="UnknownDirection" />
			<FrameFittingOption AutoFit="false" LeftCrop="0" TopCrop="0" RightCrop="0" BottomCrop="0" FittingOnEmptyFrame="None" FittingAlignment="TopLeftAnchor" />
			<TextFrameFootnoteOptionsObject EnableOverrides="false" SpanFootnotesAcross="false" MinimumSpacingOption="12" SpaceBetweenFootnotes="6" />
		</ObjectStyle>
	</RootObjectStyleGroup><xsl:text>&#xA;</xsl:text>
      <Story Self="xhtml2icml_default_story" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="MyStory" AppliedNamedGrid="n"><xsl:text>&#xA;</xsl:text>
        <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="LeftToRightDirection"/><xsl:text>&#xA;</xsl:text>
        <InCopyExportOption IncludeGraphicProxies="true" IncludeAllResources="false"/><xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates/>
      </Story>
      <xsl:apply-templates select=".//a" mode="hyperlink-url-destinations"/>
      <xsl:apply-templates select=".//a" mode="hyperlinks"/>
    </Document>
  </xsl:template>

  <!-- Headings -->
  <xsl:template match="h1|
                       h2|
                       h3|
                       h4|
                       h5|
                       h6">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name" select="name()"/>
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
  <xsl:template match="p[not(@class)]
                              [preceding-sibling::*[1][self::p[not(@class)] or @class='start']] 
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
  <xsl:template match="p[@class='dc-creator']">
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
  <xsl:template match="p[@class='ignore']">
  </xsl:template>    

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
  <xsl:template match="ol/li/p|
                       ol/li[not(*)]">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">ol</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="ul/li/p|
                       ul/li[not(*)]">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">ul</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Tables -->
  <!-- ==================================================================== -->

  <!-- TODO: 
         Allow for tables with less than 3 rows
         Make code more idiomatic XSLT (even if functionality isn't increased)
		 я заменил 3 на 40
         -->
  <xsl:template match="table">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/table"><xsl:text>&#xA;</xsl:text>
      <CharacterStyleRange><xsl:text>&#xA;</xsl:text>
        <Table HeaderRowCount="0" FooterRowCount="0" TableDirection="LeftToRightDirection">
          <xsl:attribute name="AppliedTableStyle">
            <xsl:choose>
				<xsl:when test="@tab_name">
					<xsl:value-of select="'TableStyle/TableMono_1ThinLine'"/>
				</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'TableStyle/TableMono_0Line'"/>
					</xsl:otherwise>
			</xsl:choose>
          </xsl:attribute>
		<xsl:attribute name="BodyRowCount">
            <xsl:value-of select="count(child::tr)"/>
          </xsl:attribute>
          <xsl:attribute name="ColumnCount">
            <xsl:value-of select="count(child::tr[1]/td)"/>
          </xsl:attribute><xsl:text>&#xA;</xsl:text>
          <xsl:variable name="columnWidth" select="$table-width div count(tr[1]/td)"/>
          <xsl:for-each select="tr[1]/td">
            <Column Name="{position() - 1}" SingleColumnWidth="{$columnWidth}"/><xsl:text>&#xA;</xsl:text>
          </xsl:for-each>
          <xsl:for-each select="tr">
            <xsl:variable name="rowNum" select="position() - 1"/>
            <xsl:for-each select="td">
				<xsl:variable name="colNum" select="position() - 1"/>
				<xsl:variable name="get-para-style">
					<xsl:choose>
						<xsl:when test="@class">
							<xsl:value-of select="@class"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'NormalParagraphStyle'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="get-col-span">
					<xsl:choose>
						<xsl:when test="@colspan">
							<xsl:value-of select="@colspan"/>
						</xsl:when>
						<xsl:when test="contains(@class,'_Clear')">
								<xsl:value-of select="2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="1"/>
						</xsl:otherwise>
					</xsl:choose>				
				</xsl:variable>
<!--				<xsl:variable name="get_col_span" select="1"/> -->
                <Cell Name="{$colNum}:{$rowNum}" RowSpan="1" ColumnSpan="{$get-col-span}" AppliedCellStyle="CellStyle/$ID/[None]" AppliedCellStylePriority="0"><xsl:text>&#xA;</xsl:text>
                    <xsl:call-template name="para-style-range-in-table">
						<xsl:with-param name="style-name" select="$get-para-style"/>
					</xsl:call-template>
                </Cell><xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
          </xsl:for-each>
        </Table><xsl:text>&#xA;</xsl:text>
      </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
    </ParagraphStyleRange><xsl:text>&#xA;</xsl:text>
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
<!--	<xsl:choose>
		<xsl:when test="@width and @height">
			<xsl:variable name="halfwidth" select="@width div 4"/>
			<xsl:variable name="halfheight" select="@height div 4"/>
		</xsl:when>
		<xsl:otherwise>-->
			<xsl:variable name="halfwidth" select="80.77"/>
			<xsl:variable name="halfheight" select="51"/>
<!--		</xsl:otherwise>	
	</xsl:choose>-->
    <ParagraphStyleRange><xsl:text>&#xA;</xsl:text>
      <CharacterStyleRange><xsl:text>&#xA;</xsl:text>
        <Rectangle ContentType="GraphicType" AppliedObjectStyle="ObjectStyle/$ID/[Normal Graphics Frame]" Visible="true" ItemTransform="1 0 0 1 {$halfwidth} -{$halfheight}"><xsl:text>&#xA;</xsl:text>
          <Properties><xsl:text>&#xA;</xsl:text>
            <PathGeometry><xsl:text>&#xA;</xsl:text>
              <GeometryPathType PathOpen="false"><xsl:text>&#xA;</xsl:text>
                <PathPointArray><xsl:text>&#xA;</xsl:text>
                  <PathPointType Anchor="-{$halfwidth} -{$halfheight}" 
                                 LeftDirection="-{$halfwidth} -{$halfheight}" 
                                 RightDirection="-{$halfwidth} -{$halfheight}"/><xsl:text>&#xA;</xsl:text>
                  <PathPointType Anchor="-{$halfwidth} {$halfheight}" 
                                 LeftDirection="-{$halfwidth} {$halfheight}" 
                                 RightDirection="-{$halfwidth} {$halfheight}"/><xsl:text>&#xA;</xsl:text>
                  <PathPointType Anchor="{$halfwidth} {$halfheight}" 
                                 LeftDirection="{$halfwidth} {$halfheight}" 
                                 RightDirection="{$halfwidth} {$halfheight}"/><xsl:text>&#xA;</xsl:text>
                  <PathPointType Anchor="{$halfwidth} -{$halfheight}" 
                                 LeftDirection="{$halfwidth} -{$halfheight}" 
                                 RightDirection="{$halfwidth} -{$halfheight}"/><xsl:text>&#xA;</xsl:text>
                </PathPointArray><xsl:text>&#xA;</xsl:text>
              </GeometryPathType><xsl:text>&#xA;</xsl:text>
            </PathGeometry><xsl:text>&#xA;</xsl:text>
          </Properties><xsl:text>&#xA;</xsl:text>
					<AnchoredObjectSetting AnchoredPosition="AboveLine" SpineRelative="false" LockPosition="false" PinPosition="true" AnchorPoint="BottomRightAnchor" HorizontalAlignment="CenterAlign" HorizontalReferencePoint="TextFrame" VerticalAlignment="TopAlign" VerticalReferencePoint="LineBaseline" AnchorXoffset="0" AnchorYoffset="-5.164724409448819" AnchorSpaceAbove="5.164724409448819" /><xsl:text>&#xA;</xsl:text>
					<TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false" TextWrapSide="BothSides" TextWrapMode="None"><xsl:text>&#xA;</xsl:text>
						<Properties><xsl:text>&#xA;</xsl:text>
							<TextWrapOffset Top="0" Left="0" Bottom="0" Right="0" /><xsl:text>&#xA;</xsl:text>
						</Properties><xsl:text>&#xA;</xsl:text>
						<ContourOption ContourType="SameAsClipping" IncludeInsideEdges="false" ContourPathName="$ID/" /><xsl:text>&#xA;</xsl:text>
					</TextWrapPreference><xsl:text>&#xA;</xsl:text>
          <Image ItemTransform="1 0 0 1 -{$halfwidth} -{$halfheight}"><xsl:text>&#xA;</xsl:text>
            <Properties><xsl:text>&#xA;</xsl:text>
              <Profile type="string">$ID/Embedded</Profile><xsl:text>&#xA;</xsl:text>
              <GraphicBounds Left="0" Top="0" Right="{2*$halfwidth}" Bottom="{2*$halfheight}"/><xsl:text>&#xA;</xsl:text>
            </Properties><xsl:text>&#xA;</xsl:text>
            <Link Self="ueb" LinkResourceURI="file:N:/2-%D0%92%D0%95%D0%A0%D0%A1%D0%A2%D0%9A%D0%90%28design%29/Nikitin/%D0%A0%D0%9B%D0%A1/test%20convert%2icml/{@src}"/><xsl:text>&#xA;</xsl:text>
          </Image><xsl:text>&#xA;</xsl:text>
        </Rectangle><xsl:text>&#xA;</xsl:text>
        <Br/><xsl:text>&#xA;</xsl:text>
      </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
    </ParagraphStyleRange><xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Links -->
  <!-- ==================================================================== -->
  <xsl:template match="a" mode="character-style-range">
    <xsl:variable name="hyperlink-key" select="count(preceding::a) + 1"/>
    <xsl:variable name="self" select="concat('htss-', $hyperlink-key)"/>
    <xsl:variable name="name" select="."/>
    <CharacterStyleRange><xsl:text>&#xA;</xsl:text>
      <xsl:attribute name="AppliedCharacterStyle">CharacterStyle/link</xsl:attribute> 
      <HyperlinkTextSource Self="{$self}" Name="{$name}" Hidden="false"><xsl:text>&#xA;</xsl:text>
        <Content><xsl:value-of select="."/></Content><xsl:text>&#xA;</xsl:text>
      </HyperlinkTextSource><xsl:text>&#xA;</xsl:text>
    </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
  </xsl:template>  

  <!-- TODO: Add support for internal hyperlinks -->
  <xsl:template match="a[not(@href)]" mode="hyperlinks"/>
  <xsl:template match="a[not(@href)]" mode="hyperlink-url-destinations"/>

  <xsl:template match="a[@href]" mode="hyperlink-url-destinations">
    <xsl:variable name="hyperlink-key" select="count(preceding::a) + 1"/>
    <xsl:variable name="hyperlink-text-source-self" select="concat('htss-', $hyperlink-key)"/>
    <xsl:variable name="hyperlink-url-destination-self" select="concat('huds-', $hyperlink-key)"/>
    <xsl:variable name="hyperlink-text-source-name" select="."/>
    <xsl:variable name="destination-unique-key" select="$hyperlink-key"/>
    <HyperlinkURLDestination Self="{$hyperlink-url-destination-self}" 
                             Name="{$hyperlink-text-source-name}"
                             DestinationURL="{@href}" 
                             DestinationUniqueKey="{$destination-unique-key}"/><xsl:text>&#xA;</xsl:text>
  </xsl:template>  

  <xsl:template match="a[@href]" mode="hyperlinks">
    <xsl:variable name="hyperlink-key" select="count(preceding::a) + 1"/>
    <xsl:variable name="hyperlink-self" select="concat('hs-', $hyperlink-key)"/>
    <xsl:variable name="hyperlink-url-destination-self" select="concat('huds-', $hyperlink-key)"/>
    <xsl:variable name="hyperlink-text-source-self" select="concat('htss-', $hyperlink-key)"/>
    <xsl:variable name="hyperlink-text-source-name" select="."/>
    <xsl:variable name="destination-unique-key" select="$hyperlink-key"/>
    <Hyperlink Self="{$hyperlink-self}" 
               Name="{$hyperlink-text-source-name}" 
               Source="{$hyperlink-text-source-self}" 
               Visible="true" 
               DestinationUniqueKey="{$destination-unique-key}"><xsl:text>&#xA;</xsl:text>
      <Properties><xsl:text>&#xA;</xsl:text>
        <BorderColor type="enumeration">Black</BorderColor><xsl:text>&#xA;</xsl:text>
        <Destination type="object"><xsl:value-of select="$hyperlink-url-destination-self"/></Destination><xsl:text>&#xA;</xsl:text>
      </Properties><xsl:text>&#xA;</xsl:text>
    </Hyperlink><xsl:text>&#xA;</xsl:text>
  </xsl:template>  


  <!-- ==================================================================== -->
  <!-- Inlines -->
  <!-- ==================================================================== -->
  <xsl:template match="em|i" mode="character-style-range">
    <xsl:call-template name="char-style-range">
      <xsl:with-param name="style-name">i</xsl:with-param>
    </xsl:call-template>
  </xsl:template>  

  <xsl:template match="strong|b" mode="character-style-range">
    <xsl:call-template name="char-style-range">
      <xsl:with-param name="style-name">b</xsl:with-param>
    </xsl:call-template>
  </xsl:template>  

  <xsl:template match="span[@class]" mode="character-style-range">
    <xsl:call-template name="char-style-range">
      <xsl:with-param name="style-name" select="@class"/>
    </xsl:call-template>
  </xsl:template>  

  <xsl:template match="text()" mode="character-style-range">
    <xsl:call-template name="char-style-range">
      <xsl:with-param name="style-name">[No character style]</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="br" mode="character-style-range">
    <Br/> <!-- TODO: Is this always going to appear in an acceptable location? -->
  </xsl:template>

  <xsl:template match="sub" mode="character-style-range">
    <xsl:call-template name="char-style-range">
      <xsl:with-param name="style-name">[No character style]</xsl:with-param>
      <xsl:with-param name="vertical-position">Subscript</xsl:with-param>
    </xsl:call-template>
  </xsl:template>  

  <xsl:template match="sup" mode="character-style-range">
    <xsl:call-template name="char-style-range">
      <xsl:with-param name="style-name">[No character style]</xsl:with-param>
      <xsl:with-param name="vertical-position">Superscript</xsl:with-param>
    </xsl:call-template>
  </xsl:template>  

  <xsl:template match="font[@face]" mode="character-style-range">
    <xsl:call-template name="char-style-range">
      <xsl:with-param name="style-name" select="@face"/>
    </xsl:call-template>
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
  <xsl:template match="*[a[contains(@name, 'sdfootnote') or 
                                       contains(@name, 'sdendnote')]]" 
                priority="1"/>

  <!-- The second paragraphs of two-paragraph footnotes should be ignored as well. -->
  <xsl:template match="*[not(a[contains(@name, 'sdfootnote') or 
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
  <xsl:template match="p[not(a[contains(@name, 'sdfootnote') or 
                                           contains(@name, 'sdendnote')])]
                              [preceding-sibling::*[1]
                                                   [not(a[contains(@name, 'sdfootnote') or 
                                                                contains(@name, 'sdendnote')])]]
                              [preceding-sibling::*[2]
                                                   [a[contains(@name, 'sdfootnote') or 
                                                            contains(@name, 'sdendnote')]]]"
                priority="1">
  <xsl:message>WARNING: Footnotes with more than 2 paragraphs are not supported. Extra paragraphs will appear at the end of the document!
Problematic text starts with: <xsl:value-of select="."/> 
</xsl:message>
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">p</xsl:with-param>
    </xsl:call-template>
  </xsl:template>              


  <!-- The hardcoded anchors that used to link the footnotes together should
       also be omitted, as InDesign will generate auto-numbered foonote Markers. -->
  <xsl:template match="*/a[contains(@name, 'sdfootnote') or
                                       contains(@name, 'sdendnote')]"  
                mode="character-style-range"/>

  <xsl:template match="sup[a[contains(@name, 'sdfootnote') or
                                         contains(@name, 'sdendnote')]]" 
                mode="character-style-range">
    <xsl:variable name="marker-name" select="a[contains(@name, 'sdfootnote') or
                                                     contains(@name, 'sdendnote')]/@name"/>
    <xsl:variable name="target" select="concat('#', $marker-name)"/>
    <xsl:call-template name="process-footnote">
      <xsl:with-param name="content">
        <xsl:apply-templates select="//*[a[@href = $target]]" 
                             mode="character-style-range"/>

        <!-- Check if there are extra paragraphs hanging around after this one -->
        <xsl:if test="//*[not(a[contains(@name, 'sdfootnote') or
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
          <xsl:apply-templates select="//*[not(a[contains(@name, 'sdfootnote') or
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
  <xsl:template match="*[a[contains(@href, '#_ftnref')]]" 
                priority="1"/>

  <!-- The second paragraphs of two-paragraph footnotes should be ignored as well. -->
  <xsl:template match="*[not(a[contains(@href, '#_ftnref')])]
                              [preceding-sibling::*[1]
                                                   [a[contains(@href, '#_ftnref')]]]" 
                priority="1"/>

  <!-- The third paragraphs of multi-paragraph footnotes should warn. See
       above for explanation of this horrific XPath. -->
  <xsl:template match="p[not(a[contains(@href, '#_ftnref')])]
                              [preceding-sibling::*[1]
                                                   [not(a[contains(@href, '#_ftnref')])]]
                              [preceding-sibling::*[2]
                                                   [a[contains(@href, '#_ftnref')]]]"
                priority="1">
  <xsl:message>WARNING: Footnotes with more than 2 paragraphs are not supported. Extra paragraphs will appear at the end of the document!
Problematic text starts with: <xsl:value-of select="."/> 
</xsl:message>
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">p</xsl:with-param>
    </xsl:call-template>
  </xsl:template>              

  <!-- The hardcoded anchors that used to link the footnotes together should
       also be omitted, as InDesign will generate auto-numbered foonote Markers. -->
  <xsl:template match="*/a[contains(@href, '#_ftnref')]"
                mode="character-style-range"/>

  <xsl:template match="a[contains(@id, '_ftnref')]" 
                mode="character-style-range">
    <xsl:variable name="marker-name" select="@id"/>
    <xsl:variable name="target" select="concat('#', $marker-name)"/>
    <xsl:call-template name="process-footnote">
      <xsl:with-param name="content">
        <xsl:apply-templates select="//*[a[@href = $target]]" 
                             mode="character-style-range"/>
        <!-- Check if there are extra paragraphs hanging around after this one -->
        <xsl:if test="//*[not(a[contains(@href, '#_ftnref')])]
                               [preceding-sibling::*[1]
                                                    [a[@href = $target]]]">
          <!-- This is how we fake InDesign into separating "multi-paragraph"
               footnotes (they are actually one paragraph). -->
          <CharacterStyleRange><xsl:text>&#xA;</xsl:text>
            <Br/><xsl:text>&#xA;</xsl:text>
          </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
          <xsl:apply-templates select="//*[not(a[contains(@href, '#_ftnref')])]
                                                [preceding-sibling::*[1]
                                                                     [a[@href = $target]]]"
                               mode="character-style-range"/>
        </xsl:if>

      </xsl:with-param>  
    </xsl:call-template>
  </xsl:template>  

  <!-- == Docutils footnotes (legacy) == -->
  <xsl:template match="table[@class='docutils footnote']/tbody/tr">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/footnote"><xsl:text>&#xA;</xsl:text>
      <xsl:for-each select="td">
        <xsl:choose>
          <xsl:when test="self::td[@class='label']">
            <CharacterStyleRange><xsl:text>&#xA;</xsl:text>
              <Content><xsl:value-of select="substring-before(substring-after(.,'['),']')"/>. </Content><xsl:text>&#xA;</xsl:text>
            </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <Content><xsl:text>&#xA;</xsl:text>
              <xsl:value-of select="."/><xsl:text>&#xA;</xsl:text>
            </Content><xsl:text>&#xA;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </ParagraphStyleRange><xsl:text>&#xA;</xsl:text>
    <Br/><xsl:text>&#xA;</xsl:text>
  </xsl:template>
  <xsl:template match="div[@class='footnotes']/p">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/footnote"><xsl:text>&#xA;</xsl:text>
      <CharacterStyleRange><xsl:text>&#xA;</xsl:text>
        <Content><xsl:text>&#xA;</xsl:text>
          <xsl:value-of select="."/><xsl:text>&#xA;</xsl:text>
        </Content><xsl:text>&#xA;</xsl:text>
        <Br/><xsl:text>&#xA;</xsl:text>
      </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
    </ParagraphStyleRange><xsl:text>&#xA;</xsl:text>
  </xsl:template>

    
  <!-- ==================================================================== -->
  <!-- StyleGroup boilerplate -->
  <!-- ==================================================================== -->

  <!-- Grab only the first instance of each @class -->
  <xsl:template match="p[@class]"
                mode="paragraph-style">
    <xsl:variable name="c" select="@class"/>
    <xsl:if test="not(following::p[@class = $c])">
      <xsl:choose>
        <xsl:when test="@class='quote'">
          <!-- Ignore; already hardcoded because of <blockquote> -->
        </xsl:when>
        <xsl:when test="@class='dc-creator'">
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

  <xsl:template match="td[@class]"
                mode="paragraph-style">
    <xsl:variable name="c" select="@class"/>
    <xsl:if test="not(following::p[@class = $c])">
          <xsl:call-template name="generate-paragraph-style">
            <xsl:with-param name="style-name" select="@class"/>
          </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="span[@class]"
                mode="character-style">
    <xsl:variable name="c" select="@class"/>
    <xsl:if test="not(following::span[@class = $c])">
      <xsl:call-template name="generate-character-style">
        <xsl:with-param name="style-name" select="@class"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="font[@face]"
                mode="character-style">
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
      </xsl:attribute><xsl:text>&#xA;</xsl:text>
      <xsl:if test="$prefix-content != ''">
        <CharacterStyleRange><xsl:text>&#xA;</xsl:text>
          <Content>
		  <xsl:value-of select="$prefix-content"/>
		  </Content><xsl:text>&#xA;</xsl:text>
        </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="text()|*" mode="character-style-range"/>
    </ParagraphStyleRange><xsl:text>&#xA;</xsl:text>
	<Br/><xsl:text>&#xA;</xsl:text>
</xsl:template>
  
    <xsl:template name="para-style-range-in-table">
    <!-- The name of the paragraph style in InDesign -->
    <xsl:param name="style-name"/> 
    <!-- A string of text that will precede the paragraph's actual content (ex: 'by ')-->
    <xsl:param name="prefix-content" select="''"/>
    <ParagraphStyleRange>
      <xsl:attribute name="AppliedParagraphStyle">
        <xsl:value-of select="concat('ParagraphStyle/', $style-name)"/>
      </xsl:attribute><xsl:text>&#xA;</xsl:text>
      <xsl:if test="$prefix-content != ''">
        <CharacterStyleRange><xsl:text>&#xA;</xsl:text>
          <Content>
		  <xsl:value-of select="$prefix-content"/>
		  </Content><xsl:text>&#xA;</xsl:text>
        </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="text()|*" mode="character-style-range"/>
      <xsl:text>&#xA;</xsl:text>
    </ParagraphStyleRange><xsl:text>&#xA;</xsl:text>
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
      </xsl:if><xsl:text>&#xA;</xsl:text>
      <Content><xsl:value-of select="."/></Content><xsl:text>&#xA;</xsl:text>
    </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="process-footnote">
    <xsl:param name="content"/>
    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" 
                         Position="Superscript"><xsl:text>&#xA;</xsl:text>
      <Footnote><xsl:text>&#xA;</xsl:text>
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/footnote"><xsl:text>&#xA;</xsl:text>
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]"><xsl:text>&#xA;</xsl:text>
            <!-- InDesign magical footnote character -->
            <Content><xsl:processing-instruction name="ACE">4</xsl:processing-instruction></Content><xsl:text>&#xA;</xsl:text>
          </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
          <xsl:copy-of select="$content"/>
        </ParagraphStyleRange><xsl:text>&#xA;</xsl:text>
      </Footnote><xsl:text>&#xA;</xsl:text>
    </CharacterStyleRange><xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="generate-paragraph-style">
    <xsl:param name="style-name"/>
    <ParagraphStyle>
      <xsl:attribute name="Self"><xsl:value-of select="concat('ParagraphStyle/', $style-name)"/></xsl:attribute> 
      <xsl:attribute name="Name"><xsl:value-of select="$style-name"/></xsl:attribute>
    </ParagraphStyle>
  </xsl:template>

  <xsl:template name="generate-character-style">
    <xsl:param name="style-name"/>
    <CharacterStyle>
      <xsl:attribute name="Self"><xsl:value-of select="concat('CharacterStyle/', $style-name)"/></xsl:attribute> 
      <xsl:attribute name="Name"><xsl:value-of select="$style-name"/></xsl:attribute>
    </CharacterStyle>
  </xsl:template>

</xsl:stylesheet>

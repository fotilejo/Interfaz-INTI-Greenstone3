<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:util="xalan://org.greenstone.gsdl3.util.XSLTUtil"
	xmlns:gslib="http://www.greenstone.org/skinning"
	xmlns:gsf="http://www.greenstone.org/greenstone3/schema/ConfigFormat"
	extension-element-prefixes="java util"
	exclude-result-prefixes="java util gsf">
			
	<!-- Creates a header for the html page -->
	<xsl:template name="create-html-header">

<script type="text/javascript">
<xsl:text disable-output-escaping="yes">
function mostrar(id){
	var div=document.getElementById(id);div.style.display=="none";
	if (div.style.display=="none"){
		div.style.display="block";
	} else {
		div.style.display="none";
	}
}
</xsl:text>
</script>

		<base>
			<xsl:attribute name="href">
				<xsl:choose>
					<xsl:when test="/page/pageResponse/metadataList/metadata[@name = 'siteURL']">
						<xsl:value-of select="/page/pageResponse/metadataList/metadata[@name = 'siteURL']"/>
					</xsl:when>
					<xsl:when test="/page/pageRequest/@baseURL">
						<xsl:value-of select="/page/pageRequest/@baseURL"/>
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
		</base>
		<xsl:comment>[if lte IE 6]&gt;&lt;/base&gt;&lt;![endif]</xsl:comment>
	
		<title>
			<xsl:variable name="currentPageTitle"><xsl:call-template name="pageTitle"/></xsl:variable>
			<xsl:variable name="cleanPageTitle" select="normalize-space($currentPageTitle)"/>
			<xsl:choose>
				<xsl:when test="$cleanPageTitle = '' or $cleanPageTitle = 'Repositorio Institucional' or $cleanPageTitle = 'Repositorio Institucional INTI'">
					<xsl:text>Repositorio Institucional INTI</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$cleanPageTitle"/><xsl:text> | Repositorio Institucional INTI</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</title>
		
		<xsl:if test="/page/pageRequest/@action ='d'">
		  
		  <xsl:variable name="myMetadataHeader" select="/page/pageResponse/format/gsf:headMetaTags/gsf:metadata"/>
		  <xsl:for-each select="$myMetadataHeader">
		    <xsl:variable name="metaname" select="@name"/>
		    
		    <xsl:variable name="metavals" 
				  select="/page/pageResponse/document/metadataList/metadata[@name = $metaname]|/page/pageResponse/document/documentNode/metadataList/metadata[@name = $metaname]"/>
		    <xsl:for-each select="$metavals">
		      <META NAME="{$metaname}" CONTENT="{.}"/>
		    </xsl:for-each>
		  </xsl:for-each>
		  
		</xsl:if>

<!-- ModificaciÃ³n para Celular -->
<meta content="width=device-width, initial-scale=1" name="viewport" />
<meta name="view-transition" content="same-origin" />
<link rel="stylesheet" href="interfaces/{$interface_name}/styles/fontawesome.min.css" type="text/css" />
<link rel="stylesheet" href="interfaces/{$interface_name}/styles/gs3-core-min.css" type="text/css" />
    <link rel="stylesheet" href="interfaces/{$interface_name}/styles/modern.css?v=7.03" type="text/css" />
<!-- Hasta acÃ¡ -->

		<link rel="shortcut icon" href="interfaces/{$interface_name}/images/favicon_inti.svg?v=2" type="image/svg+xml"/>
		<link rel="icon" href="interfaces/{$interface_name}/images/favicon_inti.png?v=1" type="image/png" sizes="512x512"/>

		<script type="text/javascript" src="interfaces/{$interface_name}/js/jquery.min.js"><xsl:text> </xsl:text></script>
		<script type="text/javascript" src="interfaces/{$interface_name}/js/jquery-ui-1.10.2.custom/js/jquery-ui-1.10.2.custom.min.js"><xsl:text> </xsl:text></script>
		<script type="text/javascript" src="interfaces/{$interface_name}/js/jquery.themeswitcher.min.js"><xsl:text> </xsl:text></script>
		<script type="text/javascript" src="interfaces/{$interface_name}/js/jquery.blockUI.js"><xsl:text> </xsl:text></script>
		<script type="text/javascript" src="interfaces/{$interface_name}/js/ace/ace.js"><xsl:text> </xsl:text></script>
		
		<script type="text/javascript" src="interfaces/{$interface_name}/js/zoomer.js"><xsl:text> </xsl:text></script>
    <script type="text/javascript" src="interfaces/{$interface_name}/js/modern.js?v=7.03"><xsl:text> </xsl:text></script>

		<xsl:if test="/page/pageResponse/format[@type='display' or @type='browse' or @type='search']/gsf:option[@name='mapEnabled']/@value = 'true'">
		  <xsl:call-template name="map-scripts"/>
		</xsl:if>
		
		<xsl:if test="/page/pageResponse/format/gsf:option[@name='mapEnabledOpenLayers']/@value = 'true'">
		  <xsl:call-template name="openlayers-map-scripts"/>
		</xsl:if>


		<xsl:if test="/page/pageResponse/format/gsf:option[@name='panoramaViewerEnabled']/@value = 'true'">
		  <xsl:call-template name="panoramaViewer-scripts"/>
		</xsl:if>

		<xsl:if test="/page/pageRequest/userInformation and /page/pageRequest/userInformation/@editEnabled = 'true' and (util:contains(/page/pageRequest/userInformation/@groups, 'administrator') or util:contains(/page/pageRequest/userInformation/@groups, 'all-collections-editor') or util:contains(/page/pageRequest/userInformation/@groups, $thisCollectionEditor))">
			<xsl:if test="/page/pageRequest/paramList/param[(@name='docEdit') and (@value='on' or @value='true' or @value='1')]">
			</xsl:if>
			<script type="text/javascript" src="interfaces/{$interface_name}/js/debug_scripts.js"><xsl:text> </xsl:text></script>
			<script type="text/javascript" src="interfaces/{$interface_name}/js/visual-xml-editor.js"><xsl:text> </xsl:text></script>
		</xsl:if>
		
		<xsl:call-template name="setup-gs-variable"/>
		<xsl:call-template name="define-js-macro-variables"/>

		<xsl:call-template name="additionalHeaderContent"/>
	</xsl:template>
	
</xsl:stylesheet>

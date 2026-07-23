<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:util="xalan://org.greenstone.gsdl3.util.XSLTUtil"
	xmlns:gslib="http://www.greenstone.org/skinning"
	extension-element-prefixes="java util"
	exclude-result-prefixes="java util">
  
	<!-- use the 'main' layout -->
	<xsl:include href="layouts/main.xsl"/>

	<!-- set page title -->
	<xsl:template name="pageTitle">Aviso del Sistema</xsl:template>

	<!-- set page breadcrumbs -->
	<xsl:template name="breadcrumbs"><gslib:siteLink/></xsl:template>

	<!-- the page content -->
	<xsl:template match="/page">
		<div class="search-error-fallback" style="text-align:center; padding: 40px 20px;">
			<i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #e74c3c; margin-bottom: 20px;"></i>
			<h2 style="font-family: 'Lora', serif; color: #333;">Aviso del Sistema</h2>
			<p style="font-family: 'Inter', sans-serif; color: #666; font-size: 1.1rem; max-width: 600px; margin: 0 auto 20px;">
				Lo sentimos, ha ocurrido un error al procesar su solicitud o está intentando acceder a una zona restringida. Si esto ocurrió durante una búsqueda, verifique que los términos ingresados sean válidos.
			</p>
			<a href="{/page/pageResponse/metadataList/metadata[@name='siteURL']|/page/pageResponse/metadataList/metadata[@name='library_name']|$library_name}?a=p&amp;sa=home" style="display: inline-block; padding: 10px 20px; background: #0066cc; color: #fff; text-decoration: none; border-radius: 4px; font-family: 'Inter', sans-serif;">Volver al inicio</a>
		</div>
	</xsl:template>
</xsl:stylesheet>
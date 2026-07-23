<?xml version="1.0" encoding="UTF-8"?><!-- main.xsl aybara modif -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"

	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:util="xalan://org.greenstone.gsdl3.util.XSLTUtil"
	xmlns:gslib="http://www.greenstone.org/skinning"
    xmlns:gsf="http://www.greenstone.org/greenstone3/schema/ConfigFormat"
    
    xmlns:lxslt="http://xml.apache.org/xslt"
    xmlns:result="http://www.example.com/results"
    xmlns:exsl="http://exslt.org/common"

	extension-element-prefixes="java util result exsl"
	exclude-result-prefixes="util java util">

	
<!-- The main layout is defined here -->
<xsl:template name="mainTemplate">
<html>
	<head>
		<!-- ***** in header.xsl ***** -->
		<xsl:call-template name="create-html-header"/>
		
		<!-- Etiquetas Meta Globales (SEO y Open Graph) -->
		<meta name="description" content="Repositorio Institucional del INTI. Acceso abierto a publicaciones, libros, artículos y documentos técnicos para el desarrollo productivo." />
		<meta property="og:title" content="Repositorio Institucional INTI" />
		<meta property="og:description" content="Conocimiento científico y técnico al servicio del desarrollo productivo. Consultá publicaciones, artículos y documentos en acceso abierto." />
		<meta property="og:image" content="https://app.inti.gob.ar/greenstone3/interfaces/otra/images/LogoINTI.png" />
		<meta property="og:url" content="https://app.inti.gob.ar/greenstone3/library" />
		<meta property="og:site_name" content="Instituto Nacional de Tecnología Industrial" />
		<meta property="og:type" content="website" />
		<meta name="twitter:card" content="summary_large_image" />
		<script type="application/ld+json">
		{
		  "@context" : "https://schema.org",
		  "@type" : "WebSite",
		  "name" : "Repositorio Institucional INTI",
		  "alternateName" : ["INTI", "Instituto Nacional de Tecnología Industrial"],
		  "url" : "https://app.inti.gob.ar/greenstone3/biblio"
		}
		</script>
		<link rel="icon" type="image/svg+xml" href="https://app.inti.gob.ar/greenstone3/interfaces/otra/images/favicon_inti.svg" />
		<link rel="icon" type="image/png" sizes="512x512" href="https://app.inti.gob.ar/greenstone3/interfaces/otra/images/favicon_inti.png" />
	</head>
	<body id="top">
		<xsl:if test="page/pageRequest/@subaction='home'">
			<xsl:attribute name="class">page-home</xsl:attribute>
		</xsl:if>
		<header class="site-header">
			<div class="site-header__inner">
				<a class="site-brand" href="{$library_name}" title="Inicio del Repositorio INTI">
					<img class="site-brand__logo" src="interfaces/{$interface_name}/images/LogoINTI.png" alt="INTI" />
					<span class="site-brand__divider"><xsl:text> </xsl:text></span>
					<span class="site-brand__text">
						<span class="site-brand__eyebrow">Instituto Nacional de Tecnolog&#237;a Industrial</span>
						<span class="site-brand__title">Repositorio <strong>Institucional</strong></span>
					</span>
				</a>
			</div>
		</header>
		<div class="site-header__underline"><xsl:text> </xsl:text></div>
		<xsl:if test="/page/pageResponse/collection">
			<div class="descri">
				<div class="collection-tab">
					<i class="fa-regular fa-folder-open collection-tab__icon"><xsl:text> </xsl:text></i>
					<span class="collection-tab__breadcrumb">Repositorio</span>
					<i class="fa-solid fa-chevron-right collection-tab__separator"><xsl:text> </xsl:text></i>
					<span class="collection-tab__name"><xsl:call-template name="descripcion"/></span>
				</div>
			</div>
		</xsl:if>
		<div class="wrapper col2">
			<div id="topbar">
				<div id="topnav">
					<ul>
						<xsl:call-template name="navBar"/>
					</ul>
				</div>
<!--**********************************************************************-->
	<xsl:choose>
		<xsl:when test="page/pageRequest/@subaction='home'">
			<xsl:call-template name="crossCollSearch"/>
		</xsl:when>
		<xsl:otherwise/>
	</xsl:choose>
<!--**********************************************************************-->
			</div>
		</div>
			
		<!--<xsl:apply-templates select="/page"/>-->
		<div class="wrapper page-content-wrapper">
			<div class="container" id="gs_content">
				<xsl:apply-templates select="/page"/><br />
				<br class="clear" />
			</div>
		</div>
		<xsl:call-template name="gs_footer"/>
	</body>
</html>
</xsl:template>

 	<xsl:template name="descripcion">
	   <xsl:value-of select="/page/pageResponse/collection/displayItemList/
displayItem[@name='name']" disable-output-escaping="yes"/>
	</xsl:template>

<!-- Template controlling the footer. -->
<xsl:template name="gs_footer">
	<footer class="site-footer">
		<div class="site-footer__accent"><xsl:text> </xsl:text></div>
		<div class="site-footer__inner">
			<section>
				<h2>Repositorio</h2>
				<ul class="site-footer__links">
					<li><a href="{$library_name}">Inicio</a></li>
					<li><a href="{$library_name}#colecciones">Colecciones</a></li>
					<li><a href="{$library_name}/page/help">Ayuda</a></li>
				</ul>
			</section>
			<section>
				<h2>Enlaces de inter&#233;s</h2>
				<ul class="site-footer__links">
					<li><a href="https://www.inti.gob.ar">Web INTI</a></li>
					<li><a href="https://repositoriosdigitales.mincyt.gob.ar">Sistema Nacional de Repositorios Digitales (SNRD)</a></li>
					<li><a href="https://biblioteca.inti.gob.ar">Biblioteca INTI</a></li>
				</ul>
			</section>
			<section>
				<h2>Redes INTI</h2>
				<div class="site-footer__social">
					<a href="https://x.com/intiargentina" target="_blank" rel="noopener noreferrer" aria-label="Seguir a INTI en X (Twitter)"><i class="fab fa-x-twitter"><xsl:text> </xsl:text></i></a>
					<a href="https://www.facebook.com/INTIArg" target="_blank" rel="noopener noreferrer" aria-label="Seguir a INTI en Facebook"><i class="fab fa-facebook-f"><xsl:text> </xsl:text></i></a>
					<a href="https://www.instagram.com/intiargentina" target="_blank" rel="noopener noreferrer" aria-label="Seguir a INTI en Instagram"><i class="fab fa-instagram"><xsl:text> </xsl:text></i></a>
					<a href="https://www.youtube.com/canalinti" target="_blank" rel="noopener noreferrer" aria-label="Ver canal de INTI en YouTube"><i class="fab fa-youtube"><xsl:text> </xsl:text></i></a>
					<a href="https://www.linkedin.com/company/inti" target="_blank" rel="noopener noreferrer" aria-label="Seguir a INTI en LinkedIn"><i class="fab fa-linkedin"><xsl:text> </xsl:text></i></a>
				</div>
			</section>
		</div>
		<div class="site-footer__bottom">
			<div class="site-footer__inner">
				<span>2026 - Instituto Nacional de Tecnolog&#237;a Industrial</span>
			</div>
		</div>
	</footer>
</xsl:template>

<xsl:template name="navBar">
<xsl:choose>
<xsl:when test="page/pageResponse/collection">
<xsl:variable name="count" select="count(/page/pageResponse/collection/serviceList/service[@name='ClassifierBrowse']/classifierList/classifier)"/>
<xsl:variable name="currentPage" select="page/pageRequest/@fullURL"/>

<xsl:if test="/page/pageResponse/collection/serviceList/service/@type='query'">
<li class="nav-has-submenu">
<button type="button" class="nav-dropdown-toggle" aria-expanded="false"><i class="fa-solid fa-magnifying-glass"><xsl:text> </xsl:text></i> Buscar <i class="fa-solid fa-chevron-down nav-dropdown-chevron"><xsl:text> </xsl:text></i></button>
<ul class="nav-dropdown-menu">
<xsl:for-each select="/page/pageResponse/collection/serviceList/service[@type='query']">
<xsl:variable name="search" select="@name"/>
<xsl:variable name="search_name" select="displayItem[@name='name']"/>
<li><a href="{$library_name}/collection/{$collNameChecked}/search/{$search}"><xsl:value-of select="$search_name"/></a></li>
</xsl:for-each>
</ul>
</li>
</xsl:if>

<xsl:choose>
<xsl:when test="$count > 3">
<li><a href="{$currentPage}"><i class="fa-solid fa-compass"><xsl:text> </xsl:text></i> Explorar</a>
<ul>
<xsl:call-template name="Browsing"/>
</ul>
</li>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="Browsing"/>
</xsl:otherwise>
</xsl:choose>

<li><a href="{$library_name}/page/help"><i class="fa-solid fa-circle-question"><xsl:text> </xsl:text></i> Ayuda</a></li>

<li><a href="{$library_name}"><i class="fa-solid fa-house"><xsl:text> </xsl:text></i> Inicio</a></li>

</xsl:when>
<xsl:otherwise>
<li><a href="{$library_name}"><i class="fa-solid fa-house"><xsl:text> </xsl:text></i> Inicio</a></li>
<li><a href="{$library_name}#colecciones"><i class="fa-solid fa-layer-group"><xsl:text> </xsl:text></i> Colecciones</a></li>
<li><a href="{$library_name}/page/help"><i class="fa-solid fa-circle-question"><xsl:text> </xsl:text></i> Ayuda</a></li>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="Browsing">
<xsl:for-each select="/page/pageResponse/collection/serviceList/service[@name='ClassifierBrowse']/classifierList/classifier">
<li>
<xsl:choose>
<!-- If this tab is selected then colour it differently -->
<xsl:when test="util:contains(/page/pageRequest/paramList/param[@name = 'cl' and /page/pageRequest/@action = 'b']/@value, @name)">
<xsl:attribute name='class'>active</xsl:attribute>
</xsl:when>
<xsl:otherwise> </xsl:otherwise>
</xsl:choose>

<a>
<!-- Add a title element to the <a> tag if a description exists for this classifier -->
<xsl:if test="displayItem[@name='description']">
<xsl:attribute name='title'><xsl:value-of select="displayItem[@name='description']"/></xsl:attribute>
</xsl:if>

<!-- Add the href element to the <a> tag -->
<xsl:choose>
<xsl:when test="@name">
<xsl:attribute name="href"><xsl:value-of select="$library_name"/>/collection/<xsl:value-of select="/page/pageResponse/collection[@name=$collNameChecked]/@name"/>/browse/<xsl:value-of select="@name"/></xsl:attribute>
</xsl:when>
<xsl:otherwise>
<xsl:attribute name="href"><xsl:value-of select="$library_name"/>/collection/<xsl:value-of select="/page/pageResponse/collection[@name=$collNameChecked]/@name"/>/browse/1</xsl:attribute>
</xsl:otherwise>
</xsl:choose>

<!-- Add the actual text of the <a> tag -->
<xsl:value-of select="displayItem[@name='name']"/>
</a>
</li>
</xsl:for-each>
</xsl:template>

<xsl:template name="crossCollSearch">
<div id="search" class="repo-search">
<xsl:for-each select="/page/pageResponse/serviceList/service[@name='TextQuery']">
<form name="QuickSearch" method="get" action="{$library_name}">
<input type="hidden" name="a" value="q"/>
<input type="hidden" name="rt" value="rd"/>
<input type="hidden" name="s" value="{@name}"/>
<input type="hidden" name="s1.collection" value="all"/>
<label class="repo-search__label" for="search-text">Buscar en todo el repositorio</label>
<div class="repo-search__bar">
	<i class="fa-solid fa-magnifying-glass"><xsl:text> </xsl:text></i>
	<input type="text" name="s1.query" id="search-text" value="" placeholder="Autor, t&#237;tulo, tema o palabra clave" />
	<button type="submit" name="go" id="go"><span>Buscar</span><i class="fa-solid fa-arrow-right"><xsl:text> </xsl:text></i></button>
</div>
</form>
</xsl:for-each>
</div>
<br class="clear" />
</xsl:template>

<xsl:template name="CollectionSearch">
<div id="search">
<xsl:variable name="subaction" select="/page/pageRequest/@subaction"/>
<form action="{$library_name}/collection/{$collNameChecked}/search/TextQuery">
<!-- This parameter says that we have come from the quick search area -->
<input type="hidden" name="qs" value="1"/>
<input type="hidden" name="rt" value="rd"/>
<input type="hidden" name="s1.level">
<xsl:attribute name="value">
<xsl:choose>
<xsl:when test="/page/pageRequest/paramList/param[@name = 's1.level']">
<xsl:value-of select="/page/pageRequest/paramList/param[@name = 's1.level']/@value"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/page/pageResponse/collection/serviceList/service[@name='TextQuery']/paramList/param[@name = 'level']/@default"/>
</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
</input>
<xsl:choose>
<xsl:when test="/page/pageResponse/service[@name = 'TextQuery']/paramList/param[@name = 'startPage']">
<input type="hidden" name="s1.startPage" value="1"/>
</xsl:when>
<xsl:otherwise>
<input type="hidden" name="startPage" value="1"/>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="not(/page/pageRequest/paramList/param[@name = 's1.hitsPerPage'])">
<input type="hidden" name="s1.hitsPerPage" value="20"/>
</xsl:if>
<xsl:if test="not(/page/pageRequest/paramList/param[@name = 's1.maxDocs'])">
<input type="hidden" name="s1.maxDocs" value="100"/>
</xsl:if>
<!-- The query text box -->
<!-- Borra Ricar <span class="querybox">
<xsl:variable name="qs">
<xsl:apply-templates select="/page/pageResponse/collection[@name=$collNameChecked]/serviceList/service[@name='TextQuery']/paramList/param[@name='query']" mode="calculate-default"/>
</xsl:variable>
<nobr>
<xsl:apply-templates select="/page/pageResponse/collection[@name=$collNameChecked]/serviceList/service[@name='TextQuery']/paramList/param[@name='query']">
<xsl:with-param name="default" select="java:org.greenstone.gsdl3.util.XSLTUtil.tidyWhitespace($qs, /page/@lang)"/>
</xsl:apply-templates>
</nobr>
</span>  Hasta aca-->
<!-- The submit button (for TextQuery) -->
<!-- Borra Ricar <xsl:if test="/page/pageResponse/collection[@name=$collNameChecked]/serviceList/service[@name='TextQuery']">
<input type="submit" name="go" id="go" value="Buscar" > </input>
<br/>
</xsl:if>  Hasta aca --><span class="querybox"></span>
</form>
</div>
<br class="clear" />
<!-- Borra Ricar <div id="advanced"><a href="{$library_name}/collection/{$collNameChecked}/search/TextQuery">búsqueda avanzada</a></div> Hasta aca -->
</xsl:template>

<xsl:template name="loginLinks"></xsl:template>
		
</xsl:stylesheet>

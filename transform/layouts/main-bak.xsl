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
	</head>
	<body id="top">
		<div class="wrapper col0">
			<div id="topline">
				<!-- Ricar Saco los botones Login, Preferencias y Ayuda en layout.css, línea 52-->
				<ul>
					<xsl:call-template name="loginLinks"/>
					<li><a href="{$library_name}/collection/{$collNameChecked}/page/pref">Preferencias</a></li>
					<li><a href="{$library_name}/collection/{$collNameChecked}/page/help">Ayuda</a></li>
				</ul>
				<br class="clear" />
			</div>
		</div>
		<div class="wrapper">
			<div id="header">
				<a href="https://www.argentina.gob.ar/inti" title="Acceso Página del INTI"><img src="interfaces/{$interface_name}/images/inti-logo-65c.jpg" alt="logo INTI" /></a>
				<div class="fl_left">
					<h1><a href="{$library_name}"><xsl:call-template name="siteName"/></a></h1>
<!--					<p>&#160;
						<xsl:if test="page/pageResponse/collection">
							<a href="{$library_name}/collection/{$collNameChecked}/page/about">
								<xsl:value-of select="page/pageResponse/collection/displayItemList/displayItem[@name='name']"/>
							</a>
						</xsl:if>
					</p>-->
				</div>
			<br class="clear"/>
			</div>
		</div>
		<div class="descri"><br /><xsl:call-template name="descripcion"/></div>
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
		<xsl:when test="page/pageRequest/paramList/param/@name='c' and /page/pageResponse/collection[@name=$collNameChecked]/serviceList/service[@name='TextQuery']">
			<xsl:call-template name="CollectionSearch"/>
		</xsl:when>
		<xsl:otherwise/>
	</xsl:choose>
<!--**********************************************************************-->
			</div>
		</div>
			
		<!--<xsl:apply-templates select="/page"/>-->
		<div class="wrapper">
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
<!-- Put footer in here. -->
<!-- ******DO NOT REMOVE THE LINK TO OS TEMPLATES: Template is free to use/modify, but this link MUST remain on all pages. Do not remove Copyright information. Replace "Your Webpage Here" (and it's link) with your own information.-->
	<div class="wrapper col8" style="background-color:#DDDDDD;">
		<div id="copyright">
			<p style="font-weight:bold;float:left;">Contacto<br />Teléfono 0800 444 4004<br />Email <a href="mailto:consultas@inti.gob.ar" style="background-color:#DDDDDD">consultas@inti.gob.ar</a></p><p style="padding-left:28.3%; font-weight:bold; float:left;">Redes sociales<br />
			<a href="https://www.linkedin.com/company/inti/"><img src="interfaces/{$interface_name}/images/linkedin4.png" alt="Acceso linkedin" style="float:left;" /></a> &#160;&#160; 
			<a href="https://www.twitter.com/intiargentina/"><img src="interfaces/{$interface_name}/images/twitter4.png" alt="Acceso linkedin" style="float:left; padding-left:10px;" /></a> &#160;&#160; 
			<a href="https://www.facebook.com/INTIArg/"><img src="interfaces/{$interface_name}/images/facebook4.png" alt="Acceso linkedin" style="float:left; padding-left:10px;" /></a> &#160;&#160; 
			<a href="https://www.instagram.com/intiargentina/"><img src="interfaces/{$interface_name}/images/instagram4.png" alt="Acceso linkedin" style="float:left; padding-left:10px;"/></a> &#160;&#160; 
			<a href="https://www.youtube.com/user/canalinti/"><img src="interfaces/{$interface_name}/images/youtube4.png" alt="Acceso linkedin" style="float:left; padding-left:10px;" /></a> &#160;&#160; </p>
<!--		<p class="fl_right" style="margin-right:50px;">Hora INTI<br />02:56:44 pm</p>-->
			<br class="clear" />
		</div>
	</div>

	<div class="wrapper col8">
		<div id="copyright">
			<p class="fl_left"><img src="interfaces/{$interface_name}/images/logoMiniterio-de-produccion.png" alt="Logo Miniterio Produccion" /><!--<br /><a href="https://www.inti.gob.ar/contacto" class="contacto">Contactanos</a><a href="http://www-biblio.inti.gob.ar" class="contacto2">Biblioteca INTI</a><a href="http://www.os-templates.com/" title="Free Website Templates" target="_blank" style="text-align:right">Template by OS Templates</a>--></p>
			<br class="clear" />
		</div>
	</div>
	<div class="wrapper col8">
		<div id="copyright">
			<p><a href="https://www.inti.gob.ar/contacto" class="contacto">Contactanos</a><a href="http://www-biblio.inti.gob.ar" class="contacto2">Biblioteca INTI</a><a href="http://www.os-templates.com/" title="Free Website Templates" target="_blank" style="margin-right:40px;float:right">Template by OS Templates</a></p>
			<br class="clear" />
		</div>
	</div>
<!--	
	<div class="wrapper col8">
<br />
		<div id="copyright">
			<p class="fl_left">2022 - <a href="http://www-biblio.inti.gob.ar">Biblioteca INTI</a></p><p style="padding-left:320px;" class="fl_left"><a href="http://www-biblio.inti.gob.ar/index.php?seccion=contactos">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Contacto</a></p>
			<p class="fl_right">Template by <a href="http://www.os-templates.com/" title="Free Website Templates" target="_blank">OS Templates</a></p>
			<br class="clear" />
		</div>
	</div>
-->
</xsl:template>

<xsl:template name="navBar">
<xsl:choose>
<xsl:when test="page/pageResponse/collection">
<xsl:variable name="count" select="count(/page/pageResponse/collection/serviceList/service[@name='ClassifierBrowse']/classifierList/classifier)"/>
<xsl:variable name="currentPage" select="page/pageRequest/@fullURL"/>

<xsl:if test="/page/pageResponse/collection/serviceList/service/@type='query'">
<li><a href="{$currentPage}">Buscar</a>
<ul>
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
<li><a href="{$currentPage}">Explorar</a>
<ul>
<xsl:call-template name="Browsing"/>
</ul>
</li>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="Browsing"/>
</xsl:otherwise>
</xsl:choose>

<li><a href="{$library_name}/collection/{$collNameChecked}/page/help">Ayuda</a></li>

<li><a href="{$library_name}">Inicio</a></li>
<li>
<xsl:if test="page/pageRequest/@subaction='about'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
<a href="{$library_name}/collection/{$collNameChecked}/page/about">Acerca de</a>
</li>

</xsl:when>
<xsl:otherwise> </xsl:otherwise>
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
<div id="search">
<xsl:for-each select="/page/pageResponse/serviceList/service[@name='TextQuery']">
<form name="QuickSearch" method="get" action="{$library_name}">
<!-- <textarea name="" rows="1" cols="30">Buscar en todas las colecciones …</textarea>  --><!-- <input type="button" style="width:200px;background-color:#DDDDDD; border-color:#DDDDDD;color:#000000;font-size:14px;" value="Buscar en todas las colecciones …" />  -->
<span style="width:210px; background-color:#DDDDDD; color:#000; font-weight:500; text-align:left; font-size:14px; margin-top:-15px;">Buscar en todas las colecciones</span>
<input type="hidden" name="a" value="q"/>
<input type="hidden" name="rt" value="rd"/>
<input type="hidden" name="s" value="{@name}"/>
<input type="hidden" name="s1.collection" value="all"/>
<br /><input type="text" name="s1.query" id="search-text" value="" onfocus="this.value=(this.value=='')? '' : this.value ;" />
<!-- <input type="text" name="s1.query" id="search-text" value="Buscar en todas las colecciones …" onfocus="this.value=(this.value=='Buscar en todas las colecciones …')? '' : this.value ;" /> -->
<input type="submit" name="go" id="go" value="Buscar" /> <span style="background-color:#FFFFFF; width:65px; height:18px; border-radius:12px; padding-left:12px;"><a href="{$library_name}/page/help"> Ayuda</a></span> <!-- Ricar (Ayuda) -->
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

<xsl:template name="loginLinks">
<xsl:variable name="username" select="/page/pageRequest/userInformation/@username"/>
<xsl:variable name="groups" select="/page/pageRequest/userInformation/@groups"/>

<xsl:choose>
<xsl:when test="$username">
<xsl:if test="contains($groups,'admin')">
<li class="login"><a href="{$library_name}/admin/AddUser">Add user</a></li>
<li class="login"><a href="{$library_name}/admin/ListUsers">Administration</a></li>
</xsl:if>
<li class="login"><a href="{$library_name}/admin/AccountSettings?s1.username={$username}">Logged in as: <xsl:value-of select="$username"/></a></li>
<li class="login"><a href="{$library_name}?logout=">Logout</a></li>
</xsl:when>
<xsl:otherwise>
<li class="login">
<a href="{$library_name}?a=p&amp;sa=login&amp;redirectURL={$library_name}%3Fa=p%26sa=home">Ingreso
<xsl:attribute name="title">
<xsl:value-of select="util:getInterfaceText($interface_name, /page/@lang, 'login_tip')"/>
</xsl:attribute>
</a>
</li>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
		
</xsl:stylesheet>

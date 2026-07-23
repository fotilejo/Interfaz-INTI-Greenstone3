<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:util="xalan://org.greenstone.gsdl3.util.XSLTUtil"
	xmlns:gslib="http://www.greenstone.org/skinning"
	extension-element-prefixes="java util"
	exclude-result-prefixes="java util">

	<xsl:template name="pageTitle">Repositorio Institucional INTI</xsl:template>

	<xsl:template match="/page/pageResponse">
		<section class="home-hero">
			<div class="home-hero__content">
				<span class="home-hero__eyebrow"><i class="fa-solid fa-book-open"><xsl:text> </xsl:text></i> Acceso abierto · INTI</span>
				<h1><span class="accent-underline">Repositorio Institucional</span></h1>
				<p>Conocimiento cient&#237;fico y t&#233;cnico al servicio del desarrollo productivo. Consult&#225; publicaciones, libros, art&#237;culos y documentos de conferencias.</p>
			</div>
			<img class="home-hero__watermark" src="interfaces/{$interface_name}/images/favicon_inti.svg" alt="" />
		</section>

		<div class="section-divider" aria-hidden="true"><span><xsl:text> </xsl:text></span></div>

		<section class="collections-section" id="colecciones">
			<div class="collections-section__heading">
				<div>
					<span class="section-kicker">Explor&#225; el repositorio</span>
					<h2>Colecciones disponibles</h2>
					<p>Acced&#233; a cada colecci&#243;n para conocer su alcance, navegar sus &#237;ndices o realizar una b&#250;squeda.</p>
				</div>
			</div>
			<div id="hpage_cats" class="collections-grid">
				<xsl:call-template name="collectionsOrGroupsList"/>
			</div>
		</section>

		<section class="researcher-cta-banner">
			<div class="researcher-cta-banner__content">
				<div class="researcher-cta-banner__text">
					<h2><i class="fa-solid fa-lightbulb" aria-hidden="true"><xsl:text> </xsl:text></i> &#191;Sos investigador/a del INTI?</h2>
					<p>Compart&#237; tus art&#237;culos, libros y documentos t&#233;cnicos. Al sumarlos al Repositorio garantiz&#225;s la preservaci&#243;n digital de tu obra, multiplic&#225;s su visibilidad global y facilit&#225;s que otros profesionales citen tu trabajo.</p>
				</div>
				<div class="researcher-cta-banner__action">
					<a class="btn-primary btn-cta" href="mailto:biblio@inti.gob.ar?subject=Env%C3%ADo%20de%20publicaci%C3%B3n%20para%20el%20Repositorio%20INTI&amp;body=Hola,%20equipo%20de%20la%20Biblioteca.%0A%0AAdjunto%20mi%20publicaci%C3%B3n%20para%20que%20sea%20evaluada%20e%20ingresada%20al%20Repositorio%20Institucional.%0A%0AT%C3%ADtulo:%0AA%C3%B1o:%0AAutores:%0A%0A(No%20olvides%20adjuntar%20el%20archivo%20PDF%20o%20documento)">
						<i class="fa-regular fa-paper-plane" aria-hidden="true"><xsl:text> </xsl:text></i> Enviar mi publicaci&#243;n
					</a>
					<span class="researcher-cta-banner__email">o escrib&#237; a <strong>biblio@inti.gob.ar</strong></span>
				</div>
			</div>
		</section>
	</xsl:template>

	<xsl:template name="collectionsOrGroupsList">
		<xsl:for-each select="./collectionList/collection|groupList/group">
			<xsl:choose>
				<xsl:when test="name() = 'group'">
					<xsl:call-template name="groupCard"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="collectionCard"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="collectionCard">
		<xsl:variable name="collectionFolder" select="@name"/>
		<xsl:variable name="collectionName" select="displayItemList/displayItem[@name='name']"/>
		<xsl:variable name="collDesc" select="displayItemList/displayItem[@name='description']"/>
		<xsl:variable name="numDocs" select="metadataList/metadata[@name='numDocs']"/>
		<a class="collection-card" href="{$library_name}/collection/{$collectionFolder}/browse/CL1">
			<span class="collection-card__top">
				<span class="collection-card__icon"><i class="fa-solid fa-layer-group"><xsl:text> </xsl:text></i></span>
				<i class="collection-card__arrow fa-solid fa-arrow-up-right-from-square"><xsl:text> </xsl:text></i>
			</span>
			<h3><xsl:value-of select="$collectionName"/></h3>
			<xsl:choose>
				<xsl:when test="$collDesc">
					<p><xsl:value-of select="$collDesc" disable-output-escaping="yes"/></p>
				</xsl:when>
				<xsl:otherwise>
					<p>Esta colecci&#243;n contiene <xsl:value-of select="$numDocs"/> documentos disponibles para consulta.</p>
				</xsl:otherwise>
			</xsl:choose>
			<span class="collection-card__footer">
				<span class="collection-card__meta"><i class="fa-regular fa-folder-open"><xsl:text> </xsl:text></i> Abrir colecci&#243;n</span>
				<xsl:if test="$numDocs"><span class="collection-card__count"><i class="fa-regular fa-file-lines"><xsl:text> </xsl:text></i> <xsl:value-of select="$numDocs"/> documentos</span></xsl:if>
			</span>
		</a>
	</xsl:template>

	<xsl:template name="groupCard">
		<xsl:variable name="short"><xsl:value-of select="shortDescription"/></xsl:variable>
		<xsl:variable name="desc"><xsl:value-of select="description"/></xsl:variable>
		<xsl:variable name="group_href"><xsl:value-of select="$library_name"/>/group/<xsl:if test="/page/pageRequest/paramList/param[@name='group']"><xsl:value-of select="/page/pageRequest/paramList/param[@name='group']/@value"/>/</xsl:if><xsl:value-of select="@name"/></xsl:variable>
		<a class="collection-card group-card" href="{$group_href}" title="{$short}">
			<span class="collection-card__top">
				<span class="collection-card__icon"><i class="fa-solid fa-folder-tree"><xsl:text> </xsl:text></i></span>
				<i class="collection-card__arrow fa-solid fa-arrow-up-right-from-square"><xsl:text> </xsl:text></i>
			</span>
			<h3>
				<xsl:choose>
					<xsl:when test="boolean(title)"><xsl:value-of select="title"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
				</xsl:choose>
			</h3>
			<xsl:choose>
				<xsl:when test="$desc"><p><xsl:value-of select="$desc" disable-output-escaping="yes"/></p></xsl:when>
				<xsl:otherwise><p>Grupo tem&#225;tico de colecciones del Repositorio Institucional INTI.</p></xsl:otherwise>
			</xsl:choose>
			<span class="collection-card__meta"><i class="fa-regular fa-folder-open"><xsl:text> </xsl:text></i> Abrir grupo</span>
		</a>
	</xsl:template>

	<xsl:template name="additionalHeaderContent"><xsl:text> </xsl:text></xsl:template>
</xsl:stylesheet>

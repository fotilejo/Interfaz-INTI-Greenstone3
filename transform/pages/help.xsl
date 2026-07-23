<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gslib="http://www.greenstone.org/skinning">

	<xsl:include href="layouts/main.xsl"/>
	<xsl:template name="pageTitle">Ayuda</xsl:template>
	<xsl:template name="breadcrumbs">
		<gslib:siteLink/><gslib:rightArrow/>
		<xsl:if test="/page/pageResponse/collection"><gslib:collectionNameLinked/><gslib:rightArrow/></xsl:if>
	</xsl:template>

	<xsl:template match="page">
		<section class="help-page">
			<div class="help-page__intro">
				<span class="section-kicker">Gu&#237;a de uso</span>
				<h1>Encontr&#225; y consult&#225; publicaciones del INTI</h1>
				<p>El repositorio permite buscar en todas las colecciones o recorrer una colecci&#243;n por autor, t&#237;tulo y fecha. Esta gu&#237;a resume el recorrido m&#225;s habitual.</p>
			</div>

			<div class="help-flow">
				<article><span>1</span><i class="fa-solid fa-magnifying-glass"><xsl:text> </xsl:text></i><h2>Busc&#225;</h2><p>Ingres&#225; autores, t&#237;tulos, temas o palabras clave. Para una consulta m&#225;s precisa, us&#225; la secci&#243;n <em>Buscar</em> de cada colecci&#243;n.</p></article>
				<article><span>2</span><i class="fa-solid fa-list"><xsl:text> </xsl:text></i><h2>Explor&#225;</h2><p>Naveg&#225; por autores, t&#237;tulos o fechas. Los indicadores permiten desplegar cada grupo sin perder el contexto.</p></article>
				<article><span>3</span><i class="fa-regular fa-file-lines"><xsl:text> </xsl:text></i><h2>Consult&#225;</h2><p>Abr&#237; el registro para ver sus metadatos. Cuando exista un archivo asociado, podr&#225;s leer el PDF en una pesta&#241;a nueva.</p></article>
			</div>

			<div class="help-grid">
				<article class="help-card">
					<i class="fa-solid fa-filter-circle-dollar"><xsl:text> </xsl:text></i>
					<h2>C&#243;mo mejorar una b&#250;squeda</h2>
					<ul>
						<li>Prob&#225; primero con pocas palabras significativas.</li>
						<li>Us&#225; el apellido del autor para recuperar sus publicaciones.</li>
						<li>Ingres&#225; a una colecci&#243;n cuando quieras limitar el alcance.</li>
						<li><button type="button" class="help-boolean-trigger" aria-haspopup="dialog">Us&#225; operadores booleanos para precisar la b&#250;squeda.</button></li>
					</ul>
				</article>
				<article class="help-card">
					<i class="fa-solid fa-circle-info"><xsl:text> </xsl:text></i>
					<h2>Qu&#233; contiene un registro</h2>
					<ul>
						<li>T&#237;tulo, autor&#237;a, fecha y materias asociadas.</li>
						<li>Datos editoriales y licencia cuando est&#233;n disponibles.</li>
						<li>Acciones para abrir, compartir o guardar la referencia.</li>
					</ul>
				</article>
			</div>

			<xsl:if test="/page/pageResponse/collection">
				<section class="help-browse">
					<h2>Opciones disponibles en esta colecci&#243;n</h2>
					<div class="help-browse__chips">
						<xsl:for-each select="/page/pageResponse/collection/serviceList/service[@name='ClassifierBrowse']/classifierList/classifier">
							<span><i class="fa-solid fa-compass"><xsl:text> </xsl:text></i><xsl:value-of select="displayItem[@name='name']"/></span>
						</xsl:for-each>
					</div>
				</section>
			</xsl:if>
		</section>
	</xsl:template>
</xsl:stylesheet>

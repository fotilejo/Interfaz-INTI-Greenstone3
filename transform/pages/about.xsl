<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gslib="http://www.greenstone.org/skinning">

	<xsl:include href="layouts/main.xsl"/>
	<xsl:variable name="groupPath"><xsl:value-of select="/page/pageRequest/paramList/param[@name='group']/@value"/></xsl:variable>
	<xsl:template name="pageTitle"><gslib:collectionName/></xsl:template>

	<xsl:template name="breadcrumbs">
		<gslib:siteLink/><gslib:rightArrow/>
		<xsl:if test="$groupPath != ''">
			<xsl:for-each select="/page/pageResponse/pathList/group">
				<xsl:sort data-type="number" select="@position"/>
				<a>
					<xsl:attribute name="href"><gslib:groupHref path="{@path}"/></xsl:attribute>
					<xsl:attribute name="title"><gslib:groupName path="{@path}"/></xsl:attribute>
					<gslib:groupName path="{@path}"/>
				</a>
				<gslib:rightArrow/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/page">
		<section class="collection-about">
			<div class="collection-about__heading">
				<span class="collection-about__icon"><i class="fa-solid fa-layer-group"><xsl:text> </xsl:text></i></span>
				<div>
					<span class="section-kicker">Colecci&#243;n del repositorio</span>
					<h1><xsl:value-of select="$this-element/displayItemList/displayItem[@name='name']"/></h1>
				</div>
			</div>
			<div class="collection-about__description">
				<gslib:collectionDescriptionTextAndServicesLinks/>
			</div>
		</section>
	</xsl:template>
</xsl:stylesheet>

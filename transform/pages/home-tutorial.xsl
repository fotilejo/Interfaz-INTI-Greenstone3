<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:util="xalan://org.greenstone.gsdl3.util.XSLTUtil"
	xmlns:gslib="http://www.greenstone.org/skinning"
	extension-element-prefixes="java util"
	exclude-result-prefixes="java util">
	
<xsl:template match="/">
<html>
<head>
<meta name="keywords" content="" />
<meta name="description" content="" />
<title>Repositorio del INTI</title>
<link href="interfaces/{$interface_name}/style/themes/tutorialbliss/style.css" rel="stylesheet" type="text/css" media="screen" />
<link rel="icon" href="interfaces/{$interface_name}/style/themes/tutorialbliss/images/icon.jpg" type="image/jpg"/>
<!--
Design by Free CSS Templates
http://www.freecsstemplates.org
Released for free under a Creative Commons Attribution 2.5 License

Name       : Heavenly Bliss  
Description: A two-column, fixed-width design with dark color scheme.
Version    : 1.0
Released   : 20130517

-->
</head>
<body>
<div id="banner-wrapper">
	<div id="banner"><img src="interfaces/{$interface_name}/style/themes/tutorialbliss/images/inti.jpg" width="1000px" height="200px" alt="" /></div><!-- R cambié la imagen-->
</div>
<div id="header-wrapper">
	<div id="header">
		<div id="logo">
			<h1><a href="{$library_name}">Repositorio del INTI</a></h1>
			<p>Biblioteca digital<a href="http://www.greenstone.org/"> Greenstone</a></p>
		</div>
	</div>
</div>
<div id="wrapper"> 
	<!-- end #header -->
	<div id="page">
		<div id="page-bgtop">
			<div id="page-bgbtm">
				<div id="sidebar">
					<ul>
						<li>
							<h2><a href="?a=q&amp;rt=d&amp;s=TextQuery">Cross-Collection Search:</a></h2>
							<div id="search" >	
								<form method="get" action="#">
									<div>
										<input type="text" name="s" id="search-text" value="" />
										<input type="submit" id="search-submit" value="" />
									</div>
								</form>
						</div>
							<div style="clear: both;"></div>
						</li>
						<li>
							<h2>Library Links</h2>
							<ul>
								<li><a href="?a=p&amp;sa=login&amp;redirectURL={$library_name}%3Fa=p%26sa=home">Login</a></li>
								<li><a href="{$library_name}/admin/AccountSettings?s1.username=">Account Settings</a></li>
								<li><a href="{$library_name}/admin/AddUser">Register a new user</a></li>
								<li><a href="{$library_name}/admin/ListUsers">Administration</a></li>
								<li><a href="{$library_name}?logout=">Logout</a></li>
								<li><a href="{$library_name}/collection//page/help">Help</a></li>
								<li><a href="{$library_name}/collection//page/pref">Preferences</a></li>
							</ul>
						</li>
						<li>
							<h2>External Links</h2>
							<ul>
								<li><a href="http://www.greenstone.org">Greenstone</a></li>
								<li><a href="http://wiki.greenstone.org">Greenstone Wiki</a></li>
							</ul>
						</li>
					</ul>
				</div>
				<!-- end #sidebar -->
				<div id="content">
					<div class="post">
						<h2 class="title"><a href="#">PÃ¡gina de inicio del repositorio</a></h2>
						<div class="entry">
							<p>A new home page can be created for your Greenstone3 digital library by modifying or replacing the <span style="font-family:courier;">home.xsl</span> file found in the <i>Greenstone3/web/interfaces/otra/transform/pages</i> folder.</p>
							<p>For this homepage, we first downloaded a free CSS template from <a href="http://www.freecsstemplates.org/previews/heavenlybliss/" rel="nofollow">FreeCSSTemplates.org</a>, released under a <a href="http://creativecommons.org/licenses/by/2.5/">Creative Commons Attributions 2.5</a> license, so you're pretty much free to do whatever you want with it (even use it commercially) provided you keep the links in the footer intact.</p>
							<p>We made a few modifications to the HTML of the <span style="font-family:courier;">index.html</span> page-like removing a navigation bar at the top, changing the main photo, and removing or replacing parts of the text, as well as removing some escape characters (e.g. <i>&amp;nbsp;</i>, <i>&amp;copy;</i>), before including it in this tutorial.</p>
							<p>In the tutorial, you create your own <span style="font-family:courier;">home.xsl</span>, and <b>define</b> and <b>call</b> some XSL templates that make it possible to do many things, like include an up-to-date list of collections in your library, have a cross-collection search box, and have links that appear/disappear when you login.</p>
							<p>If you want to completely change the layout of your entire library, you probably want to define your very own interface. You can read more about interfaces in the <a href="http://www.greenstone.org/docs/greenstone3/manual.pdf">Greenstone3 manual</a>. Tutorial coming soon!</p>
						</div>
					</div>
				</div>
				<!-- end #content -->
				
				<div id="sidebar2">
					<ul>
						<li>
							<h2>Colecciones:</h2>
							<ul>
								<xsl:call-template name="collectionsList"/>
							</ul>
						</li>					
					</ul>
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
	<!-- end #page --> 
</div>
<!-- footer2 lo agregÃ³ Ricar -->
<div id="footer2">
	<p> 2020 - Repositorio del INTI |<a href="http://www-biblio.inti.gob.ar/"> Biblioteca</a>.</p>
</div>
<div id="footer">
	<p> 2013 Sitename.com. | Photo by <a href="http://www.leagoon.com/">Leagoon</a> | Design by <a href="http://www.freecsstemplates.org/" rel="nofollow">FreeCSSTemplates.org</a>.</p>
</div>
<!-- end #footer -->
</body>
</html>
</xsl:template>	

<xsl:template name="collectionsList">
<xsl:for-each select="./page/pageResponse/collectionList/collection">
<xsl:variable name="collectionName" select="@name"/>
<li>
<a href="{$library_name}/collection/{$collectionName}/page/about">
<xsl:value-of select="displayItemList/displayItem[@name='name']"/>
</a>
</li>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>

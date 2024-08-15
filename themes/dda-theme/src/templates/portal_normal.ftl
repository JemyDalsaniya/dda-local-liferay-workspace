<!DOCTYPE html>

<#include init />

<html class="${root_css_class}" dir="<@liferay.language key="lang.dir" />" lang="${w3c_language_id}">

<head>
	<title>${html_title}</title>
	<meta content="initial-scale=1.0, width=device-width" name="viewport" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
	<@liferay_util["include"] page=top_head_include />
</head>

<body class="${css_class}">
<@liferay_ui["quick-access"] contentId="#main-content" />

<@liferay_util["include"] page=body_top_include />

<div class="d-flex flex-column min-vh-100">
	<@liferay.control_menu />

	<div class="d-flex flex-column flex-fill position-relative" id="wrapper">
	<#--	<#include "${full_templates_path}/header.ftl" /> -->
		<section class="${portal_content_css_class} flex-fill" id="content">
			<#if selectable>
				<@liferay_util["include"] page=content_include />
			<#else>
				${portletDisplay.recycle()}

				${portletDisplay.setTitle(the_title)}

				<@liferay_theme["wrap-portlet"] page="portlet.ftl">
					<@liferay_util["include"] page=content_include />
				</@>
			</#if>
		</section>
	<#--	<#include "${full_templates_path}/footer.ftl" /> -->
	</div>
</div>

<@liferay_util["include"] page=body_bottom_include />

<@liferay_util["include"] page=bottom_include />

<script type="text/javascript" src=${themeDisplay.getPathThemeJavaScript()}/bootstrap.min.js></script>
<script type="text/javascript" src=${themeDisplay.getPathThemeJavaScript()}/bootstrap.bundle.min.js></script>
<script type="text/javascript" src=${themeDisplay.getPathThemeJavaScript()}/jquery-3.3.1.slim.min.js></script>

</body>

</html>

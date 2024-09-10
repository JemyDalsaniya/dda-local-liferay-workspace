<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %><%@
        taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %><%@
        taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %><%@
        taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@ page import="com.liferay.asset.kernel.model.AssetCategory" %>
<%@ page import="com.liferay.commerce.product.model.CPAttachmentFileEntry" %>
<%@ page import="com.liferay.commerce.product.model.CPDefinition" %>
<%@ page import="com.liferay.object.model.ObjectEntry" %>
<%@ page import="com.liferay.portal.kernel.exception.PortalException" %>

<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="java.io.Serializable" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.*" %>


<%@ page import="dda.marketplace.util.DdaMarketplaceUtil" %>
<%@ page import="static dda.marketplace.util.DdaMarketplaceUtil.getPrices" %>
<%@ page import="static dda.marketplace.constants.DdaMarketplacePortletKeys.*" %>
<%@ page import="java.math.BigDecimal" %>


<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<liferay-theme:defineObjects />
<portlet:defineObjects />


<%--<script type="text/javascript" src=${request.getContextPath()}/js/main.js></script>--%>

<h1>${request.getContextPath()}</h1>

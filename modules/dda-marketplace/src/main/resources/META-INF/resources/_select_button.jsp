<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.liferay.commerce.product.model.CPDefinition" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet_2_0" %>
<%@ taglib prefix="liferay-theme" uri="http://liferay.com/tld/theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<liferay-theme:defineObjects/>
<portlet:defineObjects/>

<%
    CPDefinition product = (CPDefinition) request.getAttribute("productDetails");
    boolean isLoggedIn = themeDisplay.isSignedIn();
    String loginUrl = themeDisplay.getURLSignIn();
    long productId = product.getCPDefinitionId();
    String packageType = (String) request.getAttribute("packageType");
    String subscriptionType = (String) request.getAttribute("subscriptionType");

//    String userEmailAddress = themeDisplay.getUser().getEmailAddress();
//    boolean isAxenoEmail = userEmailAddress.endsWith("@axeno.co");
%>

<% if (isLoggedIn) { %>
<a href="<portlet:renderURL>
                    <portlet:param name="jspPage" value="/checkout.jsp" />
                    <portlet:param name="productId" value="<%= String.valueOf(productId) %>" />
                    <portlet:param name="packageType" value="<%= packageType %>" />
                    <portlet:param name="subscriptionType" value="<%= subscriptionType %>" />

         </portlet:renderURL>" class="btn btn-outline-primary btn-block"><liferay-ui:message key="select"/></a><% } else { %>
<a href="<%= loginUrl %>" class="btn btn-outline-primary btn-block"><liferay-ui:message key="select"/></a>

<% } %>

<%--<% if (isLoggedIn && isAxenoEmail) { %>--%>
<%--<a href="<portlet:renderURL>--%>
<%--                    <portlet:param name="jspPage" value="/checkout.jsp" />--%>
<%--                    <portlet:param name="productId" value="<%= productId %>" />--%>
<%--                    <portlet:param name="packageType" value="<%= packageType %>" />--%>
<%--                    <portlet:param name="totalEstimatedPrice" value="<%= totalEstimatedPrice %>" />--%>
<%--                    <portlet:param name="subscriptionType" value="<%= subscriptionType %>" />--%>
<%--         </portlet:renderURL>" class="btn btn-outline-primary btn-block"><liferay-ui:message key="select"/></a>--%>
<%--<% } else if (isLoggedIn) { %>--%>
<%--<a href="<%= loginUrl %>" class="btn btn-outline-primary btn-block" style="display: none;"><liferay-ui:message key="select"/></a>--%>
<%--<% } else { %>--%>
<%--<a href="<%= loginUrl %>" class="btn btn-outline-primary btn-block"><liferay-ui:message key="select"/></a>--%>
<%--<% } %>--%>

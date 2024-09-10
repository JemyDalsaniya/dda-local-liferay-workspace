<%@ include file="/init.jsp" %>

<%
    CPDefinition product = (CPDefinition) request.getAttribute("productDetails");
    long productId = Validator.isNotNull(product) ? product.getCPDefinitionId() : 0;


    String packageType = Validator.isNotNull(request.getAttribute("packageType"))
            ? (String) request.getAttribute("packageType")
            : "";

    String subscriptionType = Validator.isNotNull(request.getAttribute("subscriptionType"))
            ? (String) request.getAttribute("subscriptionType")
            : "";

    if (productId == 0) {
        System.err.println("Product ID is not available or product object is null.");
    }

    boolean isLoggedIn = themeDisplay.isSignedIn();
    String loginUrl = themeDisplay.getPortalURL() + "/login?saveLastPath=false";
    String userEmail = isLoggedIn ? themeDisplay.getUser().getEmailAddress() : "";
    boolean isGmailUser = userEmail.equals("test@gmail.com");

%>


<% if (isLoggedIn && isGmailUser) { %>
        <a href="<portlet:renderURL>
                        <portlet:param name="jspPage" value="/checkout.jsp" />
                        <portlet:param name="productId" value="<%= String.valueOf(productId) %>"/>
                        <portlet:param name="packageType" value="<%= packageType %>" />
                        <portlet:param name="subscriptionType" value="<%= subscriptionType %>" />
             </portlet:renderURL>" class="btn btn-outline-primary btn-block"><liferay-ui:message key="select"/>
        </a>

<% } else if (!isLoggedIn) { %>
        <a href="<%= loginUrl %>" class="btn btn-outline-primary btn-block">
            <liferay-ui:message key="select"/>
        </a>
<% } %>


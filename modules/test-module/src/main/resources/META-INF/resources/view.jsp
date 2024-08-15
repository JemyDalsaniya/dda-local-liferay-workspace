<%@ include file="/init.jsp" %>

<%
	List<CPDefinition> productList = (List<CPDefinition>) request.getAttribute("productList");
	String languageId = LanguageUtil.getLanguageId(request);
%>

<div class="container-fluid">
    <div class="row">
        <!-- Product List Section -->
        <div class="col-md-12">
            <h4>Products</h4>
            <% if (productList != null && !productList.isEmpty()) { %>
            <% for (CPDefinition product : productList) { %>
            <div class="product-card">
                <div class="product-tags">
                    <% List<AssetCategory> categories = getCategoriesForProduct(product.getCPDefinitionId());
                        for (AssetCategory category : categories) { %>
                    <span class="badge badge-primary"><%= category.getName() %></span>
                    <%
                        }
                    %>
                    <% if (product.getSubscriptionType() != null) { %>
                    <span class="badge badge-secondary"><%= product.getSubscriptionType() %></span>
                    <% } %>
                </div>
                <h2 class="product-name"><%= product.getName(languageId) %>
                </h2>
                <p class="product-description"><%= product.getShortDescription(languageId) %>
                </p>
                <div class="product-price">
                    $<%= getPrice(product).setScale(2, RoundingMode.HALF_UP) %>/month
                </div>
                <div class="product-buttons">
                <a href="<portlet:renderURL>
                    <portlet:param name="jspPage" value="/productDetail.jsp" />
                    <portlet:param name="productId" value="<%= String.valueOf(product.getCPDefinitionId()) %>" />
                </portlet:renderURL>"
                       class="btn btn-outline-primary">Learn more</a>
<%--    <a href="<%= request.getContextPath() %>/productDetail.jsp?productId=<%= product.getCPDefinitionId() %>" class="btn btn-outline-primary">Learn more</a>--%>

    <a href="#" class="btn btn-primary">Buy now</a>

                </div>
            </div>
            <% } %>
            <% } else { %>
            <div class="alert alert-warning" role="alert">
                No products available.
            </div>
            <% } %>
        </div>
    </div>
</div>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
<script src="<%= request.getContextPath() %>/js/jquery-3.3.1.slim.min.js"></script>
<script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>

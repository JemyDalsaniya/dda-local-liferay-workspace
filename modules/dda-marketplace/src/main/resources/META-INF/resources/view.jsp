<%@ page import="com.liferay.commerce.product.model.CPDefinition" %>
<%@ page import="com.liferay.asset.kernel.model.AssetCategory" %>
<%@ page import="java.util.List" %>
<%@ page import="com.liferay.asset.kernel.service.AssetCategoryLocalServiceUtil" %>
<%@ page import="com.liferay.asset.kernel.model.AssetTag" %>
<%@ page import="com.liferay.asset.kernel.service.AssetTagLocalServiceUtil" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="static dda.marketplace.portlet.service.DdaMarketplaceServiceImpl.getPrice" %>
<%@ include file="/init.jsp" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%
    List<CPDefinition> productList = (List<CPDefinition>) request.getAttribute("productList");
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
                    <% for (AssetCategory category : AssetCategoryLocalServiceUtil.getCategories(CPDefinition.class.getName(), product.getCPDefinitionId())) { %>
                    <span class="badge badge-primary"><%= category.getName() %></span>
                    <% } %>
                    <%
                        if (product.getSubscriptionType() != null) {
                            String subscriptionType = product.getSubscriptionType();
                    %>
                    <span class="badge badge-secondary"><%= subscriptionType %></span>
                    <% } %>
                    <% for (AssetTag tag : AssetTagLocalServiceUtil.getTags(CPDefinition.class.getName(), product.getCPDefinitionId())) { %>
                    <span class="badge badge-dark"><%= tag.getName() %></span>
                    <% } %>
                </div>
                <h2 class="product-name"><%= product.getName() %></h2>
                <p class="product-description"><%= product.getShortDescription() %></p>
                <div class="product-price">
                    $<%= getPrice(product).setScale(2, RoundingMode.HALF_UP) %>/month
                </div>
                <div class="product-buttons">
                    <a href="<%= request.getContextPath() %>/productDetail.jsp?productId=<%= product.getCPDefinitionId() %>" class="btn btn-outline-primary">Learn more</a>
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

<style>
    .product-card {
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
        background-color: #fff;
    }

    .product-tags .badge {
        margin-right: 5px;
    }

    .product-name {
        font-size: 1.5em;
        margin: 10px 0;
    }

    .product-description {
        color: #666;
    }

    .product-price {
        font-weight: bold;
        margin: 10px 0;
    }

    .product-buttons {
        display: flex;
        justify-content: space-between;
    }
</style>

<!-- Include Bootstrap CSS and JS -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

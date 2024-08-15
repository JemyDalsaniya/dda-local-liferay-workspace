<%@ include file="/init.jsp" %>

<%
    List<CPDefinition> productList = (List<CPDefinition>) request.getAttribute("productList");
    String languageId = LanguageUtil.getLanguageId(request);
%>

<div class="container-fluid">
    <div class="row">
        <!-- Product List Section -->
        <div class="col-md-12">
            <% if (productList != null && !productList.isEmpty()) { %>
            <% for (CPDefinition product : productList) { %>
            <div class="product-card">
                <div class="product-tags">
                    <%
                        Map<String, List<String>> productCategories = DdaMarketplaceUtil.getProductCategories(product.getCPDefinitionId());
                    %>

                    <% if (Validator.isNotNull(productCategories) && !productCategories.isEmpty()) { %>
                    <% for (Map.Entry<String, List<String>> entry : productCategories.entrySet()) { %>
                    <div class="vocabulary-group">
                        <span class="badge badge-primary"><%= String.join(", ", entry.getValue()) %></span>
                    </div>
                    <% } %>
                    <% } %>
                </div>
                <h2 class="product-name"><%= product.getName(languageId) %>
                </h2>
                <p class="product-description"><%= product.getShortDescription(languageId) %>
                </p>
                <% getPrices(product,renderRequest);
                    Map<String, BigDecimal> priceMap = (Map<String, BigDecimal>) renderRequest.getAttribute("priceMap");
                    BigDecimal bronzeYearlyPrice = priceMap != null ? priceMap.getOrDefault("bronzeYearlyPrice", BigDecimal.ZERO) : BigDecimal.ZERO;
                    BigDecimal bronzeMonthlyPrice = priceMap != null ? priceMap.getOrDefault("bronzeMonthlyPrice", BigDecimal.ZERO) : BigDecimal.ZERO;
                %>
                <div class="product-price">
                    <b>$<%= bronzeMonthlyPrice.setScale(2, RoundingMode.HALF_UP) %><liferay-ui:message key="per-month" /></b> <liferay-ui:message key="or" /> <%= bronzeYearlyPrice.setScale(2, RoundingMode.HALF_UP)%> <liferay-ui:message key="yearly" />
                </div>
                <div class="product-buttons">
                <a href="<portlet:renderURL>
                    <portlet:param name="jspPage" value="/productDetail.jsp" />
                    <portlet:param name="productId" value="<%= String.valueOf(product.getCPDefinitionId()) %>" />
                </portlet:renderURL>"
                       class="btn btn-outline-primary"><liferay-ui:message key="learn-more" /></a>
                    <%--    <a href="<%= request.getContextPath() %>/productDetail.jsp?productId=<%= product.getCPDefinitionId() %>" class="btn btn-outline-primary">Learn more</a>--%>

                    <a href="#" class="btn btn-primary"><liferay-ui:message key="buy-now" /></a>

                </div>
            </div>
            <% } %>
            <% } else { %>
            <div class="alert alert-warning" role="alert">
                <liferay-ui:message key="no-products-were-found" />
            </div>
            <% } %>
        </div>
    </div>
</div>


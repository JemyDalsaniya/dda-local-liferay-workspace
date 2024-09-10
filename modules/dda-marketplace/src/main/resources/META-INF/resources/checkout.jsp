<%@ include file="/init.jsp" %>

<%
    CPDefinition product = null;
    if (Validator.isNotNull(request.getAttribute("productDetails"))){
         product = (CPDefinition) request.getAttribute("productDetails");
    }

    long productId = 0;
    if (Validator.isNotNull(product)) {
        productId = product.getCPDefinitionId();
    }

    String subscriptionType = ParamUtil.getString(request, "subscriptionType", "bronze");
    String packageType = ParamUtil.getString(request, "packageType", "monthly");

    String productThumbnailImageURL = (String) request.getAttribute("productThumbnailImageURL");

    boolean hasMonthly = false;
    boolean hasYearly = false;
    if (Validator.isNotNull(request.getAttribute("hasMonthlySubscription"))) {
        hasMonthly = (boolean) request.getAttribute("hasMonthlySubscription");
    }
    if (Validator.isNotNull(request.getAttribute("hasYearlySubscription"))) {
        hasYearly = (boolean) request.getAttribute("hasYearlySubscription");
    }

    Map<String, List<String>> productCategories = null;
    List<String> packageTypes = null;
    if (Validator.isNotNull(product)) {
        productCategories = DdaMarketplaceUtil.getProductCategories(product.getCPDefinitionId(), themeDisplay.getLocale());
        packageTypes = productCategories.get(SUBSCRIPTION_TYPE_VOCABULARY);
    }

    boolean disableSubscriptionType = IS_PAY_AS_YOU_GO.equalsIgnoreCase(packageType) || IS_ONE_TIME_PAYMENT.equalsIgnoreCase(packageType);

    List<Map<String, Object>> attachmentDetailsList = null;
    if (Validator.isNotNull(request.getAttribute("fileAttachments"))) {
        attachmentDetailsList = (List<Map<String, Object>>) request.getAttribute("fileAttachments");
    }

    Boolean isOrderCreated = null;
    if (Validator.isNotNull(request.getAttribute("isOrderCreated"))) {
        isOrderCreated = (Boolean) request.getAttribute("isOrderCreated");
    }
%>

<%
    // Checking if product and related data are null or empty
    if (Validator.isNull(product)) {
%>
<div class="alert alert-warning">
    <liferay-ui:message key="no-data-available"/>
</div>
<%
} else { %>
<div class="checkout-main">   
    <div class="container-fluid  mt-5">
        <h2 ><liferay-ui:message key="check-out" /></h2>

    <div class="product-summary">
            <div class="product-img">
                <c:if test="<%= Validator.isNotNull(productThumbnailImageURL) %>">
                    <img src="<%= productThumbnailImageURL %>" alt="Thumbnail" class="img-fluid"
                         style="width: 50px; height: 50px;"/>
                </c:if>
            </div>
            <div class="product-tilte">
		    <h3><%= product.getName(String.valueOf(themeDisplay.getLocale())) %></h3>
		    <p><%= product.getShortDescription(String.valueOf(themeDisplay.getLocale())) %></p>
            </div>
    </div>

        <div class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <label for="subscriptionType"><liferay-ui:message key="subscription-type" /></label>
                    <select id="subscriptionType" name="subscriptionType" class="form-control" <%= disableSubscriptionType ? "disabled" : "" %>>
                        <option value="bronze" <%= "bronze".equals(subscriptionType) ? "selected" : "" %>><liferay-ui:message key="bronze" /></option>
                        <option value="silver" <%= "silver".equals(subscriptionType) ? "selected" : "" %>><liferay-ui:message key="silver" /></option>
                        <option value="gold" <%= "gold".equals(subscriptionType) ? "selected" : "" %>><liferay-ui:message key="gold" /></option>
                    </select>
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <label for="package"><liferay-ui:message key="package" /></label>
                    <select id="package" name="package" class="form-control">
                        <% if (packageTypes != null) {
                            for (String type : packageTypes) {
                                if ((type.equalsIgnoreCase(IS_MONTHLY) && hasMonthly) || (type.equalsIgnoreCase(IS_YEARLY) && hasYearly)) {
                        %>
                        <option value="<%= type.toLowerCase() %>" <%= type.equalsIgnoreCase(packageType) ? "selected" : "" %>><liferay-ui:message key="<%= type.toLowerCase() %>" /></option>
                        <% } } } %>
                        <option value="pay-as-you-go" <%= IS_PAY_AS_YOU_GO.equalsIgnoreCase(packageType) ? "selected" : "" %>>
                            <liferay-ui:message key="pay-as-you-go" />
                        </option>
                        <option value="one-time-payment" <%= IS_ONE_TIME_PAYMENT.equalsIgnoreCase(packageType) ? "selected" : "" %>>
                            <liferay-ui:message key="one-time-payment" />
                        </option>
                    </select>
                </div>
            </div>
        </div>


    <div class="terms-conditions mb-4">
        <div class="form-check">
            <input type="checkbox" class="form-check-input" id="agreeTerms" required>
            <label class="form-check-label" for="agreeTerms">
                <liferay-ui:message key="i-agree-to-the" />
                <a href="#"><liferay-ui:message key="terms-and-conditions-policy" /></a>
            </label>
        </div>
    </div>

        <div class="disclaimer">
            <h4><liferay-ui:message key="disclaimer" /></h4>
            <p><liferay-ui:message key="checkout-disclaimer-text" /></p>
        </div>

        <% if (attachmentDetailsList != null && !attachmentDetailsList.isEmpty()) { %>
        <div class="documentation-main">
            <h3><liferay-ui:message key="documentation" /></h3>
            <div class="row">
                <% for (Map<String, Object> attachmentDetails : attachmentDetailsList) { %>
                <% if ((Boolean) attachmentDetails.get("hasTagName"))  { %>
                <div class="col-md-4 mb-3">
                    <div class=" doc-card ">
                        <div class="card-body p-0">
                                <div class="doc-icon">
                                    <img src="<%= attachmentDetails.get("fileIconURL") %>" alt="PDF" style="width: 20px; height: 20px;"/>
                                </div>
                                <div class="doc-content">
                                    <h5 class="doc-title">
                                        <a target="_blank" href="<%= attachmentDetails.get("previewURL") %>" class="card-link mr-2">
                                            <%= attachmentDetails.get("fileName") %>
                                        </a>
                                    </h5>
                                    <div class="doc-file-info">
                                    <small><%= attachmentDetails.get("year") %></small>
                                    <div>
                                    <small class=""><%= attachmentDetails.get("fileSize") %> KB</small>
                                    </div>
                                </div>
                                </div>
                                
                        </div>
                    </div>
                </div>
                <% } %>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <p><liferay-ui:message key="no-attachments-were-found" /></p>
        <% } %>

        <div class="pricing-summary">
            <p><liferay-ui:message key="total-estimated-price" /></p>
            <h5 class="price h2 mb-3" id="priceDisplay"> <liferay-ui:message key="aed" /></h5>
        </div>


    <portlet:actionURL name="createOrder" var="createOrderURL">
        <portlet:param name="productId" value="<%= String.valueOf(product.getCPDefinitionId()) %>" />
    </portlet:actionURL>

        <div class="action-buttons d-flex justify-content-end">
            <button class="btn btn-secondary mr-2"><liferay-ui:message key="cancel" /></button>
            <% if (themeDisplay.isSignedIn()) { %>
            <a href="#" class="btn btn-primary common-btn" id="buyButton"><liferay-ui:message key="buy" /></a>
            <% } else { %>
            <a href="<%=  themeDisplay.getURLSignIn() %>" class="btn btn-primary common-btn" id="buyButton"><liferay-ui:message key="buy" /></a>
            <% } %>
        </div>

    <!-- Modal -->
    <div class="modal fade product-modal" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
            <% if (Validator.isNotNull(isOrderCreated)) { %>
            <div class="modal-content">
                <div class="modal-body text-center">
                    <% if (isOrderCreated) { %>
                    <div class="text-success mb-4">
                        <i class="fas fa-check-circle fa-5x"></i>
                    </div>
                    <h5 class="modal-title" id="resultModalLabel"><liferay-ui:message key="order-success-message" /></h5>
                    <p><b><liferay-ui:message key="disclaimer" /></b></p>
                    <p>
                        <liferay-ui:message key="order-success-disclaimer"/>
                    </p>
                    <% } else { %>
                    <div class="text-danger mb-4">
                        <i class="fas fa-times-circle fa-5x"></i>
                    </div>
                    <h5 class="modal-title" id="resultModalLabel"><liferay-ui:message key="order-failure-message" /></h5>
                    <p><liferay-ui:message key="reason" /></p>
                    <p>
                        <liferay-ui:message key="order-failure-reason"/>
                    </p>
                    <% } %>
                </div>
                <div class="modal-footer justify-content-center">
                    <% if (isOrderCreated) { %>
                    <a href="<%=themeDisplay.getPortalURL()%>/products" class="btn btn-secondary close-model"><liferay-ui:message key="close" /></a>
                    <a href="<%= themeDisplay.getPortalURL() + ORDER_HISTORY_TAB_USER_PROFILE %>" class="btn btn-primary common-btn close-model"><liferay-ui:message key="go-to-order-history" /></a>
                    <% } else { %>
                    <a href="<%=themeDisplay.getPortalURL()%>/products" class="btn btn-secondary close-model"><liferay-ui:message key="cancel" /></a>
                    <button type="button" class="btn btn-primary common-btn close-model" id="tryAgainButton"><liferay-ui:message key="try-again" /></button>
                    <% } %>
                </div>
            </div>
            <% } else {%>
            <% } %>
        </div>
    </div>


        <input type="hidden" id="productId" value="<%= productId %>" />
    </div>
</div> 

<div id="priceUrl" data-url="<%= renderResponse.createResourceURL().toString() %>"></div>
<div id="namespace" data-value="<portlet:namespace />"></div>
<div id="aedMessage" data-value="<liferay-ui:message key="aed" />"></div>
<div id="createOrderUrl" data-url="<%= createOrderURL %>"></div>
<% if(Validator.isNotNull(isOrderCreated)) { %>
    <div id="modal-content-data" data-value="<%= isOrderCreated %>"></div>
<% } %>
<% } %>



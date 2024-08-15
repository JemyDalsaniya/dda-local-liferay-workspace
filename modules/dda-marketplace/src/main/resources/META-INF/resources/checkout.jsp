<%@ page import="static dda.marketplace.constants.DdaMarketplacePortletKeys.SUBSCRIPTION_TYPE_VOCABULARY" %>
<%@ include file="/init.jsp" %>

<%
    CPDefinition product = (CPDefinition) request.getAttribute("productDetails");
    long productId = product.getCPDefinitionId();
    String subscriptionType = ParamUtil.getString(request, "subscriptionType", "bronze");
    String packageType = ParamUtil.getString(request, "packageType", "monthly");
    System.out.println("subscriptionType:" + subscriptionType + "packageType:" + packageType);
    boolean hasMonthly = (boolean) request.getAttribute("hasMonthlySubscription");
    boolean hasYearly = (boolean) request.getAttribute("hasYearlySubscription");
    Map<String, List<String>> productCategories = DdaMarketplaceUtil.getProductCategories(product.getCPDefinitionId());
    List<String> packageTypes = productCategories.get(SUBSCRIPTION_TYPE_VOCABULARY);
    System.out.println("package types:  "+ packageTypes);
    boolean disableSubscriptionType = "payAsYouGo".equalsIgnoreCase(packageType) || "oneTimePayment".equalsIgnoreCase(packageType);
    List<Map<String, Object>> attachmentDetailsList = (List<Map<String, Object>>) request.getAttribute("fileAttachments");

    Boolean isOrderCreated = (Boolean) request.getAttribute("isOrderCreated");


%>

<!-- Hidden field to store product ID -->
<div class="container checkout-container mt-5">
    <h1 class="mb-4"><liferay-ui:message key="check-out" /></h1>

    <div class="product-summary mb-4">
        <h2 class="font-weight-bold"><%= product.getName(String.valueOf(themeDisplay.getLocale())) %></h2>
        <p class="text-muted"><%= product.getShortDescription(String.valueOf(themeDisplay.getLocale())) %></p>
    </div>

    <div class="row mb-4">
        <div class="col-md-6">
            <div class="form-group">
                <label for="subscriptionType"><liferay-ui:message key="subscription-type" /></label>
                <select id="subscriptionType" name="subscriptionType" class="form-control" <%= disableSubscriptionType ? "disabled" : "" %>>
                    <option value="bronze" <%= "bronze".equals(subscriptionType) ? "selected" : "" %>><liferay-ui:message key="bronze" /></option>
                    <option value="silver" <%= "silver".equals(subscriptionType) ? "selected" : "" %>><liferay-ui:message key="silver" /></option>
                    <option value="gold" <%= "gold".equals(subscriptionType) ? "selected" : "" %>><liferay-ui:message key="gold" /></option>
                </select>
            </div>
        </div>
        <div class="col-md-6">
            <div class="form-group">
                <label for="package"><liferay-ui:message key="package" /></label>
                <select id="package" name="package" class="form-control">
                    <% if (packageTypes != null) {
                        for (String type : packageTypes) {
                            if ((type.equalsIgnoreCase("Monthly") && hasMonthly) || (type.equalsIgnoreCase("Yearly") && hasYearly)) {
                    %>
                    <option value="<%= type.toLowerCase() %>" <%= type.equalsIgnoreCase(packageType) ? "selected" : "" %>><liferay-ui:message key="<%= type.toLowerCase() %>" /></option>
                    <% } } } %>
                    <option value="pay-as-you-go" <%= "pay-as-you-go".equalsIgnoreCase(packageType) ? "selected" : "" %>>
                        <liferay-ui:message key="pay-as-you-go" />
                    </option>
                    <option value="one-time-payment" <%= "one-time-payment".equalsIgnoreCase(packageType) ? "selected" : "" %>>
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
                <a href="#"><liferay-ui:message key="terms-and-conditions" /></a>,
                <a href="#"><liferay-ui:message key="privacy-policy" /></a> &
                <a href="#"><liferay-ui:message key="ims-policy" /></a>
            </label>
        </div>
    </div>

    <div class="disclaimer mb-4">
        <p class="text-muted"><liferay-ui:message key="checkout-disclaimer-text" /></p>
    </div>

    <% if (attachmentDetailsList != null && !attachmentDetailsList.isEmpty()) { %>
    <div class="container">
        <h3><liferay-ui:message key="documentation" /></h3>
        <div class="row">
            <% for (Map<String, Object> attachmentDetails : attachmentDetailsList) { %>
            <% if ((Boolean) attachmentDetails.get("hasTagName"))  { %>
            <div class="col-md-4 mb-3">
                <div class="card border rounded shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="card-title mb-0">
                                <a target="_blank" href="<%= attachmentDetails.get("previewURL") %>" class="card-link mr-2">
                                    <%= attachmentDetails.get("fileName") %>
                                </a>
                            </h5>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small><%= attachmentDetails.get("year") %></small>
                            <small><%= attachmentDetails.get("fileSize") %> KB</small>
                            <img src="<%= attachmentDetails.get("fileIconURL") %>" alt="PDF" style="width: 20px; height: 20px;"/>
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

    <div class="pricing-summary mb-4">
        <h5 class="font-weight-bold"><liferay-ui:message key="total-estimated-price" /></h5>
        <p class="price h2" id="priceDisplay"> <liferay-ui:message key="aed" /></p>
        <%--        <p class="price h2" id="priceDisplay"><%= price %> <liferay-ui:message key="aed" /></p>--%>
    </div>


   <%-- <div class="action-buttons d-flex justify-content-end">
        <button class="btn btn-secondary mr-2"><liferay-ui:message key="cancel" /></button>
        &lt;%&ndash;        <button class="btn btn-primary" id="buyButton" disabled><liferay-ui:message key="buy" /></button>&ndash;%&gt;
        <% if (themeDisplay.isSignedIn()) { %>
        <a href="<portlet:actionURL name='createOrder'>
                    <portlet:param name="productId" value="<%= String.valueOf(product.getCPDefinitionId()) %>" />
                    <portlet:param name="subscriptionType" value="<%= subscriptionType %>" />
&lt;%&ndash;                    <portlet:param name="totalEstimatedPrice" value="<%= String.valueOf(price) %>" />&ndash;%&gt;
                    <portlet:param name="packageType" value="<%= packageType %>" />
         </portlet:actionURL>" class="btn btn-primary" id="buyButton"><liferay-ui:message key="buy" /></a>
        <% } else { %>
        <a href="<%=  themeDisplay.getURLSignIn() %>" class="btn btn-primary" id="buyButton"><liferay-ui:message key="buy" /></a>
        <% } %>
    </div>--%>

    <div class="action-buttons d-flex justify-content-end">
        <button class="btn btn-secondary mr-2"><liferay-ui:message key="cancel" /></button>
        <% if (themeDisplay.isSignedIn()) { %>
        <a href="#" class="btn btn-primary" id="buyButton"><liferay-ui:message key="buy" /></a>
        <% } else { %>
        <a href="<%=  themeDisplay.getURLSignIn() %>" class="btn btn-primary" id="buyButton"><liferay-ui:message key="buy" /></a>
        <% } %>
    </div>

    <portlet:actionURL name="createOrder" var="createOrderURL">
        <portlet:param name="productId" value="<%= String.valueOf(product.getCPDefinitionId()) %>" />
    </portlet:actionURL>

</div>
<input type="hidden" id="productId" value="<%= productId %>" />

<!-- Modal -->
<div class="modal fade" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <% if (Validator.isNotNull(isOrderCreated)) { %>
        <div class="modal-content">
            <div class="modal-body text-center">
                <% if (isOrderCreated) { %>
                <div class="text-success mb-4">
                    <i class="fas fa-check-circle fa-5x"></i>
                </div>
                <h5 class="modal-title" id="resultModalLabel">You have successfully subscribed to this data product</h5>
                <p class="text-muted">
                    Disclaimer: Your offering includes a free 15-day trial. On beyond expiry date, it automatically
                    switches to annual billing.
                </p>
                <% } else { %>
                <div class="text-danger mb-4">
                    <i class="fas fa-times-circle fa-5x"></i>
                </div>
                <h5 class="modal-title" id="resultModalLabel">Subscription Unsuccessful: Please Try Again</h5>
                <p class="text-muted">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore
                    et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.
                </p>
                <% } %>
            </div>
            <div class="modal-footer justify-content-center">
                <% if (isOrderCreated) { %>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Go to Order History</button>
                <% } else { %>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary">Try again</button>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
</div>
<!-- Add this to the <head> section -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">

<!-- Add these just before the closing </body> tag -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        console.log("Start")
        $('#resultModal').modal('show');
    });
</script>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script>
    (function() {
        let isFirstLoad = true;

        function initializeEventListeners() {
            var subscriptionTypeElement = document.getElementById('subscriptionType');
            var packageElement = document.getElementById('package');

            if (subscriptionTypeElement && packageElement) {
                subscriptionTypeElement.addEventListener('change', handleChange);
                packageElement.addEventListener('change', handleChange);
                updatePrice(); // Call updatePrice manually once to set the initial price
            } else {
                console.error('Required elements not found');
            }
        }

        function handleChange() {
            isFirstLoad = false;
            updatePrice();
        }

        function updatePrice() {
            let sku;
            const subscriptionTypeElement = document.getElementById('subscriptionType');
            const packageTypeElement = document.getElementById('package');
            const productId = document.getElementById('productId').value;

            const packageType = packageTypeElement.value;

            // Check if the selected package type is "pay-as-you-go" or "one-time-payment"
            console.log("Package type:", packageType);
            console.log("Is pay-as-you-go:", packageType === "pay-as-you-go");
            console.log("Is one-time-payment:", packageType === "one-time-payment");
            console.log("condition: " + (packageType === "pay-as-you-go" || packageType === "one-time-payment"));
            if (packageType === "pay-as-you-go" || packageType === "one-time-payment") {
                // Disable the subscription type dropdown
                subscriptionTypeElement.disabled = true;
                // Only use package type in SKU
                sku = packageType;
            } else {
                // Enable the subscription type dropdown if it's not one of the special cases
                subscriptionTypeElement.disabled = false;
                const subscriptionType = subscriptionTypeElement.value;
                // Combine subscription type and package type for the SKU
                sku = subscriptionType + "-" + packageType;
            }

            // Construct the full URL with namespaced parameters
            var fullURL = '<%= renderResponse.createResourceURL().toString() %>&<portlet:namespace />sku=' + encodeURIComponent(sku) + '&<portlet:namespace />productId=' + encodeURIComponent(productId);

            // Make an AJAX request to get the price based on the SKU and product
            fetch(fullURL)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.statusText);
                    }
                    return response.text();
                })
                .then(text => {
                    console.log("Raw response:", text);
                    return JSON.parse(text);
                })
                .then(data => {
                    console.log("Parsed data:", data);
                    // Update the price display on the page
                    if (data.price) {
                        document.getElementById('priceDisplay').innerHTML = data.price + ' <liferay-ui:message key="aed" />';
                    } else {
                        console.error("Price data not found in response");
                    }
                })
                .catch(error => {
                    console.error('Error fetching price:', error);
                    console.error('Error details:', error.message);
                });
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeEventListeners);
        } else {
            initializeEventListeners();
        }
    })();
</script>
<script>
    AUI().use('aui-base', function(A) {
        var buyButton = A.one('#buyButton');
        var subscriptionTypeSelect = A.one('#subscriptionType');
        var packageSelect = A.one('#package');
        var createOrderURL = '<%= createOrderURL %>';

        function updateBuyButtonURL() {
            if (buyButton) {
                var subscriptionType = subscriptionTypeSelect.get('value');
                var packageType = packageSelect.get('value');

                var updatedURL = createOrderURL +
                    '&<portlet:namespace />subscriptionType=' + encodeURIComponent(subscriptionType) +
                    '&<portlet:namespace />packageType=' + encodeURIComponent(packageType);

                buyButton.setAttribute('href', updatedURL);
            }
        }

        if (subscriptionTypeSelect) {
            subscriptionTypeSelect.on('change', updateBuyButtonURL);
        }

        if (packageSelect) {
            packageSelect.on('change', updateBuyButtonURL);
        }

        // Initial update
        updateBuyButtonURL();
    });
</script>

<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        var agreeTermsCheckbox = document.getElementById('agreeTerms');
        var buyButton = document.getElementById('buyButton');

        agreeTermsCheckbox.addEventListener('change', function () {
            buyButton.disabled = !agreeTermsCheckbox.checked;
        });
    });

</script>


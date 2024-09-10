<%@ include file="/init.jsp" %>

<%
    // Section: Fetching Data from Request Attributes
    long accountId = 0;
    CPAttachmentFileEntry productImage = null;
    CPDefinition product = null;
    List<CPDefinition> relatedProductsList = null;
    Map<String, Object> relatedObjects = null;
    Map<String, BigDecimal> priceMap = null;
    boolean hasMonthly = false;
    boolean hasYearly = false;
    String languageId = LanguageUtil.getLanguageId(request);

    // Check and assign attributes using Validator to avoid null pointer exceptions
    if (Validator.isNotNull(request.getAttribute("accountId"))) {
        accountId = (Long) request.getAttribute("accountId");
    }
    if (Validator.isNotNull(request.getAttribute("productImage"))) {
        productImage = (CPAttachmentFileEntry) request.getAttribute("productImage");
    }

    String productThumbnailImageURL = (String) request.getAttribute("productThumbnailImageURL");

    if (Validator.isNotNull(request.getAttribute("productDetails"))) {
        product = (CPDefinition) request.getAttribute("productDetails");
        getPrices(product, renderRequest);
    }
    if (Validator.isNotNull(request.getAttribute("relatedProducts"))) {
        relatedProductsList = (List<CPDefinition>) request.getAttribute("relatedProducts");
    }
    if (Validator.isNotNull(request.getAttribute("relatedObjects"))) {
        relatedObjects = (Map<String, Object>) request.getAttribute("relatedObjects");
    }
    if (Validator.isNotNull(renderRequest.getAttribute("priceMap"))) {
        priceMap = (Map<String, BigDecimal>) renderRequest.getAttribute("priceMap");
    }
    if (Validator.isNotNull(request.getAttribute("hasMonthlySubscription"))) {
        hasMonthly = (boolean) request.getAttribute("hasMonthlySubscription");
    }
    if (Validator.isNotNull(request.getAttribute("hasYearlySubscription"))) {
        hasYearly = (boolean) request.getAttribute("hasYearlySubscription");
    }

    // Section: Handling Price Data
    BigDecimal bronzeMonthlyPrice = Validator.isNotNull(priceMap) ? priceMap.getOrDefault("bronzeMonthlyPrice", BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal silverMonthlyPrice = Validator.isNotNull(priceMap) ? priceMap.getOrDefault("silverMonthlyPrice", BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal goldMonthlyPrice = Validator.isNotNull(priceMap) ? priceMap.getOrDefault("goldMonthlyPrice", BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal bronzeYearlyPrice = Validator.isNotNull(priceMap) ? priceMap.getOrDefault("bronzeYearlyPrice", BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal silverYearlyPrice = Validator.isNotNull(priceMap) ? priceMap.getOrDefault("silverYearlyPrice", BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal goldYearlyPrice = Validator.isNotNull(priceMap) ? priceMap.getOrDefault("goldYearlyPrice", BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal payAsYouGo = Validator.isNotNull(priceMap) ? priceMap.getOrDefault("payAsYouGo", BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal oneTimePayment = Validator.isNotNull(priceMap) ? priceMap.getOrDefault("oneTimePayment", BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;

    // Section: Other Variables
    List<Map<String, Object>> attachmentDetailsList = Validator.isNotNull(request.getAttribute("fileAttachments")) ? (List<Map<String, Object>>) request.getAttribute("fileAttachments") : null;
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
<!-- Section: Product Overview -->
<div class="Product-detail-main">
    <div class="container-fluid">
        <div class="product-header">
            <div class="product-left-header">
                <div class="d-flex align-items-center">
                    <div class="mr-3 product-icon">
                        <c:if test="<%= Validator.isNotNull(productThumbnailImageURL) %>">
                            <img src="<%= productThumbnailImageURL %>" alt="Thumbnail" class="img-fluid"
                                 style="width: 50px; height: 50px;"/>
                        </c:if>
                    </div>
                    <div>
                        <h2><%= product.getName(languageId) %>
                        </h2>
                        <p><%= product.getShortDescription(languageId) %>
                        </p>
                    </div>
                </div>
            </div>
            <!-- Button to trigger the modal -->
            <div class="product-right">
                <a href="#" class="btn btn-primary common-btn" data-toggle="modal" data-target="#productPreviewModal">
                    <liferay-ui:message key="preview-sample"/>
                </a>
            </div>

            <!-- Modal Structure -->
            <div class="modal fade product-modal" id="productPreviewModal" tabindex="-1" role="dialog"
                 aria-labelledby="productPreviewModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="productPreviewModalLabel">Analytics Pro</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <!-- Content related to "Analytics Pro" goes here -->
                            <p><liferay-ui:message key="preview-sample-content"/></p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
      <div class="product-overview-content">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h3><liferay-ui:message key="product-overview"/></h3>
                <%=product.getDescription(languageId)%>
            </div>
            <div class="col-md-4 text-center">
                <div class="product-img">
                <%
                    // Section: Product Main Image
                    String imageURL;
                    if (Validator.isNotNull(productImage)) {
                        imageURL = "/o/commerce-media/accounts/" + accountId + "/images/" + productImage.getCPAttachmentFileEntryId() + "?download=false";
                    }
                    else {
                        imageURL = productThumbnailImageURL;
                    }
                %>
                <c:if test="<%=Validator.isNotNull(imageURL) %>">
                    <img src="<%= imageURL %>" alt="Product Image" class="img-fluid"
                         style="max-width: 100%; height: auto;">
                </c:if>
            </div>
            </div>
        </div>
      </div>
       
    </div>

    <!-- Section: Subscription Types -->
    <div class="subscription-type">
        <div class="container-fluid">
            <h3><liferay-ui:message key="payment-options"/></h3>

            <ul class="nav nav-tabs tabs " id="subscriptionTabs" role="tablist">
                <c:if test="<%= hasMonthly %>">
                    <!-- Section: Monthly Subscription Tab -->
                    <li class="nav-item tab-button" role="presentation">
                        <a class="nav-link active" id="monthly-tab" data-toggle="tab" href="#monthly"
                           role="tab"><liferay-ui:message key="monthly"/></a>
                    </li>
                </c:if>
                <c:if test="<%= hasYearly %>">
                    <!-- Section: Yearly Subscription Tab -->
                    <li class="nav-item tab-button" role="presentation">
                        <a class="nav-link <%= !hasMonthly ? "active" : "" %>" id="yearly-tab" data-toggle="tab"
                           href="#yearly" role="tab"><liferay-ui:message key="yearly"/></a>
                    </li>
                </c:if>
                <!-- Section: Pay as You Go Subscription Tab -->
                <li class="nav-item tab-button" role="presentation">
                    <a class="nav-link <%= !hasMonthly && !hasYearly ? "active" : "" %>" id="payg-tab" data-toggle="tab"
                       href="#payg" role="tab"><liferay-ui:message key="pay-as-you-go"/></a>
                </li>
                <!-- Section: One Time Payment Tab -->
                <li class="nav-item tab-button" role="presentation">
                    <a class="nav-link" id="otp-tab" data-toggle="tab" href="#otp" role="tab" aria-controls="otp"
                       aria-selected="false"><liferay-ui:message key="one-time-payment"/></a>
                </li>
            </ul>

            <div class="tab-content" id="subscriptionTabContent">
                <c:if test="<%= hasMonthly %>">
                    <!-- Section: Monthly Subscription Content -->
                    <div class="tab-pane fade show active" id="monthly" role="tabpanel">
                        <div class="row">
                            <!-- Bronze Monthly Plan -->

                            <div class="subscription-card">
                                <h5><liferay-ui:message key="bronze"/></h5>
                                <ul class="feature-list">
                                    <li><liferay-ui:message key="subscription-monthly-bronze-line-1"/></li>
                                    <li><liferay-ui:message key="subscription-monthly-bronze-line-2"/></li>
                                    <li><liferay-ui:message key="subscription-monthly-bronze-line-3"/></li>
                                </ul>
                                <h4 class="price"><%= bronzeMonthlyPrice %> <liferay-ui:message key="aed"/></h4>
                                <%
                                    request.setAttribute("subscriptionType", "bronze");
                                    request.setAttribute("packageType", "monthly");
                                %>
                                <jsp:include page="_select_button.jsp"/>
                            </div>

                            <!-- Silver Monthly Plan -->

                            <div class="subscription-card bg-light">
                                <h5><liferay-ui:message key="silver"/></h5>
                                <ul class="feature-list">
                                    <li><liferay-ui:message key="subscription-monthly-silver-line-1"/></li>
                                    <li><liferay-ui:message key="subscription-monthly-silver-line-2"/></li>
                                    <li><liferay-ui:message key="subscription-monthly-silver-line-3"/></li>
                                </ul>
                                <h4 class="price"><%= silverMonthlyPrice%> <liferay-ui:message key="aed"/></h4>
                                <%
                                    request.setAttribute("subscriptionType", "silver");
                                    request.setAttribute("packageType", "monthly");
                                %>
                                <jsp:include page="_select_button.jsp"/>
                            </div>

                            <!-- Gold Monthly Plan -->

                            <div class="subscription-card">
                                <h5><liferay-ui:message key="gold"/></h5>
                                <ul class="feature-list">
                                    <li><liferay-ui:message key="subscription-monthly-gold-line-1"/></li>
                                    <li><liferay-ui:message key="subscription-monthly-gold-line-2"/></li>
                                    <li><liferay-ui:message key="subscription-monthly-gold-line-3"/></li>
                                </ul>
                                <h4 class="price"><%= goldMonthlyPrice %> <liferay-ui:message key="aed"/></h4>
                                <%
                                    request.setAttribute("subscriptionType", "gold");
                                    request.setAttribute("packageType", "monthly");
                                %>
                                <jsp:include page="_select_button.jsp"/>
                            </div>
                        </div>
                    </div>
                </c:if>
                <c:if test="<%= hasYearly %>">
                    <!-- Section: Yearly Subscription Content -->
                    <div class="tab-pane fade <%= !hasMonthly ? "show active" : "" %>" id="yearly" role="tabpanel">
                        <div class="row">
                            <!-- Bronze Yearly Plan -->

                            <div class="subscription-card">
                                <h5><liferay-ui:message key="bronze"/></h5>
                                <ul class="feature-list">
                                    <li><liferay-ui:message key="subscription-yearly-bronze-line-1"/></li>
                                    <li><liferay-ui:message key="subscription-yearly-bronze-line-2"/></li>
                                    <li><liferay-ui:message key="subscription-yearly-bronze-line-3"/></li>
                                </ul>
                                <h4 class="price"><%= bronzeYearlyPrice %> <liferay-ui:message key="aed"/></h4>
                                <%
                                    request.setAttribute("subscriptionType", "bronze");
                                    request.setAttribute("packageType", "yearly");
                                %>
                                <jsp:include page="_select_button.jsp"/>
                            </div>

                            <!-- Silver Yearly Plan -->

                            <div class="subscription-card bg-light">
                                <h5><liferay-ui:message key="silver"/></h5>
                                <ul class="feature-list">
                                    <li><liferay-ui:message key="subscription-yearly-silver-line-1"/></li>
                                    <li><liferay-ui:message key="subscription-yearly-silver-line-2"/></li>
                                    <li><liferay-ui:message key="subscription-yearly-silver-line-3"/></li>
                                </ul>
                                <h4 class="price"><%= silverYearlyPrice %> <liferay-ui:message key="aed"/></h4>
                                <%
                                    request.setAttribute("subscriptionType", "silver");
                                    request.setAttribute("packageType", "yearly");
                                %>
                                <jsp:include page="_select_button.jsp"/>
                            </div>

                            <!-- Gold Yearly Plan -->

                            <div class="subscription-card">
                                <h5><liferay-ui:message key="gold"/></h5>
                                <ul class="feature-list">
                                    <li><liferay-ui:message key="subscription-yearly-gold-line-1"/></li>
                                    <li><liferay-ui:message key="subscription-yearly-gold-line-2"/></li>
                                    <li><liferay-ui:message key="subscription-yearly-gold-line-3"/></li>
                                </ul>
                                <h4 class="price"><%= goldYearlyPrice %> <liferay-ui:message key="aed"/></h4>
                                <%
                                    request.setAttribute("subscriptionType", "gold");
                                    request.setAttribute("packageType", "yearly");
                                %>
                                <jsp:include page="_select_button.jsp"/>
                            </div>

                        </div>
                    </div>
                </c:if>
                <!-- Section: Pay as You Go Content -->
                <div class="tab-pane fade <%= !hasMonthly && !hasYearly ? "show active" : "" %>" id="payg" role="tabpanel">
                    <div class="row">

                        <div class="subscription-card price-per-call tab-part">
                            <h5><liferay-ui:message key="priced-per-call"/></h5>
                            <div class="list-point">
                                <div class="row">
                                    <div class="col-md-8">
                                        <ul class="feature-list">
                                            <li><liferay-ui:message key="subscription-payg-line-1"/></li>
                                            <li><liferay-ui:message key="subscription-payg-line-2"/></li>
                                            <li><liferay-ui:message key="subscription-payg-line-3"/></li>
                                            <li><liferay-ui:message key="subscription-payg-line-4"/></li>
                                        </ul>
                                    </div>



                                    <div class="col-md-4">
                                        <div class="bill-type-tab">
                                            <h4 class="price"><%= payAsYouGo %> <liferay-ui:message key="aed-per-call"/></h4>
                                            <p class="billing-cycle"><liferay-ui:message key="billed-monthly"/></p>
                                            <%
                                                request.setAttribute("packageType", "pay-as-you-go");
                                            %>
                                            <jsp:include page="_select_button.jsp"/>
                                        </div>
                                    </div>
                                </div>
                            </div>


                        </div>

                    </div>
                </div>
                <!-- Section: One Time Payment Content -->
                <div class="tab-pane fade" id="otp" role="tabpanel" aria-labelledby="otp-tab">
                    <div class="row">

                        <div class="subscription-card tab-part">
                            <h5><liferay-ui:message key="fixed-price"/></h5>
                            <div class="row">
                                <div class="col-md-8">
                                    <ul class="feature-list">
                                        <li><liferay-ui:message key="subscription-otp-line-1"/></li>
                                        <li><liferay-ui:message key="subscription-otp-line-2"/></li>
                                        <li><liferay-ui:message key="subscription-otp-line-3"/></li>
                                        <li><liferay-ui:message key="subscription-otp-line-4"/></li>
                                    </ul>
                                </div>
                                <div class="col-md-4">
                                    <h4 class="price"><%=oneTimePayment%><liferay-ui:message key="aed"/></h4>
                                    <%
                                        request.setAttribute("packageType", "one-time-payment");
                                    %>
                                    <jsp:include page="_select_button.jsp"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Section: Discussion Section -->
     <div class="cta-bar">
    <%--<div class="container-fluid">
        <div class="row">
            <div class="col-md-12 text-center bg-secondary py-4 text-white">
                <h4>Want to discuss different packages?</h4>
                <p>We're here to answer any questions and help.</p>
                <button class="btn btn-outline-light mr-3"><liferay-ui:message key="schedule-a-callback" /></button>
                <button class="btn btn-outline-light"><liferay-ui:message key="email-us" /></button>
            </div>
        </div>
    </div> --%>
</div>

<div class="product-cta">
    <div class="container-fluid">
    <div class="product-content">
        <h3><liferay-ui:message key="marketplace-different-packages-question"/></h3>
        <p><liferay-ui:message key="marketplace-different-packages-answer"/></p>
    </div>
    <div class="product-btn">
        <button class="btn btn-outline-light mr-3 w-auto"><liferay-ui:message key="schedule-a-callback" /></button>
        <button class="btn btn-outline-light"><liferay-ui:message key="email-us"/></button>
    </div>
    </div>
</div>

    <!-- Section: Related Objects Information -->
    <div class="more-info">
        <div class="container-fluid">
            <h3 class="font-weight-bold mb-4 title-bg"><liferay-ui:message key="more-information"/></h3>

            <%
                if (Validator.isNotNull(relatedObjects) && !relatedObjects.isEmpty()) {
            %>
            <ul class="nav nav-tabs mb-4 pl-0" id="myTab" role="tablist">
                <% int tabIndex = 0; %>
                <% for (String relationship : relatedObjects.keySet()) { %>
                <li class="nav-item">
                    <a class="nav-link <%= tabIndex == 0 ? "active" : "" %> px-3 py-2"
                       id="<%= relationship.replaceAll("\\s+", "-").toLowerCase() %>-tab" data-toggle="tab"
                       href="#<%= relationship.replaceAll("\\s+", "-").toLowerCase() %>" role="tab">
                        <%= relationship %>
                    </a>
                </li>
                <% tabIndex++; %>
                <% } %>
            </ul>


            <div class="tab-content" id="myTabContent">
                <% tabIndex = 0; %>
                <% for (Map.Entry<String, Object> entry : relatedObjects.entrySet()) { %>
                <div class="tab-pane fade <%= tabIndex == 0 ? "show active" : "" %>"
                     id="<%= entry.getKey().replaceAll("\\s+", "-").toLowerCase() %>" role="tabpanel">
                    <%
                        Map<String, Object> data = (Map<String, Object>) entry.getValue();
                        List<ObjectEntry> objectEntries = (List<ObjectEntry>) data.get("entries");
                        Map<String, String> fieldLabels = (Map<String, String>) data.get("fieldLabels");
                    %>
                    <% if (!objectEntries.isEmpty()) { %>
                    <% if (entry.getKey().equalsIgnoreCase(IS_DATA_API_ENGLISH) || entry.getKey().equals(IS_DATA_API_ARABIC)) { %>
                    <!-- Accordion for Data API -->
                    <div class="mt-4">
                        <div id="accordion" class="accordion">
                            <% int apiIndex = 0; %>
                            <% for (ObjectEntry objectEntry : objectEntries) { %>
                            <% for (String key : fieldLabels.keySet()) { %>
                            <div class="card mb-0">
                                <!-- Card Header -->
                                <div class="card-header <%= apiIndex == 0 ? "" : "collapsed" %>"
                                     data-toggle="collapse"
                                     data-target="#collapse<%= apiIndex %>"
                                     aria-expanded="<%= apiIndex == 0 ? "true" : "false" %>"
                                     aria-controls="collapse<%= apiIndex %>">
                                    <a class="card-title">
                                        <%= fieldLabels.get(key) %>
                                    </a>
                                </div>

                            <!-- Collapsible Content -->
                   <div id="collapse<%= apiIndex %>"
                                 class="collapse <%= apiIndex == 0 ? "show" : "" %>"
                                 data-parent="#accordion">
                                <div class="card-body">
                                    <p><%= objectEntry.getValues().getOrDefault(key, "No Value Available") %></p>
                                </div>
                            </div>
                        </div>
                        <% apiIndex++; %>
                        <% } %>
                        <% } %>
                    </div>
                </div>

                    <% } else { %>

                    <div class="table-responsive">
                        <table class="table table-bordered table-striped">
                            <thead class="thead-light">
                            <tr>
                                <% for (String key : fieldLabels.keySet()) { %>
                                <th class="font-weight-bold"><%= fieldLabels.get(key) %></th>
                                <% } %>
                            </tr>
                            </thead>
                            <tbody>
                            <% int rowIndex = 0;
                                for (ObjectEntry objectEntry : objectEntries) { %>
                            <tr class="<%= rowIndex >= 5 ? "d-none additional-row" : "" %>">
                                <% for (String key : fieldLabels.keySet()) { %>
                                <td><%= objectEntry.getValues().getOrDefault(key, "") %></td>
                                <% } %>
                            </tr>
                            <% rowIndex++;
                            } %>

                            <tr class="show-more-row">
                                <td colspan="<%= fieldLabels.size() %>" class="text-left">
                                    <a href="#" class="btn btn-link show-more"
                                       data-show-more="<liferay-ui:message key='show-more' />"
                                       data-show-less="<liferay-ui:message key='show-less' />">
                                        <liferay-ui:message key="show-more"/> <i class="fa-solid fa-chevron-down"></i>
                                    </a>
                                </td>
                            </tr>

                            </tbody>
                        </table>
                    </div>

                    <% } %>

                <% } else { %>
                <p><liferay-ui:message key="no-data-available"/></p>
                <% } %>
            </div>
            <% tabIndex++; %>
            <% } %>
        </div>
        <% } %>
    </div>
</div>

    <!-- Section: Policy Section -->
     <div class="policy-main">
    <div class="container-fluid">
        <div class="row align-items-center m-0">
           
                <h3 class="mb-0 title-bg"><liferay-ui:message key="policy"/></h3>
           
            <%-- <div class="col-md-4 text-right">
                 <a href="#" class="btn btn-outline-primary d-flex align-items-center justify-content-center common-btn">
                     <img src="/path/to/icon.png" alt="Policy Icon" />
                     <liferay-ui:message key="read-our-policy" />
                 </a>
             </div> --%>
        </div>
    </div>

    <!-- Section: Documentation Section -->

    <div class="container-fluid">
        <h3><liferay-ui:message key="documentation"/></h3>
        <% if (attachmentDetailsList != null && !attachmentDetailsList.isEmpty()) { %>
        <div class="row">
            <div class="col-md-12 text-right mb-3">
                <a href="javascript:void(0);" class=" download-all" onclick="downloadAllDocumentation()">
                    <liferay-ui:message key="download-all"/>
                </a>
            </div>
        </div>
        <div class="row">
            <script>
                var attachments = [];
            </script>
            <% for (Map<String, Object> attachmentDetails : attachmentDetailsList) { %>
            <% if (Validator.isNotNull(attachmentDetails.get("hasTagName"))) {%>
            <% if (!(Boolean) attachmentDetails.get("hasTagName")) { %>
            <div class="col-md-4 mb-3">
                <div class="doc-card">
                    <div class="card-body">
                      
                           
                            <div class="doc-actions">
                                <a target="_blank" href="<%= attachmentDetails.get("previewURL") %>"
                                   class="card-link mr-2">
                                    <img src="<%= attachmentDetails.get("previewIconURL") %>" alt="Preview"/>
                                </a>
                                <a target="_blank" href="<%= attachmentDetails.get("downloadURL") %>" class="card-link">
                                    <img src="<%= attachmentDetails.get("downloadIconURL") %>" alt="Download"
                                         style="width: 20px; height: 20px;"/>
                                </a>
                            
                            
                        </div>
                        <h3 class="doc-title"><%= attachmentDetails.get("fileName") %>
                        </h3>
                        <div class="doc-file-info">
                            <p><%= attachmentDetails.get("year") %></p>
                            <div>
                            <span><%= attachmentDetails.get("fileSize") %> KB</span>
                            <img src="<%= attachmentDetails.get("fileIconURL") %>" alt="PDF"/>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
            <script>
                attachments.push({
                    url: '<%= attachmentDetails.get("downloadURL") %>',
                    name: '<%= attachmentDetails.get("fileName") %>'
                });
            </script>
            <% } %>
            <% } %>
            <% } %>
        </div>
        <% } else { %>
        <div class="alert alert-warning">
            <p><liferay-ui:message key="no-attachments-were-found"/></p>
        </div>
        <% } %>
    </div>
    <div class="product-document">
    <div class="container-fluid">
        <h3><liferay-ui:message key="related-products"/></h3>
        <% if (relatedProductsList != null && !relatedProductsList.isEmpty()) { %>
        <div class="row">
            <% for (CPDefinition relatedProduct : relatedProductsList) { %>
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <div class="product-tags mb-2">
                            <%
                                Map<String, List<String>> relatedProductCategories = DdaMarketplaceUtil.getProductCategories(relatedProduct.getCPDefinitionId(), locale);
                            %>
                            <% if (Validator.isNotNull(relatedProductCategories) && !relatedProductCategories.isEmpty()) { %>
                            <% for (Map.Entry<String, List<String>> entry : relatedProductCategories.entrySet()) { %>
                            <div class="vocabulary-group">
                                <span class="badge badge-primary"><%= String.join(", ", entry.getValue()) %></span>
                            </div>
                            <% } %>
                            <% } %>
                        </div>
                        <a href="<%=themeDisplay.getCDNBaseURL()+"/p/"+ relatedProduct.getURL(themeDisplay.getLanguageId())+"?productId="+relatedProduct.getCPDefinitionId()%>">
                            <h5 class="card-title product-name"><%= relatedProduct.getName(languageId) %>
                            </h5></a>
                        <p class="card-text product-description"><%= relatedProduct.getShortDescription(languageId) %>
                        </p>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</div>
    <% } else { %>
    <div class="alert alert-warning">
        <p><liferay-ui:message key="no-data-available"/></p>
    </div>
    <% } %>
</div>
<%
    }
%>


<script type="text/javascript" src=${themeDisplay.getPathThemeJavaScript()}/jszip.min.js></script>
<script type="text/javascript" src=${themeDisplay.getPathThemeJavaScript()}/FileSaver.min.js></script>



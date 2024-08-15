<%@ page import="sun.util.resources.cldr.lo.CurrencyNames_lo" %>
<%@ include file="/init.jsp" %>

<%
    // Section: Fetching Data from Request Attributes
    long accountId = (Long) request.getAttribute("accountId");
    List<CPAttachmentFileEntry> productImageList = (List<CPAttachmentFileEntry>) request.getAttribute("productImage");
    CPDefinition product = (CPDefinition) request.getAttribute("productDetails");
    List<CPDefinition> relatedProductsList = (List<CPDefinition>) request.getAttribute("relatedProducts");
    System.out.println("relatedProductsList=======" + relatedProductsList);
    Map<String, List<ObjectEntry>> relatedObjects = (Map<String, List<ObjectEntry>>) request.getAttribute("relatedObjects");
    System.out.println("relatedObjects=======" + relatedObjects);
    String languageId = LanguageUtil.getLanguageId(request);
    getPrices(product,renderRequest);
    boolean hasMonthly = (boolean) request.getAttribute("hasMonthlySubscription");
    System.out.println("hasMonthly=======" + hasMonthly);
    boolean hasYearly = (boolean) request.getAttribute("hasYearlySubscription");
    System.out.println("hasYearly=======" + hasYearly);
    Map<String, BigDecimal> priceMap = (Map<String, BigDecimal>) renderRequest.getAttribute("priceMap");
    System.out.println("priceMap======" + priceMap);

    // Section: Handling Price Data
    BigDecimal bronzeMonthlyPrice = priceMap != null ? priceMap.getOrDefault("bronzeMonthlyPrice", BigDecimal.ZERO).setScale(2,RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal silverMonthlyPrice = priceMap != null ? priceMap.getOrDefault("silverMonthlyPrice", BigDecimal.ZERO).setScale(2,RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal goldMonthlyPrice = priceMap != null ? priceMap.getOrDefault("goldMonthlyPrice", BigDecimal.ZERO).setScale(2,RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal bronzeYearlyPrice = priceMap != null ? priceMap.getOrDefault("bronzeYearlyPrice", BigDecimal.ZERO).setScale(2,RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal silverYearlyPrice = priceMap != null ? priceMap.getOrDefault("silverYearlyPrice", BigDecimal.ZERO).setScale(2,RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal goldYearlyPrice = priceMap != null ? priceMap.getOrDefault("goldYearlyPrice", BigDecimal.ZERO).setScale(2,RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal payAsYouGo = priceMap != null ? priceMap.getOrDefault("payAsYouGo", BigDecimal.ZERO).setScale(2,RoundingMode.HALF_UP) : BigDecimal.ZERO;
    BigDecimal oneTimePayment = priceMap != null ? priceMap.getOrDefault("oneTimePayment", BigDecimal.ZERO).setScale(2,RoundingMode.HALF_UP) : BigDecimal.ZERO;

    // Section: Other Variables
    List<Map<String, Object>> attachmentDetailsList = (List<Map<String, Object>>) request.getAttribute("fileAttachments");
%>
<!-- Section: Product Overview -->
<div class="container">
    <div class="row my-4">
        <div class="col-md-8">
            <div class="d-flex align-items-center">
                <div class="mr-3">
                    <%
                        // Section: Product Thumbnail Image
                        String thumbnailURL = null;
                        if (productImageList != null && !productImageList.isEmpty()) {
                            CPAttachmentFileEntry fileEntry = productImageList.get(0);
                            thumbnailURL = "/o/commerce-media/accounts/" + accountId + "/images/" + fileEntry.getCPAttachmentFileEntryId() + "?download=false";
                        }
                    %>
                    <c:if test="<%= thumbnailURL != null %>">
                        <img src="<%= thumbnailURL %>" alt="Thumbnail" class="img-fluid" style="width: 50px; height: 50px;"/>
                    </c:if>
                </div>
                <div>
                    <h1><%= product.getName(languageId) %></h1>
                    <p><%= product.getShortDescription(languageId) %></p>
                </div>
            </div>
        </div>
        <!-- Button to trigger the modal -->
        <div class="col-md-4 text-right">
            <a href="#" class="btn btn-primary" data-toggle="modal" data-target="#productPreviewModal">
                <liferay-ui:message key="preview-sample" />
            </a>
        </div>

        <!-- Modal Structure -->
        <div class="modal fade" id="productPreviewModal" tabindex="-1" role="dialog" aria-labelledby="productPreviewModalLabel" aria-hidden="true">
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
                        <p>In today's fast-paced digital world, technology plays a crucial role in shaping the way we live, work, and communicate. From smartphones that keep us connected to smart home devices that make our lives more convenient, technological advancements are everywhere. The rise of artificial intelligence and machine learning has further accelerated innovation, enabling machines to learn and adapt like never before. Businesses are leveraging these technologies to enhance productivity, improve customer experiences, and gain a competitive edge. However, with these advancements come challenges, such as concerns about data privacy, security, and the ethical implications of AI. As we continue to integrate technology into every aspect of our lives, it's essential to strike a balance between innovation and responsibility. By fostering a culture of ethical tech development, we can ensure that technology serves humanity's best interests while minimizing potential risks. The future holds immense possibilities, and with thoughtful consideration, we can harness the power of technology to create a better world for all.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <hr>
    <div class="row my-4">
        <div class="col-md-8">
            <h3><liferay-ui:message key="product-overview" /></h3>
            <%=product.getDescription(languageId)%>
        </div>
        <div class="col-md-4 text-center">
            <%
                // Section: Product Main Image
                String imageURL = null;
                if (productImageList != null && !productImageList.isEmpty()) {
                    CPAttachmentFileEntry fileEntry = productImageList.get(0);
                    imageURL = "/o/commerce-media/accounts/" + accountId + "/images/" + fileEntry.getCPAttachmentFileEntryId() + "?download=false";
                }
            %>
            <c:if test="<%= imageURL != null %>">
                <img src="<%= imageURL %>" alt="Product Image" class="img-fluid" style="max-width: 100%; height: auto;">
            </c:if>
        </div>
    </div>
</div>

<!-- Section: Subscription Types -->
<div class="container">
    <h3><liferay-ui:message key="subscription-type" /></h3>

    <ul class="nav nav-tabs mb-4" id="subscriptionTabs" role="tablist">
        <c:if test="<%= hasMonthly %>">
            <!-- Section: Monthly Subscription Tab -->
            <li class="nav-item" role="presentation">
                <a class="nav-link active" id="monthly-tab" data-toggle="tab" href="#monthly" role="tab"><liferay-ui:message key="monthly" /></a>
            </li>
        </c:if>
        <c:if test="<%= hasYearly %>">
            <!-- Section: Yearly Subscription Tab -->
            <li class="nav-item" role="presentation">
                <a class="nav-link <%= !hasMonthly ? "active" : "" %>" id="yearly-tab" data-toggle="tab" href="#yearly" role="tab"><liferay-ui:message key="yearly" /></a>
            </li>
        </c:if>
        <!-- Section: Pay as You Go Subscription Tab -->
        <li class="nav-item" role="presentation">
            <a class="nav-link <%= !hasMonthly && !hasYearly ? "active" : "" %>" id="payg-tab" data-toggle="tab" href="#payg" role="tab"><liferay-ui:message key="pay-as-you-go" /></a>
        </li>
        <!-- Section: One Time Payment Tab -->
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="otp-tab" data-toggle="tab" href="#otp" role="tab" aria-controls="otp" aria-selected="false"><liferay-ui:message key="one-time-payment" /></a>
        </li>
    </ul>

    <div class="tab-content" id="subscriptionTabContent">
        <c:if test="<%= hasMonthly %>">
            <!-- Section: Monthly Subscription Content -->
            <div class="tab-pane fade show active" id="monthly" role="tabpanel">
                <div class="row">
                    <!-- Bronze Monthly Plan -->
                    <div class="col-md-4">
                        <div class="subscription-card">
                            <h5><liferay-ui:message key="bronze" /></h5>
                            <ul class="feature-list">
                                <li><liferay-ui:message key="subscription-monthly-bronze-line-1" /></li>
                                <li><liferay-ui:message key="subscription-monthly-bronze-line-2" /></li>
                                <li><liferay-ui:message key="subscription-monthly-bronze-line-3" /></li>
                            </ul>
                            <h4 class="price"><%= bronzeMonthlyPrice %> <liferay-ui:message key="aed" /> </h4>
                            <%
                                request.setAttribute("subscriptionType", "bronze");
                                request.setAttribute("packageType", "monthly");
                            %>
                            <jsp:include page="_select_button.jsp" />
                        </div>
                    </div>
                    <!-- Silver Monthly Plan -->
                    <div class="col-md-4">
                        <div class="subscription-card bg-light">
                            <h5><liferay-ui:message key="silver" /></h5>
                            <ul class="feature-list">
                                <li><liferay-ui:message key="subscription-monthly-silver-line-1" /></li>
                                <li><liferay-ui:message key="subscription-monthly-silver-line-2" /></li>
                                <li><liferay-ui:message key="subscription-monthly-silver-line-3" /></li>
                            </ul>
                            <h4 class="price"><%= silverMonthlyPrice%> <liferay-ui:message key="aed" /> </h4>
                            <%
                                request.setAttribute("subscriptionType", "silver");
                                request.setAttribute("packageType", "monthly");
                            %>
                            <jsp:include page="_select_button.jsp" />
                        </div>
                    </div>
                    <!-- Gold Monthly Plan -->
                    <div class="col-md-4">
                        <div class="subscription-card">
                            <h5><liferay-ui:message key="gold" /></h5>
                            <ul class="feature-list">
                                <li><liferay-ui:message key="subscription-monthly-gold-line-1" /></li>
                                <li><liferay-ui:message key="subscription-monthly-gold-line-2" /></li>
                                <li><liferay-ui:message key="subscription-monthly-gold-line-3" /></li>
                            </ul>
                            <h4 class="price"><%= goldMonthlyPrice %> <liferay-ui:message key="aed" /> </h4>
                            <%
                                request.setAttribute("subscriptionType", "gold");
                                request.setAttribute("packageType", "monthly");
                            %>
                            <jsp:include page="_select_button.jsp" />
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="<%= hasYearly %>">
            <!-- Section: Yearly Subscription Content -->
            <div class="tab-pane fade <%= !hasMonthly ? "show active" : "" %>" id="yearly" role="tabpanel">
                <div class="row">
                    <!-- Bronze Yearly Plan -->
                    <div class="col-md-4">
                        <div class="subscription-card">
                            <h5><liferay-ui:message key="bronze" /></h5>
                            <ul class="feature-list">
                                <li><liferay-ui:message key="subscription-yearly-bronze-line-1" /></li>
                                <li><liferay-ui:message key="subscription-yearly-bronze-line-2" /></li>
                                <li><liferay-ui:message key="subscription-yearly-bronze-line-3" /></li>
                            </ul>
                            <h4 class="price"><%= bronzeYearlyPrice %> <liferay-ui:message key="aed" /> </h4>
                            <%
                                request.setAttribute("subscriptionType", "bronze");
                                request.setAttribute("packageType", "yearly");
                            %>
                            <jsp:include page="_select_button.jsp" />
                        </div>
                    </div>
                    <!-- Silver Yearly Plan -->
                    <div class="col-md-4">
                        <div class="subscription-card bg-light">
                            <h5><liferay-ui:message key="silver" /></h5>
                            <ul class="feature-list">
                                <li><liferay-ui:message key="subscription-yearly-silver-line-1" /></li>
                                <li><liferay-ui:message key="subscription-yearly-silver-line-2" /></li>
                                <li><liferay-ui:message key="subscription-yearly-silver-line-3" /></li>
                            </ul>
                            <h4 class="price"><%= silverYearlyPrice %> <liferay-ui:message key="aed" /> </h4>
                            <%
                                request.setAttribute("subscriptionType", "silver");
                                request.setAttribute("packageType", "yearly");
                            %>
                            <jsp:include page="_select_button.jsp" />
                        </div>
                    </div>
                    <!-- Gold Yearly Plan -->
                    <div class="col-md-4">
                        <div class="subscription-card">
                            <h5><liferay-ui:message key="gold" /></h5>
                            <ul class="feature-list">
                                <li><liferay-ui:message key="subscription-yearly-gold-line-1" /></li>
                                <li><liferay-ui:message key="subscription-yearly-gold-line-2" /></li>
                                <li><liferay-ui:message key="subscription-yearly-gold-line-3" /></li>
                            </ul>
                            <h4 class="price"><%= goldYearlyPrice %> <liferay-ui:message key="aed" /> </h4>
                            <%
                                request.setAttribute("subscriptionType", "gold");
                                request.setAttribute("packageType", "yearly");
                            %>
                            <jsp:include page="_select_button.jsp" />
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        <!-- Section: Pay as You Go Content -->
        <div class="tab-pane fade <%= !hasMonthly && !hasYearly ? "show active" : "" %>" id="payg" role="tabpanel">
            <div class="row">
                <div class="col-md-12">
                    <div class="subscription-card">
                        <h5><liferay-ui:message key="priced-per-call" /></h5>
                        <ul class="feature-list">
                            <li><liferay-ui:message key="subscription-payg-line-1" /></li>
                            <li><liferay-ui:message key="subscription-payg-line-2" /></li>
                            <li><liferay-ui:message key="subscription-payg-line-3" /></li>
                        </ul>
                        <h4 class="price"><%= payAsYouGo %> <liferay-ui:message key="aed-per-call" /></h4>
                        <p class="billing-cycle"><liferay-ui:message key="billed-monthly" /></p>
                        <%
                            request.setAttribute("packageType", "pay-as-you-go");
                        %>
                        <jsp:include page="_select_button.jsp" />
                    </div>
                </div>
            </div>
        </div>
        <!-- Section: One Time Payment Content -->
        <div class="tab-pane fade" id="otp" role="tabpanel" aria-labelledby="otp-tab">
            <div class="row">
                <div class="col-md-12">
                    <div class="subscription-card">
                        <h5><liferay-ui:message key="fixed-price" /></h5>
                        <ul class="feature-list">
                            <li><liferay-ui:message key="subscription-otp-line-1" /></li>
                            <li><liferay-ui:message key="subscription-otp-line-2" /></li>
                            <li><liferay-ui:message key="subscription-otp-line-3" /></li>
                        </ul>
                        <h4 class="price"><%=oneTimePayment%><liferay-ui:message key="aed" /></h4>
                        <%
                            request.setAttribute("packageType", "one-time-payment");
                        %>
                        <jsp:include page="_select_button.jsp" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Section: Discussion Section -->
 <%--<div class="container my-4">
     <div class="row"> 
         <div class="col-md-12 text-center bg-secondary py-4 text-white"> 
             <h4>Want to discuss different packages?</h4> 
             <p>We're here to answer any questions and help.</p> 
             <button class="btn btn-outline-light mr-3"><liferay-ui:message key="schedule-a-callback" /></button> 
             <button class="btn btn-outline-light"><liferay-ui:message key="email-us" /></button> 
         </div> 
     </div> 
 </div> --%>

<!-- Section: Related Objects Information -->
<div class="container mb-4">
    <h3 class="font-weight-bold mb-4"><liferay-ui:message key="more-information" /></h3>

    <ul class="nav nav-tabs mb-4" id="myTab" role="tablist">
        <% int tabIndex = 0; %>
        <% for (String relationship : relatedObjects.keySet()) { %>
        <li class="nav-item">
            <a class="nav-link <%= tabIndex == 0 ? "active" : "" %> px-3 py-2" id="<%= relationship.replaceAll("\\s+", "-").toLowerCase() %>-tab" data-toggle="tab" href="#<%= relationship.replaceAll("\\s+", "-").toLowerCase() %>" role="tab">
                <%= relationship %>
            </a>
        </li>
        <% tabIndex++; %>
        <% } %>
    </ul>

    <div class="tab-content" id="myTabContent">
        <% tabIndex = 0; %>
        <% for (Map.Entry<String, List<ObjectEntry>> entry : relatedObjects.entrySet()) { %>
        <div class="tab-pane fade <%= tabIndex == 0 ? "show active" : "" %>" id="<%= entry.getKey().replaceAll("\\s+", "-").toLowerCase() %>" role="tabpanel">
            <% if (!entry.getValue().isEmpty()) { %>

            <% if (entry.getKey().equalsIgnoreCase("Data API")) { %>
            <!-- Accordion for Data API -->
            <div class="accordion" id="dataApiAccordion">
                <% int apiIndex = 0; %>
                <% for (ObjectEntry objectEntry : entry.getValue()) { %>
                <% for (Map.Entry<String, Serializable> dataEntry : objectEntry.getValues().entrySet()) { %>
                <div class="card">
                    <div class="card-header d-flex justify-content-between" id="heading<%= apiIndex %>">
                        <h5 class="mb-0">
                            <%= dataEntry.getKey() %>
                        </h5>
                        <button class="btn btn-link toggle-icon" type="button" data-toggle="collapse" data-target="#collapse<%= apiIndex %>" aria-expanded="true" aria-controls="collapse<%= apiIndex %>">
                            <span class="icon">+</span>
                        </button>
                    </div>

                    <div id="collapse<%= apiIndex %>" class="collapse <%= apiIndex == 0 ? "show" : "" %>" aria-labelledby="heading<%= apiIndex %>" data-parent="#dataApiAccordion">
                        <div class="card-body">
                            <%= dataEntry.getValue() != null ? dataEntry.getValue().toString() : "No Value Available" %>
                        </div>
                    </div>
                </div>
                <% apiIndex++; } %>
                <% } %>
            </div>
            <% } else { %>

            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <thead class="thead-light">
                    <tr>
                        <% ObjectEntry firstEntry = entry.getValue().get(0);
                            for (String key : firstEntry.getValues().keySet()) { %>
                        <th class="font-weight-bold"><%= key %></th>
                        <% } %>
                    </tr>
                    </thead>
                    <tbody>
                    <% int rowIndex = 0;
                        int totalRows = entry.getValue().size();
                        for (ObjectEntry objectEntry : entry.getValue()) { %>
                    <tr class="<%= rowIndex >= 5 ? "d-none additional-row" : "" %>">
                        <% for (Serializable value : objectEntry.getValues().values()) { %>
                        <td><%= value != null ? value.toString() : "" %></td>
                        <% } %>
                    </tr>
                    <% rowIndex++; } %>

                    <tr class="show-more-row">
                        <td colspan="<%= firstEntry.getValues().size() %>" class="text-right">
                            <a href="#" class="btn btn-link show-more" data-show-more="Show More" data-show-less="Show Less">Show More</a>

                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>

            <% } %>

            <% } else { %>
            <p><liferay-ui:message key="no-data-available" /></p>
            <% } %>
        </div>
        <% tabIndex++; %>
        <% } %>
    </div>
</div>

<!-- Section: Policy Section -->
<div class="container my-4">
    <div class="row align-items-center p-3" style="background-color: #f4f4f4;">
        <div class="col-md-8">
            <h3 class="mb-0"><liferay-ui:message key="policy" /></h3>
        </div>
        <%-- <div class="col-md-4 text-right">
             <a href="#" class="btn btn-outline-primary d-flex align-items-center justify-content-center" style="min-width: 160px;">
                 <img src="/path/to/icon.png" alt="Policy Icon" style="width: 16px; height: 16px; margin-right: 8px;"/>
                 <liferay-ui:message key="read-our-policy" />
             </a>
         </div> --%>
    </div>
</div>

<!-- Section: Documentation Section -->
<div class="container">
    <h3><liferay-ui:message key="documentation" /></h3>
    <div class="row">
        <div class="col-md-12 text-right mb-3">
            <a href="javascript:void(0);" class="btn btn-outline-primary" onclick="downloadAllDocumentation()">
                <liferay-ui:message key="download-all" />
            </a>
        </div>
    </div>
    <div class="row">
        <% if (attachmentDetailsList != null && !attachmentDetailsList.isEmpty()) { %>
        <script>
            var attachments = [];
        </script>
        <% for (Map<String, Object> attachmentDetails : attachmentDetailsList) { %>
        <% if (Validator.isNotNull(attachmentDetails.get("hasTagName"))) {%>
        <% if (!(Boolean) attachmentDetails.get("hasTagName")) { %>
        <div class="col-md-4 mb-3">
            <div class="card border rounded shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h5 class="card-title mb-0"><%= attachmentDetails.get("fileName") %></h5>
                        <div>
                            <a target="_blank" href="<%= attachmentDetails.get("previewURL") %>" class="card-link mr-2">
                                <img src="<%= attachmentDetails.get("previewIconURL") %>" alt="Preview" style="width: 20px; height: 20px;"/>
                            </a>
                            <a target="_blank" href="<%= attachmentDetails.get("downloadURL") %>" class="card-link">
                                <img src="<%= attachmentDetails.get("downloadIconURL") %>" alt="Download" style="width: 20px; height: 20px;"/>
                            </a>
                        </div>
                    </div>
                    <div class="d-flex justify-content-between">
                        <small><%= attachmentDetails.get("year") %></small>
                        <small><%= attachmentDetails.get("fileSize") %> KB</small>
                        <img src="<%= attachmentDetails.get("fileIconURL") %>" alt="PDF" style="width: 20px; height: 20px;"/>
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
        <% } else { %>
        <p><liferay-ui:message key="no-attachments-were-found" /></p>
        <% } %>
    </div>
</div>

<div class="container">
    <h3><liferay-ui:message key="related-products" /></h3>
    <% if (relatedProductsList != null && !relatedProductsList.isEmpty()) { %>
    <div class="row">
        <% for (CPDefinition relatedProduct : relatedProductsList) { %>
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body">
                    <div class="product-tags mb-2">
                        <%
                            Map<String, List<String>> relatedProductCategories = DdaMarketplaceUtil.getProductCategories(relatedProduct.getCPDefinitionId());
                        %>

                        <% if (Validator.isNotNull(relatedProductCategories) && !relatedProductCategories.isEmpty()) { %>
                        <% for (Map.Entry<String, List<String>> entry : relatedProductCategories.entrySet()) { %>
                        <div class="vocabulary-group">
                            <span class="badge badge-primary"><%= String.join(", ", entry.getValue()) %></span>
                        </div>
                        <% } %>
                        <% } %>
                    </div>
                    <h5 class="card-title product-name"><%= relatedProduct.getName(languageId) %></h5>
                    <p class="card-text product-description"><%= relatedProduct.getShortDescription(languageId) %></p>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>
<% } %>





<!-- Section: Download All Documentation Script -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.7.1/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>



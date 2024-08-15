<%@ page import="java.util.*" %>

<%@ include file="/init.jsp" %>

<%
    long accountId = (Long) request.getAttribute("accountId");
    if(accountId == 0){
        accountId = -1;
    }
    List<CPAttachmentFileEntry> fileAttachments = (List<CPAttachmentFileEntry>) request.getAttribute("fileAttachments");
    List<CPAttachmentFileEntry> productImageList = (List<CPAttachmentFileEntry>) request.getAttribute("productImage");
    CPDefinition product = (CPDefinition) request.getAttribute("productDetails");
    Map<String, List<ObjectEntry>> relatedObjects = (Map<String, List<ObjectEntry>>) request.getAttribute("relatedObjects");
    String languageId = LanguageUtil.getLanguageId(request);
%>

<div class="container">
    <div class="row my-4">
        <div class="col-md-8">
            <h1><%=product.getName(languageId)%></h1>
            <p><%=product.getShortDescription(languageId)%></p>
        </div>
        <div class="col-md-4 text-right">
            <a href="#" class="btn btn-primary">Preview Sample</a>
        </div>
    </div>
    <hr>
    <div class="row my-4">
        <div class="col-md-8">
            <h3>Product Overview</h3>
            <%=product.getDescription(languageId)%>
        </div>
        <div class="col-md-4 text-center">
            <%
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
<div class="container">
    <h3>Subscription types</h3>

    <ul class="nav nav-tabs mb-4" id="subscriptionTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <a class="nav-link active" id="monthly-tab" data-toggle="tab" href="#monthly" role="tab">Monthly</a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="yearly-tab" data-toggle="tab" href="#yearly" role="tab">Yearly</a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="payg-tab" data-toggle="tab" href="#payg" role="tab">Pay as you go</a>
        </li>
    </ul>

    <div class="tab-content" id="subscriptionTabContent">
        <div class="tab-pane fade show active" id="monthly" role="tabpanel">
            <div class="row">
                <div class="col-md-4">
                    <div class="subscription-card">
                        <h5>Bronze</h5>
                        <ul class="feature-list">
                            <li><liferay-ui:message key="product-subscription-detail" /></li>
                            <li><liferay-ui:message key="product-subscription-detail" /></li>
                            <li><liferay-ui:message key="product-subscription-detail" /></li>
                        </ul>
                        <h4 class="price">XXX AED</h4>
                        <button class="btn btn-outline-primary btn-block">Select</button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="subscription-card bg-light">
                        <h5>Silver</h5>
                        <ul class="feature-list">
                            <li><liferay-ui:message key="product-subscription-detail" /></li>
                            <li><liferay-ui:message key="product-subscription-detail" /></li>
                            <li><liferay-ui:message key="product-subscription-detail" /></li>
                        </ul>
                        <h4 class="price">XXX AED</h4>
                        <button class="btn btn-outline-primary btn-block">Select</button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="subscription-card">
                        <h5>Gold</h5>
                        <ul class="feature-list">
                            <li><liferay-ui:message key="product-subscription-detail" /></li>
                            <li><liferay-ui:message key="product-subscription-detail" /></li>
                            <li><liferay-ui:message key="product-subscription-detail" /></li>
                        </ul>
                        <h4 class="price">XXX AED</h4>
                        <button class="btn btn-outline-primary btn-block">Select</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="yearly" role="tabpanel">
            <!-- Repeat the row structure for yearly plans, adjusting prices as needed -->
        </div>
        <div class="tab-pane fade" id="payg" role="tabpanel">
            <!-- Repeat the row structure for pay-as-you-go plans, adjusting content as needed -->
        </div>
    </div>
</div>


<div class="container">
    <h3>More Information</h3>

    <ul class="nav nav-tabs" id="myTab" role="tablist">
        <% int tabIndex = 0; %>
        <% for (String relationship : relatedObjects.keySet()) { %>
        <li class="nav-item">
            <a class="nav-link <%= tabIndex == 0 ? "active" : "" %>" id="<%= relationship.replaceAll("\\s+", "-").toLowerCase() %>-tab" data-toggle="tab" href="#<%= relationship.replaceAll("\\s+", "-").toLowerCase() %>" role="tab">
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
            <table class="table table-bordered">
                <thead>
                <tr>
                    <% ObjectEntry firstEntry = entry.getValue().get(0);
                        for (String key : firstEntry.getValues().keySet()) { %>
                    <th><%= key %></th>
                    <% } %>
                </tr>
                </thead>
                <tbody>
                <% for (ObjectEntry objectEntry : entry.getValue()) { %>
                <tr>
                    <% for (Serializable value : objectEntry.getValues().values()) { %>
                    <td><%= value != null ? value.toString() : "" %></td>
                    <% } %>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p>No data available for this relationship.</p>
            <% } %>
        </div>
        <% tabIndex++; %>
        <% } %>
    </div>
</div>

<div class="container">
    <h3>Documentation</h3>
    <div class="row">
        <% if (Validator.isNotNull(fileAttachments) && !fileAttachments.isEmpty()) {
            for (CPAttachmentFileEntry fileAttachment : fileAttachments) {
                String fileName = null;
                String previewURL = null;
                String downloadURL = null;
                long fileSize = 0;
                String fileIconURL = null;
                int year = 0;
                if (Validator.isNotNull(fileAttachment)) {
                    fileName = fileAttachment.getTitle(Locale.US);
                    try {
                        fileSize = fileAttachment.fetchFileEntry().getSize();
                        Date date = fileAttachment.getCreateDate();
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(date);
                        year = calendar.get(Calendar.YEAR);
                    } catch (PortalException e) {
                        System.err.println("Exception while fetching file!");
                    }
                    fileIconURL = themeDisplay.getPortalURL()+"/documents/d/guest/pdf-icon";
                    downloadURL = "/o/commerce-media/accounts/"+ accountId + "/attachments/" + fileAttachment.getCPAttachmentFileEntryId() + "?download=true";
                    previewURL = "/o/commerce-media/accounts/"+accountId+"/attachments/" + fileAttachment.getCPAttachmentFileEntryId() + "?download=false";
                }
        %>
        <div class="col-md-4 mb-3">
            <div class="card border rounded shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h5 class="card-title mb-0"><%=fileName%></h5>
                        <div>
                            <a target="_blank" href="<%=previewURL%>" class="card-link mr-2">
                                <img src="<%=themeDisplay.getPortalURL()%>/documents/d/guest/preview-eye" alt="Preview" style="width: 20px; height: 20px;"/>
                            </a>
                            <a target="_blank" href="<%=downloadURL%>" class="card-link">
                                <img src="<%=themeDisplay.getPortalURL()%>/documents/d/guest/download-icon" alt="Download" style="width: 20px; height: 20px;"/>
                            </a>
                        </div>
                    </div>
                    <div class="d-flex justify-content-between">
                        <small class="text-muted"><%=year%></small>
                        <small class="text-muted"><%=fileSize%> KB</small>
                        <img src="<%=fileIconURL%>" alt="PDF" style="width: 20px; height: 20px;"/>
                    </div>
                </div>
            </div>
        </div>
        <% }
        } else { %>
        <p>No attachments available.</p>
        <% } %>
    </div>
</div>


<!-- Include Bootstrap CSS and JS -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
<script src="<%= request.getContextPath() %>/js/jquery-3.3.1.slim.min.js"></script>
<script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>

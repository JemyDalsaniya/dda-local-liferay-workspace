<%@ page import="com.liferay.commerce.product.model.CPAttachmentFileEntry" %>
<%@ page import="com.liferay.commerce.product.model.CPDefinition" %>
<%@ page import="com.liferay.object.model.ObjectEntry" %>
<%@ page import="com.liferay.portal.kernel.exception.PortalException" %>
<%@ page import="com.liferay.portal.kernel.model.User" %>
<%@ page import="com.liferay.portal.kernel.util.PortalUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="dda.marketplace.portlet.service.DdaMarketplaceService" %>
<%@ page import="org.osgi.framework.BundleContext" %>
<%@ page import="org.osgi.framework.FrameworkUtil" %>
<%@ page import="org.osgi.framework.ServiceReference" %>
<%@ page import="java.io.Serializable" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Map" %>
<%@ include file="/init.jsp" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%
    BundleContext bundleContext = FrameworkUtil.getBundle(DdaMarketplaceService.class).getBundleContext();
    ServiceReference<DdaMarketplaceService> serviceReference = bundleContext.getServiceReference(DdaMarketplaceService.class);
    DdaMarketplaceService ddaMarketplaceService = bundleContext.getService(serviceReference);
    CPDefinition product = null;
    long accountId = 0;
    Map<String, List<ObjectEntry>> relatedObjects = null;
    List<CPAttachmentFileEntry> fileAttachments = null;
    try {
        User currentUser = PortalUtil.getUser(request);
        accountId = ddaMarketplaceService.getCurrentUserAccountId(currentUser);
        long productId = Long.parseLong(request.getParameter("productId"));
         product = ddaMarketplaceService.getProductDetails(productId);
         relatedObjects = ddaMarketplaceService.getRelatedObjects(productId);
         fileAttachments = ddaMarketplaceService.getProductAttachments(productId);
    } catch (PortalException e) {
        System.out.println("Exception while getting data from service!" + e.getMessage());
    }
%>
<div class="container">
    <div class="row my-4">
        <div class="col-md-8">
            <h1><%=product.getName()%></h1>
            <p><%=product.getShortDescription()%></p>
        </div>
        <div class="col-md-4 text-right">
            <a href="#" class="btn btn-primary">Preview Sample</a>
        </div>
    </div>
    <hr>
    <div class="row my-4">
        <div class="col-md-8">
            <h3>Product Overview</h3>
            <%=product.getDescription()%>
        </div>
        <div class="col-md-4 text-center">
            <%
                List<CPAttachmentFileEntry> attachmentFileEntries = null;
                String imageURL = null;
                try {
                    attachmentFileEntries = product.getCPAttachmentFileEntries(0, 0);
                    if (attachmentFileEntries != null && !attachmentFileEntries.isEmpty()) {
                        CPAttachmentFileEntry fileEntry = attachmentFileEntries.get(0);
                        long fileEntryId = fileEntry.getCPAttachmentFileEntryId();
                        imageURL = "/o/commerce-media/accounts/" + accountId + "/images/" + fileEntryId + "?download=false";
                    }
                } catch (PortalException e) {
                    throw new RuntimeException(e);
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
                            <li>This is a line describing a feature that the product has and the value add</li>
                            <li>This is a line describing a feature that the product has and the value add</li>
                            <li>This is a line describing a feature that the product has and the value add</li>
                        </ul>
                        <h4 class="price">XXX AED</h4>
                        <button class="btn btn-outline-primary btn-block">Select</button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="subscription-card bg-light">
                        <h5>Silver</h5>
                        <ul class="feature-list">
                            <li>This is a line describing a feature that the product has and the value add</li>
                            <li>This is a line describing a feature that the product has and the value add</li>
                            <li>This is a line describing a feature that the product has and the value add</li>
                        </ul>
                        <h4 class="price">XXX AED</h4>
                        <button class="btn btn-outline-primary btn-block">Select</button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="subscription-card">
                        <h5>Gold</h5>
                        <ul class="feature-list">
                            <li>This is a line describing a feature that the product has and the value add</li>
                            <li>This is a line describing a feature that the product has and the value add</li>
                            <li>This is a line describing a feature that the product has and the value add</li>
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
                if (Validator.isNotNull(fileAttachment)) {
                    fileName = fileAttachment.getTitle(Locale.US);
                    try {
                        fileSize = fileAttachment.fetchFileEntry().getSize();
                    } catch (PortalException e) {
                        System.out.println("Exception while fetching file!");
                    }
                    fileIconURL = "https://liferaytest.axeno.co/documents/d/guest/pdf-icon";
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
                            <a href="<%=previewURL%>" class="card-link mr-2">
                                <img src="https://liferaytest.axeno.co/documents/d/guest/preview-eye" alt="Preview" style="width: 20px; height: 20px;"/>
                            </a>
                            <a href="<%=downloadURL%>" class="card-link">
                                <img src="https://liferaytest.axeno.co/documents/d/guest/download-icon" alt="Download" style="width: 20px; height: 20px;"/>
                            </a>
                        </div>
                    </div>
                    <div class="d-flex justify-content-between">
<%--                        <small class="text-muted"><%=year%></small>--%>
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

<style>
    .container { margin-top: 20px; }
    h1, h3 { margin-bottom: 20px; }
    .nav-tabs { margin-bottom: 20px; }
    .table { margin-top: 20px; }
    .nav-tabs .nav-link {
        color: #495057;
        background-color: transparent;
        border: none;
        border-bottom: 2px solid transparent;
    }
    .nav-tabs .nav-link.active {
        color: #007bff;
        background-color: transparent;
        border-bottom: 2px solid #007bff;
    }
    .subscription-card {
        border: 1px solid #e0e0e0;
        border-radius: 4px;
        padding: 20px;
        height: 100%;
    }
    .subscription-card h5 {
        margin-bottom: 20px;
    }
    .feature-list {
        list-style-type: none;
        padding-left: 0;
    }
    .feature-list li {
        margin-bottom: 10px;
        position: relative;
        padding-left: 25px;
    }
    .feature-list li:before {
        content: "\25CB";
        position: absolute;
        left: 0;
        color: #007bff;
    }
    .price {
        text-align: center;
        margin: 20px 0;
    }
    .btn-outline-primary {
        border-color: #007bff;
        color: #007bff;
    }
    .btn-outline-primary:hover {
        background-color: #007bff;
        color: white;
    }
</style>

<!-- Include Bootstrap CSS and JS -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

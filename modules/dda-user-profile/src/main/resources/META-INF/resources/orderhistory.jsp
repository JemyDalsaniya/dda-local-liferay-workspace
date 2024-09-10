<%@ include file="/init.jsp" %>

<%
    int totalOrders = (Integer) request.getAttribute("totalOrders");
    List<OrderDTO> orders = (List<OrderDTO>) request.getAttribute("orders");
%>

<div
  class="tab-pane fade"
  id="nav-order"
  role="tabpanel"
  aria-labelledby="nav-order-tab"
>
  <%
    if (orders != null && !orders.isEmpty()) {
  %>
  <table
    id="order-history"
    class="table table-history table-bordered"
    style="width: 100%"
  >
    <thead>
      <tr>
        <th><liferay-ui:message key="order-id" /></th>
        <th><liferay-ui:message key="date" /></th>
        <th><liferay-ui:message key="product-name" /></th>
        <th><liferay-ui:message key="subscription-type" /></th>
        <th><liferay-ui:message key="status" /></th>
        <th><liferay-ui:message key="price" /></th>
        <th><liferay-ui:message key="actions" /></th>
      </tr>
    </thead>
    <tbody>
        <% for (OrderDTO order : orders) { %>
          <tr>
            <td class="view-order-detail"
                              data-order='<%= com.liferay.portal.kernel.json.JSONFactoryUtil.looseSerialize(order) %>'
                              data-context-path='<%= request.getContextPath() %>'>
            <a class="order-id-link"> <%= order.getOrderId() %> </a>
            </td>
            <td><%= order.getDate() %></td>
            <td class="font-weight-bold"><%= order.getProductName() %></td>
            <td><%= order.getSubscriptionType() %></td>
            <td>
              <div class="order-active">
                <p class="text-center"><%= order.getStatus() %></p>
              </div>
            </td>
            <td><%= order.getPrice() %>$</td>
            <td>
              <div class="dropdown">
                <img
                  class="dropdown-toggle three-dots"
                  data-order-id="<%= order.getOrderId() %>"
                  src="<%= request.getContextPath() %>/images/dots.png"
                  alt="Options"
                />
                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                  <button class="dropdown-item order-history-details view-order-detail" data-order='<%= com.liferay.portal.kernel.json.JSONFactoryUtil.looseSerialize(order) %>'
                  data-context-path='<%= request.getContextPath() %>' >
                    <liferay-ui:message key="view-order-details" />
                  </button>
                  <portlet:actionURL var="cancelSubscriptionURL" name="processAction">
                      <portlet:param name="orderId" value="<%= order.getOrderId() %>" />
                  </portlet:actionURL>
                  <a class="dropdown-item cancel-subscription" href="<%= cancelSubscriptionURL %>" data-order-id="<%= order.getOrderId() %>">
                      <liferay-ui:message key="cancel-subscription" />
                  </a>
                </div>
              </div>
            </td>
          </tr>
       <% } %>
            </tbody>
          </table>
        <%
          } else {
        %>
          <table class="table table-empty border">
            <tbody>
              <tr>
                <td class="text-center">
                  <liferay-ui:message key="no-data-found" />
                </td>
              </tr>
            </tbody>
          </table>
        <%
          }
        %>
  <div id="orderDetailsSection" style="display: none;">
  </div>
</div>
<script type="text/javascript">
    var localizedMessages = {
        backOrderHistory: '<liferay-ui:message key="field.back-order-history" />',
        orderId: '<liferay-ui:message key="order-id" />',
        startDate: '<liferay-ui:message key="start-date" />',
        status: '<liferay-ui:message key="status" />',
        orderDetails: '<liferay-ui:message key="order-details" />',
        orderDescription: '<liferay-ui:message key="field.order-description" />',
        subscriptionType: '<liferay-ui:message key="subscription-type" />',
        bronze: '<liferay-ui:message key="bronze" />',
        numberOfQuantity: '<liferay-ui:message key="number-of-quantity" />',
        endDate: '<liferay-ui:message key="end-date" />',
        productInformation: '<liferay-ui:message key="product-information" />',
        url: '<liferay-ui:message key="url" />',
        apiKey: '<liferay-ui:message key="field.api-key" />',
        secret: '<liferay-ui:message key="secret" />',
        paymentHistory: '<liferay-ui:message key="payment-history" />',
        detail: '<liferay-ui:message key="detail" />',
        value: '<liferay-ui:message key="value" />',
        noDataFound: '<liferay-ui:message key="no-data-found" />'
    };
</script>

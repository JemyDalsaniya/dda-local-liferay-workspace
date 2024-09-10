<%@ include file="/init.jsp" %>
<%
    UserDetailsDTO userDetailsDTO = (UserDetailsDTO)request.getAttribute("userDetailsDTO");
    String userEmailAddress = userDetailsDTO.getEmailAddress();
    boolean isTestUser = "test@gmail.com".equals(userEmailAddress);
%>
<div
  class="tab-pane fade"
  id="nav-inbox"
  role="tabpanel"
  aria-labelledby="nav-inbox-tab"
>
  <div class="row">
    <div class="col-lg-12">
      <div>
        <div class="col-lg-4">
          <nav>
            <div
              class="nav nav-tabbs nav-fill"
              role="tablist"
            >
              <a
                class="nav-item nav-link active nav-service border"
                id="nav-service-tab"
                data-toggle="tab"
                href="#nav-service"
                role="tab"
                aria-controls="nav-service"
                aria-selected="true"
                >
                <liferay-ui:message key="field.service-request"/>
                </a>
              <a
                class="nav-item nav-link nav-customer border mx-2"
                id="nav-customer-tab"
                data-toggle="tab"
                href="#nav-customer"
                role="tab"
                aria-controls="nav-customer"
                aria-selected="false"
                ><liferay-ui:message key="field.customer-feedback" /></a
              >
            </div>
          </nav>
        </div>
      </div>
      <div class="tab-content py-3 px-3 px-sm-0" id="nav-tabContent">
        <div
          class="tab-pane fade show active"
          id="nav-service"
          role="tabpanel"
          aria-labelledby="nnav-service-tab"
        >
          <div class="border rounded">
            <div class="row">
              <div class="col-lg-6">
                <div class="mx-3 my-2 inbox-doc-title"">
                  <h4><liferay-ui:message key="field.service-request" /></h4>
                  <p><liferay-ui:message key="field.description" /></p>
                </div>
              </div>
              <div class="col-lg-6">
              <a href="${themeDisplay.getPortalURL()}/web/guest/services" class="request-service" target="_blank">
                <button
                  type="button"
                  class="mx-3 btn tab-btn btn-primary ml-auto my-3 d-block px-3 py-2"
                ><liferay-ui:message key="field-request-service" />
                </button>
                </a>
              </div>
            </div>
            <div class="row">
              <div class="col-lg-12 col-sm-12 mb-4">
               <% if (isTestUser) { %>
              <table class="table table-inbox">
                  <thead>
                    <tr>
                      <th scope="col"><liferay-ui:message key="service-name" /></th>
                      <th scope="col"><liferay-ui:message key="request-number" /></th>
                      <th scope="col"><liferay-ui:message key="service-type" /></th>
                      <th scope="col"><liferay-ui:message key="date" /></th>
                      <th scope="col d-flex"><liferay-ui:message key="status" /> <img src="<%= request.getContextPath() %>/images/arrow-down.png" alt=""></th>
                      <th scope="col"><liferay-ui:message key="actions" /></th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td scope="row"><liferay-ui:message key="first-service-name" /></td>
                      <td>SRV-02252-GKS750</td>
                      <td><liferay-ui:message key="first-service-type" /></td>
                      <td>18/03/2023</td>
                      <td><div class="status">
                          <p class="text-center"><liferay-ui:message key="resolved" /></p>
                      </div></td>
                      <td>
                          <div class="d-flex">
                              <button class="btn font-weight-bold"><img class="t-img" src="<%= request.getContextPath() %>/images/download.png" alt=""><liferay-ui:message key="download" /></button>
                          </div>
                       </td>
                    </tr>
                    <tr>
                      <td scope="row"><liferay-ui:message key="second-service-name" /></td>
                      <td>SRV-02252-GKS750</td>
                      <td><liferay-ui:message key="first-service-type" /></td>
                      <td>18/03/2023</td>
                      <td><div class="statuss">
                          <p class="text-center"><liferay-ui:message key="in-progress" /></p>
                      </div></td>
                      <td></td>
                    </tr>
                  </tbody>
                </table>
                <% } else { %>
               <table class="table table-empty border">
                <tbody>
                  <tr class="">
                    <td class="text-center"><liferay-ui:message key="no-service-request-found" /></td>
                  </tr>
                </tbody>
              </table>
               <% } %>
              </div>
            </div>
          </div>
        </div>

        <div
          class="tab-pane fade"
          id="nav-customer"
          role="tabpanel"
          aria-labelledby="nav-customer-tab"
        >
          <div class="border rounded">
            <div class="row">
              <div class="col-lg-12">
                <div class="mx-3 my-2 inbox-doc-title">
                  <h4><liferay-ui:message key="field.customer-feedback" /></h4>
                  <p><liferay-ui:message key="field.description" /></p>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-lg-12 col-sm-12 mb-4">
               <% if (isTestUser) { %>
               <table class="table table-inbox">
                  <thead>
                    <tr class="">
                      <th scope="col"><liferay-ui:message key="service-name" /></th>
                      <th scope="col"><liferay-ui:message key="feedback-type" /></th>
                      <th scope="col"><liferay-ui:message key="submission-date" /></th>
                      <th scope="col"><liferay-ui:message key="status" /> <img src="<%= request.getContextPath() %>/images/arrow-down.png" alt=""></th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td scope="row"><liferay-ui:message key="first-service-name" /></td>
                      <td><liferay-ui:message key="complaint" /></td>
                      <td>18/03/2023</td>
                      <td><div class="status">
                          <p class="text-center"><liferay-ui:message key="resolved" /></p>
                      </div></td>
                    </tr>
                    <tr>
                      <td scope="row"><liferay-ui:message key="second-service-name" /></td>
                      <td><liferay-ui:message key="complaint" /></td>
                      <td>18/03/2023</td>
                      <td><div class="statuss">
                          <p class="text-center"><liferay-ui:message key="in-progress" /></p>
                      </div></td>
                    </tr>
                  </tbody>
                </table>
                 <% } else { %>
               <table class="table table-empty border">
                   <tbody>
                     <tr class="">
                       <td class="text-center"><liferay-ui:message key="no-feedback-found" /></td>
                     </tr>
                   </tbody>
              </table>
              <% } %>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

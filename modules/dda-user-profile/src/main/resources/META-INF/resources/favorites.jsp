<%@ include file="/init.jsp" %>
<%
    UserDetailsDTO userDetailsDTO = (UserDetailsDTO)request.getAttribute("userDetailsDTO");
    String userEmailAddress = userDetailsDTO.getEmailAddress();
    boolean isTestUser = "test@gmail.com".equals(userEmailAddress);
%>

<div
  class="tab-pane fade"
  id="nav-favourite"
  role="tabpanel"
  aria-labelledby="nav-favourite-tab"
>
  <section>
    <% if (isTestUser) { %>
    <div class="container-fluid favourite-data">
      <div class="row">
        <div class="col-lg-7 fav-input">
        <input
                type="text"
                class="fav-sarch my-2 mx-3"
                placeholder="<liferay-ui:message key='favourite-search' />"
        />
        </div>
        <div class="col-lg-5">
         <div class="form-group input-select-wrapper d-flex">
           <label class=" control-label" for="_com_liferay_portal_search_web_internal_sort_portlet_SortPortlet_INSTANCE_gbmy_sortSelection"> Sort By </label>
           <select class="form-control fav-select" id="_com_liferay_portal_search_web_internal_sort_portlet_SortPortlet_INSTANCE_gbmy_sortSelection" name="_com_liferay_portal_search_web_internal_sort_portlet_SortPortlet_INSTANCE_gbmy_sortSelection">
              <option class="" selected="" value="assetTagNames.raw+"> Featured First </option> <option class="" value="modified-"> Latest </option>
              <option class="" value="modified+"> Oldest </option> <option class="" value="name_sortable+"> A to Z </option> <option class="" value="name_sortable-"> Z to A </option>
            </select>
           </div>
        </div>
      </div>
    </div>
    <div class="container">
      <div class="row">
        <div class="col-lg-12">
          <form
            id="filters"
            class="max-w-3xl mx-auto flex justify-center p-4"
          ></form>
          <div class="wrapper max-w-3xl mx-auto px-3">
            <div class="item my-2 p-4">
              <div class="fav-img border p-2">
                <img
                  class="mx-auto d-block"
                  width="34px"
                  src="<%= request.getContextPath() %>/images/favourites.png"
                  alt=""
                />
              </div>
              <div class="d-flex my-3">
                <div class="d-flex pl-3">
                  <div class="fav-business px-2 mt-2">
                  <liferay-ui:message key="business-and-employment" />
                  </div>
                  <div class="fav-freezone px-2 mt-2 mx-2">
                  <liferay-ui:message key="dubai-airport-freezone" />
                  </div>
                  <div class="fav-licences px-2 mt-2"><liferay-ui:message key="licenses" /></div>
                </div>
                <div class="d-flex ml-auto d-block">
                  <div>
                    <img src="<%= request.getContextPath() %>/images/like.png" alt="" />
                  </div>
                  <div class="mx-3">
                    <img src="<%= request.getContextPath() %>/images/link.png" alt="" />
                  </div>
                  <div>
                    <img src="<%= request.getContextPath() %>/images/message.png" alt="" />
                  </div>
                </div>
              </div>

              <div class="d-flex my-4">
                <div class="pl-3">
                  <h4 class="font-weight-bold"><liferay-ui:message key="title-of-the-document" /></h4>
                </div>
                <div class="ml-auto d-block">
                  <img src="<%= request.getContextPath() %>/images/Api.png" alt="" />
                </div>
              </div>
            </div>

            <div class="item my-5 p-4">
              <div class="fav-img border p-2 ">
                <img
                  class="mx-auto d-block"
                  width="34px"
                  src="<%= request.getContextPath() %>/images/favourites.png"
                  alt=""
                />
              </div>
              <div class="d-flex my-3">
                <div class="d-flex pl-3">
                  <div class="fav-business px-2 mt-2">
                   <liferay-ui:message key="business-and-employment" />
                  </div>
                  <div class="fav-freezone px-2 mt-2 mx-2">
                     <liferay-ui:message key="dubai-airport-freezone" />
                  </div>
                  <div class="fav-licences px-2 mt-2"><liferay-ui:message key="licenses" /></div>
                </div>
                <div class="d-flex ml-auto d-block">
                  <div>
                    <img src="<%= request.getContextPath() %>/images/like.png" alt="" />
                  </div>
                  <div class="mx-3">
                    <img src="<%= request.getContextPath() %>/images/link.png" alt="" />
                  </div>
                  <div>
                    <img src="<%= request.getContextPath() %>/images/message.png" alt="" />
                  </div>
                </div>
              </div>

              <div class="d-flex my-4">
                <div class="pl-3">
                  <h4 class="font-weight-bold"><liferay-ui:message key="title-of-the-document" /></h4>
                </div>
                <div class="ml-auto d-block">
                  <img src="<%= request.getContextPath() %>/images/Api.png" alt="" />
                </div>
              </div>
            </div>
            <div class="item my-5 p-4">
              <div class="fav-img border p-2 ">
                <img
                  class="mx-auto d-block"
                  width="34px"
                  src="<%= request.getContextPath() %>/images/favourites.png"
                  alt=""
                />
              </div>
              <div class="d-flex my-3">
                <div class="d-flex pl-3">
                  <div class="fav-business px-2 mt-2">
                    <liferay-ui:message key="business-and-employment" />
                  </div>
                  <div class="fav-freezone px-2 mt-2 mx-2">
                   <liferay-ui:message key="dubai-airport-freezone" />
                  </div>
                  <div class="fav-licences px-2 mt-2"><liferay-ui:message key="licenses" /></div>
                </div>
                <div class="d-flex ml-auto d-block">
                  <div>
                    <img src="<%= request.getContextPath() %>/images/like.png" alt="" />
                  </div>
                  <div class="mx-3">
                    <img src="<%= request.getContextPath() %>/images/link.png" alt="" />
                  </div>
                  <div>
                    <img src="<%= request.getContextPath() %>/images/message.png" alt="" />
                  </div>
                </div>
              </div>

              <div class="d-flex my-4">
                <div class="pl-3">
                  <h4 class="font-weight-bold"><liferay-ui:message key="title-of-the-document" /></h4>
                </div>
                <div class="ml-auto d-block">
                  <img src="<%= request.getContextPath() %>/images/Api.png" alt="" />
                </div>
              </div>
            </div>
          </div>
          <div class="pagination fav-pagination flex justify-center my-5">
            <button class="prev" id="prev" disabled><liferay-ui:message key="previous" /></button>
            <div id="page-numbers" class="pagination-numbers"></div>
            <button class="next" id="next"><liferay-ui:message key="next" /></button>
          </div>
        </div>
      </div>
    </div>
    <% } else { %>

    <div class="container-fluid favourite">
      <div class="row">
        <div class="col-lg-12">
          <p><liferay-ui:message key="field.item-favourites" /></p>
        </div>
      </div>
      <div class="row">
        <div class="col-lg-12">
          <div class="content">
            <img
              class="mx-auto d-block img-fluid"
              src="<%= request.getContextPath() %>/images/wishlist.png"
              alt=""
            />
            <p class="text-center">
              <liferay-ui:message key="field.favourites-empty" />
            </p>
          </div>
        </div>
      </div>
    </div>
    <% } %>
  </section>
</div>

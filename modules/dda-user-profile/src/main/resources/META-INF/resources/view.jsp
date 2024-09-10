<html lang="en">
<%@ include file="/init.jsp" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<body>
    <section>
        <div class="common-head">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-12">
                          <nav aria-label="">
                            <ol class="breadcrumb px-5 my-4 breadcrumb-profile">
                              <li class="breadcrumb-item"><img src="<%= request.getContextPath() %>/images/img.png" alt=""></li>
                              <li class="breadcrumb-item"><a href="#"><liferay-ui:message key="profile" /></a></li>
                            </ol>
                          </nav>
                    </div>
                </div>
                <div class="top-container row">
                    <img src="<%= user.getPortraitURL(themeDisplay) %>" class="img-fluid profile-image border p-1" width="70">
                    <div class="ml-3">
                        <h5 class="name"><%= user.getFullName() %></h5>
                        <p class="mail my-1"><liferay-ui:message key="field.entity-name" /></p>
                    </div>
                    <a href="<%= themeDisplay.getURLSignOut() %>" class="common-btn ml-auto d-block px-5 font-weight-bold"><liferay-ui:message key="action.LOGOUT" /></a>
                </div>
            </div>
        </div>
    </section>
<section id="tabs">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12 ">
				<nav>
					<div class="nav nav-tabs nav-fill" id="nav-tab" role="tablist">
						<a class="nav-item nav-link" id="nav-inbox-tab" data-toggle="tab" href="#nav-inbox" role="tab" aria-controls="nav-inbox" aria-selected="true"><liferay-ui:message key="inbox" /></a>
						<a class="nav-item nav-link" id="nav-personal-tab" data-toggle="tab" href="#nav-personal" role="tab" aria-controls="nav-personal" aria-selected="false"><liferay-ui:message key="personal-details" /></a>
						<a class="nav-item nav-link" id="nav-favourite-tab" data-toggle="tab" href="#nav-favourite" role="tab" aria-controls="nav-favourite" aria-selected="false"><liferay-ui:message key="field-favourites" /></a>
                       <a class="nav-item nav-link" id="nav-order-tab" data-toggle="tab" href="#nav-order" role="tab" aria-controls="nav-order" aria-selected="false">
                           <liferay-ui:message key="order-history" />
                       </a>
					</div>
				</nav>
				<div class="tab-content px-3 px-sm-0" id="nav-tabContent">
				    <jsp:include page="/inbox.jsp" />
                    <jsp:include page="/details.jsp" />
                    <jsp:include page="/orderhistory.jsp" />
                    <jsp:include page="/favorites.jsp" />
				</div>
            </div>
        </div>
    </div>
</section>
</body>
</html>
<script>
   var activeTab = '<%= ParamUtil.getString(renderRequest, "activeTab") %>'.trim() || '';
</script>

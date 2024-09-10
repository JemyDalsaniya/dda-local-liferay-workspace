<%@ include file="/init.jsp" %>
<portlet:actionURL name='processAction' var="processActionURL"/>
<%    UserDetailsDTO userDetailsDTO = (UserDetailsDTO)request.getAttribute("userDetailsDTO");
      Set<Locale> availableLocales = (Set<Locale>)request.getAttribute("availableLocales");
      List<Country> countries  = (List<Country>) renderRequest.getAttribute("countries");
%>
<div
  class="tab-pane fade"
  id="nav-personal"
  role="tabpanel"
  aria-labelledby="nav-personal-tab"
>
  <form id="userDetailsForm" action="<%= processActionURL %>" method="post">
    <div class="form-row">
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputscreenname"><liferay-ui:message key="field.screen-name" /><span class="estrict"> * </span></label>
        <input
          type="text"
          class="form-control form-bg"
          id="inputscreenname"
          name="<portlet:namespace/>screenName"
          value="<%= userDetailsDTO.getScreenName() %>"
          placeholder=<liferay-ui:message key="test" />
        />
        <span id="screenNameError" class="error-message"></span>
        <span id="ScreenNameAlreadyExists" class="error-message"></span>
      </div>
      <div class="form-group col-md-4 col-lg-4">
              <label for="inputemiratesid"><liferay-ui:message key="field.emirates-Id" /></label>
              <input
                type="text"
                class="form-control form-bg"
                id="inputemiratesid"
                name="<portlet:namespace/>screenName"
                value="<%= userDetailsDTO.getEmiratesId() %>"
                placeholder="132423423423"
                disabled
              />
      </div>
        <div class="form-group col-md-4 col-lg-4">
                 <label for="inputeemail"><liferay-ui:message key="email-address" /></label>
                 <input
                   type="text"
                   class="form-control form-bg"
                   id="inputemiratesid"
                   name="<portlet:namespace/>screenName"
                   value="<%= userDetailsDTO.getEmailAddress() %>"
                   placeholder="test@liferay.com"
                   disabled
                 />
        </div>
    </div>

    <div class="form-row my-4">
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputfirstname"><liferay-ui:message key="field.first-name" /><span class="estrict"> * </span></label>
        <input
          type="firstname"
          class="form-control form-bg"
          id="inputfirstname"
          name="<portlet:namespace/>firstName"
          value="<%= userDetailsDTO.getFirstName() %>"
          placeholder="John"
        />
        <span id="firstNameError" class="error-message"></span>
      </div>
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputlastname"><liferay-ui:message key="field.last-name" /><span class="estrict"> * </span></label>
        <input
          type="lastname"
          class="form-control form-bg"
          id="inputlastname"
          name="<portlet:namespace/>lastName"
          value="<%= userDetailsDTO.getLastName() %>"
          placeholder="Doe"
        />
        <span id="lastNameError" class="error-message"></span>
      </div>
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputmobilenumber"><liferay-ui:message key="label-mobile-number" /><span class="estrict"> * </span></label>
        <input
          type="mobilenumber"
          class="form-control"
          id="inputmobilenumber"
          name="<portlet:namespace/>mobileNumber"
          value="<%= userDetailsDTO.getMobileNumber() %>"
          placeholder="9123456789"
        />
        <span id="phoneError" class="error-message"></span>
      </div>
    </div>
    <div class="form-row my-4">
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputdateofbirth"><liferay-ui:message key="field.birth-date" /></label>
        <input
          type="date"
          class="form-control form-bg"
          id="inputdateofbirth"
          name="<portlet:namespace/>dateOfBirth"
          value="<%= userDetailsDTO.getDateOfBirth() %>"
        />
        <span id="dobError" class="error-message"></span>
      </div>
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputgender"><liferay-ui:message key="gender" /></label>
        <div class="form-control border-0 p-0 gender-radio-group">
          <div class="form-check form-check-inline my-2">
            <input
              class="form-check-input"
              class="form-control"
              type="radio"
              id="inlineRadio1"
              name="<portlet:namespace/>gender"
              value='<liferay-ui:message key="male" />'
              <%= "male".equalsIgnoreCase(userDetailsDTO.getGender()) ? "checked" : "" %>
            />
            <label class="form-check-label" for="inlineRadio1"><liferay-ui:message key="male" /></label>
          </div>
          <div class="form-check form-check-inline">
            <input
              class="form-check-input"
              class="form-control"
              type="radio"
              id="inlineRadio2"
              name="<portlet:namespace/>gender"
              value='<liferay-ui:message key="female" />'
              <%= "female".equalsIgnoreCase(userDetailsDTO.getGender()) ? "checked" : "" %>
            />
            <label class="form-check-label" for="inlineRadio2"><liferay-ui:message key="female" /></label>
          </div>
        </div>
      </div>
    </div>
    <div class="form-row my-4">
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputoccupation"><liferay-ui:message key="label-occupation" /></label>
        <input
          type="occupation"
          class="form-control form-bg"
          id="inputoccupation"
          placeholder="Consultant"
          name="<portlet:namespace/>occupation"
          value="<%= userDetailsDTO.getOccupation() %>"
        />
      </div>
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputlanguage"><liferay-ui:message key="label-preferred-language" /></label>
        <select id="inputlanguage" class="form-control" name="<portlet:namespace/>preferredLanguage">
          <% for (Locale availableLocale : availableLocales) { %>
              <option value="<%= LocaleUtil.toLanguageId(availableLocale) %>" lang="<%= LocaleUtil.toW3cLanguageId(availableLocale) %>"
              <%= userDetailsDTO.getPreferredLanguage().equals(availableLocale.getLanguage()) ? "selected" : "" %>>
                  <%= availableLocale.getDisplayName(availableLocale) %>
              </option>
          <% } %>
        </select>
      </div>
    </div>
    <div class="form-row mt-4">
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputcountry"><liferay-ui:message key="country" /></label>
        <select id="inputcountry" class="form-control form-bg" name="<portlet:namespace/>country">
            <% for (Country country : countries) { %>
            <%= country.getName() %>
                    <option value="<%= country.getA2() %>" <%= (userDetailsDTO.getCountry() != null && userDetailsDTO.getCountry().equals(country.getName())) ? "selected" : "" %>>
                        <%= country.getTitle() %>
                    </option>
            <% } %>
        </select>
      </div>
      <div class="form-group col-md-4 col-lg-4">
        <label for="inputcity"><liferay-ui:message key="city" /><span class="estrict"> * </span></label>
        <input
                  type="text"
                  class="form-control"
                  id="inputcity"
                  name="<portlet:namespace/>city"
                  value="<%= userDetailsDTO.getCity() %>"
                  placeholder="Ahmedabad"
        />
        <span id="cityError" class="error-message"></span>
      </div>
    </div>
    <div class="form-row">
      <div class="form-group col-md-8 col-lg-8">
        <label for="inputaddress"><liferay-ui:message key="address" /></label>
        <input
          type="address"
          class="form-control"
          id="inputaddress"
          name="<portlet:namespace/>address"
          value="<%= userDetailsDTO.getAddress() %>"
          placeholder="Doe"
        />
        <span id="addressError" class="error-message"></span>
      </div>
    </div>
    <button type="submit" class="btn form-btn ml-auto d-block mx-5 my-5">
      <liferay-ui:message key="label-update-profile" />
    </button>
  </form>
</div>
<portlet:resourceURL var="resourceURL" id="checkScreenName" />
<script type="text/javascript">
        var localizedErrorMessages = {
            cityError: '<liferay-ui:message key="cityError" />',
            dobError: '<liferay-ui:message key="dobError" />',
            phoneError: '<liferay-ui:message key="phoneError" />',
            addressError: '<liferay-ui:message key="addressError" />',
            firstNameError: '<liferay-ui:message key="firstNameError" />',
            lastNameError: '<liferay-ui:message key="lastNameError" />',
            screenNameError: '<liferay-ui:message key="screenNameError" />',
            ScreenNameAlreadyExists: '<liferay-ui:message key="screenNameAlreadyExists" />'
        };
        var companyId = <%= themeDisplay.getCompanyId() %>;
        var resourceURL = '<%= resourceURL.toString()%>';
        var namespace = '<portlet:namespace/>';
        var userId = "<%=  themeDisplay.getUserId() %>";
</script>
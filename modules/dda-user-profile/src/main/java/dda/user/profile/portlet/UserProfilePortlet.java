package dda.user.profile.portlet;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.*;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.*;
import dda.user.profile.constants.DdaUserProfilePortletKeys;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

import javax.portlet.*;
import javax.portlet.Portlet;

import dda.user.profile.dto.OrderDTO;
import dda.user.profile.dto.UserDetailsDTO;
import dda.user.profile.service.UserProfileService;
import dda.user.profile.util.UserProfileUtil;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

import static dda.user.profile.constants.DdaUserProfilePortletKeys.RESOURCE_ID;

/**
 * @author root318
 */
@Component(
        property = {
                "com.liferay.portlet.display-category=category.UserServices",
                "com.liferay.portlet.header-portlet-css=/css/main.css",
//                "com.liferay.portlet.footer-portlet-javascript=/js/main.js",
                "com.liferay.portlet.instanceable=true",
                "javax.portlet.display-name=DdaUserProfile",
                "javax.portlet.init-param.template-path=/",
                "javax.portlet.init-param.view-template=/view.jsp",
                "javax.portlet.name=" + DdaUserProfilePortletKeys.DDAUSERPROFILE,
                "javax.portlet.resource-bundle=content.Language",
                "javax.portlet.security-role-ref=power-user,user"
        },
        service = Portlet.class
)
public class UserProfilePortlet extends MVCPortlet {

    private static final Log log = LogFactoryUtil.getLog(UserProfilePortlet.class);

    @Reference
    private UserProfileService userProfileService;

    /**
     * Renders the view of the portlet.
     *
     * @param renderRequest
     * @param renderResponse
     * @throws IOException
     * @throws PortletException
     */
    @Override
    public void render(RenderRequest renderRequest, RenderResponse renderResponse)
            throws IOException, PortletException {
        ThemeDisplay themeDisplay = (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);
        try {
            User user = themeDisplay.getUser();
            Optional<Phone> primaryPhone = userProfileService.getPrimaryPhone(user);
            List<Country> countries = userProfileService.getCountries(themeDisplay.getCompanyId());
            Optional<Address> primaryAddress = userProfileService.getPrimaryAddress(user.getCompanyId(), Contact.class.getName(), user.getContact().getContactId());
            UserDetailsDTO userDetailsDTO = UserProfileUtil.getUserProfile(user, primaryAddress, primaryPhone);
            renderRequest.setAttribute("userDetailsDTO", userDetailsDTO);
            renderRequest.setAttribute("countries", countries);
            renderRequest.setAttribute("availableLocales", LanguageUtil.getAvailableLocales());
            List<OrderDTO> orderDTOList =  userProfileService.getOrderDTOList(user.getUserId(), themeDisplay.getLocale());
            renderRequest.setAttribute("totalOrders", orderDTOList.size());
            renderRequest.setAttribute("orders", orderDTOList);
        } catch (PortalException e) {
            log.error("Error retrieving user or contact information", e);
        }
        super.render(renderRequest, renderResponse);
    }

    /**
     * Processes an action request to update the user's profile.
     *
     * @param actionRequest
     * @param actionResponse
     * @throws PortletException
     * @throws IOException
     */
    @ProcessAction(name = "processAction")
    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws PortletException, IOException {
        try {
            ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
            long orderId = ParamUtil.getLong(actionRequest, "orderId");
            if(Validator.isNotNull(orderId) && orderId!=0) {
                userProfileService.cancelOrder(orderId);
                actionResponse.setRenderParameter("activeTab", "orderhistory");
            }else {
                UserDetailsDTO userDetails = UserProfileUtil.getUserDetails(actionRequest);
                actionResponse.setRenderParameter("activeTab", "personal");
                userProfileService.updateUserProfile(userDetails, themeDisplay.getUser());
                // Update the ThemeDisplay locale
                Locale newLocale = LocaleUtil.fromLanguageId(userDetails.getPreferredLanguage());
                themeDisplay.setLocale(newLocale);
            }
        } catch (Exception e) {
            log.error("Error updating user profile", e);
        }
    }

    /**
     * Processes a resource request to check if a given screen name already exists for a user other than the current user.
     * @param resourceRequest
     * @param resourceResponse
     * @throws IOException
     * @throws PortletException
     */
    @Override
    public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException, PortletException {
        String resourceID = resourceRequest.getResourceID();
        if (RESOURCE_ID.equals(resourceID)) {
            String screenName = ParamUtil.getString(resourceRequest, "screenName");
            long currentUserId = ParamUtil.getLong(resourceRequest, "userId");
            boolean exists = false;
            try {
                long userId = UserLocalServiceUtil.getUserIdByScreenName(PortalUtil.getCompanyId(resourceRequest), screenName);
                if (userId != 0 && userId != currentUserId) {
                    exists = true;
                }
            } catch (Exception e) {
                log.error("Exception while getting screen name "+e.getMessage());
            }
            JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
            jsonObject.put("exists", exists);
            resourceResponse.setContentType("application/json");
            PrintWriter writer = resourceResponse.getWriter();
            writer.write(jsonObject.toString());
        }
        super.serveResource(resourceRequest, resourceResponse);
    }


}

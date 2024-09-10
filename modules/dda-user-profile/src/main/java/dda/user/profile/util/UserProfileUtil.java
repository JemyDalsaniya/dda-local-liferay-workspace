package dda.user.profile.util;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.Address;
import com.liferay.portal.kernel.model.Phone;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import dda.user.profile.dto.UserDetailsDTO;

import javax.portlet.ActionRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Optional;

import static dda.user.profile.constants.DdaUserProfilePortletKeys.DATE_FORMAT;
import static dda.user.profile.constants.DdaUserProfilePortletKeys.EMIRATES_ID;

/**
 * Utility class for handling user profile operations.
 */
public class UserProfileUtil {

    static Log log = LogFactoryUtil.getLog(UserProfileUtil.class.getName());

    /**
     * Extracts user details from the given action request.
     *
     * @param actionRequest
     * @return
     */
    public static UserDetailsDTO getUserDetails(ActionRequest actionRequest) {
        UserDetailsDTO userDetails = new UserDetailsDTO();
        userDetails.setScreenName(ParamUtil.getString(actionRequest, "screenName"));
        userDetails.setFirstName(ParamUtil.getString(actionRequest, "firstName"));
        userDetails.setLastName(ParamUtil.getString(actionRequest, "lastName"));
        userDetails.setDateOfBirth(ParamUtil.getString(actionRequest, "dateOfBirth"));
        userDetails.setGender(ParamUtil.getString(actionRequest, "gender"));
        userDetails.setOccupation(ParamUtil.getString(actionRequest, "occupation"));
        userDetails.setPreferredLanguage(ParamUtil.getString(actionRequest, "preferredLanguage"));
        userDetails.setCountry(ParamUtil.getString(actionRequest, "country"));
        userDetails.setAddress(ParamUtil.getString(actionRequest, "address"));
        userDetails.setCity(ParamUtil.getString(actionRequest, "city"));
        userDetails.setZipcode(String.valueOf(320008));
        userDetails.setMobileNumber(ParamUtil.getString(actionRequest, "mobileNumber"));
        return userDetails;
    }

    /**
     * Constructs a {@link UserDetailsDTO} from the provided user, address, and phone information.
     *
     * @param user
     * @param optionalAddress
     * @param optionalPhone
     * @return
     */
    public static UserDetailsDTO getUserProfile(User user, Optional<Address> optionalAddress, Optional<Phone> optionalPhone) {
        UserDetailsDTO dto = new UserDetailsDTO();
        if (Validator.isNotNull(user)) {
            dto.setScreenName(user.getScreenName());
            dto.setFirstName(user.getFirstName());
            dto.setLastName(user.getLastName());
            dto.setEmailAddress(user.getEmailAddress());
            Long emiratesId = (Long) user.getExpandoBridge().getAttribute(EMIRATES_ID);
            if(Validator.isNull(emiratesId)){
                dto.setEmiratesId(String.valueOf(0));
            }
            dto.setEmiratesId(String.valueOf(emiratesId));
            try {
                dto.setDateOfBirth(formatDate(user.getBirthday(), DATE_FORMAT));
            } catch (PortalException e) {
                log.error("While getting date of birth");
            }
            try {
                dto.setGender(user.isMale() ? "male" : "female");

            } catch (PortalException e) {
                log.error("While getting gender");
            }
            Locale userLocale = user.getLocale();
            dto.setOccupation(user.getJobTitle());
            dto.setPreferredLanguage(userLocale.getLanguage());
        }

        if (Validator.isNotNull(optionalAddress) && optionalAddress.isPresent()) {
            Address address = optionalAddress.get();
            dto.setCountry(address.getCountry() != null ? address.getCountry().getName() : "");
            dto.setAddress(address.getStreet1());
            dto.setZipcode(address.getZip());
            dto.setCity(address.getCity());
        }

        if (Validator.isNotNull(optionalPhone) && optionalPhone.isPresent()) {
            Phone phone = optionalPhone.get();
            dto.setMobileNumber(phone.getNumber());
        }
        return dto;
    }

    /**
     * Parses a date string into a {@link Date} object.
     *
     * @param dateString
     * @return
     * @throws ParseException
     */
    public static Date parseDate(String dateString) throws ParseException {
        if (dateString == null || dateString.trim().isEmpty()) {
            String formattedDate = DATE_FORMAT.format(new Date());
            return DATE_FORMAT.parse(formattedDate);
        }
        return DATE_FORMAT.parse(dateString);
    }

    /**
     * Formats a {@link Date} object into a string.
     *
     * @param date
     * @return
     */
    public static String formatDate(Date date, SimpleDateFormat dateFormat) {
        if (date == null) {
            date = new Date();
        }
        return dateFormat.format(date);
    }


}

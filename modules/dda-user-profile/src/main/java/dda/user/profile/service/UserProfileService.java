package dda.user.profile.service;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.model.Address;
import com.liferay.portal.kernel.model.Country;
import com.liferay.portal.kernel.model.Phone;
import com.liferay.portal.kernel.model.User;
import dda.user.profile.dto.OrderDTO;
import dda.user.profile.dto.UserDetailsDTO;
import org.osgi.annotation.versioning.ProviderType;

import java.util.List;
import java.util.Locale;
import java.util.Optional;

/**
 * Provides methods for managing user profiles.
 */
@ProviderType
public interface UserProfileService {

    /**
     * Retrieves the primary phone number for the specified user.
     *
     * @param user
     * @return
     */
    Optional<Phone> getPrimaryPhone(User user);

    /**
     * Retrieves a list of countries for a given company ID.
     *
     * @param companyId
     * @return
     */
    List<Country> getCountries(long companyId);

    /**
     * Retrieves the primary address associated with a given entity.
     *
     * @param companyId
     * @param className
     * @param classPK
     * @return
     */
    Optional<Address> getPrimaryAddress(long companyId, String className, long classPK);

    /**
     * Updates the user profile with the provided details.
     *
     * @param userDetails
     * @param user
     */
    void updateUserProfile(UserDetailsDTO userDetails, User user);

    /**
     * Fetch the order list data
     * @param userId
     * @param locale
     * @return
     */
    List<OrderDTO> getOrderDTOList(long userId, Locale locale);

    /**
     * To cancel the order
     * @param orderId
     * @throws PortalException
     */
    void cancelOrder(long orderId) throws PortalException;

}

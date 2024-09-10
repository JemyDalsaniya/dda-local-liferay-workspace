package dda.user.profile.service.impl;

import com.liferay.commerce.constants.CommerceOrderConstants;
import com.liferay.commerce.model.CommerceOrder;
import com.liferay.commerce.model.CommerceOrderItem;
import com.liferay.commerce.model.CommerceOrderItemTable;
import com.liferay.commerce.model.CommerceOrderTable;
import com.liferay.commerce.product.model.CPAttachmentFileEntry;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.commerce.product.model.CProduct;
import com.liferay.commerce.product.service.CPDefinitionLocalServiceUtil;
import com.liferay.commerce.product.service.CProductLocalServiceUtil;
import com.liferay.commerce.service.CommerceOrderItemLocalServiceUtil;
import com.liferay.commerce.service.CommerceOrderLocalService;
import com.liferay.commerce.service.CommerceOrderLocalServiceUtil;
import com.liferay.counter.kernel.service.CounterLocalService;
import com.liferay.petra.sql.dsl.DSLQueryFactoryUtil;
import com.liferay.petra.sql.dsl.query.DSLQuery;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.*;
import com.liferay.portal.kernel.service.*;
import com.liferay.portal.kernel.util.Validator;
import dda.user.profile.dto.OrderDTO;
import dda.user.profile.dto.UserDetailsDTO;
import dda.user.profile.service.UserProfileService;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ServiceScope;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

import static dda.user.profile.constants.DdaUserProfilePortletKeys.*;
import static dda.user.profile.util.UserProfileUtil.formatDate;
import static dda.user.profile.util.UserProfileUtil.parseDate;

/**
 * Implementation of the {@link UserProfileService} for managing user profile updates.
 * <p>
 * This class provides methods to retrieve and update user profile information, including
 * user phones, addresses, and other profile details.
 * </p>
 */
@Component(
        scope = ServiceScope.PROTOTYPE,
        service = UserProfileService.class
)
public class UserProfileServiceImpl implements UserProfileService {


    Log log = LogFactoryUtil.getLog(UserProfileServiceImpl.class.getName());

    /**
     * Retrieves the primary phone of a user.
     *
     * @param user
     * @return
     */
    @Override
    public Optional<Phone> getPrimaryPhone(User user) {
        return user.getPhones().stream()
                .filter(Phone::isPrimary)
                .findFirst();
    }

    /**
     * Retrieves a list of countries for a given company ID.
     *
     * @param companyId
     * @return
     */
    @Override
    public List<Country> getCountries(long companyId) {
        return countryLocalService.getCompanyCountries(companyId);
    }

    /**
     * Retrieves the primary address of a user.
     *
     * @param companyId
     * @param className
     * @param classPK
     * @return
     */
    @Override
    public Optional<Address> getPrimaryAddress(long companyId, String className, long classPK) {
        return addressLocalService.getAddresses(companyId, className, classPK).stream()
                .filter(Address::isPrimary)
                .findFirst();
    }

    /**
     * Updates the user profile with the given details.
     *
     * @param userDetails
     * @param user
     */
    @Override
    public void updateUserProfile(UserDetailsDTO userDetails, User user) {
        // Validate user details
        if(validateUserDetails(userDetails)) {
            try {
                user.setJobTitle(userDetails.getOccupation());
                user.setLanguageId(userDetails.getPreferredLanguage());
                user.setScreenName(userDetails.getScreenName());
                user.setFirstName(userDetails.getFirstName());
                user.setLastName(userDetails.getLastName());
                Contact contact = user.getContact();
                if (contact != null) {
                    contact.setBirthday(parseDate(userDetails.getDateOfBirth()));
                    contact.setMale(userDetails.getGender().equalsIgnoreCase(LanguageUtil.get(user.getLocale(), "male")));
                    user.setContact(contact);
                }
                user = userLocalService.updateUser(user);
                updateUserContact(user, userDetails.getMobileNumber());
                long contactId = user.getContactId();
                updateAddress(userDetails, user.getUserId(), user.getCompanyId(), contactId);
            } catch (Exception e) {
                log.error("Error updating user profile", e);
            }
        }else{
            log.info("userDetails are blank");
        }
    }

    /**
     * To check the user details are exists or not
     * @param userDetails
     * @return
     */
    private boolean validateUserDetails(UserDetailsDTO userDetails) {
        if (userDetails == null) {
            return false;
        }
        // Validate user fields
        return Validator.isNotNull(userDetails.getPreferredLanguage()) &&
                Validator.isNotNull(userDetails.getScreenName()) &&
                Validator.isNotNull(userDetails.getFirstName()) &&
                Validator.isNotNull(userDetails.getLastName()) &&
                Validator.isNotNull(userDetails.getDateOfBirth()) &&
                Validator.isNotNull(userDetails.getGender()) &&
                Validator.isNotNull(userDetails.getMobileNumber()) &&
                // Validate contact fields
                Validator.isNotNull(userDetails.getCountry()) &&
                Validator.isNotNull(userDetails.getAddress()) &&
                Validator.isNotNull(userDetails.getCity());
    }

    /**
     * Updates or creates a phone record for the user.
     *
     * @param user
     * @param mobileNumber
     */
    private void updateUserContact(User user, String mobileNumber) {
        try {
            if (mobileNumber == null) {
                log.info("Mobile number is null. Skipping update.");
                return;
            }
            Optional<Phone> primaryPhone = getPrimaryPhone(user);
            long listTypeId = listTypeLocalService.getListTypeId(user.getCompanyId(), CUSTOM_PHONE_TYPE, ListTypeConstants.ADDRESS_PHONE);
            if (primaryPhone.isPresent()) {
                Phone phone = primaryPhone.get();
                phone.setNumber(mobileNumber);
                phone.setUserId(user.getUserId());
                phone.setUserName(user.getFullName());
                phone.setClassPK(user.getContactId());
                phone.setCompanyId(user.getCompanyId());
                phone.setListTypeId(listTypeId);
                phone.setPrimary(true);
                phoneLocalService.updatePhone(phone);
            } else {
                Phone newPhone = phoneLocalService.createPhone(counterLocalService.increment());
                ClassName contactClassName = ClassNameLocalServiceUtil.getClassName(Contact.class.getName());
                newPhone.setUserId(user.getUserId());
                newPhone.setUserName(user.getFullName());
                newPhone.setClassPK(user.getContactId());
                newPhone.setCompanyId(user.getCompanyId());
                newPhone.setNumber(mobileNumber);
                newPhone.setListTypeId(listTypeId);
                newPhone.setClassNameId(contactClassName.getClassNameId());
                newPhone.setPrimary(true);
                phoneLocalService.addPhone(newPhone);
            }
        } catch (Exception e) {
            log.error("Error updating user contact: " + e.getMessage(), e);
        }
    }

    /**
     * Updates or creates an address record for the user.
     *
     * @param userDetails
     * @param userId
     * @param companyId
     * @param contactId
     */
    private void updateAddress(UserDetailsDTO userDetails, long userId, long companyId, long contactId) {
        try {
            Country country = null;
            try {
                country = countryLocalService.getCountryByA2(companyId, userDetails.getCountry());
            } catch (PortalException e) {
                log.error("Exception while getting county " + e.getMessage());
            }
            long countryId = Validator.isNotNull(country) ? country.getCountryId() : 0;
            Optional<Address> existingAddress = getPrimaryAddress(companyId, Contact.class.getName(), contactId);
            if (existingAddress.isPresent()) {
                Address address = existingAddress.get();
                address.setStreet1(userDetails.getAddress());
                address.setCountryId(countryId);
                address.setCity(userDetails.getCity());
                address.setZip(userDetails.getZipcode());
                address.setUserId(userId);
                address.setCompanyId(companyId);
                address.setClassName(Contact.class.getName());
                address.setClassPK(contactId);
                address.setPrimary(true);
                addressLocalService.updateAddress(address);
            } else {
                Address newAddress = addressLocalService.createAddress(counterLocalService.increment());
                newAddress.setUserId(userId);
                newAddress.setCompanyId(companyId);
                newAddress.setClassName(Contact.class.getName());
                newAddress.setClassPK(contactId);
                newAddress.setStreet1(userDetails.getAddress());
                newAddress.setCity(userDetails.getCity());
                newAddress.setZip(userDetails.getZipcode());
                newAddress.setCountryId(countryId);
                newAddress.setPrimary(true);
                addressLocalService.addAddress(newAddress);
            }
        } catch (Exception e) {
            log.error("Error updating user address: " + e.getMessage());
        }
    }

    /**
     * To fetch the order list
     * @param userId
     * @param locale
     * @return
     */
    public List<OrderDTO> getOrderDTOList(long userId, Locale locale) {

        DSLQuery query = DSLQueryFactoryUtil.select(
                        CommerceOrderTable.INSTANCE.commerceOrderId,
                        CommerceOrderTable.INSTANCE.orderDate,
                        CommerceOrderTable.INSTANCE.orderStatus,
                        CommerceOrderTable.INSTANCE.total,
                        CommerceOrderTable.INSTANCE.commerceAccountId).
                from(CommerceOrderTable.INSTANCE).where(CommerceOrderTable.INSTANCE.userId.eq(userId));

        List<Object[]> orders = CommerceOrderLocalServiceUtil.dslQuery(query);
        // Map query results to OrderDTO list
        List<OrderDTO> orderDTOList = orders.stream()
                .filter(order -> hasCommerceOrderItem((Long) order[0]))  // New filter method
                .map(order -> getOrder(order,locale))
                .collect(Collectors.toList());
        return orderDTOList;
    }


    /**
     * To fetch the single order
     * @param order
     * @param locale
     * @return
     */
    private OrderDTO getOrder(Object[] order,Locale locale) {
        List<CPAttachmentFileEntry> productImageList;
        String imageURL = StringPool.BLANK;
        Long orderId = (Long) order[0];// commerceOrderId
        Date orderDate = (Date) order[1]; // orderDate
        int orderStatus = (int) order[2]; // orderStatus
        BigDecimal total = (BigDecimal) order[3]; // total
        Long accountId = (Long) order[4]; //accountId
        List<CommerceOrderItem> items = CommerceOrderItemLocalServiceUtil.getCommerceOrderItems(orderId, -1, -1);
        CommerceOrderItem orderItem = null;
        if (!items.isEmpty()) {
            orderItem = items.get(0);
        }
        long commerceOrderItemId = 0;
        String date = StringPool.BLANK;
        String productName = StringPool.BLANK;
        String subscriptionType = StringPool.BLANK;
        String status = StringPool.BLANK;
        BigDecimal quantity = BigDecimal.valueOf(0);
        String productDescription = StringPool.BLANK;
        if (Validator.isNotNull(orderItem)) {

            quantity = orderItem.getQuantity();
            commerceOrderItemId = orderItem.getCommerceOrderItemId();
            subscriptionType = orderItem.getSku();
            if (subscriptionType.toLowerCase().contains(BRONZE)) {
                subscriptionType = LanguageUtil.get(locale, BRONZE);
            } else if (subscriptionType.toLowerCase().contains(SILVER)) {
                subscriptionType = LanguageUtil.get(locale, SILVER);
            } else if (subscriptionType.toLowerCase().contains(GOLD)) {
                subscriptionType = LanguageUtil.get(locale, GOLD);
            }
            date = formatDate(orderDate, DATE_FORMAT_DAY_MONTH_YEAR);
            productDescription = StringPool.BLANK;
            productName = StringPool.BLANK;
            try {
                long productId = orderItem.getCProductId();
                CProduct cProduct = CProductLocalServiceUtil.getCProduct(productId);
                CPDefinition cpDefinition = CPDefinitionLocalServiceUtil.getCPDefinition(cProduct.getPublishedCPDefinitionId());
                productName = cpDefinition.getName(LanguageUtil.getLanguageId(locale));
                productDescription = cpDefinition.getShortDescription(LanguageUtil.getLanguageId(locale));
                imageURL = cpDefinition.getDefaultImageThumbnailSrc(accountId);
            } catch (PortalException e) {
                log.error("Exception while fetching cp definition " + e.getMessage());
            } catch (Exception e) {
                log.error("Exception while fetching image " + e.getMessage());
            }
            status = LanguageUtil.get(locale, CommerceOrderConstants.getOrderStatusLabel(orderStatus));
        }

        return new OrderDTO(String.valueOf(orderId), String.valueOf(commerceOrderItemId), date, productName, subscriptionType, status, String.format("%.2f", total), String.format("%.2f", quantity), productDescription, imageURL);
    }

    /**
     * To cancel the order using status
     * @param orderId
     * @throws PortalException
     */
    @Override
    public void cancelOrder(long orderId) throws PortalException {
        CommerceOrder commerceOrder = commerceOrderLocalService.getCommerceOrder(orderId);
        commerceOrder.setOrderStatus(CommerceOrderConstants.ORDER_STATUS_CANCELLED);
        commerceOrderLocalService.updateCommerceOrder(commerceOrder);
    }

    /**
     * Checks if an order has at least one CommerceOrderItem
     * @param orderId
     * @return true if the order has CommerceOrderItem, false otherwise
     */
    private boolean hasCommerceOrderItem(Long orderId) {
        List<CommerceOrderItem> items = CommerceOrderItemLocalServiceUtil.getCommerceOrderItems(orderId, -1, -1);
        return items != null && !items.isEmpty();
    }


    @Reference
    private UserLocalService userLocalService;

    @Reference
    private CountryLocalService countryLocalService;

    @Reference
    private AddressLocalService addressLocalService;

    @Reference
    private PhoneLocalService phoneLocalService;

    @Reference
    private ContactLocalService contactLocalService;

    @Reference
    private CounterLocalService counterLocalService;

    @Reference
    private ListTypeLocalService listTypeLocalService;

    @Reference
    private CommerceOrderLocalService commerceOrderLocalService;
}

package dda.marketplace.service.impl;

import com.liferay.asset.kernel.service.AssetTagLocalServiceUtil;
import com.liferay.commerce.product.model.CPAttachmentFileEntry;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.commerce.product.model.CPDefinitionLink;
import com.liferay.commerce.product.service.CPDefinitionLinkLocalServiceUtil;
import com.liferay.commerce.product.service.CPDefinitionLocalServiceUtil;
import com.liferay.object.model.ObjectDefinition;
import com.liferay.object.model.ObjectEntry;
import com.liferay.object.model.ObjectField;
import com.liferay.object.model.ObjectRelationship;
import com.liferay.object.service.ObjectDefinitionLocalServiceUtil;
import com.liferay.object.service.ObjectEntryLocalServiceUtil;
import com.liferay.object.service.ObjectFieldLocalServiceUtil;
import com.liferay.object.service.ObjectRelationshipLocalServiceUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Validator;
import dda.marketplace.service.DdaMarketplaceService;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.ServiceScope;

import java.io.Serializable;
import java.util.*;
import java.util.stream.Collectors;

import static dda.marketplace.constants.DdaMarketplacePortletKeys.*;
import static dda.marketplace.util.DdaMarketplaceUtil.getProductCategories;

@Component(
        service = DdaMarketplaceService.class,
        scope = ServiceScope.PROTOTYPE
)
public class DdaMarketplaceServiceImpl implements DdaMarketplaceService {

    private static final Log log = LogFactoryUtil.getLog(DdaMarketplaceServiceImpl.class);

    /**
     * Retrieves a list of all product definitions.
     *
     * @return a list of all CPDefinition objects representing the products
     */
    @Override
    public List<CPDefinition> getAllProductList() {
        return CPDefinitionLocalServiceUtil.getCPDefinitions(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
    }

    /**
     * Retrieves the details of a specific product.
     *
     * @param productId the ID of the product
     * @return a CPDefinition object representing the product details
     * @throws PortalException if an error occurs while fetching the product details
     */
    @Override
    public CPDefinition getProductDetails(long productId) throws PortalException {
        return CPDefinitionLocalServiceUtil.getCPDefinition(productId);
    }

    /**
     * Retrieves related objects for a specific product.
     *
     * @param productId the ID of the product for which related objects are being retrieved
     * @param locale the locale used for localizing relationship labels
     * @return a map where the key is a string representing the localized relationship label and the value is
     *         a map containing related ObjectEntry objects and their field labels
     * @throws PortalException if an error occurs while fetching or processing the related objects
     */
    @Override
    public Map<String, Object> getRelatedObjects(long productId , Locale locale) throws PortalException {
        Map<String, Object> relatedObjects = new LinkedHashMap<>();
        List<ObjectRelationship> objectRelationships = ObjectRelationshipLocalServiceUtil.getObjectRelationships(QueryUtil.ALL_POS, QueryUtil.ALL_POS);

        if (Validator.isNotNull(objectRelationships)) {
            long groupId = getProductDetails(productId).getGroupId();
            for (ObjectRelationship relationship : objectRelationships) {
                processObjectRelationship(relationship, groupId, productId, relatedObjects, locale);
            }
        }

        return relatedObjects;
    }



    /**
     * Processes an object relationship and populates the related objects map with filtered entries and field labels.
     *
     * @param relationship the object relationship to process
     * @param groupId the group ID associated with the entries
     * @param productId the ID of the product for which related objects are being retrieved
     * @param relatedObjects the map to populate with related objects, where the key is the localized relationship label
     *                       and the value is a map containing filtered entries and field labels
     * @param locale the locale used for localizing relationship labels and field labels
     * @throws PortalException if an error occurs while processing the relationship or retrieving the related objects
     */
    private void processObjectRelationship(ObjectRelationship relationship, long groupId, long productId, Map<String, Object> relatedObjects, Locale locale) throws PortalException {
        ObjectDefinition relatedObjectDefinition = ObjectDefinitionLocalServiceUtil.getObjectDefinition(relationship.getObjectDefinitionId2());

        if (Validator.isNotNull(relatedObjectDefinition) && !relatedObjectDefinition.isSystem()) {
            long objectRelationshipId = relationship.getObjectRelationshipId();

            List<ObjectEntry> entries = ObjectEntryLocalServiceUtil.getOneToManyObjectEntries(
                    groupId, objectRelationshipId, productId, true, "", QueryUtil.ALL_POS, QueryUtil.ALL_POS
            );

            List<ObjectEntry> filteredEntries = new ArrayList<>();

            for (ObjectEntry entry : entries) {
                Map<String, Serializable> filteredValues = filterEntries(entry.getValues());

                if (!filteredValues.isEmpty()) {
                    entry.setValues(filteredValues);
                    filteredEntries.add(entry);
                    log.debug("Filtered entry values: " + filteredValues);
                }
            }

            if (!filteredEntries.isEmpty()) {
                // Fetch custom object field labels
                Map<String, String> fieldLabels = new HashMap<>();
                for (ObjectField objectField : ObjectFieldLocalServiceUtil.getCustomObjectFields(relatedObjectDefinition.getObjectDefinitionId())) {
                    String businessType = objectField.getBusinessType();

                    // Exclude fields with type "Relationship" or equivalent
                    if (!IS_RELATIONSHIP_FIELD.equalsIgnoreCase(businessType)) {
                        String label = objectField.getLabel(locale);
                        fieldLabels.put(objectField.getName(), label);
                    }
                }

                // Store field labels along with the entries
                Map<String, Object> result = new HashMap<>();
                result.put("entries", filteredEntries);
                result.put("fieldLabels", fieldLabels);

                relatedObjects.put(relationship.getLabel(locale), result);
            }
        }
    }

    /**
     * Filters the entries to exclude certain keys.
     *
     * @param originalMap the original map of entry values
     * @return a map with filtered entry values
     */
    public Map<String, Serializable> filterEntries(Map<String, Serializable> originalMap) {
        return originalMap.entrySet().stream()
                .filter(entry -> !entry.getKey().startsWith("c_") && !entry.getKey().startsWith("r_"))
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> entry.getValue() != null ? entry.getValue() : ""
                ));
    }


    /**
     * Retrieves and processes the attachment details for a given product.
     *
     * @param productId the ID of the product whose attachments are to be retrieved
     * @param accountId the ID of the account associated with the attachments
     * @param themeDisplay the base URL of the portal
     * @return a list of maps containing the attachment details
     * @throws PortalException if an error occurs while fetching the attachments or file details
     */
    @Override
    public List<Map<String, Object>> getProductAttachments(long productId, long accountId, ThemeDisplay themeDisplay) throws PortalException {
        String fileIconURL = themeDisplay.getPathThemeImages()+"/common/Pdf-img.png";
        String previewIconURL = themeDisplay.getPathThemeImages() + "/common/view-icon.png";
        String downloadIconURL = themeDisplay.getPathThemeImages() + "/common/download-img.png";

        List<CPAttachmentFileEntry> fileAttachments = CPDefinitionLocalServiceUtil.getCPDefinition(productId).getCPAttachmentFileEntries(1, 0);
        List<Map<String, Object>> attachmentDetailsList = new ArrayList<>();
        if (fileAttachments != null && !fileAttachments.isEmpty()) {
            for (CPAttachmentFileEntry fileAttachment : fileAttachments) {
                if (fileAttachment != null) {
                    Map<String, Object> attachmentDetails = new HashMap<>();
                    boolean hasTagName = false;
                    try {
                        String[] tagNames = AssetTagLocalServiceUtil.getTagNames(CPAttachmentFileEntry.class.getName(), fileAttachment.getCPAttachmentFileEntryId());
                        for (String tag : tagNames) {
                            if (tag.contains(IS_CHECKOUT_DOCUMENT)) {
                                hasTagName = true;
                                break; // No need to check further, we found a match
                            }
                        }
                        String fileName = fileAttachment.getTitle(themeDisplay.getLocale());
                        long fileSize = fileAttachment.fetchFileEntry().getSize();
                        Date date = fileAttachment.getCreateDate();
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(date);
                        int year = calendar.get(Calendar.YEAR);

                        String downloadURL = "/o/commerce-media/accounts/" + accountId + "/attachments/" + fileAttachment.getCPAttachmentFileEntryId() + "?download=true";
                        String previewURL = "/o/commerce-media/accounts/" + accountId + "/attachments/" + fileAttachment.getCPAttachmentFileEntryId() + "?download=false";

                        attachmentDetails.put("fileName", fileName);
                        attachmentDetails.put("fileSize", fileSize);
                        attachmentDetails.put("year", year);
                        attachmentDetails.put("fileIconURL", fileIconURL);
                        attachmentDetails.put("downloadURL", downloadURL);
                        attachmentDetails.put("previewURL", previewURL);
                        attachmentDetails.put("previewIconURL", previewIconURL);
                        attachmentDetails.put("downloadIconURL", downloadIconURL);
                        attachmentDetails.put("hasTagName", hasTagName);
                    } catch (PortalException e) {
                        log.error("Exception while fetching file!");
                    }
                    attachmentDetailsList.add(attachmentDetails);
                }
            }
        }

        return attachmentDetailsList;
    }


    /**
     * Retrieves the image attachment file entries for a specific product.
     *
     * @param productId the ID of the product
     * @return a list of CPAttachmentFileEntry objects representing the product image attachments
     * @throws PortalException if an error occurs while fetching the product image attachments
     */
    @Override
    public List<CPAttachmentFileEntry> getProductImageAttachments(long productId) throws PortalException {
        return CPDefinitionLocalServiceUtil.getCPDefinition(productId).getCPAttachmentFileEntries(0, 0);
    }


    /**
     * Checks if the product categories contain a specific category type.
     *
     * @param productCategories a map of product categories where the keys are vocabulary names and the values are lists of category names
     * @param categoryType the category type to check for
     * @return true if the product categories contain the specified category type, false otherwise
     */
    public boolean hasCategoryType(Map<String, List<String>> productCategories, String categoryType) {
        List<String> subscriptionTypes = productCategories.get(SUBSCRIPTION_TYPE_VOCABULARY);
        return subscriptionTypes != null && subscriptionTypes.contains(categoryType);
    }

    /**
     * Checks if the product has a monthly subscription category, localized according to the specified locale.
     *
     * This method retrieves the product categories for the given product ID and locale, and checks if any of the categories
     * match the "Monthly" subscription type.
     *
     * @param cpDefinitionId the ID of the CPDefinition to check.
     * @param locale         The locale used to localize the product categories. This affects the category names and how they are interpreted.
     *
     * @return true if the product has a category for monthly subscriptions, false otherwise.
     */
    @Override
    public boolean hasMonthlySubscription(long cpDefinitionId, Locale locale) {
        Map<String, List<String>> productCategories = getProductCategories(cpDefinitionId, locale);
        return hasCategoryType(productCategories, "Monthly");
    }

    /**
     * Checks if the product has a yearly subscription category, localized according to the specified locale.
     *
     * This method retrieves the product categories for the given product ID and locale, and checks if any of the categories
     * match the "Yearly" subscription type.
     *
     * @param cpDefinitionId the ID of the CPDefinition to check.
     * @param locale         The locale used to localize the product categories. This affects the category names and how they are interpreted.
     *
     * @return true if the product has a category for yearly subscriptions, false otherwise.
     */
    @Override
    public boolean hasYearlySubscription(long cpDefinitionId, Locale locale) {
        Map<String, List<String>> productCategories = getProductCategories(cpDefinitionId, locale);
        return hasCategoryType(productCategories, "Yearly");
    }


    /**
     * Retrieves a list of related products for a given product ID, localized according to the specified locale.
     *
     * This method fetches related products and uses the provided locale to retrieve localized product categories.
     *
     * @param productId  The ID of the product for which related products are to be retrieved.
     * @param locale     The locale used to localize product categories. This affects how category names and other localized fields are presented.
     *
     * @return           A list of {@link CPDefinition} objects representing the related products.
     *
     * @throws PortalException  If an error occurs while fetching the related products, such as issues with accessing the database or retrieving the product definitions.
     */
    @Override
    public List<CPDefinition> getRelatedProducts(long productId, Locale locale) throws PortalException {
        List<CPDefinition> cpDefinitions = new ArrayList<>();
        List<CPDefinitionLink> productRelations =  CPDefinitionLinkLocalServiceUtil.getCPDefinitionLinks(productId,"related");
        for(CPDefinitionLink relatedProduct: productRelations){
            long cpDefinitionId = relatedProduct.getCProduct().getPublishedCPDefinitionId();
            log.debug("getProductCategories:  "+  getProductCategories(cpDefinitionId, locale));
            CPDefinition cpDefinition = CPDefinitionLocalServiceUtil.getCPDefinition(cpDefinitionId);
            if (Validator.isNotNull(cpDefinition)) {
                cpDefinitions.add(cpDefinition);
            }

        }
        return cpDefinitions;

    }

}

package dda.marketplace.service.impl;

import com.liferay.asset.kernel.service.AssetTagLocalServiceUtil;
import com.liferay.commerce.product.model.CPAttachmentFileEntry;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.commerce.product.model.CPDefinitionLink;
import com.liferay.commerce.product.service.CPDefinitionLinkLocalServiceUtil;
import com.liferay.commerce.product.service.CPDefinitionLocalServiceUtil;
import com.liferay.object.model.ObjectDefinition;
import com.liferay.object.model.ObjectEntry;
import com.liferay.object.model.ObjectRelationship;
import com.liferay.object.service.ObjectDefinitionLocalServiceUtil;
import com.liferay.object.service.ObjectEntryLocalServiceUtil;
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

import static dda.marketplace.constants.DdaMarketplacePortletKeys.IS_CHECKOUT_DOCUMENT;
import static dda.marketplace.constants.DdaMarketplacePortletKeys.SUBSCRIPTION_TYPE_VOCABULARY;
import static dda.marketplace.util.DdaMarketplaceUtil.getProductCategories;

@Component(
        service = DdaMarketplaceService.class,
        scope = ServiceScope.PROTOTYPE
)
public class DdaMarketplaceServiceImpl implements DdaMarketplaceService {

    private static final Log _log = LogFactoryUtil.getLog(DdaMarketplaceServiceImpl.class);

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
     * @param productId the ID of the product
     * @return a map where the key is a string representing the relationship and the value is a list of ObjectEntry objects representing the related objects
     * @throws PortalException if an error occurs while fetching the related objects
     */
    @Override
    public Map<String, List<ObjectEntry>> getRelatedObjects(long productId , Locale locale) throws PortalException {
        Map<String, List<ObjectEntry>> relatedObjects = new LinkedHashMap<>();
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
     * Processes an object relationship and populates the related objects map.
     *
     * @param relationship the object relationship to process
     * @param groupId the group ID
     * @param productId the product ID
     * @param relatedObjects the map to populate with related objects
     * @throws PortalException if an error occurs while processing the relationship
     */
    private void processObjectRelationship(ObjectRelationship relationship, long groupId, long productId, Map<String, List<ObjectEntry>> relatedObjects, Locale locale) throws PortalException {
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
                    _log.debug("Filtered entry values: " + filteredValues);
                }
            }

            if (!filteredEntries.isEmpty()) {
                relatedObjects.put(relationship.getLabel(locale), filteredEntries);
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
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
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
        String previewIconURL = themeDisplay.getPathThemeImages() + "/common/view.png";
        String downloadIconURL = themeDisplay.getPathThemeImages() + "/common/download-img.png";
        boolean hasTagName = false;
        List<CPAttachmentFileEntry> fileAttachments = CPDefinitionLocalServiceUtil.getCPDefinition(productId).getCPAttachmentFileEntries(1, 0);
        List<Map<String, Object>> attachmentDetailsList = new ArrayList<>();
        if (fileAttachments != null && !fileAttachments.isEmpty()) {
            for (CPAttachmentFileEntry fileAttachment : fileAttachments) {
                if (fileAttachment != null) {
                    Map<String, Object> attachmentDetails = new HashMap<>();
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
                        _log.error("Exception while fetching file!");
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
     * Checks if the product has a monthly subscription category.
     *
     * @param cpDefinitionId the ID of the CPDefinition to check
     * @return true if the product has a monthly subscription category, false otherwise
     */
    @Override
    public boolean hasMonthlySubscription(long cpDefinitionId) {
        Map<String, List<String>> productCategories = getProductCategories(cpDefinitionId);
        return hasCategoryType(productCategories, "Monthly");
    }

    /**
     * Checks if the product has a yearly subscription category.
     *
     * @param cpDefinitionId the ID of the CPDefinition to check
     * @return true if the product has a yearly subscription category, false otherwise
     */
    @Override
    public boolean hasYearlySubscription(long cpDefinitionId) {
        Map<String, List<String>> productCategories = getProductCategories(cpDefinitionId);
        return hasCategoryType(productCategories, "Yearly");
    }

    @Override
    public List<CPDefinition> getRelatedProducts(long productId) throws PortalException {
        List<CPDefinition> cpDefinitions = new ArrayList<>();
        List<CPDefinitionLink> productRelations =  CPDefinitionLinkLocalServiceUtil.getCPDefinitionLinks(productId,"related");
           for(CPDefinitionLink relatedProduct: productRelations){
               long cpDefinitionId = relatedProduct.getCProduct().getPublishedCPDefinitionId();
               _log.info("getProductCategories:  "+  getProductCategories(cpDefinitionId));
               CPDefinition cpDefinition = CPDefinitionLocalServiceUtil.getCPDefinition(cpDefinitionId);
               if (Validator.isNotNull(cpDefinition)) {
                   cpDefinitions.add(cpDefinition);
               }

           }
        return cpDefinitions;

    }


}

package test.module.service.impl;

import com.liferay.commerce.product.model.CPAttachmentFileEntry;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.commerce.product.service.CPDefinitionLocalServiceUtil;
import com.liferay.object.model.*;
import com.liferay.object.service.ObjectDefinitionLocalServiceUtil;
import com.liferay.object.service.ObjectEntryLocalService;
import com.liferay.object.service.ObjectEntryLocalServiceUtil;
import com.liferay.object.service.ObjectRelationshipLocalServiceUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Validator;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ServiceScope;
import test.module.service.DdaMarketplaceService;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


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
    public Map<String, List<ObjectEntry>> getRelatedObjects(long productId) throws PortalException {
        Map<String, List<ObjectEntry>> relatedObjects = new LinkedHashMap<>();
        List<ObjectRelationship> objectRelationships = ObjectRelationshipLocalServiceUtil.getObjectRelationships(QueryUtil.ALL_POS, QueryUtil.ALL_POS);

        if (Validator.isNotNull(objectRelationships)) {
            long groupId = getProductDetails(productId).getGroupId();
            for (ObjectRelationship relationship : objectRelationships) {
                processObjectRelationship(relationship, groupId, productId, relatedObjects);
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
    private void processObjectRelationship(ObjectRelationship relationship, long groupId, long productId, Map<String, List<ObjectEntry>> relatedObjects) throws PortalException {
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
                    _log.info("Filtered entry values: " + filteredValues);
                }
            }

            if (!filteredEntries.isEmpty()) {
                relatedObjects.put(relationship.getName(), filteredEntries);
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
     * Retrieves the attachment file entries for a specific product.
     *
     * @param productId the ID of the product
     * @return a list of CPAttachmentFileEntry objects representing the product attachments
     * @throws PortalException if an error occurs while fetching the product attachments
     */
    @Override
    public List<CPAttachmentFileEntry> getProductAttachments(long productId) throws PortalException {
        return CPDefinitionLocalServiceUtil.getCPDefinition(productId).getCPAttachmentFileEntries(1, 0);
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

}

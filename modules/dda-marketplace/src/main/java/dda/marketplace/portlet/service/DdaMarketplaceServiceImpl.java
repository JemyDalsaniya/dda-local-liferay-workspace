package dda.marketplace.portlet.service;

import com.liferay.account.service.AccountEntryLocalServiceUtil;
import com.liferay.commerce.price.list.model.CommercePriceEntry;
import com.liferay.commerce.price.list.service.CommercePriceEntryLocalServiceUtil;
import com.liferay.commerce.product.model.*;
import com.liferay.commerce.product.service.CPDefinitionLocalServiceUtil;
import com.liferay.commerce.product.service.CPInstanceLocalServiceUtil;
import com.liferay.object.model.*;
import com.liferay.object.service.ObjectDefinitionLocalServiceUtil;
import com.liferay.object.service.ObjectEntryLocalServiceUtil;
import com.liferay.object.service.ObjectRelationshipLocalServiceUtil;
import com.liferay.petra.sql.dsl.DSLQueryFactoryUtil;
import com.liferay.petra.sql.dsl.query.DSLQuery;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.util.Validator;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.ServiceScope;

import java.io.Serializable;
import java.math.BigDecimal;
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

    @Override
    public List<CPDefinition> getAllProductList() throws PortalException {
        return CPDefinitionLocalServiceUtil.getCPDefinitions(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
    }

    @Override
    public long getCurrentUserAccountId(User user) throws PortalException {
        if (user != null) {
            return AccountEntryLocalServiceUtil.getUserAccountEntries(
                    user.getUserId(), 0L, null, new String[]{"person", "business"}, -1, -1).get(0).getAccountEntryId();
        }
        return 0;
    }

    @Override
    public CPDefinition getProductDetails(long productId) throws PortalException {
        return CPDefinitionLocalServiceUtil.getCPDefinition(productId);
    }

    @Override
    public Map<String, List<ObjectEntry>> getRelatedObjects(long productId) throws PortalException {
        Map<String, List<ObjectEntry>> relatedObjects = new LinkedHashMap<>();
        List<ObjectRelationship> objectRelationships = ObjectRelationshipLocalServiceUtil.getObjectRelationships(QueryUtil.ALL_POS, QueryUtil.ALL_POS);

        if (Validator.isNotNull(objectRelationships)) {
            for (ObjectRelationship relationship : objectRelationships) {
                ObjectDefinition relatedObjectDefinition = ObjectDefinitionLocalServiceUtil.getObjectDefinition(relationship.getObjectDefinitionId2());

                if (Validator.isNotNull(relatedObjectDefinition) && !relatedObjectDefinition.isSystem()) {
                    long objectRelationshipId = relationship.getObjectRelationshipId();
                    long groupId = getProductDetails(productId).getGroupId();

                    List<ObjectEntry> entries = ObjectEntryLocalServiceUtil.getOneToManyObjectEntries(
                            groupId, objectRelationshipId, productId, true, "", QueryUtil.ALL_POS, QueryUtil.ALL_POS
                    );

                    List<ObjectEntry> filteredEntries = new ArrayList<>();

                    for (ObjectEntry entry : entries) {
                        Map<String, Serializable> originalValues = entry.getValues();
                        Map<String, Serializable> filteredValues = filterEntries(originalValues);

                        if (!filteredValues.isEmpty()) {
                            entry.setValues(filteredValues);  // Modify the existing entry
                            filteredEntries.add(entry);
                        }
                        _log.info("Filtered entry values: " + filteredValues);
                    }
                    if (Validator.isNotNull(filteredEntries) && !filteredEntries.isEmpty()) {
                        relatedObjects.put(relationship.getName(), filteredEntries);
                    }

                }
            }
        }
        return relatedObjects;
    }

    public static Map<String, Serializable> filterEntries(Map<String, Serializable> originalMap) {
        return originalMap.entrySet().stream()
                .filter(entry -> !entry.getKey().startsWith("c_") && !entry.getKey().startsWith("r_"))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
    }


    @Override
    public List<CPAttachmentFileEntry> getProductAttachments(long productId) throws PortalException {
        return CPDefinitionLocalServiceUtil.getCPDefinition(productId).getCPAttachmentFileEntries(1,0);
    }


    public static BigDecimal getPrice(CPDefinition product) {
        List<CPInstance> cpInstances = CPInstanceLocalServiceUtil.getCPDefinitionApprovedCPInstances(product.getCPDefinitionId());
        if (!cpInstances.isEmpty()) {
            String cpInstanceUuid = cpInstances.get(0).getCPInstanceUuid();
            CommercePriceEntry commercePriceEntry = CommercePriceEntryLocalServiceUtil.getInstanceBaseCommercePriceEntry(cpInstanceUuid, "price-list", null);
            if (commercePriceEntry != null) {
                return commercePriceEntry.getPrice();
            }
        }
        return BigDecimal.ZERO;
    }

}

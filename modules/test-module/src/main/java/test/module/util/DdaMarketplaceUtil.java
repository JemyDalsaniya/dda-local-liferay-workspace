package test.module.util;

import com.liferay.account.service.AccountEntryLocalServiceUtil;
import com.liferay.asset.kernel.model.AssetCategory;
import com.liferay.asset.kernel.service.AssetCategoryLocalServiceUtil;
import com.liferay.commerce.price.list.model.CommercePriceEntry;
import com.liferay.commerce.price.list.service.CommercePriceEntryLocalServiceUtil;
import com.liferay.commerce.product.model.CPAttachmentFileEntry;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.commerce.product.model.CPInstance;
import com.liferay.commerce.product.service.CPInstanceLocalServiceUtil;
import com.liferay.object.model.ObjectEntry;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ServiceScope;
import test.module.service.DdaMarketplaceService;

import javax.portlet.RenderRequest;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import static test.module.constants.TestModulePortletKeys.PRICE_LIST_TYPE;

@Component(
        service = DdaMarketplaceUtil.class,
        scope = ServiceScope.PROTOTYPE
)
public class DdaMarketplaceUtil {

    @Reference
    DdaMarketplaceService ddaMarketplaceService;

    private static final Log _log = LogFactoryUtil.getLog(DdaMarketplaceUtil.class);

    /**
     * Retrieves the price for a given product.
     *
     * @param product the product for which the price is to be retrieved
     * @return the price of the product as a BigDecimal
     */
    public static BigDecimal getPrice(CPDefinition product) {
        List<CPInstance> cpInstances = CPInstanceLocalServiceUtil.getCPDefinitionApprovedCPInstances(product.getCPDefinitionId());
        if (!cpInstances.isEmpty()) {
            String cpInstanceUuid = cpInstances.get(0).getCPInstanceUuid();
            CommercePriceEntry commercePriceEntry = CommercePriceEntryLocalServiceUtil.getInstanceBaseCommercePriceEntry(cpInstanceUuid, PRICE_LIST_TYPE, null);
            if (commercePriceEntry != null) {
                return commercePriceEntry.getPrice();
            }
        }
        return BigDecimal.ZERO;
    }

    /**
     * Retrieves the categories associated with a given product.
     *
     * @param cpDefinitionId the ID of the product
     * @return a list of AssetCategory objects representing the categories of the product
     */
    public static List<AssetCategory> getCategoriesForProduct(long cpDefinitionId) {
        return AssetCategoryLocalServiceUtil.getCategories(
                CPDefinition.class.getName(), cpDefinitionId);
    }

    /**
     * Retrieves the current user's account ID.
     *
     * @param userId the ID of the user
     * @return the account ID of the user, or 0 if the user is a guest
     * @throws PortalException if an error occurs while fetching the account ID
     */
    public static long getCurrentUserAccountId(long userId) throws PortalException {
        if (!UserLocalServiceUtil.getUser(userId).isGuestUser()) {
            return AccountEntryLocalServiceUtil.getUserAccountEntries(
                    userId, 0L, null, new String[]{"person", "business"}, -1, -1).get(0).getAccountEntryId();
        }
        return 0;
    }

    /**
     * Sets various product attributes in the render request.
     *
     * @param renderRequest the render request
     * @param productId the ID of the product
     * @param userId the ID of the user
     * @throws PortalException if an error occurs while setting the product attributes
     */
    public void setProductAttributes(RenderRequest renderRequest, long productId, long userId) throws PortalException {
        long accountId = getCurrentUserAccountId(userId);
        CPDefinition productDetails = ddaMarketplaceService.getProductDetails(productId);
        Map<String, List<ObjectEntry>> relatedObjects = ddaMarketplaceService.getRelatedObjects(productId);
        List<CPAttachmentFileEntry> fileAttachments = ddaMarketplaceService.getProductAttachments(productId);
        List<CPAttachmentFileEntry> productImage = ddaMarketplaceService.getProductImageAttachments(productId);

        renderRequest.setAttribute("accountId", accountId);
        renderRequest.setAttribute("productDetails", productDetails);
        renderRequest.setAttribute("relatedObjects", relatedObjects);
        renderRequest.setAttribute("fileAttachments", fileAttachments);
        renderRequest.setAttribute("productImage", productImage);
    }


}



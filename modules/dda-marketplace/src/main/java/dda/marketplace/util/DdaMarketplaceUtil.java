package dda.marketplace.util;

import com.liferay.account.model.AccountEntry;
import com.liferay.account.service.AccountEntryLocalServiceUtil;
import com.liferay.asset.kernel.model.AssetCategory;
import com.liferay.asset.kernel.model.AssetVocabulary;
import com.liferay.asset.kernel.service.AssetCategoryLocalServiceUtil;
import com.liferay.asset.kernel.service.AssetVocabularyLocalServiceUtil;
import com.liferay.commerce.context.CommerceContext;
import com.liferay.commerce.context.CommerceContextFactory;
import com.liferay.commerce.currency.model.CommerceCurrency;
import com.liferay.commerce.currency.service.CommerceCurrencyLocalServiceUtil;
import com.liferay.commerce.exception.CommerceOrderAccountLimitException;
import com.liferay.commerce.model.CommerceOrder;
import com.liferay.commerce.price.list.model.CommercePriceEntry;
import com.liferay.commerce.price.list.service.CommercePriceEntryLocalServiceUtil;
import com.liferay.commerce.product.model.CPAttachmentFileEntry;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.commerce.product.model.CPInstance;
import com.liferay.commerce.product.model.CommerceChannel;
import com.liferay.commerce.product.service.CPInstanceLocalServiceUtil;
import com.liferay.commerce.product.service.CommerceChannelLocalService;
import com.liferay.commerce.product.service.CommerceChannelLocalServiceUtil;
import com.liferay.commerce.service.CommerceOrderItemLocalServiceUtil;
import com.liferay.commerce.service.CommerceOrderLocalServiceUtil;
import com.liferay.dynamic.data.mapping.model.DDMFormInstanceRecord;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Validator;
import dda.marketplace.service.DdaMarketplaceService;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ServiceScope;

import javax.portlet.ActionRequest;
import javax.portlet.RenderRequest;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;

import static dda.marketplace.constants.DdaMarketplacePortletKeys.*;

@Component(
        service = DdaMarketplaceUtil.class,
        scope = ServiceScope.PROTOTYPE
)
public class DdaMarketplaceUtil {

    @Reference
    DdaMarketplaceService ddaMarketplaceService;

    private static final Log log = LogFactoryUtil.getLog(DdaMarketplaceUtil.class);


    /**
     * Retrieves the product categories for a given CPDefinition ID, organized by vocabulary.
     *
     * @param cpDefinitionId the ID of the CPDefinition for which the categories are to be retrieved
     * @return a map where the keys are vocabulary names and the values are lists of category names
     */
    public static Map<String, List<String>> getProductCategories(long cpDefinitionId, Locale locale) {
        Map<String, List<String>> categoriesByVocabulary = new HashMap<>();

        try {
            List<AssetCategory> categories = AssetCategoryLocalServiceUtil.getCategories(
                    CPDefinition.class.getName(), cpDefinitionId);

            for (AssetCategory category : categories) {
                AssetVocabulary vocabulary = AssetVocabularyLocalServiceUtil.getAssetVocabulary(category.getVocabularyId());
                String vocabularyName = vocabulary.getName();

                categoriesByVocabulary.computeIfAbsent(vocabularyName, k -> new ArrayList<>())
                        .add(category.getTitle(locale));
            }

        } catch (PortalException e) {
            log.error("Error occurred while getting product categories.");
        }

        return categoriesByVocabulary;
    }

    /**
     * Retrieves and categorizes the prices for a given product and sets the results as attributes
     * on the provided RenderRequest.
     *
     * @param product the product for which the prices are to be retrieved
     * @param renderRequest the RenderRequest object to which the prices will be set as attributes
     */
    public static void getPrices(CPDefinition product, RenderRequest renderRequest) {

        List<CPInstance> cpInstances = CPInstanceLocalServiceUtil.getCPDefinitionApprovedCPInstances(product.getCPDefinitionId());
        BigDecimal bronzeYearlyPrice = BigDecimal.ZERO;
        BigDecimal silverYearlyPrice = BigDecimal.ZERO;
        BigDecimal goldYearlyPrice = BigDecimal.ZERO;
        BigDecimal bronzeMonthlyPrice = BigDecimal.ZERO;
        BigDecimal silverMonthlyPrice = BigDecimal.ZERO;
        BigDecimal goldMonthlyPrice = BigDecimal.ZERO;
        BigDecimal payAsYouGo = BigDecimal.ZERO;
        BigDecimal oneTimePayment = BigDecimal.ZERO;

        if (!cpInstances.isEmpty()) {
            for (CPInstance cpInstance : cpInstances) {
                String cpInstanceUuid = cpInstance.getCPInstanceUuid();
                CommercePriceEntry commercePriceEntry = CommercePriceEntryLocalServiceUtil.getInstanceBaseCommercePriceEntry(cpInstanceUuid, PRICE_LIST_TYPE, null);

                BigDecimal price = (commercePriceEntry != null) ? commercePriceEntry.getPrice() : BigDecimal.ZERO;

                // Categorize prices
                String category = cpInstance.getSku(); // Assuming there is a method to get the category
                category = category.trim().toLowerCase().replace(" ", "");
                switch (category) {
                    case "bronze-yearly":
                        bronzeYearlyPrice = price;
                        break;
                    case "silver-yearly":
                        silverYearlyPrice = price;
                        break;
                    case "gold-yearly":
                        goldYearlyPrice = price;
                        break;
                    case "bronze-monthly":
                        bronzeMonthlyPrice = price;
                        break;
                    case "silver-monthly":
                        silverMonthlyPrice = price;
                        break;
                    case "gold-monthly":
                        goldMonthlyPrice = price;
                        break;
                    case "pay-as-you-go":
                        payAsYouGo = price;
                        break;
                    case "one-time-payment":
                        oneTimePayment = price;
                        break;
                    default:
                        break;
                }
            }
        }

        Map<String, BigDecimal> priceMap = new HashMap<>();
        priceMap.put("bronzeYearlyPrice", bronzeYearlyPrice);
        priceMap.put("silverYearlyPrice", silverYearlyPrice);
        priceMap.put("goldYearlyPrice", goldYearlyPrice);
        priceMap.put("bronzeMonthlyPrice", bronzeMonthlyPrice);
        priceMap.put("silverMonthlyPrice", silverMonthlyPrice);
        priceMap.put("goldMonthlyPrice", goldMonthlyPrice);
        priceMap.put("payAsYouGo", payAsYouGo);
        priceMap.put("oneTimePayment", oneTimePayment);

        renderRequest.setAttribute("priceMap", priceMap);
    }

    /**
     * Retrieves the price of a product based on its SKU.
     *
     * @param product The CPDefinition object representing the product for which the price is to be fetched.
     * @param sku     The SKU (Stock Keeping Unit) of the product, used to identify the specific product instance.
     *
     * @return        The price of the product as a BigDecimal, rounded to two decimal places using RoundingMode.HALF_UP.
     *
     * @throws PortalException If there is an issue retrieving the CPInstance or CommercePriceEntry.
     */
    public BigDecimal getPriceBasedOnSKU(CPDefinition product, String sku) throws PortalException {

        CPInstance cpInstance = CPInstanceLocalServiceUtil.getCPInstance(product.getCPDefinitionId(), sku.toUpperCase());
        CommercePriceEntry commercePriceEntry = CommercePriceEntryLocalServiceUtil.getInstanceBaseCommercePriceEntry(cpInstance.getCPInstanceUuid(), PRICE_LIST_TYPE, null);
        return commercePriceEntry.getPrice().setScale(2, RoundingMode.HALF_UP);
    }
    /**
     * Retrieves the current user's account ID.
     *
     * @param userId the ID of the user
     * @return the account ID of the user, or 0 if the user is a guest
     */
    public static long getCurrentUserAccountId(long userId) {
        try {
            User user = UserLocalServiceUtil.getUser(userId);

            if (!user.isGuestUser()) {
                List<AccountEntry> accountEntries = AccountEntryLocalServiceUtil.getUserAccountEntries(
                        userId, 0L, null, new String[]{"person", "business"}, -1, -1);

                if (!accountEntries.isEmpty()) {
                    long accountId = accountEntries.get(0).getAccountEntryId();

                    if (Validator.isNotNull(accountId)) {
                        return accountId;
                    }
                }
            }
        } catch (PortalException e) {
            log.error("Error retrieving user or account entries for userId: " + userId);
        } catch (IndexOutOfBoundsException e) {
            log.error("No account entries found for userId: " + userId);
        } catch (Exception e) {
            log.error("Unexpected error occurred while retrieving account ID for userId: " + userId);
        }

        return -1;
    }

    /**
     * Creates an order based on the provided product ID, package type, and subscription type.
     *
     * @param productIdString   The string representation of the product ID. It is parsed to a long value.
     * @param packageType       The type of package for the order (e.g., "basic", "premium").
     * @param subscriptionType  The type of subscription for the order (e.g., "monthly", "yearly").
     * @param themeDisplay      The ThemeDisplay object containing user context, such as user ID and site group ID.
     * @param actionRequest     The ActionRequest object containing the request parameters and context.
     *
     * @return                  {@code true} if the order is successfully created, {@code false} otherwise.
     */
    public boolean createOrder(String productIdString, String packageType, String subscriptionType, ThemeDisplay themeDisplay, ActionRequest actionRequest) {


        try {
            // Parse totalEstimatedPrice to BigDecimal
            long productId = Long.parseLong(productIdString);
            List<AccountEntry> entries = null;
            AccountEntry account = null;
            try {
                entries = AccountEntryLocalServiceUtil.getUserAccountEntries(themeDisplay.getUserId(), 0L, "", new String[]{"person","business"}, -1, -1);

                if (Validator.isNotNull(entries)) {
                    account = entries.get(0);
                    log.info("account: " + account.getName());
                }

            } catch (Exception pe) {
                if (log.isErrorEnabled()) {
                    log.error("Could not find commerce account for username: " + themeDisplay.getUser().getFullName() + ". Error due to: " + pe.getMessage());
                }
            }


            CommerceCurrency commerceCurrency =
                    CommerceCurrencyLocalServiceUtil.fetchPrimaryCommerceCurrency(
                            themeDisplay.getCompanyId());

            CommerceChannel commerceChannel =
                    CommerceChannelLocalServiceUtil.fetchCommerceChannelBySiteGroupId(
                            themeDisplay.getSiteGroupId());

            ServiceContext serviceContext = ServiceContextFactory.getInstance(
                    DDMFormInstanceRecord.class.getName(), actionRequest);



            CommerceOrder order = null;

            String sku = null;
            if(packageType.equals(IS_PAY_AS_YOU_GO) || packageType.equals(IS_ONE_TIME_PAYMENT)){
                sku = packageType;
            } else {
                sku = subscriptionType + "-" + packageType;
            }
            sku = sku.toUpperCase();
            log.info("SKU: " + sku);

            CPInstance cpInstance = CPInstanceLocalServiceUtil.getCPInstance(productId, sku);
            String cpInstanceUuid = cpInstance.getCPInstanceUuid();
            CommercePriceEntry commercePriceEntry = CommercePriceEntryLocalServiceUtil.getInstanceBaseCommercePriceEntry(cpInstanceUuid, PRICE_LIST_TYPE, null);
            BigDecimal totalEstimatedPriceDecimal = commercePriceEntry.getPrice();

            try {

                if (Validator.isNotNull(account) && Validator.isNotNull(commerceCurrency) && Validator.isNotNull(commerceChannel)) {
                    order = CommerceOrderLocalServiceUtil.addCommerceOrder(themeDisplay.getUserId(), commerceChannel.getGroupId(), account.getAccountEntryId(), commerceCurrency.getCommerceCurrencyId(), 0);
                }
                if (Validator.isNotNull(order)) {
                    order.setShippingAddressId(
                            account.getDefaultShippingAddressId());
                    order.setBillingAddressId(
                            account.getDefaultShippingAddressId());

                    order.setTotal(totalEstimatedPriceDecimal);

                    CommerceContext commerceContext = _commerceContextFactory.create(
                            themeDisplay.getCompanyId(),
                            _commerceChannelLocalService.getCommerceChannelGroupIdBySiteGroupId(
                                    themeDisplay.getSiteGroupId()),
                            themeDisplay.getUserId(), order.getCommerceOrderId(),
                            account.getAccountEntryId());

                    CommerceOrderItemLocalServiceUtil.addCommerceOrderItem(themeDisplay.getUserId(), order.getCommerceOrderId(),cpInstance.getCPInstanceId(),
                            "[]", BigDecimal.ONE, 0, BigDecimal.ONE, "", commerceContext, serviceContext);


                    log.debug("order info: " + order);
                }

            } catch (Exception exception) {
                if (exception instanceof CommerceOrderAccountLimitException) {
                    SessionErrors.add(actionRequest, exception.getClass());
                }

                if (log.isErrorEnabled()) {
                    if(Validator.isNotNull(account))
                        log.error("Could not create order for accountId:  " + account.getAccountEntryId());
                }

                throw exception;
            }

            return true;
        } catch (Exception e) {
            log.error("Error creating order");
            return false;
        }

    }

    /**
     * Sets various product-related attributes in the given render request.
     *
     * @param renderRequest the render request used to set attributes
     * @param productId     the ID of the product for which attributes are being set
     * @param themeDisplay  the ThemeDisplay object containing theme-related information
     * @throws PortalException if an error occurs while retrieving or setting the product attributes
     */
    public void setProductAttributes(RenderRequest renderRequest, long productId, ThemeDisplay themeDisplay) throws Exception {
        long accountId = getCurrentUserAccountId(themeDisplay.getUserId());
        log.debug("accountId:" + accountId);
        CPDefinition productDetails = ddaMarketplaceService.getProductDetails(productId);
        log.debug("productDetails:");
        Map<String, Object> relatedObjects = ddaMarketplaceService.getRelatedObjects(productId, renderRequest.getLocale());
        log.debug("relatedObjects:" + relatedObjects.size());
        List<CPDefinition> relatedProducts = ddaMarketplaceService.getRelatedProducts(productId, themeDisplay.getLocale());
        List<Map<String, Object>> fileAttachments = ddaMarketplaceService.getProductAttachments(productId, accountId, themeDisplay);
        log.debug("fileAttachments:" + fileAttachments.size());
        List<CPAttachmentFileEntry> productImages = ddaMarketplaceService.getProductImageAttachments(productId);
        if (Validator.isNotNull(productImages) && productImages.size() > 1) {
            double highestPriority = Integer.MIN_VALUE;
            for (CPAttachmentFileEntry productImage : productImages) {
                if(Validator.isNotNull(productImage)){
                    if(productImage.getPriority() > highestPriority){
                        highestPriority = productImage.getPriority();
                        renderRequest.setAttribute("productImage", productImage);
                    }
                }
            }
        }
        
        String productThumbnailImageURL = productDetails.getDefaultImageThumbnailSrc(accountId);

        boolean hasMonthlySubscription = ddaMarketplaceService.hasMonthlySubscription(productId, themeDisplay.getLocale());
        boolean hasYearlySubscription = ddaMarketplaceService.hasYearlySubscription(productId, themeDisplay.getLocale());
        Map<String, List<String>> productCategories = getProductCategories(productId, themeDisplay.getLocale());
        log.debug("Product categories" + productCategories);

        if (Validator.isNotNull(accountId) && Validator.isNotNull(productDetails) && Validator.isNotNull(relatedObjects) && Validator.isNotNull(fileAttachments)  && Validator.isNotNull(productCategories)) {

            renderRequest.setAttribute("accountId", accountId);
            renderRequest.setAttribute("productDetails", productDetails);
            renderRequest.setAttribute("relatedProducts", relatedProducts);
            renderRequest.setAttribute("relatedObjects", relatedObjects);
            renderRequest.setAttribute("fileAttachments", fileAttachments);
            renderRequest.setAttribute("productThumbnailImageURL", productThumbnailImageURL);
            renderRequest.setAttribute("hasMonthlySubscription", hasMonthlySubscription);
            renderRequest.setAttribute("hasYearlySubscription", hasYearlySubscription);
            if (Validator.isNotNull(productCategories) && !productCategories.isEmpty()) {
                renderRequest.setAttribute("productCategories", productCategories);
            }
        }

    }

    @Reference
    private CommerceContextFactory _commerceContextFactory;

    @Reference
    CommerceChannelLocalService _commerceChannelLocalService;

}

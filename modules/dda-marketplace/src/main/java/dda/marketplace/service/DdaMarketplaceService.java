package dda.marketplace.service;

import com.liferay.commerce.product.model.CPAttachmentFileEntry;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.object.model.ObjectEntry;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import org.osgi.annotation.versioning.ProviderType;

import java.util.List;
import java.util.Locale;
import java.util.Map;

@ProviderType
public interface DdaMarketplaceService {

        /**
         * Retrieves a list of all products.
         *
         * @return a list of all CPDefinition objects representing the products
         * @throws PortalException if an error occurs while fetching the product list
         */
        List<CPDefinition> getAllProductList() throws PortalException;

        /**
         * Retrieves the details of a specific product.
         *
         * @param productId the ID of the product
         * @return a CPDefinition object representing the product details
         * @throws PortalException if an error occurs while fetching the product details
         */
        CPDefinition getProductDetails(long productId) throws PortalException;

        /**
         * Retrieves related objects for a specific product.
         *
         * @param productId the ID of the product
         * @return a map where the key is a string representing the relationship and the value is a list of ObjectEntry objects representing the related objects
         * @throws PortalException if an error occurs while fetching the related objects
         */
        Map<String, List<ObjectEntry>> getRelatedObjects(long productId , Locale locale) throws PortalException;


        /**
         * Retrieves a list of attachments for a given product and account.
         *
         * @param productId the ID of the product for which attachments are being retrieved
         * @param accountId the ID of the account associated with the product
         * @param themeDisplay the ThemeDisplay object containing theme-related information
         * @return a list of maps, each representing an attachment with its properties
         * @throws PortalException if an error occurs while retrieving the attachments
         */
        List<Map<String, Object>> getProductAttachments(long productId, long accountId, ThemeDisplay themeDisplay) throws PortalException;

        /**
         * Retrieves the image attachment file entries for a specific product.
         *
         * @param productId the ID of the product
         * @return a list of CPAttachmentFileEntry objects representing the product image attachments
         * @throws PortalException if an error occurs while fetching the product image attachments
         */
        List<CPAttachmentFileEntry> getProductImageAttachments(long productId) throws PortalException;

        /**
         * Checks if the product categories contain a specific category type.
         *
         * @param productCategories a map of product categories where the keys are vocabulary names and the values are lists of category names
         * @param categoryType the category type to check for
         * @return true if the product categories contain the specified category type, false otherwise
         */
        boolean hasCategoryType(Map<String, List<String>> productCategories, String categoryType);

        /**
         * Checks if the product has a monthly subscription category.
         *
         * @param cpDefinitionId the ID of the CPDefinition to check
         * @return true if the product has a monthly subscription category, false otherwise
         */
        boolean hasMonthlySubscription(long cpDefinitionId);

        /**
         * Checks if the product has a yearly subscription category.
         *
         * @param cpDefinitionId the ID of the CPDefinition to check
         * @return true if the product has a yearly subscription category, false otherwise
         */
        boolean hasYearlySubscription(long cpDefinitionId);

        List<CPDefinition> getRelatedProducts(long productId) throws PortalException;
}

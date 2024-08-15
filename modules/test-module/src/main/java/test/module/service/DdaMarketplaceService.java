package test.module.service;

import com.liferay.commerce.product.model.CPAttachmentFileEntry;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.object.model.ObjectEntry;
import com.liferay.portal.kernel.exception.PortalException;
import org.osgi.annotation.versioning.ProviderType;

import java.util.List;
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
    Map<String, List<ObjectEntry>> getRelatedObjects(long productId) throws PortalException;

    /**
     * Retrieves the attachment file entries for a specific product.
     *
     * @param productId the ID of the product
     * @return a list of CPAttachmentFileEntry objects representing the product attachments
     * @throws PortalException if an error occurs while fetching the product attachments
     */
    List<CPAttachmentFileEntry> getProductAttachments(long productId) throws PortalException;

    /**
     * Retrieves the image attachment file entries for a specific product.
     *
     * @param productId the ID of the product
     * @return a list of CPAttachmentFileEntry objects representing the product image attachments
     * @throws PortalException if an error occurs while fetching the product image attachments
     */
    List<CPAttachmentFileEntry> getProductImageAttachments(long productId) throws PortalException;

}

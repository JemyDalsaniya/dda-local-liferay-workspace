package dda.marketplace.portlet.service;

import com.liferay.commerce.product.model.CPAttachmentFileEntry;
import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.object.model.ObjectEntry;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.model.User;
import org.osgi.annotation.versioning.ProviderType;

import java.util.List;
import java.util.Map;

@ProviderType
public interface DdaMarketplaceService {

        List<CPDefinition> getAllProductList() throws PortalException;

        long getCurrentUserAccountId(User user) throws PortalException;

        CPDefinition getProductDetails(long productId) throws PortalException;

        Map<String, List<ObjectEntry>> getRelatedObjects(long productId) throws PortalException;

        List<CPAttachmentFileEntry> getProductAttachments(long productId) throws PortalException;
}

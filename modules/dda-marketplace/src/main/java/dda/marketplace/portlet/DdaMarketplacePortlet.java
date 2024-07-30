package dda.marketplace.portlet;

import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import dda.marketplace.constants.DdaMarketplacePortletKeys;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import dda.marketplace.portlet.service.DdaMarketplaceService;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import java.io.IOException;
import java.util.List;

/**
 * @author root321
 */
@Component(
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=DdaMarketplace",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + DdaMarketplacePortletKeys.DDAMARKETPLACE,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class DdaMarketplacePortlet extends MVCPortlet {

	private static final Log _log = LogFactoryUtil.getLog(DdaMarketplacePortlet.class.getName());

	@Reference
	private DdaMarketplaceService ddaMarketplaceService;

	@Override
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse)
			throws IOException, PortletException {


        List<CPDefinition> productList = null;
        try {
            productList = ddaMarketplaceService.getAllProductList();
        } catch (PortalException e) {
            throw new RuntimeException(e);
        }
		renderRequest.setAttribute("productList", productList);

		super.doView(renderRequest, renderResponse);
	}

}

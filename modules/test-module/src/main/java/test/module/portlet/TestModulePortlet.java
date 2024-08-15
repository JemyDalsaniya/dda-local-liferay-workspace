package test.module.portlet;

import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import test.module.constants.TestModulePortletKeys;
import test.module.service.DdaMarketplaceService;
import test.module.util.DdaMarketplaceUtil;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import java.io.IOException;
import java.util.List;


@Component(
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=TestModule",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + TestModulePortletKeys.TESTMODULE,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class TestModulePortlet extends MVCPortlet {

	private static final Log _log = LogFactoryUtil.getLog(TestModulePortlet.class.getName());

	@Reference
	private DdaMarketplaceService ddaMarketplaceService;

	@Reference
	private DdaMarketplaceUtil ddaMarketplaceUtil;


	/**
	 * Renders the view for this portlet. This method is called to display the portlet's content.
	 * It fetches the product list, sets product attributes, and handles any exceptions that occur during the process.
	 *
	 * @param renderRequest the render request
	 * @param renderResponse the render response
	 * @throws IOException if an I/O error occurs
	 * @throws PortletException if a portlet error occurs
	 */
	@Override
	public void render(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
		// Fetch and set the product list
		try {
			ThemeDisplay themeDisplay = (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);
			List<CPDefinition> productList = ddaMarketplaceService.getAllProductList();
			_log.info("Product list size::::: " + productList.size());
			renderRequest.setAttribute("productList", productList);
			long productId = ParamUtil.getLong(renderRequest, "productId");
			if (productId > 0) {
				ddaMarketplaceUtil.setProductAttributes(renderRequest, productId, themeDisplay.getUser().getUserId());
			}
		} catch (Exception e) {
			_log.error("Error while rendering attributes!", e);
		}

		super.render(renderRequest, renderResponse);
	}


}

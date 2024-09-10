package dda.marketplace.portlet;

import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.commerce.product.service.CPDefinitionLocalServiceUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import dda.marketplace.constants.DdaMarketplacePortletKeys;
import dda.marketplace.service.DdaMarketplaceService;
import dda.marketplace.util.DdaMarketplaceUtil;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import javax.portlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;


@Component(
	property = {
		"com.liferay.portlet.display-category=category.marketplace",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.header-portlet-javascript=/js/main.js",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=DdaMarketplace",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/productDetail.jsp",
		"javax.portlet.name=" + DdaMarketplacePortletKeys.DDAMARKETPLACE,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user",
		"mvc.command.name=/create_order"
	},
	service = Portlet.class
)
public class DdaMarketplacePortlet extends MVCPortlet {

	private static final Log log = LogFactoryUtil.getLog(DdaMarketplacePortlet.class.getName());

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
			HttpServletRequest httpServletRequest = PortalUtil.getOriginalServletRequest(PortalUtil.getHttpServletRequest(renderRequest));
			// Initialize productId
			long productId = 0;
			String productIdString = httpServletRequest.getParameter("productId");
			if(Validator.isNull(productIdString)){
				productIdString = httpServletRequest.getParameter(renderResponse.getNamespace() + "productId");
			}
			// Parse the productId if the value is valid
			if (Validator.isNotNull(productIdString)) {
				try {
					productId = Long.parseLong(productIdString);
				} catch (NumberFormatException e) {
					log.error("Invalid productId format: " + e);
				}
			}
			log.info("productId: " + productId);
			if (Validator.isNotNull(productId) && productId > 0) {
				ddaMarketplaceUtil.setProductAttributes(renderRequest, productId, themeDisplay);
			} else {
				List<CPDefinition> productList = ddaMarketplaceService.getAllProductList();
				log.info("Product list size:: " + productList.size());
				renderRequest.setAttribute("productList", productList);
			}
		} catch (Exception e) {
			log.error("Error while rendering attributes!", e);
		}

		super.render(renderRequest, renderResponse);
	}

	/**
	 * Processes the action request, creating an order based on the provided product, package, and subscription type.
	 *
	 * @param actionRequest  The action request object, which provides access to the request parameters and attributes.
	 * @param actionResponse The action response object, which is used to set render parameters and redirect the user.
	 *
     */
	@Override
	public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) {

		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		HttpServletRequest httpServletRequest = PortalUtil.getOriginalServletRequest(PortalUtil.getHttpServletRequest(actionRequest));
		String productId = httpServletRequest.getParameter(actionResponse.getNamespace()+"productId");
		String packageType = ParamUtil.getString(actionRequest, "packageType");
		String subscriptionType = ParamUtil.getString(actionRequest, "subscriptionType");

		// Call your utility method to create the order
		boolean isOrderCreated = ddaMarketplaceUtil.createOrder(productId, packageType, subscriptionType, themeDisplay, actionRequest);
		actionRequest.setAttribute("isOrderCreated", isOrderCreated);
		actionResponse.setRenderParameter("jspPage", "/checkout.jsp");



	}


	/**
	 * Serves a resource request, returning a JSON response with the price of a product based on the SKU.
	 *
	 * @param resourceRequest  The resource request object, which provides access to the request parameters.
	 * @param resourceResponse The resource response object, used to write the JSON response.
	 *
	 * @throws IOException If an input or output error occurs while processing the request.
	 */
	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException {

		Map<String, String[]> parameters = resourceRequest.getParameterMap();
		for (Map.Entry<String, String[]> entry : parameters.entrySet()) {
			log.info("Parameter: " + entry.getKey() + " = " + Arrays.toString(entry.getValue()));
		}

		String sku = ParamUtil.getString(resourceRequest, "sku");
		long productId = ParamUtil.getLong(resourceRequest, "productId");
		JSONObject jsonResponse = JSONFactoryUtil.createJSONObject();

		try {
			// Fetch the product using the product ID
			CPDefinition product = CPDefinitionLocalServiceUtil.getCPDefinition(productId);

			// Get the price based on the SKU
			BigDecimal price = ddaMarketplaceUtil.getPriceBasedOnSKU(product, sku);

			// Return the price in the JSON response
			jsonResponse.put("price", price.toString());
		} catch (PortalException e) {
			// Log the error and return an appropriate response
			log.error("Error fetching price for SKU: " + sku + " and Product ID: " + productId, e);
			jsonResponse.put("error", "Unable to fetch price. Please try again later.");
		} catch (Exception e) {
			// Catch any other unexpected exceptions
			log.error("Unexpected error occurred", e);
			jsonResponse.put("error", "An unexpected error occurred. Please try again later.");
		}

		resourceResponse.setContentType("application/json");
		resourceResponse.getWriter().write(jsonResponse.toString());
	}


}

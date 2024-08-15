package dda.marketplace.portlet;

import com.liferay.commerce.product.model.CPDefinition;
import com.liferay.commerce.product.service.CPDefinitionLocalServiceUtil;
import com.liferay.headless.commerce.admin.catalog.dto.v1_0.Product;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import dda.marketplace.constants.DdaMarketplacePortletKeys;
import dda.marketplace.service.DdaMarketplaceService;
import dda.marketplace.util.DdaMarketplaceUtil;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import javax.portlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Component(
	property = {
		"com.liferay.portlet.display-category=category.marketplace",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.header-portlet-css=/css/style.css",
		"com.liferay.portlet.footer-portlet-css=/css/bootstrap.min.css",
		"com.liferay.portlet.footer-portlet-javascript=/js/custom.js",
//		"com.liferay.portlet.header-portlet-javascript=/js/jquery-3.3.1.slim.min.js",
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

	private static final Log _log = LogFactoryUtil.getLog(DdaMarketplacePortlet.class.getName());

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
			long productId = getProductIdFromUrl(themeDisplay.getURLCurrent());
			_log.info("Product Id: " + productId);
			if (Validator.isNotNull(productId) && productId > 0) {
				_log.info("Before setting attributes==");
				ddaMarketplaceUtil.setProductAttributes(renderRequest, productId, themeDisplay);
				_log.info("After setting attributes==");
			} else {
				List<CPDefinition> productList = ddaMarketplaceService.getAllProductList();
				_log.info("Product list size::::: " + productList.size());
				renderRequest.setAttribute("productList", productList);
			}
		} catch (Exception e) {
			_log.error("Error while rendering attributes!", e);
		}

		super.render(renderRequest, renderResponse);
	}

	public static long getProductIdFromUrl(String url) {
		// Check if the URL contains query parameters
		if (url.contains("?")) {
			String[] parts = url.split("\\?");
			if (parts.length > 1) {
				String query = parts[1];
				// Split the query string into key-value pairs
				String[] pairs = query.split("&");
				Map<String, String> queryPairs = new HashMap<>();
				for (String pair : pairs) {
					String[] keyValue = pair.split("=");
					if (keyValue.length == 2) {
						queryPairs.put(keyValue[0], keyValue[1]);
					}
				}
				// Search for the key that contains "productId"
				for (Map.Entry<String, String> entry : queryPairs.entrySet()) {
					if (entry.getKey().toLowerCase().contains("productid")) {
						try {
							return Long.parseLong(entry.getValue());
						} catch (NumberFormatException e) {
							_log.error("Invalid productId format: " + entry.getValue(), e);
							return 0;
						}
					}
				}
			}
		}
		return 0; // Return 0 if productId not found or an error occurred
	}


	/*@Override
	public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException {
		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);

		String productId = ParamUtil.getString(actionRequest, "productId");
		String packageType = ParamUtil.getString(actionRequest, "packageType");
		String totalEstimatedPrice = ParamUtil.getString(actionRequest, "totalEstimatedPrice");
		String subscriptionType = ParamUtil.getString(actionRequest, "subscriptionType");

		// Call your utility method to create the order
		boolean isOrderCreated = ddaMarketplaceUtil.createOrder(productId, packageType, totalEstimatedPrice, subscriptionType, themeDisplay, actionRequest);
		actionRequest.setAttribute("isOrderCreated", isOrderCreated);
		actionResponse.setRenderParameter("jspPage", "/checkout.jsp");

	}*/
	@Override
	public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);

		// Retrieve the dynamic values from the request
		String productId = ParamUtil.getString(actionRequest, "productId");
		String subscriptionType = ParamUtil.getString(actionRequest, "subscriptionType");
		String packageType = ParamUtil.getString(actionRequest, "packageType");

		// Your existing logic to create the order
		boolean isOrderCreated = ddaMarketplaceUtil.createOrder(productId, packageType, null, subscriptionType, themeDisplay, actionRequest);
		actionRequest.setAttribute("isOrderCreated", isOrderCreated);
		actionResponse.setRenderParameter("jspPage", "/checkout.jsp");
	}


	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException {

		Map<String, String[]> parameters = resourceRequest.getParameterMap();
		for (Map.Entry<String, String[]> entry : parameters.entrySet()) {
			_log.info("Parameter: " + entry.getKey() + " = " + Arrays.toString(entry.getValue()));
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
			_log.error("Error fetching price for SKU: " + sku + " and Product ID: " + productId, e);
			jsonResponse.put("error", "Unable to fetch price. Please try again later.");
		} catch (Exception e) {
			// Catch any other unexpected exceptions
			_log.error("Unexpected error occurred", e);
			jsonResponse.put("error", "An unexpected error occurred. Please try again later.");
		}

		resourceResponse.setContentType("application/json");
		resourceResponse.getWriter().write(jsonResponse.toString());
	}



}

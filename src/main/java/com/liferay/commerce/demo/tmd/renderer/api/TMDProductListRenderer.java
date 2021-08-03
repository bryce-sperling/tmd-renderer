package com.liferay.commerce.demo.tmd.renderer.api;

import com.liferay.commerce.product.constants.CPPortletKeys;
import com.liferay.commerce.product.content.render.list.CPContentListRenderer;
import com.liferay.commerce.product.service.CPDefinitionSpecificationOptionValueLocalService;
import com.liferay.commerce.product.service.CPOptionCategoryLocalService;
import com.liferay.commerce.product.service.CPOptionLocalService;
import com.liferay.commerce.product.util.CPInstanceHelper;
import com.liferay.commerce.wish.list.model.CommerceWishList;
import com.liferay.commerce.wish.list.model.CommerceWishListItem;
import com.liferay.commerce.wish.list.service.CommerceWishListItemLocalService;
import com.liferay.commerce.wish.list.service.CommerceWishListLocalService;
import com.liferay.frontend.taglib.servlet.taglib.util.JSPRenderer;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ResourceBundleUtil;
import com.liferay.portal.kernel.util.WebKeys;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Jeff Handa
 */
@Component(
        immediate = true,
        property = {
                "commerce.product.content.list.renderer.key=" + TMDProductListRenderer.KEY,
                "commerce.product.content.list.renderer.order=600",
                "commerce.product.content.list.renderer.portlet.name=" + CPPortletKeys.CP_PUBLISHER_WEB,
                "commerce.product.content.list.renderer.portlet.name=" + CPPortletKeys.CP_SEARCH_RESULTS
        },
        service = CPContentListRenderer.class
)

public class TMDProductListRenderer implements CPContentListRenderer {

        public static final String KEY = "tmd-list";

        @Override
        public String getKey() {
                return KEY;
        }

        @Override
        public String getLabel(Locale locale) {
                ResourceBundle resourceBundle = ResourceBundleUtil.getBundle(
                        "content.Language", locale, getClass());

                return LanguageUtil.get(resourceBundle, "tmd-list");
        }

        @Override
        public void render(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {

                ThemeDisplay themeDisplay = (ThemeDisplay)httpServletRequest.getAttribute(WebKeys.THEME_DISPLAY);
                long companyId = themeDisplay.getCompanyId();

                long reliabilityCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "reliability").getCPOptionCategoryId();

                httpServletRequest.setAttribute("cpInstanceHelper", _cpInstanceHelper);
                httpServletRequest.setAttribute("cpDefinitionSpecificationOptionValueLocalService", _cpDefinitionSpecificationOptionValueLocalService);
                httpServletRequest.setAttribute("reliabilityCategoryId", reliabilityCategoryId);
            	
//                long groupId = themeDisplay.getLayout().getGroupId();
//                System.out.println("groupId=" + groupId);
                

//                List<CommerceWishList> wishList = _wishListLocalService.getCommerceWishLists(0, Integer.MAX_VALUE);
                long wlUserId = themeDisplay.getUserId();

                
                List<CommerceWishList> wishList = _wishListLocalService.getCommerceWishLists(0, Integer.MAX_VALUE);
                for(CommerceWishList aWishList : wishList) {
                	if(wlUserId != aWishList.getUserId()) {
                		continue;
                	}
                	
                	if(aWishList.getDefaultWishList()) {
                		httpServletRequest.setAttribute("defaultWishList", aWishList.getCommerceWishListId());
                		System.out.println("found wishlist=" + aWishList.getCommerceWishListId());
                		break;
                	}
                }
                
                List<CommerceWishListItem> wishlistList = _wishListItemLocalService.getCommerceWishListItems(0, Integer.MAX_VALUE);
                
            	Map<Long, CommerceWishListItem> wishlistMap = new HashMap();
            	CommerceWishListItem wishlistItem;

            	
            	for(int i = 0; i < wishlistList.size(); i++) {
            		wishlistItem = wishlistList.get(i);
            		
            		if(wishlistItem.getUserId() != wlUserId) {
            			continue;
            		}
            		
            		wishlistMap.put(wishlistItem.getCProductId(), wishlistItem);
            	}
            	
            	httpServletRequest.setAttribute("wishlistMap", wishlistMap);

                _jspRenderer.renderJSP(
                        _servletContext, httpServletRequest, httpServletResponse,
                        "/list_render/view.jsp");
        }

        @Reference(
                target = "(osgi.web.symbolicname=com.liferay.commerce.demo.tmd.renderer)"
        )
        private ServletContext _servletContext;

        @Reference
        private JSPRenderer _jspRenderer;

        @Reference
        private CPInstanceHelper _cpInstanceHelper;

        @Reference
        private CPOptionLocalService _cpOptionLocalService;

        @Reference
        private CPDefinitionSpecificationOptionValueLocalService _cpDefinitionSpecificationOptionValueLocalService;

        @Reference
        private CPOptionCategoryLocalService _cpOptionCategoryLocalService ;

        @Reference
        private CommerceWishListLocalService _wishListLocalService;
        
        @Reference
        private CommerceWishListItemLocalService _wishListItemLocalService;
}
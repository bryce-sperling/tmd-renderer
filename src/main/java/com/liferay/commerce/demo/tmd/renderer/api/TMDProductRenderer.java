package com.liferay.commerce.demo.tmd.renderer.api;

import com.liferay.commerce.product.catalog.CPCatalogEntry;
import com.liferay.commerce.product.content.render.CPContentRenderer;
import com.liferay.commerce.product.model.CPOptionCategory;
import com.liferay.commerce.product.service.CPOptionCategoryLocalService;
import com.liferay.commerce.product.service.CProductLocalService;
import com.liferay.frontend.taglib.servlet.taglib.util.JSPRenderer;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.mobile.device.Device;
import com.liferay.portal.kernel.service.GroupLocalService;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ResourceBundleUtil;
import com.liferay.portal.kernel.util.WebKeys;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

/**
 * @author Jeff Handa
 */
@Component(
        immediate = true,
        property = {
                "commerce.product.content.renderer.key=" + TMDProductRenderer.KEY,
                "commerce.product.content.renderer.type=grouped",
                "commerce.product.content.renderer.type=simple",
                "commerce.product.content.renderer.type=virtual"
        },
        service = CPContentRenderer.class
)
public class TMDProductRenderer implements CPContentRenderer {

    public static final String KEY = "tmd-renderer";

    @Override
    public String getKey() {
        return KEY;
    }

    @Override
    public String getLabel(Locale locale) {
        ResourceBundle resourceBundle = ResourceBundleUtil.getBundle(
                "content.Language", locale, getClass());

        return LanguageUtil.get(resourceBundle, "tmd-renderer");
    }

    @Override
    public void render(CPCatalogEntry cpCatalogEntry, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {


        ThemeDisplay themeDisplay = (ThemeDisplay)httpServletRequest.getAttribute(WebKeys.THEME_DISPLAY);
        long companyId = themeDisplay.getCompanyId();
        Locale locale = themeDisplay.getLocale();

        List<CPOptionCategory> specificationGroups = _cpOptionCategoryLocalService.getCPOptionCategories(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
        for (CPOptionCategory specificationGroup: specificationGroups){
            _log.debug(specificationGroup.getTitle(locale));
        }
        long ownerCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "owner").getCPOptionCategoryId();
        long locationCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "location").getCPOptionCategoryId();
        long modelCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "model").getCPOptionCategoryId();
        long categorizationCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "categorization").getCPOptionCategoryId();
        long reliabilityCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "reliability").getCPOptionCategoryId();
        long financialCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "financial").getCPOptionCategoryId();
        long softwareCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "software").getCPOptionCategoryId();
        long rudrScoreDetailsCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "rudr-score-details").getCPOptionCategoryId();
        long deviceAgeCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "device-age").getCPOptionCategoryId();
        long partsAvailabilityCategoryId = _cpOptionCategoryLocalService.getCPOptionCategory(companyId, "parts-availability").getCPOptionCategoryId();

        httpServletRequest.setAttribute("ownerCategoryId", ownerCategoryId);
        httpServletRequest.setAttribute("locationCategoryId", locationCategoryId);
        httpServletRequest.setAttribute("modelCategoryId", modelCategoryId);
        httpServletRequest.setAttribute("categorizationCategoryId", categorizationCategoryId);
        httpServletRequest.setAttribute("reliabilityCategoryId", reliabilityCategoryId);
        httpServletRequest.setAttribute("financialCategoryId", financialCategoryId);
        httpServletRequest.setAttribute("softwareCategoryId", softwareCategoryId);
        httpServletRequest.setAttribute("rudrScoreDetailsCategoryId", rudrScoreDetailsCategoryId);
        httpServletRequest.setAttribute("deviceAgeCategoryId", deviceAgeCategoryId);
        httpServletRequest.setAttribute("partsAvailabilityCategoryId", partsAvailabilityCategoryId);

        _jspRenderer.renderJSP(
                _servletContext, httpServletRequest, httpServletResponse,
                "/render/view.jsp");
    }

    private static final Log _log = LogFactoryUtil.getLog(
            TMDProductRenderer.class);

    @Reference(
            target = "(osgi.web.symbolicname=com.liferay.commerce.demo.tmd.renderer)"
    )
    private ServletContext _servletContext;

    @Reference
    private JSPRenderer _jspRenderer;

    @Reference
    private CPOptionCategoryLocalService _cpOptionCategoryLocalService ;

    @Reference
    private CProductLocalService _cProductLocalService;

    @Reference
    private GroupLocalService _groupLocalService;
}

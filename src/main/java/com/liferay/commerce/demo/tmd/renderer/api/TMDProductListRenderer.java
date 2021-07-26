package com.liferay.commerce.demo.tmd.renderer.api;

import com.liferay.commerce.product.constants.CPPortletKeys;
import com.liferay.commerce.product.content.render.list.CPContentListRenderer;
import com.liferay.commerce.product.util.CPInstanceHelper;
import com.liferay.frontend.taglib.servlet.taglib.util.JSPRenderer;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.util.ResourceBundleUtil;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;
import java.util.ResourceBundle;

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

                httpServletRequest.setAttribute("cpInstanceHelper", _cpInstanceHelper);

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
}
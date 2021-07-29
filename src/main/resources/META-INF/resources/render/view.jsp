<%@ page import="java.util.ArrayList" %>
<%@ include file="../init.jsp" %>

<%
	long ownerCategoryId = GetterUtil.getLong(request.getAttribute("ownerCategoryId"));
	long locationCategoryId = GetterUtil.getLong(request.getAttribute("locationCategoryId"));
	long modelCategoryId = GetterUtil.getLong(request.getAttribute("modelCategoryId"));
	long categorizationCategoryId = GetterUtil.getLong(request.getAttribute("categorizationCategoryId"));
	long reliabilityCategoryId = GetterUtil.getLong(request.getAttribute("reliabilityCategoryId"));
	long financialCategoryId = GetterUtil.getLong(request.getAttribute("financialCategoryId"));
	long softwareCategoryId = GetterUtil.getLong(request.getAttribute("softwareCategoryId"));
	long rudrScoreDetailsCategoryId = GetterUtil.getLong(request.getAttribute("rudrScoreDetailsCategoryId"));
	long deviceAgeCategoryId = GetterUtil.getLong(request.getAttribute("deviceAgeCategoryId"));
	long partsAvailabilityCategoryId  = GetterUtil.getLong(request.getAttribute("partsAvailabilityCategoryId"));

	CPContentHelper cpContentHelper = (CPContentHelper)request.getAttribute(CPContentWebKeys.CP_CONTENT_HELPER);
	CPCatalogEntry cpCatalogEntry = cpContentHelper.getCPCatalogEntry(request);


	CPSku cpSku = cpContentHelper.getDefaultCPSku(cpCatalogEntry);
	long cpDefinitionId = cpCatalogEntry.getCPDefinitionId();
	String addToCartId = PortalUtil.generateRandomKey(request, "add-to-cart");
	String currentUrl = PortalUtil.getCurrentURL(request);
	String signInUrl = "/c/portal/login?redirect=" + currentUrl;

	List<CPDefinitionSpecificationOptionValue> ownerItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, ownerCategoryId);
	List<CPDefinitionSpecificationOptionValue> locationItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, locationCategoryId);
	List<CPDefinitionSpecificationOptionValue> modelItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, modelCategoryId);
	List<CPDefinitionSpecificationOptionValue> categorizationItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, categorizationCategoryId);
	List<CPDefinitionSpecificationOptionValue> reliabilityItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, reliabilityCategoryId);
	List<CPDefinitionSpecificationOptionValue> financialItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, financialCategoryId);
	List<CPDefinitionSpecificationOptionValue> softwareItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, softwareCategoryId);
	List<CPDefinitionSpecificationOptionValue> rudrScoreDetailsItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, rudrScoreDetailsCategoryId);
	List<CPDefinitionSpecificationOptionValue> deviceAgeItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, deviceAgeCategoryId);
	List<CPDefinitionSpecificationOptionValue> partsAvailabilityItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, partsAvailabilityCategoryId);

%>

<style>
	.grid-container {
		display: grid;
		grid-template-columns: auto auto;
		padding: 10px;
	}
	.sub-grid {
		display: grid;
		grid-template-columns: 50% 50%;
	}
	.grid-item {
		text-align: left;
		border-bottom: 2px solid;

	}
	.grid-item.spec-group-name {
		font-weight:  bold;
	}

</style>

<div class="mb-5 product-detail" id="<portlet:namespace /><%= cpDefinitionId %>ProductContent">
	<div class="row">
		<div class="col-md-6 col-xs-12">
			<commerce-ui:gallery CPDefinitionId="<%= cpDefinitionId %>" />
		</div>

		<div class="col-md-6 col-xs-12">
			<header class="product-header">
				<commerce-ui:compare-checkbox
						componentId="compareCheckbox"
						CPDefinitionId="<%= cpDefinitionId %>"
				/>

				<h3 class="product-header-tagline" data-text-cp-instance-sku>
					<%= (cpSku == null) ? StringPool.BLANK : HtmlUtil.escape(cpSku.getSku()) %>
				</h3>

				<h2 class="product-header-title"><%= HtmlUtil.escape(cpCatalogEntry.getName()) %></h2>

				<h4 class="product-header-subtitle" data-text-cp-instance-manufacturer-part-number>
					<%= (cpSku == null) ? StringPool.BLANK : HtmlUtil.escape(cpSku.getManufacturerPartNumber()) %>
				</h4>

				<h4 class="product-header-subtitle" data-text-cp-instance-gtin>
					<%= (cpSku == null) ? StringPool.BLANK : HtmlUtil.escape(cpSku.getGtin()) %>
				</h4>
			</header>

			<p class="mt-3 procuct-description"><%= cpCatalogEntry.getDescription() %></p>

			<h4 class="commerce-subscription-info mt-3 w-100">
				<c:if test="<%= cpSku != null %>">
					<commerce-ui:product-subscription-info
							CPInstanceId="<%= cpSku.getCPInstanceId() %>"
					/>
				</c:if>

				<span data-text-cp-instance-subscription-info></span>
				<span data-text-cp-instance-delivery-subscription-info></span>
			</h4>

			<div class="product-detail-options">
				<%= cpContentHelper.renderOptions(renderRequest, renderResponse) %>

				<%@ include file="/render/form_handlers/metal_js.jspf" %>
			</div>

			<c:choose>
				<c:when test="<%= cpSku != null %>">
					<div class="availability mt-1"><%= cpContentHelper.getAvailabilityLabel(request) %></div>
					<div class="availability-estimate mt-1"><%= cpContentHelper.getAvailabilityEstimateLabel(request) %></div>
					<div class="mt-1 stock-quantity"><%= cpContentHelper.getStockQuantityLabel(request) %></div>
				</c:when>
				<c:otherwise>
					<div class="availability mt-1" data-text-cp-instance-availability></div>
					<div class="availability-estimate mt-1" data-text-cp-instance-availability-estimate></div>
					<div class="stock-quantity mt-1" data-text-cp-instance-stock-quantity></div>
				</c:otherwise>
			</c:choose>

			<h2 class="commerce-price mt-3">
				<commerce-ui:price
						CPDefinitionId="<%= cpCatalogEntry.getCPDefinitionId() %>"
						CPInstanceId="<%= (cpSku == null) ? 0 : cpSku.getCPInstanceId() %>"
						id='<%= "productDetail_" + cpCatalogEntry.getCPDefinitionId() %>'
				/>
			</h2>

			<c:if test="<%= cpSku != null %>">
				<liferay-commerce:tier-price
						CPInstanceId="<%= cpSku.getCPInstanceId() %>"
						taglibQuantityInputId='<%= liferayPortletResponse.getNamespace() + cpDefinitionId + "Quantity" %>'
				/>
			</c:if>

			<div class="mt-3 product-detail-actions">
				<div class="autofit-col">
					<commerce-ui:add-to-cart
							CPInstanceId="<%= (cpSku == null) ? 0 : cpSku.getCPInstanceId() %>"
							id="<%= addToCartId %>"
					/>
				</div>
			</div>
		</div>
	</div>
</div>

<%
	List<CPDefinitionSpecificationOptionValue> cpDefinitionSpecificationOptionValues = cpContentHelper.getCPDefinitionSpecificationOptionValues(cpDefinitionId);
	List<CPOptionCategory> cpOptionCategories = cpContentHelper.getCPOptionCategories(company.getCompanyId());
%>

<div class="container">
	<div class="row">
		<div class="col-sm">
				<commerce-ui:panel
						elementClasses="mb-3"
						title='Overview'
				>

					<div class="grid-container">
						<!-- Owner -->
						<div class="grid-item spec-group-name">Owner</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue ownerItem : ownerItems) {
									CPSpecificationOption cpSpecificationOption = ownerItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%=HtmlUtil.escape(ownerItem.getValue(languageId)) %></div>
							<div class="spec-value">&nbsp;</div>
							<%
								}
							%>
						</div>

						<!-- Location -->
						<div class="grid-item spec-group-name">Location</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue locationItem : locationItems) {
									CPSpecificationOption cpSpecificationOption = locationItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %></div>
							<div class="spec-value"><%= HtmlUtil.escape(locationItem.getValue(languageId)) %></div>
							<%
								}
							%>
						</div>

						<!-- Model -->
						<div class="grid-item spec-group-name">Model</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue modelItem : modelItems) {
									CPSpecificationOption cpSpecificationOption = modelItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %></div>
							<div class="spec-value"><%= HtmlUtil.escape(modelItem.getValue(languageId)) %></div>
							<%
								}
							%>
						</div>

						<!-- Categorization -->
						<div class="grid-item spec-group-name">Categorization</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue categorizationItem : categorizationItems) {
									CPSpecificationOption cpSpecificationOption = categorizationItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %></div>
							<div class="spec-value"><%= HtmlUtil.escape(categorizationItem.getValue(languageId)) %></div>
							<%
								}
							%>
						</div>

						<!-- Reliability -->
						<div class="grid-item spec-group-name">Reliability</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue reliabilityItem : reliabilityItems) {
									CPSpecificationOption cpSpecificationOption = reliabilityItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %></div>
							<div class="spec-value"><%= HtmlUtil.escape(reliabilityItem.getValue(languageId)) %></div>
							<%
								}
							%>
						</div>

						<!-- Financial -->
						<div class="grid-item spec-group-name">Financial</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue financialItem : financialItems) {
									CPSpecificationOption cpSpecificationOption = financialItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %></div>
							<div class="spec-value"><%= HtmlUtil.escape(financialItem.getValue(languageId)) %></div>
							<%
								}
							%>
						</div>

						<!-- Software -->
						<div class="grid-item spec-group-name">Software</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue softwareItem : softwareItems) {
									CPSpecificationOption cpSpecificationOption = softwareItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %></div>
							<div class="spec-value"><%= HtmlUtil.escape(softwareItem.getValue(languageId)) %></div>
							<%
								}
							%>
						</div>

						<!-- RUDR -->
						<div class="grid-item spec-group-name">RUDR Score Details</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue rudrScoreDetailsItem : rudrScoreDetailsItems) {
									CPSpecificationOption cpSpecificationOption = rudrScoreDetailsItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %></div>
							<div class="spec-value"><%= HtmlUtil.escape(rudrScoreDetailsItem.getValue(languageId)) %></div>
							<%
								}
							%>
						</div>

						<!-- RUDR -->
						<div class="grid-item spec-group-name">Device Age</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue deviceAgeItem : deviceAgeItems) {
									CPSpecificationOption cpSpecificationOption = deviceAgeItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %></div>
							<div class="spec-value"><%= HtmlUtil.escape(deviceAgeItem.getValue(languageId)) %></div>
							<%
								}
							%>
						</div>

						<!-- Parts Availability -->
						<div class="grid-item spec-group-name">Parts Availability</div>
						<div class="grid-item sub-grid">
							<%
								for (CPDefinitionSpecificationOptionValue partsAvailabilityItem : partsAvailabilityItems) {
									CPSpecificationOption cpSpecificationOption = partsAvailabilityItem.getCPSpecificationOption();
							%>
							<div class="spec-name"><%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %></div>
							<div class="spec-value"><%= HtmlUtil.escape(partsAvailabilityItem.getValue(languageId)) %></div>
							<%
								}
							%>
						</div>
					</div>





				</commerce-ui:panel>
		</div>
	</div>
</div>
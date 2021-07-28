<%@ page import="java.math.BigDecimal" %>
<%@ include file="/META-INF/resources/init.jsp" %>

<%
    CPContentHelper cpContentHelper = (CPContentHelper)request.getAttribute(CPContentWebKeys.CP_CONTENT_HELPER);
    CPInstanceHelper cpInstanceHelper = (CPInstanceHelper)request.getAttribute("cpInstanceHelper");
    long reliabilityCategoryId = GetterUtil.getLong(request.getAttribute("reliabilityCategoryId"));
    CPDataSourceResult cpDataSourceResult = (CPDataSourceResult)request.getAttribute(CPWebKeys.CP_DATA_SOURCE_RESULT);

    List<CPCatalogEntry> cpCatalogEntries = cpDataSourceResult.getCPCatalogEntries();
    CommerceContext commerceContext = (CommerceContext)request.getAttribute(CommerceWebKeys.COMMERCE_CONTEXT);

%>

<style>

    .quantity-selector {
        display: none;
    }

</style>

<c:choose>
    <c:when test="<%= !cpCatalogEntries.isEmpty() %>">
        <div class="dataset-display-content-wrapper">
            <div class="table-style-stacked">
                <div class="table-responsive">
                    <table class="table table-autofit">
                        <thead>
                            <tr>
                                <th>

                                </th>
                                <th>

                                </th>
                                <th>

                                </th>
                                <th>
                                    <p class="table-list-title">SKU</p>
                                </th>
                                <th>
                                    <p class="table-list-title">Name</p>
                                </th>
                                <th>
                                    <p class="table-list-title">Fair Market Value</p>
                                </th>
                                <th>
                                    <p class="table-list-title">Repair Events Score</p>
                                </th>
                                <th>
                                    <p class="table-list-title">Equipment Downtime Score</p>
                                </th>
                                <th>

                                </th>
                            </tr>
                        </thead>
                        <%
                            for (CPCatalogEntry cpCatalogEntry : cpCatalogEntries) {
                        %>
                        <tr>
                            <%
                                String friendlyURL = cpContentHelper.getFriendlyURL(cpCatalogEntry, themeDisplay);
                                CPSku cpSku = cpContentHelper.getDefaultCPSku(cpCatalogEntry);

                                long cpDefinitionId = cpCatalogEntry.getCPDefinitionId();
                                List<CPDefinitionSpecificationOptionValue> reliabilityItems = cpContentHelper.getCategorizedCPDefinitionSpecificationOptionValues(cpDefinitionId, reliabilityCategoryId);

                                double equipmentDowntimeScore = 0.0;
                                double repairEventsScore = 0.0;

                                for (CPDefinitionSpecificationOptionValue reliabilityItem : reliabilityItems) {
                                    String specKey = reliabilityItem.getCPSpecificationOption().getKey();
                                    if (specKey.equalsIgnoreCase("equipment-downtime-score")) {
                                        equipmentDowntimeScore = GetterUtil.getDouble(reliabilityItem.getValue(languageId));
                                    } else if (specKey.equalsIgnoreCase("repair-events-score")){
                                        repairEventsScore = GetterUtil.getDouble(reliabilityItem.getValue(languageId));
                                    }
                                }

                                String skuValue;
                                long cpInstanceId = 0;


                                List<CPSku> cpSkus = cpCatalogEntry.getCPSkus();
                                cpInstanceId = cpSkus.get(0).getCPInstanceId();

                                String addToCartId = PortalUtil.generateRandomKey(request, "add-to-cart");

                                if (cpSkus.size() > 1){
                                    skuValue = "Multiple SKUs";
                                }else {
                                    skuValue = cpContentHelper.getDefaultCPSku(cpCatalogEntry).getSku();
                                }

                                String thumbnailSrc = cpInstanceHelper.getCPInstanceThumbnailSrc(cpInstanceId);
                            %>
							<td
								<commerce-ui:compare-checkbox
									CPCatalogEntry="<%= cpCatalogEntry %>"
									label='<%= LanguageUtil.get(request, "compare") %>'
								/>								
							</td>
							<td
								<commerce-ui:add-to-wish-list
									 CPCatalogEntry="<%= cpCatalogEntry %>"
								 />
							</td>
                            <td class="">
                                <a href="<%= friendlyURL %>"><img class="card-img-top img-fluid" src="<%= thumbnailSrc %>"></a>
                            </td>
                            <td class=""><a href="<%= friendlyURL %>"><%= skuValue %></a></td>
                            <td class=""><a href="<%= friendlyURL %>"><%= cpCatalogEntry.getName() %></a></td>
                            <td class="">$<%= cpCatalogEntry.getCPSkus().get(0).getPrice().setScale(0, BigDecimal.ROUND_UP)%></td>
<%--                            <td class="">--%>
<%--                                <commerce-ui:price--%>
<%--                                        CPDefinitionId="<%= cpCatalogEntry.getCPDefinitionId() %>"--%>
<%--                                        CPInstanceId="<%= (cpSku == null) ? 0 : cpSku.getCPInstanceId() %>"--%>
<%--                                        id='<%= "productDetail_" + cpCatalogEntry.getCPDefinitionId() %>'--%>
<%--                                />--%>
<%--                            </td>--%>
                            <td class=""><a href="<%= friendlyURL %>"><%= repairEventsScore %></a></td>
                            <td class=""><a href="<%= friendlyURL %>"><%= equipmentDowntimeScore %></a></td>

                            <c:choose>
                                <c:when test="<%= cpSku != null %>">
                                    <td>
                                        <commerce-ui:add-to-cart
                                                        CPInstanceId="<%= cpSku.getCPInstanceId() %>"
                                                        id="<%= addToCartId %>"
                                        />
                                    </td>
                                </c:when>
                            <c:otherwise>
                                <td>
                                    <a class="commerce-button commerce-button--outline w-100" href="<%= friendlyURL %>">
                                        <liferay-ui:message key="view-all-variants" />
                                    </a>
                                </td>
                            </c:otherwise>
                        </c:choose>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="alert alert-info">
            <liferay-ui:message key="no-products-were-found" />
        </div>
    </c:otherwise>
</c:choose>
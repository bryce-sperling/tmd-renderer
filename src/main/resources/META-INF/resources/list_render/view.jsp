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


<script>
	function addWishListItem(wishlistId, cpId, cpiUuid, cpDefId) {
		Liferay.Service(
			'/commerce.commercewishlistitem/add-commerce-wish-list-item',
		  	{
			    commerceAccountId: 0,
			    commerceWishListId: wishlistId,
			    cProductId: cpId,
			    cpInstanceUuid: cpiUuid,
			    json: ''
			},
			function(obj) {
		    	console.log(obj);
		  		var el = document.getElementById("wishlist-" + cpDefId + "-button-id");
		  		console.log("add wishlist elem classname=" + el.className)
		  		el.className = "minium-card__add-to-wishlist-button minium-card minium-card__add-to-wishlist-button--added";
		  	}
		);
	}
	
	function deleteWishListItem(wishlistItemId, cpDefId) {
		Liferay.Service(
			'/commerce.commercewishlistitem/delete-commerce-wish-list-item',
			{
				commerceWishListItemId: wishlistItemId
			},
			function(obj) {
				console.log(obj);
		  		var el = document.getElementById("wishlist-" + cpDefId + "-button-id");
		  		console.log("delete wishlist elem classname=" + el.className)
		  		el.className = "minium-card__add-to-wishlist-button";
			}
		);	
	}
</script>

<c:choose>
    <c:when test="<%= !cpCatalogEntries.isEmpty() %>">
        <div class="dataset-display-content-wrapper">
            <div class="table-style-stacked">
                <div class="table-responsive">
                    <table class="table table-autofit" id="datatable">
                        <thead>
                            <tr>
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
<%--                                 <a href="<%= friendlyURL %>"><img class="card-img-top img-fluid" src="<%= thumbnailSrc %>"></a> --%>
                                 <a href="<%= friendlyURL %>"><img class="rounded mx-auto d-block" src="<%= thumbnailSrc %>"></a> 
                            </td>
                            <td class=""><a href="<%= friendlyURL %>"><%= skuValue %></a></td>
                            <td class="" style="text-overflow: ellipsis; overflow: hidden; white-space: nowrap; max-width: 400px; min-width: 200px;"><a href="<%= friendlyURL %>"><%= cpCatalogEntry.getName() %></a></td>
<%--                            <td class=""><a href="<%= friendlyURL %>"><%= cpCatalogEntry.getName() %></a></td>  --%>
                            <td class="">$<%= NumberFormat.getCurrencyInstance().format(cpCatalogEntry.getCPSkus().get(0).getPrice().setScale(0, BigDecimal.ROUND_UP))%></td>
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
                                    <td class="">
                                        <commerce-ui:add-to-cart
                                                        CPInstanceId="<%= cpSku.getCPInstanceId() %>"
                                                        id="<%= addToCartId %>"
                                        />
                                    </td>
                                </c:when>
                            <c:otherwise>
                                <td class=""">
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

<script
  src="https://code.jquery.com/jquery-3.6.0.min.js"
  integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
  crossorigin="anonymous"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.css">
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.js"></script>
<script>
        $('#datatable').DataTable();
</script>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Available Vehicles"/>
</jsp:include>

<%-- Page header --%>
<div class="page-head reveal d-flex justify-content-between align-items-start flex-wrap gap-2">
  <div>
    <h2><i class="bi bi-car-front"></i> Vehicle Inventory</h2>
    <span class="muted-note">Browse and filter our verified second-hand vehicles</span>
  </div>
  <c:if test="${sessionScope.userRole == 'ADMIN'}">
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/vehicle?action=add">
      <i class="bi bi-plus-circle"></i> Add Vehicle
    </a>
  </c:if>
</div>

<c:if test="${error != null}">
  <div class="alert alert-danger auto-dismiss">
    <i class="bi bi-exclamation-circle-fill"></i> ${error}
  </div>
</c:if>
<c:if test="${message != null}">
  <div class="alert alert-success auto-dismiss">
    <i class="bi bi-check-circle-fill"></i> ${message}
  </div>
</c:if>

<%-- Search & Filter --%>
<div class="filter-panel reveal delay-1">
  <form method="get" action="${pageContext.request.contextPath}/vehicle" id="filterForm">
    <input type="hidden" name="action" value="list">
    <div class="row g-3 align-items-end">

      <div class="col-sm-6 col-lg-4">
        <label for="searchQuery" class="form-label">Search</label>
        <div class="input-group">
          <span class="input-group-text"><i class="bi bi-search"></i></span>
          <input type="text" class="form-control" id="searchQuery" name="search"
                 placeholder="Brand or model…" value="${requestScope.search}">
        </div>
      </div>

      <div class="col-sm-6 col-lg-2">
        <label for="vehicleType" class="form-label">Type</label>
        <select class="form-select" id="vehicleType" name="type">
          <option value="">All Types</option>
          <option value="SEDAN" <c:if test="${requestScope.type == 'SEDAN'}">selected</c:if>>Sedan</option>
          <option value="SUV"   <c:if test="${requestScope.type == 'SUV'  }">selected</c:if>>SUV</option>
          <option value="VAN"   <c:if test="${requestScope.type == 'VAN'  }">selected</c:if>>Van</option>
        </select>
      </div>

      <div class="col-sm-6 col-lg-2">
        <label for="vehicleStatus" class="form-label">Status</label>
        <select class="form-select" id="vehicleStatus" name="status">
          <option value="">All Status</option>
          <option value="AVAILABLE" <c:if test="${requestScope.status == 'AVAILABLE'}">selected</c:if>>Available</option>
          <option value="RENTED"    <c:if test="${requestScope.status == 'RENTED'   }">selected</c:if>>Rented</option>
          <option value="SOLD"      <c:if test="${requestScope.status == 'SOLD'     }">selected</c:if>>Sold</option>
        </select>
      </div>

      <div class="col-sm-6 col-lg-2">
        <label for="sortBy" class="form-label">Sort By</label>
        <select class="form-select" id="sortBy">
          <option value="default">Default</option>
          <option value="price_low">Price: Low → High</option>
          <option value="price_high">Price: High → Low</option>
        </select>
      </div>

      <div class="col-lg-2 d-flex gap-2">
        <button type="submit" class="btn btn-primary flex-grow-1">
          <i class="bi bi-search"></i> Search
        </button>
        <a href="${pageContext.request.contextPath}/vehicle?action=list" class="btn btn-secondary" title="Reset">
          <i class="bi bi-x-lg"></i>
        </a>
      </div>
    </div>
  </form>
</div>

<%-- Results count --%>
<c:if test="${not empty requestScope.vehicles}">
  <p class="text-secondary mb-3" style="font-size:.9rem;">
    <i class="bi bi-grid"></i>
    Showing <strong>${requestScope.vehicles.size()}</strong> vehicle(s)
    <c:if test="${not empty requestScope.search}">
      for &ldquo;<strong>${requestScope.search}</strong>&rdquo;
    </c:if>
    <c:if test="${not empty requestScope.type}">
      · Type: <strong>${requestScope.type}</strong>
    </c:if>
    <c:if test="${not empty requestScope.status}">
      · Status: <strong>${requestScope.status}</strong>
    </c:if>
  </p>
</c:if>

<%-- Vehicle Grid --%>
<c:choose>
  <c:when test="${not empty requestScope.vehicles}">
    <div class="row g-3 reveal delay-2" id="vehicleGrid">
      <c:forEach var="v" items="${requestScope.vehicles}">
        <%-- Determine thumb class --%>
        <c:set var="thumbCls" value="sedan-bg"/>
        <c:set var="iconCls"  value="sedan"/>
        <c:if test="${v.type == 'SUV'}"><c:set var="thumbCls" value="suv-bg"/><c:set var="iconCls" value="suv"/></c:if>
        <c:if test="${v.type == 'VAN'}"><c:set var="thumbCls" value="van-bg"/><c:set var="iconCls" value="van"/></c:if>

        <%-- Determine status class --%>
        <c:set var="stCls" value="available"/>
        <c:set var="stLabel" value="Available"/>
        <c:if test="${v.status == 'RENTED'}"><c:set var="stCls" value="rented"/><c:set var="stLabel" value="Rented"/></c:if>
        <c:if test="${v.status == 'SOLD'  }"><c:set var="stCls" value="sold"  /><c:set var="stLabel" value="Sold"  /></c:if>

        <div class="col-sm-6 col-lg-4" data-price="${v.price}">
          <div class="vehicle-card vehicle-card-compact">

            <%-- Thumbnail --%>
            <div class="vc-thumb ${thumbCls}">
              <c:choose>
                <c:when test="${not empty v.imageFileName}">
                  <img src="${pageContext.request.contextPath}/vehicle-image?name=${v.imageFileName}"
                       alt="${v.brand} ${v.model}" style="width:100%;height:100%;object-fit:cover;" loading="lazy">
                </c:when>
                <c:otherwise>
                  <i class="bi bi-car-front-fill vc-thumb-icon ${iconCls}"></i>
                </c:otherwise>
              </c:choose>
              <span class="vc-year">${v.year}</span>
              <span class="vc-status ${stCls}">${stLabel}</span>
            </div>

            <%-- Body --%>
            <div class="vc-body">
              <p class="vc-make mb-0">${v.brand}</p>
              <p class="vc-model-line">${v.model}</p>

              <span class="vc-chip ${iconCls}">
                <i class="bi bi-tag-fill"></i> ${v.type}
              </span>

              <div class="vc-specs">
                <div class="vc-spec">
                  <span class="vc-spec-label">Mileage</span>
                  <span class="vc-spec-val">${v.mileage} km</span>
                </div>
                <div class="vc-spec">
                  <span class="vc-spec-label">Daily Rate</span>
                  <span class="vc-spec-val">LKR ${v.dailyRate}</span>
                </div>
              </div>

              <div class="vc-price-row">
                <div class="vc-price-purchase">
                  <small>Purchase Price</small>
                  LKR ${v.price}
                </div>
              </div>
            </div>

            <%-- Footer actions --%>
            <div class="vc-footer">
              <a href="${pageContext.request.contextPath}/vehicle?action=detail&id=${v.vehicleId}"
                 class="btn btn-info btn-sm flex-grow-1">
                <i class="bi bi-eye"></i> Details
              </a>

              <c:if test="${v.status == 'AVAILABLE'}">
                <c:choose>
                  <c:when test="${sessionScope.user != null && sessionScope.userRole != 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/rental?action=book&vehicleId=${v.vehicleId}"
                       class="btn btn-primary btn-sm">
                      <i class="bi bi-calendar-event"></i> Rent
                    </a>
                    <a href="${pageContext.request.contextPath}/purchase?action=request&vehicleId=${v.vehicleId}"
                       class="btn btn-success btn-sm">
                      <i class="bi bi-bag-check"></i> Buy
                    </a>
                  </c:when>
                  <c:when test="${sessionScope.user == null}">
                    <button class="btn btn-primary btn-sm" onclick="redirectToLogin()">
                      <i class="bi bi-calendar-event"></i> Rent
                    </button>
                    <button class="btn btn-success btn-sm" onclick="redirectToLogin()">
                      <i class="bi bi-bag-check"></i> Buy
                    </button>
                  </c:when>
                </c:choose>
              </c:if>

              <c:if test="${sessionScope.userRole == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/vehicle?action=edit&id=${v.vehicleId}"
                   class="btn btn-warning btn-sm">
                  <i class="bi bi-pencil"></i>
                </a>
                <a href="${pageContext.request.contextPath}/vehicle?action=delete&id=${v.vehicleId}"
                   class="btn btn-danger btn-sm"
                   data-confirm="Delete this vehicle? This action cannot be undone.">
                  <i class="bi bi-trash"></i>
                </a>
              </c:if>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
    <div id="vehiclePagination" class="vehicle-pagination mt-4"></div>
  </c:when>
  <c:otherwise>
    <div class="empty-state reveal">
      <i class="bi bi-car-front"></i>
      <h5>No vehicles found</h5>
      <p>Try adjusting your search or filters — or check back later for new listings.</p>
      <a href="${pageContext.request.contextPath}/vehicle?action=list" class="btn btn-primary">
        <i class="bi bi-arrow-counterclockwise"></i> Clear Filters
      </a>
    </div>
  </c:otherwise>
</c:choose>

<script>
  function redirectToLogin() {
    window.location.href = '${pageContext.request.contextPath}/user?action=login';
  }
</script>

<jsp:include page="footer.jsp"/>

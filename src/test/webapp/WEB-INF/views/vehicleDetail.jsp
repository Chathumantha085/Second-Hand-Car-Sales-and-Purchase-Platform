<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Vehicle Details"/>
</jsp:include>

<c:if test="${error != null}">
  <div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
</c:if>
<c:if test="${message != null}">
  <div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle-fill"></i> ${message}</div>
</c:if>

<%-- Breadcrumb --%>
<nav aria-label="breadcrumb" class="mb-3">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/vehicle?action=list">Vehicles</a></li>
    <li class="breadcrumb-item active">Detail</li>
  </ol>
</nav>

<c:choose>
  <c:when test="${not empty requestScope.vehicle}">
    <c:set var="v" value="${requestScope.vehicle}"/>

    <%-- Type classes --%>
    <c:set var="heroCls"  value="sedan-hero"/>
    <c:set var="iconCls"  value="sedan"/>
    <c:set var="chipCls"  value="sedan"/>
    <c:if test="${v.type == 'SUV'}">
      <c:set var="heroCls" value="suv-hero"/>
      <c:set var="iconCls" value="suv"/>
      <c:set var="chipCls" value="suv"/>
    </c:if>
    <c:if test="${v.type == 'VAN'}">
      <c:set var="heroCls" value="van-hero"/>
      <c:set var="iconCls" value="van"/>
      <c:set var="chipCls" value="van"/>
    </c:if>

    <div class="row g-4 reveal">

      <%-- Main detail card --%>
      <div class="col-lg-8">
        <div class="card" style="border-radius:var(--r-xl);overflow:hidden;">

          <%-- Hero image area --%>
          <div class="detail-hero ${heroCls}">
            <c:choose>
              <c:when test="${not empty v.imageFileName}">
                <img src="${pageContext.request.contextPath}/vehicle-image?name=${v.imageFileName}"
                     alt="${v.brand} ${v.model}" style="width:100%;height:100%;object-fit:cover;">
              </c:when>
              <c:otherwise>
                <i class="bi bi-car-front-fill detail-hero-icon text-${iconCls == 'sedan' ? 'primary' : iconCls == 'suv' ? 'success' : 'violet'}"></i>
              </c:otherwise>
            </c:choose>
            <div class="overlay-badges">
              <span class="vc-year" style="font-size:.9rem;">${v.year}</span>
              <c:choose>
                <c:when test="${v.status == 'AVAILABLE'}">
                  <span class="vc-status available" style="font-size:.8rem;">Available</span>
                </c:when>
                <c:when test="${v.status == 'RENTED'}">
                  <span class="vc-status rented" style="font-size:.8rem;">Currently Rented</span>
                </c:when>
                <c:otherwise>
                  <span class="vc-status sold" style="font-size:.8rem;">Sold</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="card-body p-4">
            <%-- Title row --%>
            <div class="d-flex align-items-start justify-content-between flex-wrap gap-2 mb-3">
              <div>
                <h2 class="mb-0" style="font-size:1.75rem;font-weight:800;">
                  ${v.brand} <span style="font-weight:500;">${v.model}</span>
                </h2>
                <span class="vc-chip ${chipCls} mt-2"><i class="bi bi-tag-fill"></i> ${v.type}</span>
              </div>
            </div>

            <hr class="divider">

            <%-- Specs grid --%>
            <h6 class="fw-700 text-secondary mb-3 text-uppercase" style="font-size:.75rem;letter-spacing:.07em;">Vehicle Specifications</h6>
            <div class="spec-grid mb-4">
              <div class="spec-item">
                <p class="spec-label"><i class="bi bi-car-front me-1"></i> Brand</p>
                <p class="spec-value">${v.brand}</p>
              </div>
              <div class="spec-item">
                <p class="spec-label"><i class="bi bi-gear me-1"></i> Model</p>
                <p class="spec-value">${v.model}</p>
              </div>
              <div class="spec-item">
                <p class="spec-label"><i class="bi bi-calendar3 me-1"></i> Year</p>
                <p class="spec-value">${v.year}</p>
              </div>
              <div class="spec-item">
                <p class="spec-label"><i class="bi bi-speedometer2 me-1"></i> Mileage</p>
                <p class="spec-value">${v.mileage} km</p>
              </div>
            </div>

            <hr class="divider">

            <%-- Pricing --%>
            <h6 class="fw-700 text-secondary mb-3 text-uppercase" style="font-size:.75rem;letter-spacing:.07em;">Pricing</h6>
            <div class="row g-3 mb-4">
              <div class="col-sm-6">
                <div class="price-card purchase-price">
                  <p class="price-card-lbl"><i class="bi bi-cash-coin me-1"></i> Purchase Price</p>
                  <p class="price-card-val mb-0">LKR ${v.price}</p>
                </div>
              </div>
              <div class="col-sm-6">
                <div class="price-card rental-price">
                  <p class="price-card-lbl"><i class="bi bi-calendar-event me-1"></i> Daily Rental Rate</p>
                  <p class="price-card-val mb-0">LKR ${v.dailyRate}</p>
                </div>
              </div>
            </div>

            <c:if test="${not empty v.description}">
              <hr class="divider">
              <h6 class="fw-700 text-secondary mb-2 text-uppercase" style="font-size:.75rem;letter-spacing:.07em;">Description</h6>
              <p class="text-secondary mb-4">${v.description}</p>
            </c:if>

            <hr class="divider">

            <%-- Action buttons --%>
            <div class="d-flex gap-2 flex-wrap">
              <c:choose>
                <c:when test="${v.status == 'AVAILABLE'}">
                  <c:choose>
                    <c:when test="${sessionScope.user != null && sessionScope.userRole != 'ADMIN'}">
                      <a href="${pageContext.request.contextPath}/rental?action=book&vehicleId=${v.vehicleId}"
                         class="btn btn-primary btn-lg">
                        <i class="bi bi-calendar-event"></i> Book Rental
                      </a>
                      <a href="${pageContext.request.contextPath}/purchase?action=request&vehicleId=${v.vehicleId}"
                         class="btn btn-success btn-lg">
                        <i class="bi bi-bag-check"></i> Request Purchase
                      </a>
                    </c:when>
                    <c:when test="${sessionScope.user == null}">
                      <button class="btn btn-primary btn-lg" onclick="redirectToLogin()">
                        <i class="bi bi-calendar-event"></i> Book Rental
                      </button>
                      <button class="btn btn-success btn-lg" onclick="redirectToLogin()">
                        <i class="bi bi-bag-check"></i> Request Purchase
                      </button>
                    </c:when>
                  </c:choose>
                  <c:if test="${sessionScope.userRole == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/vehicle?action=edit&id=${v.vehicleId}"
                       class="btn btn-warning btn-lg">
                      <i class="bi bi-pencil-square"></i> Edit Vehicle
                    </a>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <button class="btn btn-secondary btn-lg" disabled>
                    <i class="bi bi-lock"></i> Not Available for Booking
                  </button>
                  <c:if test="${sessionScope.userRole == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/vehicle?action=edit&id=${v.vehicleId}"
                       class="btn btn-warning btn-lg">
                      <i class="bi bi-pencil-square"></i> Edit Vehicle
                    </a>
                  </c:if>
                </c:otherwise>
              </c:choose>
              <a href="${pageContext.request.contextPath}/vehicle?action=list"
                 class="btn btn-secondary btn-lg">
                <i class="bi bi-arrow-left"></i> Back
              </a>
            </div>
          </div>
        </div>
      </div>

      <%-- Sidebar --%>
      <div class="col-lg-4">
        <div class="card mb-3">
          <div class="card-header bg-info">
            <i class="bi bi-info-circle-fill me-1"></i> Quick Summary
          </div>
          <div class="card-body p-3">
            <div class="d-flex flex-column gap-2">
              <div class="info-card">
                <span class="label">Status</span>
                <span class="value">
                  <c:choose>
                    <c:when test="${v.status == 'AVAILABLE'}">
                      <span class="badge bg-success" style="font-size:.85rem;">Available</span>
                    </c:when>
                    <c:when test="${v.status == 'RENTED'}">
                      <span class="badge bg-warning" style="font-size:.85rem;">Rented</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-danger" style="font-size:.85rem;">Sold</span>
                    </c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="info-card">
                <span class="label">Type</span>
                <span class="value">${v.type}</span>
              </div>
              <div class="info-card">
                <span class="label">Year</span>
                <span class="value">${v.year}</span>
              </div>
              <div class="info-card">
                <span class="label">Mileage</span>
                <span class="value">${v.mileage} km</span>
              </div>
              <div class="info-card">
                <span class="label">Vehicle ID</span>
                <span class="value" style="font-size:.8rem;word-break:break-all;">${v.vehicleId}</span>
              </div>
            </div>
          </div>
        </div>

        <%-- Rental pricing info --%>
        <div class="card" style="border:1px solid #bae6fd;">
          <div class="card-body p-3">
            <h6 class="fw-700 mb-3" style="color:#075985;">
              <i class="bi bi-calculator me-1"></i> Rental Estimate
            </h6>
            <div class="price-row">
              <span>Daily rate</span>
              <strong>LKR ${v.dailyRate}</strong>
            </div>
            <div class="price-row">
              <span>3-day estimate</span>
              <strong>LKR <c:out value="${v.dailyRate * 3}"/></strong>
            </div>
            <div class="price-row">
              <span>Weekly (15% off)</span>
              <strong>LKR <c:out value="${v.dailyRate * 7 * 0.85}"/></strong>
            </div>
          </div>
        </div>
      </div>
    </div>

  </c:when>
  <c:otherwise>
    <div class="empty-state">
      <i class="bi bi-exclamation-circle"></i>
      <h5>Vehicle Not Found</h5>
      <p>The vehicle you're looking for doesn't exist or has been removed.</p>
      <a href="${pageContext.request.contextPath}/vehicle?action=list" class="btn btn-primary">
        <i class="bi bi-arrow-left"></i> Back to Vehicles
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

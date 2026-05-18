<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Edit Vehicle"/>
</jsp:include>

<nav aria-label="breadcrumb" class="mb-3">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/vehicle?action=list">Vehicles</a></li>
    <li class="breadcrumb-item active">Edit Vehicle</li>
  </ol>
</nav>

<div class="row justify-content-center reveal">
  <div class="col-lg-9 col-xl-8">

    <c:choose>
      <c:when test="${sessionScope.userRole != 'ADMIN'}">
        <div class="empty-state">
          <i class="bi bi-shield-x"></i>
          <h5>Access Denied</h5>
          <p>Only administrators can edit vehicles.</p>
          <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
            <i class="bi bi-house"></i> Go Home
          </a>
        </div>
      </c:when>

      <c:when test="${not empty requestScope.vehicle}">
        <c:set var="v" value="${requestScope.vehicle}"/>

        <c:if test="${error != null}">
          <div class="alert alert-danger"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
        </c:if>
        <c:if test="${message != null}">
          <div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
        </c:if>

        <%-- Mini vehicle summary --%>
        <c:set var="thumbCls" value="sedan-bg"/>
        <c:set var="iconCls"  value="sedan"/>
        <c:if test="${v.type == 'SUV'}"><c:set var="thumbCls" value="suv-bg"/><c:set var="iconCls" value="suv"/></c:if>
        <c:if test="${v.type == 'VAN'}"><c:set var="thumbCls" value="van-bg"/><c:set var="iconCls" value="van"/></c:if>

        <div class="d-flex align-items-center gap-3 mb-4">
          <div class="vc-thumb ${thumbCls} rounded-3" style="width:70px;height:55px;position:relative;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0;">
            <c:choose>
              <c:when test="${not empty v.imageFileName}">
                <img src="${pageContext.request.contextPath}/vehicle-image?name=${v.imageFileName}"
                     alt="${v.brand} ${v.model}" style="width:100%;height:100%;object-fit:cover;">
              </c:when>
              <c:otherwise>
                <i class="bi bi-car-front-fill vc-thumb-icon ${iconCls}" style="font-size:2.5rem;"></i>
              </c:otherwise>
            </c:choose>
          </div>
          <div>
            <h4 class="fw-700 mb-0">${v.brand} ${v.model}</h4>
            <p class="text-secondary mb-0" style="font-size:.9rem;">Editing vehicle · ID: ${v.vehicleId}</p>
          </div>
        </div>

        <div class="card" style="border-radius:var(--r-xl);">
          <div class="card-header bg-warning">
            <i class="bi bi-pencil-square me-1"></i> Edit Vehicle Details
          </div>
          <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/vehicle" method="post" enctype="multipart/form-data"
                  id="editVehicleForm" novalidate>
              <input type="hidden" name="action"    value="update">
              <input type="hidden" name="vehicleId" value="${v.vehicleId}">

              <%-- Basic info --%>
              <h6 class="fw-700 text-uppercase text-muted mb-3" style="font-size:.72rem;letter-spacing:.07em;">
                <i class="bi bi-car-front me-1"></i> Vehicle Information
              </h6>
              <div class="row g-3 mb-4">
                <div class="col-sm-6">
                  <label for="brand" class="form-label">Brand <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="brand" name="brand"
                         value="${v.brand}" required minlength="2" maxlength="50">
                  <div class="invalid-feedback">Please provide a valid brand name.</div>
                </div>
                <div class="col-sm-6">
                  <label for="model" class="form-label">Model <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="model" name="model"
                         value="${v.model}" required minlength="1" maxlength="50">
                  <div class="invalid-feedback">Please provide a valid model name.</div>
                </div>

                <div class="col-sm-3">
                  <label for="year" class="form-label">Year <span class="text-danger">*</span></label>
                  <input type="number" class="form-control" id="year" name="year"
                         value="${v.year}" required min="1990" max="2099">
                  <div class="invalid-feedback">Year must be between 1990–2099.</div>
                </div>
                <div class="col-sm-5">
                  <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                  <select class="form-select" id="status" name="status" required>
                    <option value="AVAILABLE" <c:if test="${v.status == 'AVAILABLE'}">selected</c:if>>Available</option>
                    <option value="RENTED"    <c:if test="${v.status == 'RENTED'   }">selected</c:if>>Rented</option>
                    <option value="SOLD"      <c:if test="${v.status == 'SOLD'     }">selected</c:if>>Sold</option>
                  </select>
                </div>
                <div class="col-sm-4">
                  <label for="mileage" class="form-label">Mileage (km) <span class="text-danger">*</span></label>
                  <input type="number" class="form-control" id="mileage" name="mileage"
                         value="${v.mileage}" required min="0" max="999999">
                  <div class="invalid-feedback">Please provide a valid mileage.</div>
                </div>
              </div>

              <hr class="divider">

              <%-- Pricing --%>
              <h6 class="fw-700 text-uppercase text-muted mb-3" style="font-size:.72rem;letter-spacing:.07em;">
                <i class="bi bi-cash-coin me-1"></i> Pricing
              </h6>
              <div class="row g-3 mb-4">
                <div class="col-sm-6">
                  <label for="price" class="form-label">Purchase Price (LKR) <span class="text-danger">*</span></label>
                  <div class="input-group">
                    <span class="input-group-text fw-600" style="color:#059669;">LKR</span>
                    <input type="number" class="form-control" id="price" name="price"
                           value="${v.price}" required min="0" step="0.01">
                  </div>
                  <div class="invalid-feedback">Please provide a valid purchase price.</div>
                </div>
                <div class="col-sm-6">
                  <label for="dailyRate" class="form-label">Daily Rental Rate (LKR) <span class="text-danger">*</span></label>
                  <div class="input-group">
                    <span class="input-group-text fw-600" style="color:#0284c7;">LKR</span>
                    <input type="number" class="form-control" id="dailyRate" name="dailyRate"
                           value="${v.dailyRate}" required min="0" step="0.01">
                  </div>
                  <div class="invalid-feedback">Please provide a valid daily rate.</div>
                </div>
              </div>

              <hr class="divider">

              <div class="mb-4">
                <label for="imageFile" class="form-label">
                  Vehicle Image <span class="text-muted fw-400">(optional)</span>
                </label>
                <input type="file" class="form-control" id="imageFile" name="imageFile"
                       accept=".jpg,.jpeg,.png,.gif,.webp,.bmp,image/*">
                <div class="form-text">Upload to replace current image (max 5MB). Leave empty to keep existing image.</div>

                <c:if test="${not empty v.imageFileName}">
                  <div class="mt-2">
                    <img src="${pageContext.request.contextPath}/vehicle-image?name=${v.imageFileName}"
                         alt="Current vehicle image" style="width:160px;height:96px;object-fit:cover;border-radius:8px;border:1px solid var(--border);">
                  </div>
                </c:if>
              </div>

              <div class="d-flex gap-2">
                <button type="submit" class="btn btn-warning btn-lg flex-grow-1" style="color:#fff;">
                  <i class="bi bi-check-circle"></i> Save Changes
                </button>
                <a href="${pageContext.request.contextPath}/vehicle?action=detail&id=${v.vehicleId}"
                   class="btn btn-secondary btn-lg">
                  <i class="bi bi-arrow-left"></i> Cancel
                </a>
              </div>
            </form>
          </div>
        </div>
      </c:when>

      <c:otherwise>
        <div class="empty-state">
          <i class="bi bi-exclamation-circle"></i>
          <h5>Vehicle Not Found</h5>
          <p>The vehicle you're trying to edit does not exist.</p>
          <a href="${pageContext.request.contextPath}/vehicle?action=list" class="btn btn-primary">
            <i class="bi bi-arrow-left"></i> Back to Vehicles
          </a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
  document.getElementById('editVehicleForm') &&
  document.getElementById('editVehicleForm').addEventListener('submit', function (e) {
    if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
    this.classList.add('was-validated');
  });
</script>

<jsp:include page="footer.jsp"/>

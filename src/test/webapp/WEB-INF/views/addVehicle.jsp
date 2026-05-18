<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Add Vehicle"/>
</jsp:include>

<nav aria-label="breadcrumb" class="mb-3">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/vehicle?action=list">Vehicles</a></li>
    <li class="breadcrumb-item active">Add Vehicle</li>
  </ol>
</nav>

<div class="row justify-content-center reveal">
  <div class="col-lg-9 col-xl-8">

    <c:choose>
      <c:when test="${sessionScope.userRole != 'ADMIN'}">
        <div class="empty-state">
          <i class="bi bi-shield-x"></i>
          <h5>Access Denied</h5>
          <p>Only administrators can add vehicles to the platform.</p>
          <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
            <i class="bi bi-house"></i> Go Home
          </a>
        </div>
      </c:when>
      <c:otherwise>
        <c:if test="${error != null}">
          <div class="alert alert-danger"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
        </c:if>
        <c:if test="${message != null}">
          <div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
        </c:if>

        <div class="card" style="border-radius:var(--r-xl);">
          <div class="card-header bg-primary">
            <i class="bi bi-plus-circle me-1"></i> Add New Vehicle
          </div>
          <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/vehicle" method="post" enctype="multipart/form-data"
                  id="addVehicleForm" novalidate>
              <input type="hidden" name="action" value="add">

              <%-- Basic info --%>
              <h6 class="fw-700 text-uppercase text-muted mb-3" style="font-size:.72rem;letter-spacing:.07em;">
                <i class="bi bi-car-front me-1"></i> Vehicle Information
              </h6>
              <div class="row g-3 mb-4">
                <div class="col-sm-6">
                  <label for="brand" class="form-label">Brand <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="brand" name="brand"
                         placeholder="e.g. Toyota" value="${requestScope.brand}"
                         required minlength="2" maxlength="50">
                  <div class="invalid-feedback">Please provide a valid brand name.</div>
                </div>
                <div class="col-sm-6">
                  <label for="model" class="form-label">Model <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="model" name="model"
                         placeholder="e.g. Camry" value="${requestScope.model}"
                         required minlength="1" maxlength="50">
                  <div class="invalid-feedback">Please provide a valid model name.</div>
                </div>

                <div class="col-sm-4">
                  <label for="year" class="form-label">Year <span class="text-danger">*</span></label>
                  <input type="number" class="form-control" id="year" name="year"
                         placeholder="e.g. 2020" value="${requestScope.year}"
                         required min="1990" max="2099">
                  <div class="invalid-feedback">Year must be between 1990–2099.</div>
                </div>
                <div class="col-sm-4">
                  <label for="type" class="form-label">Vehicle Type <span class="text-danger">*</span></label>
                  <select class="form-select" id="type" name="type" required>
                    <option value="">— Select type —</option>
                    <option value="SEDAN" <c:if test="${requestScope.type == 'SEDAN'}">selected</c:if>>Sedan</option>
                    <option value="SUV"   <c:if test="${requestScope.type == 'SUV'  }">selected</c:if>>SUV</option>
                    <option value="VAN"   <c:if test="${requestScope.type == 'VAN'  }">selected</c:if>>Van</option>
                  </select>
                  <div class="invalid-feedback">Please select a vehicle type.</div>
                </div>
                <div class="col-sm-4">
                  <label for="mileage" class="form-label">Mileage (km) <span class="text-danger">*</span></label>
                  <input type="number" class="form-control" id="mileage" name="mileage"
                         placeholder="0" value="${requestScope.mileage}"
                         required min="0" max="999999">
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
                           placeholder="0.00" value="${requestScope.price}"
                           required min="0" step="0.01">
                  </div>
                  <div class="invalid-feedback">Please provide a valid purchase price.</div>
                </div>
                <div class="col-sm-6">
                  <label for="dailyRate" class="form-label">Daily Rental Rate (LKR) <span class="text-danger">*</span></label>
                  <div class="input-group">
                    <span class="input-group-text fw-600" style="color:#0284c7;">LKR</span>
                    <input type="number" class="form-control" id="dailyRate" name="dailyRate"
                           placeholder="0.00" value="${requestScope.dailyRate}"
                           required min="0" step="0.01">
                  </div>
                  <div class="invalid-feedback">Please provide a valid daily rate.</div>
                </div>
              </div>

              <hr class="divider">

              <%-- Description --%>
              <div class="mb-4">
                <label for="description" class="form-label">
                  Description <span class="text-muted fw-400">(optional)</span>
                </label>
                <textarea class="form-control" id="description" name="description" rows="4"
                          maxlength="500"
                          placeholder="Describe the vehicle condition, features, etc.">${requestScope.description}</textarea>
                <div class="form-text">Maximum 500 characters</div>
              </div>

              <%-- Vehicle image --%>
              <div class="mb-4">
                <label for="imageFile" class="form-label">
                  Vehicle Image <span class="text-muted fw-400">(optional)</span>
                </label>
                <input type="file" class="form-control" id="imageFile" name="imageFile"
                       accept=".jpg,.jpeg,.png,.gif,.webp,.bmp,image/*">
                <div class="form-text">Upload a clear photo (max 5MB). Supported: jpg, jpeg, png, gif, webp, bmp.</div>
              </div>

              <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary btn-lg flex-grow-1">
                  <i class="bi bi-plus-circle"></i> Add Vehicle
                </button>
                <a href="${pageContext.request.contextPath}/vehicle?action=list"
                   class="btn btn-secondary btn-lg">
                  <i class="bi bi-arrow-left"></i> Cancel
                </a>
              </div>
            </form>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
  var addVehicleForm = document.getElementById('addVehicleForm');
  if (addVehicleForm) {
    addVehicleForm.addEventListener('submit', function (e) {
      if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
      this.classList.add('was-validated');
    });
  }
</script>

<jsp:include page="footer.jsp"/>

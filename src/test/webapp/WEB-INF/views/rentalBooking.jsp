<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Book Rental"/>
</jsp:include>

<nav aria-label="breadcrumb" class="mb-3">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/vehicle?action=list">Vehicles</a></li>
    <li class="breadcrumb-item active">Book Rental</li>
  </ol>
</nav>

<div class="row justify-content-center reveal">
  <div class="col-lg-10 col-xl-9">

    <c:if test="${error != null}">
      <div class="alert alert-danger mb-3"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
    </c:if>
    <c:if test="${message != null}">
      <div class="alert alert-success mb-3"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
    </c:if>

    <c:choose>
      <c:when test="${sessionScope.user == null}">
        <div class="empty-state">
          <i class="bi bi-lock"></i>
          <h5>Login Required</h5>
          <p>You must be signed in to book a rental.</p>
          <a href="${pageContext.request.contextPath}/user?action=login" class="btn btn-primary">
            <i class="bi bi-box-arrow-in-right"></i> Sign In
          </a>
        </div>
      </c:when>

      <c:when test="${not empty requestScope.vehicle}">
        <c:set var="v" value="${requestScope.vehicle}"/>

        <%-- Vehicle banner --%>
        <c:set var="thumbCls" value="sedan-bg"/>
        <c:set var="iconCls"  value="sedan"/>
        <c:if test="${v.type == 'SUV'}"><c:set var="thumbCls" value="suv-bg"/><c:set var="iconCls" value="suv"/></c:if>
        <c:if test="${v.type == 'VAN'}"><c:set var="thumbCls" value="van-bg"/><c:set var="iconCls" value="van"/></c:if>

        <div class="card mb-4" style="border:1px solid var(--border);">
          <div class="card-body p-3">
            <div class="row align-items-center g-3">
              <div class="col-auto">
                <div class="vc-thumb ${thumbCls} rounded-3" style="width:90px;height:70px;position:relative;display:flex;align-items:center;justify-content:center;overflow:hidden;">
                  <i class="bi bi-car-front-fill vc-thumb-icon ${iconCls}" style="font-size:3rem;"></i>
                </div>
              </div>
              <div class="col">
                <h5 class="fw-700 mb-0">${v.brand} ${v.model}</h5>
                <p class="text-secondary mb-1" style="font-size:.9rem;">${v.year} · <span class="vc-chip ${iconCls}" style="display:inline-flex;margin:0;">${v.type}</span></p>
                <p class="mb-0" style="font-size:.875rem;"><i class="bi bi-speedometer2 me-1 text-muted"></i>${v.mileage} km</p>
              </div>
              <div class="col-auto text-end">
                <p class="mb-0 text-muted" style="font-size:.8rem;">Daily Rate</p>
                <p class="fw-800 mb-0" style="font-size:1.25rem;color:#0284c7;font-family:'Space Grotesk',sans-serif;">
                  LKR ${v.dailyRate}
                </p>
              </div>
            </div>
          </div>
        </div>

        <%-- Booking form --%>
        <div class="card">
          <div class="card-header bg-primary">
            <i class="bi bi-calendar-event me-1"></i> Rental Booking Form
          </div>
          <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/rental" method="post"
                  id="bookingForm" novalidate>
              <input type="hidden" name="action"    value="create">
              <input type="hidden" name="vehicleId" value="${v.vehicleId}">

              <%-- Section: Your info (read-only) --%>
              <h6 class="fw-700 text-uppercase text-muted mb-3" style="font-size:.72rem;letter-spacing:.07em;">
                <i class="bi bi-person-circle me-1"></i> Your Information
              </h6>
              <div class="row g-3 mb-4">
                <div class="col-sm-6">
                  <label class="form-label">Full Name</label>
                  <input type="text" class="form-control" value="${sessionScope.user.name}" disabled>
                </div>
                <div class="col-sm-6">
                  <label class="form-label">Email</label>
                  <input type="email" class="form-control" value="${sessionScope.user.email}" disabled>
                </div>
                <div class="col-sm-6">
                  <label class="form-label">Phone</label>
                  <input type="tel" class="form-control" value="${sessionScope.user.phone}" disabled>
                </div>
              </div>

              <hr class="divider">

              <%-- Section: Dates --%>
              <h6 class="fw-700 text-uppercase text-muted mb-3" style="font-size:.72rem;letter-spacing:.07em;">
                <i class="bi bi-calendar-range me-1"></i> Rental Duration
              </h6>
              <div class="row g-3 mb-4">
                <div class="col-sm-6">
                  <label for="startDate" class="form-label">Start Date <span class="text-danger">*</span></label>
                  <input type="date" class="form-control" id="startDate" name="startDate"
                         value="${requestScope.startDate}" required>
                  <div class="invalid-feedback">Please select a start date.</div>
                </div>
                <div class="col-sm-6">
                  <label for="endDate" class="form-label">End Date <span class="text-danger">*</span></label>
                  <input type="date" class="form-control" id="endDate" name="endDate"
                         value="${requestScope.endDate}" required>
                  <div class="invalid-feedback">End date must be after start date.</div>
                </div>
              </div>

              <hr class="divider">

              <%-- Section: Rental type --%>
              <h6 class="fw-700 text-uppercase text-muted mb-3" style="font-size:.72rem;letter-spacing:.07em;">
                <i class="bi bi-list-check me-1"></i> Rental Plan
              </h6>
              <div class="mb-4">
                <div class="row g-3">
                  <div class="col-sm-6">
                    <label class="d-block form-label mb-2" for="rentalType">Rental Type <span class="text-danger">*</span></label>
                    <select class="form-select" id="rentalType" name="rentalType"
                            required onchange="updateRentalType()">
                      <option value="">— Select plan —</option>
                      <option value="DAILY"  <c:if test="${requestScope.rentalType == 'DAILY' }">selected</c:if>>
                        Daily Rate (standard)
                      </option>
                      <option value="WEEKLY" <c:if test="${requestScope.rentalType == 'WEEKLY'}">selected</c:if>>
                        Weekly Rate (15% discount)
                      </option>
                    </select>
                    <div class="invalid-feedback">Please select a rental plan.</div>
                  </div>
                  <div class="col-sm-6 d-flex align-items-end">
                    <div id="rentalTypeInfo" class="alert alert-info w-100 mb-0 py-2 d-none" style="font-size:.875rem;">
                      <span id="rentalTypeDetails"></span>
                    </div>
                  </div>
                </div>
              </div>

              <hr class="divider">

              <%-- Section: Add-ons --%>
              <h6 class="fw-700 text-uppercase text-muted mb-3" style="font-size:.72rem;letter-spacing:.07em;">
                <i class="bi bi-plus-square me-1"></i> Optional Add-ons
              </h6>
              <div class="row g-2 mb-4">
                <div class="col-sm-4">
                  <div class="form-check p-3 border rounded-3 h-100" style="border-color:var(--border)!important;">
                    <input class="form-check-input" type="checkbox" id="insurance" name="insurance" value="yes"
                           onchange="updateTotalPrice()">
                    <label class="form-check-label fw-600" for="insurance">
                      <i class="bi bi-shield-check text-primary me-1"></i> Insurance
                    </label>
                    <p class="text-muted mb-0 mt-1" style="font-size:.8rem;">+LKR 500/day</p>
                  </div>
                </div>
                <div class="col-sm-4">
                  <div class="form-check p-3 border rounded-3 h-100" style="border-color:var(--border)!important;">
                    <input class="form-check-input" type="checkbox" id="gps" name="gps" value="yes"
                           onchange="updateTotalPrice()">
                    <label class="form-check-label fw-600" for="gps">
                      <i class="bi bi-geo-alt text-success me-1"></i> GPS Navigation
                    </label>
                    <p class="text-muted mb-0 mt-1" style="font-size:.8rem;">+LKR 200/day</p>
                  </div>
                </div>
                <div class="col-sm-4">
                  <div class="form-check p-3 border rounded-3 h-100" style="border-color:var(--border)!important;">
                    <input class="form-check-input" type="checkbox" id="chauffeur" name="chauffeur" value="yes"
                           onchange="updateTotalPrice()">
                    <label class="form-check-label fw-600" for="chauffeur">
                      <i class="bi bi-person-badge text-warning me-1"></i> Driver Service
                    </label>
                    <p class="text-muted mb-0 mt-1" style="font-size:.8rem;">+LKR 1,000/day</p>
                  </div>
                </div>
              </div>

              <hr class="divider">

              <%-- Section: Special requests --%>
              <div class="mb-4">
                <label for="specialRequests" class="form-label">
                  <i class="bi bi-chat-text me-1"></i> Special Requests
                  <span class="text-muted fw-400">(optional)</span>
                </label>
                <textarea class="form-control" id="specialRequests" name="specialRequests"
                          rows="3" maxlength="300"
                          placeholder="e.g. Child seat needed, prefer automatic transmission…">${requestScope.specialRequests}</textarea>
                <div class="form-text">Maximum 300 characters</div>
              </div>

              <hr class="divider">

              <%-- Price summary --%>
              <div class="price-summary-box mb-4">
                <h6 class="fw-700 mb-3" style="color:#075985;">
                  <i class="bi bi-receipt me-1"></i> Price Summary
                </h6>
                <div class="price-row">
                  <span>Daily rate</span>
                  <span>LKR ${v.dailyRate}</span>
                </div>
                <div class="price-row">
                  <span>Number of days</span>
                  <span id="numberOfDaysDisplay">—</span>
                </div>
                <div class="price-row">
                  <span>Rental subtotal</span>
                  <span id="subtotalDisplay">LKR 0.00</span>
                </div>
                <div class="price-row">
                  <span>Add-ons</span>
                  <span id="servicesDisplay">LKR 0.00</span>
                </div>
                <div class="price-row total">
                  <span>Total</span>
                  <span class="price-val" id="totalDisplay">LKR 0.00</span>
                </div>
              </div>

              <%-- Terms --%>
              <div class="form-check mb-4">
                <input class="form-check-input" type="checkbox" id="terms" name="agreeTerms" required>
                <label class="form-check-label" for="terms">
                  I agree to the rental terms and conditions
                </label>
                <div class="invalid-feedback">You must agree to the terms to proceed.</div>
              </div>

              <%-- Buttons --%>
              <div class="d-flex gap-2 flex-wrap">
                <button type="submit" class="btn btn-primary btn-lg flex-grow-1">
                  <i class="bi bi-check-circle"></i> Confirm Booking
                </button>
                <a href="${pageContext.request.contextPath}/vehicle?action=detail&id=${v.vehicleId}"
                   class="btn btn-secondary btn-lg">
                  <i class="bi bi-arrow-left"></i> Back
                </a>
              </div>
            </form>
          </div>
        </div>

        <script>
          var dailyRate = ${v.dailyRate};

          function calculateDays() {
            var s = document.getElementById('startDate').value;
            var e = document.getElementById('endDate').value;
            if (s && e) {
              var diff = new Date(e) - new Date(s);
              var d    = Math.ceil(diff / 86400000) + 1;
              return d > 0 ? d : 0;
            }
            return 0;
          }

          function updateRentalType() {
            var type    = document.getElementById('rentalType').value;
            var info    = document.getElementById('rentalTypeInfo');
            var details = document.getElementById('rentalTypeDetails');
            if (type === 'DAILY') {
              details.textContent = 'Standard daily rate applies for each day.';
              info.classList.remove('d-none');
            } else if (type === 'WEEKLY') {
              details.textContent = '15% discount applied per full week; remaining days billed daily.';
              info.classList.remove('d-none');
            } else {
              info.classList.add('d-none');
            }
            updateTotalPrice();
          }

          function updateTotalPrice() {
            var days       = calculateDays();
            var type       = document.getElementById('rentalType').value;
            var insurance  = document.getElementById('insurance').checked;
            var gps        = document.getElementById('gps').checked;
            var chauffeur  = document.getElementById('chauffeur').checked;

            var rental = 0;
            if (days > 0) {
              if (type === 'WEEKLY') {
                var weeks = Math.floor(days / 7);
                var rem   = days % 7;
                rental = (weeks * dailyRate * 7 * 0.85) + (rem * dailyRate);
              } else {
                rental = days * dailyRate;
              }
            }

            var addons = 0;
            if (insurance) addons += 500  * days;
            if (gps)       addons += 200  * days;
            if (chauffeur) addons += 1000 * days;

            var total = rental + addons;

            document.getElementById('numberOfDaysDisplay').textContent = days || '—';
            document.getElementById('subtotalDisplay').textContent     = 'LKR ' + rental.toFixed(2);
            document.getElementById('servicesDisplay').textContent     = 'LKR ' + addons.toFixed(2);
            document.getElementById('totalDisplay').textContent        = 'LKR ' + total.toFixed(2);
          }

          document.getElementById('startDate').addEventListener('change', updateTotalPrice);
          document.getElementById('endDate').addEventListener('change', updateTotalPrice);

          document.getElementById('bookingForm').addEventListener('submit', function (e) {
            if (calculateDays() <= 0) {
              e.preventDefault();
              alert('End date must be after start date.');
              return;
            }
            if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
            this.classList.add('was-validated');
          });

          // Set today as min for start date
          var today = new Date().toISOString().split('T')[0];
          document.getElementById('startDate').min = today;

          updateTotalPrice();
        </script>
      </c:when>

      <c:otherwise>
        <div class="empty-state">
          <i class="bi bi-exclamation-circle"></i>
          <h5>Vehicle Not Found</h5>
          <p>The vehicle you're trying to book does not exist.</p>
          <a href="${pageContext.request.contextPath}/vehicle?action=list" class="btn btn-primary">
            <i class="bi bi-arrow-left"></i> Back to Vehicles
          </a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<jsp:include page="footer.jsp"/>

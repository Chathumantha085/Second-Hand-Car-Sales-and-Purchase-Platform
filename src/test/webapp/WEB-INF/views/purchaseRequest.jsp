<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Purchase Request"/>
</jsp:include>

<nav aria-label="breadcrumb" class="mb-3">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/vehicle?action=list">Vehicles</a></li>
    <li class="breadcrumb-item active">Purchase Request</li>
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
          <p>You must be signed in to request a vehicle purchase.</p>
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

        <div class="card mb-4">
          <div class="card-body p-3">
            <div class="row align-items-center g-3">
              <div class="col-auto">
                <div class="vc-thumb ${thumbCls} rounded-3" style="width:90px;height:70px;position:relative;display:flex;align-items:center;justify-content:center;overflow:hidden;">
                  <i class="bi bi-car-front-fill vc-thumb-icon ${iconCls}" style="font-size:3rem;"></i>
                </div>
              </div>
              <div class="col">
                <h5 class="fw-700 mb-0">${v.brand} ${v.model}</h5>
                <p class="text-secondary mb-0" style="font-size:.875rem;">${v.year} · ${v.type} · ${v.mileage} km</p>
              </div>
              <div class="col-auto text-end">
                <p class="text-muted mb-0" style="font-size:.8rem;">Purchase Price</p>
                <p class="fw-800 mb-0" style="font-size:1.5rem;color:#059669;font-family:'Space Grotesk',sans-serif;">
                  LKR ${v.price}
                </p>
              </div>
            </div>
          </div>
        </div>

        <%-- Form --%>
        <div class="card">
          <div class="card-header bg-success">
            <i class="bi bi-bag-check me-1"></i> Purchase Request Form
          </div>
          <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/purchase" method="post"
                  id="purchaseForm" novalidate>
              <input type="hidden" name="action"    value="create">
              <input type="hidden" name="vehicleId" value="${v.vehicleId}">
              <input type="hidden" name="amount"    value="${v.price}">

              <%-- Your info --%>
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

              <%-- Payment details --%>
              <h6 class="fw-700 text-uppercase text-muted mb-3" style="font-size:.72rem;letter-spacing:.07em;">
                <i class="bi bi-credit-card me-1"></i> Payment Details
              </h6>
              <div class="row g-3 mb-4">
                <div class="col-sm-6">
                  <label for="paymentType" class="form-label">Payment Method <span class="text-danger">*</span></label>
                  <select class="form-select" id="paymentType" name="paymentType"
                          required onchange="updatePaymentDetails()">
                    <option value="">— Select method —</option>
                    <option value="CASH"     <c:if test="${requestScope.paymentType == 'CASH'    }">selected</c:if>>
                      Cash Payment (full amount)
                    </option>
                    <option value="FINANCED" <c:if test="${requestScope.paymentType == 'FINANCED'}">selected</c:if>>
                      Financed (installment plan)
                    </option>
                  </select>
                  <div class="invalid-feedback">Please select a payment method.</div>
                </div>
                <div class="col-sm-6">
                  <label class="form-label">Total Amount</label>
                  <div class="input-group">
                    <span class="input-group-text fw-700" style="color:#059669;">LKR</span>
                    <input type="text" class="form-control fw-700" value="${v.price}" disabled
                           style="color:#059669;font-family:'Space Grotesk',sans-serif;">
                  </div>
                </div>
              </div>

              <%-- Finance details (conditionally shown) --%>
              <div id="financeDetails" class="d-none">
                <div class="alert alert-info mb-3" style="font-size:.9rem;">
                  <i class="bi bi-info-circle-fill me-1"></i>
                  Please provide your preferred financing terms below. Our team will contact you to finalize.
                </div>
                <div class="row g-3 mb-4">
                  <div class="col-sm-4">
                    <label for="downPayment" class="form-label">Down Payment (LKR)</label>
                    <input type="number" class="form-control" id="downPayment" name="downPayment"
                           min="0" step="0.01" placeholder="0.00"
                           value="${requestScope.downPayment}">
                    <div class="form-text">Amount payable upfront</div>
                  </div>
                  <div class="col-sm-4">
                    <label for="monthlyInstallment" class="form-label">Monthly Installment (LKR)</label>
                    <input type="number" class="form-control" id="monthlyInstallment"
                           name="monthlyInstallment" min="0" step="0.01" placeholder="0.00"
                           value="${requestScope.monthlyInstallment}">
                    <div class="form-text">Proposed monthly payment</div>
                  </div>
                  <div class="col-sm-4">
                    <label for="installmentMonths" class="form-label">Duration (months)</label>
                    <input type="number" class="form-control" id="installmentMonths"
                           name="installmentMonths" min="1" max="60" placeholder="12"
                           value="${requestScope.installmentMonths}">
                    <div class="form-text">1–60 months</div>
                  </div>
                </div>
              </div>

              <hr class="divider">

              <%-- Additional notes --%>
              <div class="mb-4">
                <label for="notes" class="form-label">
                  Additional Notes <span class="text-muted fw-400">(optional)</span>
                </label>
                <textarea class="form-control" id="notes" name="notes" rows="3"
                          maxlength="500"
                          placeholder="Any additional information or special requests…">${requestScope.notes}</textarea>
                <div class="form-text">Maximum 500 characters</div>
              </div>

              <hr class="divider">

              <%-- Price summary --%>
              <div class="price-summary-box mb-4">
                <h6 class="fw-700 mb-3" style="color:#075985;">
                  <i class="bi bi-receipt me-1"></i> Price Summary
                </h6>
                <div class="price-row">
                  <span>Vehicle price</span>
                  <strong>LKR ${v.price}</strong>
                </div>
                <div class="price-row total">
                  <span>Total Amount</span>
                  <span class="price-val">LKR ${v.price}</span>
                </div>
              </div>

              <%-- Terms --%>
              <div class="form-check mb-4">
                <input class="form-check-input" type="checkbox" id="terms" name="agreeTerms" required>
                <label class="form-check-label" for="terms">
                  I agree to the terms and conditions and the purchase request policy
                </label>
                <div class="invalid-feedback">You must agree to the terms to proceed.</div>
              </div>

              <%-- Buttons --%>
              <div class="d-flex gap-2 flex-wrap">
                <button type="submit" class="btn btn-success btn-lg flex-grow-1">
                  <i class="bi bi-check-circle"></i> Submit Purchase Request
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
          function updatePaymentDetails() {
            var type = document.getElementById('paymentType').value;
            document.getElementById('financeDetails').classList.toggle('d-none', type !== 'FINANCED');
          }
          updatePaymentDetails();

          document.getElementById('purchaseForm').addEventListener('submit', function (e) {
            if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
            this.classList.add('was-validated');
          });
        </script>
      </c:when>

      <c:otherwise>
        <div class="empty-state">
          <i class="bi bi-exclamation-circle"></i>
          <h5>Vehicle Not Found</h5>
          <p>The vehicle you're trying to purchase does not exist.</p>
          <a href="${pageContext.request.contextPath}/vehicle?action=list" class="btn btn-primary">
            <i class="bi bi-arrow-left"></i> Back to Vehicles
          </a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<jsp:include page="footer.jsp"/>

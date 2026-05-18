<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="My Profile"/>
</jsp:include>

<div class="row justify-content-center reveal">
  <div class="col-lg-9 col-xl-8">

    <c:if test="${error != null}">
      <div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
    </c:if>
    <c:if test="${message != null}">
      <div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
    </c:if>

    <c:choose>
      <c:when test="${sessionScope.user != null}">

        <%-- Profile header --%>
        <div class="card mb-4" style="border-radius:var(--r-xl);">
          <div class="card-body p-4">
            <div class="d-flex align-items-center gap-4 flex-wrap">
              <div class="profile-avatar">
                ${sessionScope.user.name.substring(0,1)}
              </div>
              <div class="flex-grow-1">
                <h3 class="fw-700 mb-0">${sessionScope.user.name}</h3>
                <p class="text-secondary mb-2" style="font-size:.9rem;">${sessionScope.user.email}</p>
                <c:choose>
                  <c:when test="${sessionScope.userRole == 'ADMIN'}">
                    <span class="badge bg-dark" style="background:linear-gradient(135deg,#7c3aed,#9333ea)!important;color:#fff!important;font-size:.8rem;">
                      <i class="bi bi-shield-fill-check me-1"></i> Administrator
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-info" style="font-size:.8rem;">
                      <i class="bi bi-person-check-fill me-1"></i> Customer
                    </span>
                  </c:otherwise>
                </c:choose>
                <span class="badge bg-success ms-1" style="font-size:.8rem;">
                  <i class="bi bi-circle-fill me-1" style="font-size:.55rem;"></i> Active
                </span>
              </div>
              <div>
                <a href="${pageContext.request.contextPath}/user?action=edit" class="btn btn-primary">
                  <i class="bi bi-pencil-square"></i> Edit Profile
                </a>
              </div>
            </div>
          </div>
        </div>

        <%-- Info cards --%>
        <div class="card mb-4" style="border-radius:var(--r-xl);">
          <div class="card-header" style="background:var(--gray-50);">
            <i class="bi bi-person-lines-fill me-1 text-secondary"></i>
            <span class="fw-700">Account Details</span>
          </div>
          <div class="card-body p-4">
            <div class="row g-3">
              <div class="col-sm-6">
                <div class="info-card">
                  <span class="label"><i class="bi bi-person me-1"></i> Full Name</span>
                  <span class="value">${sessionScope.user.name}</span>
                </div>
              </div>
              <div class="col-sm-6">
                <div class="info-card">
                  <span class="label"><i class="bi bi-envelope me-1"></i> Email Address</span>
                  <span class="value">${sessionScope.user.email}</span>
                </div>
              </div>
              <div class="col-sm-6">
                <div class="info-card">
                  <span class="label"><i class="bi bi-phone me-1"></i> Phone Number</span>
                  <span class="value">${sessionScope.user.phone}</span>
                </div>
              </div>
              <div class="col-sm-6">
                <div class="info-card">
                  <span class="label"><i class="bi bi-shield-check me-1"></i> Role</span>
                  <span class="value">${sessionScope.userRole == 'ADMIN' ? 'Administrator' : 'Customer'}</span>
                </div>
              </div>
              <div class="col-sm-12">
                <div class="info-card">
                  <span class="label"><i class="bi bi-fingerprint me-1"></i> User ID</span>
                  <span class="value" style="font-size:.85rem;font-family:monospace;word-break:break-all;">
                    ${sessionScope.user.userId}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <%-- Quick links --%>
        <div class="card" style="border-radius:var(--r-xl);">
          <div class="card-header" style="background:var(--gray-50);">
            <i class="bi bi-grid me-1 text-secondary"></i>
            <span class="fw-700">Quick Links</span>
          </div>
          <div class="card-body p-4">
            <div class="row g-3">
              <div class="col-sm-4">
                <a href="${pageContext.request.contextPath}/rental?action=list"
                   class="d-block text-center p-3 rounded-3 text-decoration-none"
                   style="background:linear-gradient(135deg,#dbeafe,#bfdbfe);border:1px solid #93c5fd;transition:all .2s;color:#1e40af;">
                  <i class="bi bi-calendar-event d-block mb-2" style="font-size:1.5rem;"></i>
                  <span class="fw-600" style="font-size:.9rem;">My Rentals</span>
                </a>
              </div>
              <div class="col-sm-4">
                <a href="${pageContext.request.contextPath}/purchase?action=list"
                   class="d-block text-center p-3 rounded-3 text-decoration-none"
                   style="background:linear-gradient(135deg,#dcfce7,#bbf7d0);border:1px solid #86efac;transition:all .2s;color:#166534;">
                  <i class="bi bi-bag-check d-block mb-2" style="font-size:1.5rem;"></i>
                  <span class="fw-600" style="font-size:.9rem;">My Purchases</span>
                </a>
              </div>
              <div class="col-sm-4">
                <a href="${pageContext.request.contextPath}/vehicle?action=list"
                   class="d-block text-center p-3 rounded-3 text-decoration-none"
                   style="background:linear-gradient(135deg,#f3e8ff,#e9d5ff);border:1px solid #d8b4fe;transition:all .2s;color:#7c3aed;">
                  <i class="bi bi-car-front d-block mb-2" style="font-size:1.5rem;"></i>
                  <span class="fw-600" style="font-size:.9rem;">Browse Cars</span>
                </a>
              </div>
            </div>
          </div>
        </div>

      </c:when>
      <c:otherwise>
        <div class="empty-state">
          <i class="bi bi-lock"></i>
          <h5>Not Signed In</h5>
          <p>You must be signed in to view your profile.</p>
          <a href="${pageContext.request.contextPath}/user?action=login" class="btn btn-primary">
            <i class="bi bi-box-arrow-in-right"></i> Sign In
          </a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<jsp:include page="footer.jsp"/>

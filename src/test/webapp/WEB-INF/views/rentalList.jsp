<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="My Rentals"/>
</jsp:include>

<div class="page-head reveal">
  <h2><i class="bi bi-calendar-event"></i> Rental Bookings</h2>
  <span class="muted-note">Track and manage your current, completed, and cancelled rentals</span>
</div>

<c:if test="${error != null}">
  <div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
</c:if>
<c:if test="${message != null}">
  <div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
</c:if>

<c:choose>
  <c:when test="${not empty requestScope.rentals}">
    <div class="row g-4 reveal delay-1">
      <c:forEach var="r" items="${requestScope.rentals}">
        <%-- Header class based on status --%>
        <c:set var="hdrCls" value="bh-active"/>
        <c:set var="statusIcon" value="play-circle"/>
        <c:if test="${r.status == 'COMPLETED'}"><c:set var="hdrCls" value="bh-completed"/><c:set var="statusIcon" value="check-circle"/></c:if>
        <c:if test="${r.status == 'CANCELLED'}"><c:set var="hdrCls" value="bh-cancelled"/><c:set var="statusIcon" value="x-circle"/></c:if>

        <div class="col-md-6 col-lg-4">
          <div class="booking-card">
            <div class="card-header ${hdrCls}">
              <div class="d-flex justify-content-between align-items-center">
                <span class="fw-700">Booking #${r.rentalId.length() > 8 ? r.rentalId.substring(0,8).concat('…') : r.rentalId}</span>
                <span class="badge bg-light" style="color:#1e293b;font-size:.75rem;">
                  <i class="bi bi-${statusIcon} me-1"></i>${r.status}
                </span>
              </div>
            </div>

            <div class="card-body">
              <%-- Vehicle --%>
              <div class="d-flex align-items-center gap-2 mb-3 p-2 rounded-3" style="background:var(--gray-50);border:1px solid var(--border);">
                <i class="bi bi-car-front-fill" style="font-size:1.5rem;color:var(--c-cyan);"></i>
                <div>
                  <p class="fw-600 mb-0" style="font-size:.9rem;">Vehicle ID: ${r.vehicleId}</p>
                  <a href="${pageContext.request.contextPath}/vehicle?action=detail&id=${r.vehicleId}"
                     style="font-size:.8rem;">View vehicle →</a>
                </div>
              </div>

              <%-- Dates --%>
              <div class="row g-2 mb-3">
                <div class="col-6">
                  <div class="info-card">
                    <span class="label"><i class="bi bi-calendar-check me-1"></i>Check-in</span>
                    <span class="value">${r.startDate}</span>
                  </div>
                </div>
                <div class="col-6">
                  <div class="info-card">
                    <span class="label"><i class="bi bi-calendar-x me-1"></i>Check-out</span>
                    <span class="value">${r.endDate}</span>
                  </div>
                </div>
              </div>

              <%-- Type & cost --%>
              <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                  <p class="text-muted mb-0" style="font-size:.78rem;">Rental Plan</p>
                  <c:choose>
                    <c:when test="${r.rentalType == 'WEEKLY'}">
                      <span class="badge bg-primary"><i class="bi bi-calendar-week me-1"></i>Weekly</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-info"><i class="bi bi-calendar-day me-1"></i>Daily</span>
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="text-end">
                  <p class="text-muted mb-0" style="font-size:.78rem;">Total Cost</p>
                  <p class="fw-800 mb-0" style="font-size:1.15rem;color:#059669;font-family:'Space Grotesk',sans-serif;">
                    LKR ${r.totalCost}
                  </p>
                </div>
              </div>

              <%-- Payment status --%>
              <div class="d-flex justify-content-between align-items-center">
                <span class="text-muted" style="font-size:.8rem;">Payment</span>
                <c:choose>
                  <c:when test="${r.status == 'COMPLETED'}">
                    <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Paid</span>
                  </c:when>
                  <c:when test="${r.status == 'CANCELLED'}">
                    <span class="badge bg-danger">Cancelled</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-warning"><i class="bi bi-clock me-1"></i>Pending</span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <%-- Footer actions --%>
            <div class="card-footer d-flex gap-2 flex-wrap">
              <a href="${pageContext.request.contextPath}/vehicle?action=detail&id=${r.vehicleId}"
                 class="btn btn-info btn-sm">
                <i class="bi bi-eye"></i> Vehicle
              </a>
              <c:if test="${r.status == 'ACTIVE'}">
                <a href="${pageContext.request.contextPath}/rental?action=complete&id=${r.rentalId}"
                   class="btn btn-success btn-sm"
                   data-confirm="Mark this rental as completed?">
                  <i class="bi bi-check-circle"></i> Complete
                </a>
                <a href="${pageContext.request.contextPath}/rental?action=cancel&id=${r.rentalId}"
                   class="btn btn-danger btn-sm"
                   data-confirm="Cancel this rental booking? This cannot be undone.">
                  <i class="bi bi-x-circle"></i> Cancel
                </a>
              </c:if>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:when>

  <c:otherwise>
    <div class="empty-state reveal">
      <i class="bi bi-calendar-event"></i>
      <h5>No Rental Bookings Yet</h5>
      <p>You haven't booked any rentals. Browse our inventory and find your next ride.</p>
      <a href="${pageContext.request.contextPath}/vehicle?action=list" class="btn btn-primary">
        <i class="bi bi-car-front"></i> Browse Vehicles
      </a>
    </div>
  </c:otherwise>
</c:choose>

<c:if test="${sessionScope.user != null && empty requestScope.rentals}">
  <a href="${pageContext.request.contextPath}/vehicle?action=list"
     class="floating-fab btn btn-primary" title="Browse Vehicles">
    <i class="bi bi-car-front" style="font-size:1.4rem;"></i>
  </a>
</c:if>

<jsp:include page="footer.jsp"/>

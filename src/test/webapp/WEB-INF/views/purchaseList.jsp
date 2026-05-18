<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Purchase Transactions"/>
</jsp:include>

<div class="page-head reveal d-flex justify-content-between align-items-start flex-wrap gap-2">
  <div>
    <h2><i class="bi bi-bag-check"></i> Purchase Transactions</h2>
    <span class="muted-note">
      <c:choose>
        <c:when test="${sessionScope.userRole == 'ADMIN'}">Review and manage all purchase requests</c:when>
        <c:otherwise>Track your vehicle purchase requests and approval status</c:otherwise>
      </c:choose>
    </span>
  </div>
  <a class="btn btn-primary" href="${pageContext.request.contextPath}/vehicle?action=list">
    <i class="bi bi-car-front"></i> Browse Vehicles
  </a>
</div>

<c:if test="${error != null}">
  <div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
</c:if>
<c:if test="${message != null}">
  <div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
</c:if>

<c:choose>
  <c:when test="${not empty requestScope.purchases}">
    <div class="table-wrap reveal delay-1">
      <div class="table-responsive">
        <table class="table table-hover table-striped mb-0">
          <thead>
            <tr>
              <th>#</th>
              <th>Vehicle</th>
              <c:if test="${sessionScope.userRole == 'ADMIN'}"><th>Buyer</th></c:if>
              <th>Amount</th>
              <th>Payment</th>
              <th>Status</th>
              <th>Date</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="p" items="${requestScope.purchases}" varStatus="loop">
              <tr>
                <td class="text-muted" style="font-size:.85rem;">${loop.index + 1}</td>

                <td>
                  <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-car-front-fill text-primary" style="font-size:1.25rem;"></i>
                    <div>
                      <p class="fw-600 mb-0" style="font-size:.9rem;">Vehicle</p>
                      <a href="${pageContext.request.contextPath}/vehicle?action=detail&id=${p.vehicleId}"
                         style="font-size:.8rem;color:var(--c-cyan);">
                        ${p.vehicleId.length() > 12 ? p.vehicleId.substring(0,12).concat('…') : p.vehicleId}
                      </a>
                    </div>
                  </div>
                </td>

                <c:if test="${sessionScope.userRole == 'ADMIN'}">
                  <td>
                    <span class="fw-600" style="font-size:.9rem;">User</span><br>
                    <span class="text-muted" style="font-size:.8rem;">${p.userId.length() > 12 ? p.userId.substring(0,12).concat('…') : p.userId}</span>
                  </td>
                </c:if>

                <td>
                  <span class="fw-700" style="color:#059669;font-family:'Space Grotesk',sans-serif;">
                    LKR ${p.amount}
                  </span>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${p.paymentType == 'CASH'}">
                      <span class="badge bg-info"><i class="bi bi-cash-coin me-1"></i>Cash</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-primary"><i class="bi bi-credit-card me-1"></i>Financed</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${p.status == 'PENDING'}">
                      <span class="badge bg-warning"><i class="bi bi-clock me-1"></i>Pending</span>
                    </c:when>
                    <c:when test="${p.status == 'APPROVED'}">
                      <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Approved</span>
                    </c:when>
                    <c:when test="${p.status == 'REJECTED'}">
                      <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i>Rejected</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-secondary"><i class="bi bi-dash-circle me-1"></i>${p.status}</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td>
                  <span class="text-secondary" style="font-size:.85rem;">${p.purchaseDate}</span>
                </td>

                <td>
                  <div class="d-flex gap-1 flex-wrap">
                    <a href="${pageContext.request.contextPath}/vehicle?action=detail&id=${p.vehicleId}"
                       class="btn btn-info btn-sm" title="View vehicle">
                      <i class="bi bi-eye"></i>
                    </a>
                    <c:if test="${sessionScope.userRole == 'ADMIN' && p.status == 'PENDING'}">
                      <a href="${pageContext.request.contextPath}/purchase?action=approve&id=${p.purchaseId}"
                         class="btn btn-success btn-sm"
                         data-confirm="Approve this purchase request?">
                        <i class="bi bi-check"></i> Approve
                      </a>
                      <a href="${pageContext.request.contextPath}/purchase?action=reject&id=${p.purchaseId}"
                         class="btn btn-danger btn-sm"
                         data-confirm="Reject this purchase request?">
                        <i class="bi bi-x"></i> Reject
                      </a>
                    </c:if>
                    <c:if test="${sessionScope.userRole != 'ADMIN' && p.status == 'PENDING'}">
                      <a href="${pageContext.request.contextPath}/purchase?action=cancel&id=${p.purchaseId}"
                         class="btn btn-outline-danger btn-sm"
                         data-confirm="Cancel this purchase request?">
                        <i class="bi bi-x-circle"></i> Cancel
                      </a>
                    </c:if>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </c:when>

  <c:otherwise>
    <div class="empty-state reveal">
      <i class="bi bi-bag-check"></i>
      <h5>No Purchase Requests</h5>
      <p>
        <c:choose>
          <c:when test="${sessionScope.userRole == 'ADMIN'}">No purchase requests have been submitted yet.</c:when>
          <c:otherwise>You haven't requested any vehicle purchases yet. Browse our inventory to find your perfect car.</c:otherwise>
        </c:choose>
      </p>
      <a href="${pageContext.request.contextPath}/vehicle?action=list" class="btn btn-primary">
        <i class="bi bi-car-front"></i> Browse Vehicles
      </a>
    </div>
  </c:otherwise>
</c:choose>

<jsp:include page="footer.jsp"/>

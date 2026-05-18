<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="User Management"/>
</jsp:include>

<div class="page-head reveal d-flex justify-content-between align-items-start flex-wrap gap-2">
  <div>
    <h2><i class="bi bi-people"></i> User Management</h2>
    <span class="muted-note">View and manage all registered platform users</span>
  </div>
  <span class="badge bg-primary" style="font-size:.9rem;padding:.5rem 1rem;border-radius:var(--r-full);">
    <i class="bi bi-shield-fill-check me-1"></i> Admin Panel
  </span>
</div>

<c:if test="${sessionScope.userRole != 'ADMIN'}">
  <div class="empty-state">
    <i class="bi bi-shield-x"></i>
    <h5>Access Denied</h5>
    <p>Only administrators can view user management.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
      <i class="bi bi-house"></i> Go Home
    </a>
  </div>
</c:if>

<c:if test="${sessionScope.userRole == 'ADMIN'}">
  <c:if test="${error != null}">
    <div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
  </c:if>
  <c:if test="${message != null}">
    <div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
  </c:if>

  <%-- Summary stats --%>
  <c:if test="${not empty requestScope.users}">
    <div class="row g-3 mb-4 reveal delay-1">
      <div class="col-sm-4">
        <div class="card text-center p-3">
          <div class="fw-800 mb-1" style="font-size:2rem;font-family:'Space Grotesk',sans-serif;color:var(--c-navy);">
            ${requestScope.users.size()}
          </div>
          <div class="text-secondary" style="font-size:.875rem;">Total Users</div>
        </div>
      </div>
      <div class="col-sm-4">
        <div class="card text-center p-3">
          <div class="fw-800 mb-1" style="font-size:2rem;font-family:'Space Grotesk',sans-serif;color:#059669;">
            <c:set var="adminCount" value="0"/>
            <c:forEach var="u" items="${requestScope.users}">
              <c:if test="${u.role == 'ADMIN'}"><c:set var="adminCount" value="${adminCount + 1}"/></c:if>
            </c:forEach>
            ${adminCount}
          </div>
          <div class="text-secondary" style="font-size:.875rem;">Administrators</div>
        </div>
      </div>
      <div class="col-sm-4">
        <div class="card text-center p-3">
          <div class="fw-800 mb-1" style="font-size:2rem;font-family:'Space Grotesk',sans-serif;color:#0284c7;">
            ${requestScope.users.size() - adminCount}
          </div>
          <div class="text-secondary" style="font-size:.875rem;">Customers</div>
        </div>
      </div>
    </div>
  </c:if>

  <c:choose>
    <c:when test="${not empty requestScope.users}">
      <div class="table-wrap reveal delay-2">
        <div class="table-responsive">
          <table class="table table-hover table-striped mb-0">
            <thead>
              <tr>
                <th>#</th>
                <th>User</th>
                <th>Contact</th>
                <th>Role</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="u" items="${requestScope.users}" varStatus="loop">
                <tr>
                  <td class="text-muted" style="font-size:.85rem;">${loop.index + 1}</td>

                  <td>
                    <div class="d-flex align-items-center gap-2">
                      <div class="nav-avatar" style="width:36px;height:36px;font-size:.9rem;flex-shrink:0;">
                        ${u.name.substring(0,1)}
                      </div>
                      <div>
                        <p class="fw-600 mb-0">${u.name}</p>
                        <p class="text-muted mb-0" style="font-size:.8rem;word-break:break-all;">
                          ${u.userId.length() > 16 ? u.userId.substring(0,16).concat('…') : u.userId}
                        </p>
                      </div>
                    </div>
                  </td>

                  <td>
                    <p class="mb-0" style="font-size:.9rem;">${u.email}</p>
                    <p class="text-muted mb-0" style="font-size:.82rem;">${u.phone}</p>
                  </td>

                  <td>
                    <c:choose>
                      <c:when test="${u.role == 'ADMIN'}">
                        <span class="badge"
                              style="background:linear-gradient(135deg,#7c3aed,#9333ea);color:#fff;font-size:.78rem;">
                          <i class="bi bi-shield-fill-check me-1"></i>Admin
                        </span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge bg-info" style="font-size:.78rem;">
                          <i class="bi bi-person me-1"></i>Customer
                        </span>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <td>
                    <span class="badge bg-success" style="font-size:.78rem;">
                      <i class="bi bi-circle-fill me-1" style="font-size:.5rem;"></i>Active
                    </span>
                  </td>

                  <td>
                    <c:if test="${u.userId != sessionScope.user.userId}">
                      <form action="${pageContext.request.contextPath}/user" method="post"
                            style="display:inline;"
                            onsubmit="return confirm('Delete user ${u.name}? This cannot be undone.');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="userId" value="${u.userId}">
                        <button type="submit" class="btn btn-danger btn-sm">
                          <i class="bi bi-trash"></i> Delete
                        </button>
                      </form>
                    </c:if>
                    <c:if test="${u.userId == sessionScope.user.userId}">
                      <span class="badge bg-secondary" style="font-size:.8rem;">Current User</span>
                    </c:if>
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
        <i class="bi bi-people"></i>
        <h5>No Users Found</h5>
        <p>There are no registered users on the platform yet.</p>
      </div>
    </c:otherwise>
  </c:choose>
</c:if>

<jsp:include page="footer.jsp"/>

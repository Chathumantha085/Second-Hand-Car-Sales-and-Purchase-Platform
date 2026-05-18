<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Sign In"/>
</jsp:include>

<div class="row justify-content-center auth-layout reveal">
  <div class="col-lg-9 col-xl-8">
    <div class="auth-panel">
      <div class="row g-0 h-100">

        <%-- Left brand panel --%>
        <div class="col-lg-5 auth-side">
          <div style="position:relative;z-index:1;">
            <div class="mb-3" style="font-size:2.5rem;opacity:.7;color:var(--c-cyan);">
              <i class="bi bi-car-front-fill"></i>
            </div>
            <h3 class="mb-2">Welcome back</h3>
            <p class="mb-3">Sign in to manage your rentals, track purchases, and update your profile — all in one dashboard.</p>
            <ul class="auth-features">
              <li><i class="bi bi-check-circle-fill text-accent me-2"></i> Track active rentals instantly</li>
              <li><i class="bi bi-check-circle-fill text-accent me-2"></i> Monitor purchase approvals</li>
              <li><i class="bi bi-check-circle-fill text-accent me-2"></i> Manage your profile &amp; bookings</li>
            </ul>
          </div>
        </div>

        <%-- Right form panel --%>
        <div class="col-lg-7 auth-form-wrap">
          <div class="mb-4">
            <h4 class="fw-700 mb-1"><i class="bi bi-box-arrow-in-right me-1 text-accent"></i> Sign In</h4>
            <p class="text-secondary mb-0" style="font-size:.9rem;">Enter your credentials to continue</p>
          </div>

          <c:if test="${error != null}">
            <div class="alert alert-danger mb-3"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
          </c:if>
          <c:if test="${message != null}">
            <div class="alert alert-success mb-3"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
          </c:if>

          <form action="${pageContext.request.contextPath}/user" method="post" novalidate>
            <input type="hidden" name="action" value="login">

            <div class="mb-3">
              <label for="email" class="form-label">Email Address</label>
              <div class="input-group">
                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                <input type="email" class="form-control" id="email" name="email"
                       placeholder="you@example.com" required value="${param.email}" autocomplete="email">
              </div>
            </div>

            <div class="mb-4">
              <label for="password" class="form-label">Password</label>
              <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="Enter password" required autocomplete="current-password">
              </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 btn-lg">
              <i class="bi bi-box-arrow-in-right"></i> Sign In
            </button>
          </form>

          <hr class="divider my-4">
          <p class="text-center text-secondary mb-0" style="font-size:.9rem;">
            New to CarHub?
            <a href="${pageContext.request.contextPath}/user?action=register" class="fw-600">Create your free account</a>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .auth-features { list-style: none; padding: 0; margin: 0; }
  .auth-features li { padding: .35rem 0; font-size: .9rem; color: rgba(255,255,255,.8); }
  .text-accent { color: var(--c-cyan) !important; }
</style>

<jsp:include page="footer.jsp"/>

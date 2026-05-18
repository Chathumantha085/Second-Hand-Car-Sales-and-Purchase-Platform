<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Create Account"/>
</jsp:include>

<div class="row justify-content-center auth-layout reveal">
  <div class="col-lg-10 col-xl-9">
    <div class="auth-panel">
      <div class="row g-0 h-100">

        <%-- Left brand panel --%>
        <div class="col-lg-4 auth-side">
          <div style="position:relative;z-index:1;">
            <div class="mb-3" style="font-size:2.5rem;opacity:.7;color:var(--c-cyan);">
              <i class="bi bi-person-plus-fill"></i>
            </div>
            <h3 class="mb-2">Join CarHub</h3>
            <p class="mb-3">Create your free account and start booking rentals or purchasing verified vehicles in minutes.</p>
            <ul class="auth-features">
              <li><i class="bi bi-check-circle-fill text-accent me-2"></i> Fast signup — 2 minutes</li>
              <li><i class="bi bi-check-circle-fill text-accent me-2"></i> Secure account management</li>
              <li><i class="bi bi-check-circle-fill text-accent me-2"></i> Real-time booking dashboard</li>
              <li><i class="bi bi-check-circle-fill text-accent me-2"></i> Daily &amp; weekly rental plans</li>
            </ul>
          </div>
        </div>

        <%-- Right form panel --%>
        <div class="col-lg-8 auth-form-wrap">
          <div class="mb-4">
            <h4 class="fw-700 mb-1"><i class="bi bi-person-plus me-1 text-accent"></i> Create Account</h4>
            <p class="text-secondary mb-0" style="font-size:.9rem;">Fill in your details below to get started</p>
          </div>

          <c:if test="${error != null}">
            <div class="alert alert-danger"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
          </c:if>
          <c:if test="${message != null}">
            <div class="alert alert-success"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
          </c:if>

          <form action="${pageContext.request.contextPath}/user" method="post"
                id="registrationForm" novalidate>
            <input type="hidden" name="action" value="register">

            <div class="row g-3">
              <div class="col-sm-12">
                <label for="name" class="form-label">Full Name <span class="text-danger">*</span></label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-person"></i></span>
                  <input type="text" class="form-control" id="name" name="name"
                         placeholder="Your full name" value="${requestScope.name}"
                         required minlength="2" maxlength="100" autocomplete="name">
                </div>
                <div class="invalid-feedback">Please provide a valid name (2–100 characters).</div>
              </div>

              <div class="col-sm-6">
                <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                  <input type="email" class="form-control" id="email" name="email"
                         placeholder="you@example.com" value="${requestScope.email}"
                         required autocomplete="email">
                </div>
                <div class="invalid-feedback">Please provide a valid email address.</div>
              </div>

              <div class="col-sm-6">
                <label for="phone" class="form-label">Phone Number <span class="text-danger">*</span></label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-phone"></i></span>
                  <input type="tel" class="form-control" id="phone" name="phone"
                         placeholder="e.g. 0771234567" value="${requestScope.phone}"
                         required pattern="[0-9\-\+\s]{10,15}" autocomplete="tel">
                </div>
                <div class="form-text">10–15 digits. You may include + or –.</div>
                <div class="invalid-feedback">Please provide a valid phone number.</div>
              </div>

              <div class="col-sm-6">
                <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-lock"></i></span>
                  <input type="password" class="form-control" id="password" name="password"
                         placeholder="At least 6 characters"
                         required minlength="6" maxlength="50" autocomplete="new-password">
                </div>
                <small id="pwStrength" class="form-text"></small>
                <div class="invalid-feedback">Password must be at least 6 characters.</div>
              </div>

              <div class="col-sm-6">
                <label for="confirmPassword" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                  <input type="password" class="form-control" id="confirmPassword"
                         name="confirmPassword" placeholder="Re-enter password"
                         required minlength="6" maxlength="50" autocomplete="new-password">
                </div>
                <div class="invalid-feedback">Passwords do not match.</div>
              </div>
            </div>

            <div class="mt-4">
              <button type="submit" class="btn btn-success w-100 btn-lg">
                <i class="bi bi-person-check"></i> Create Account
              </button>
            </div>
          </form>

          <hr class="divider my-4">
          <p class="text-center text-secondary mb-0" style="font-size:.9rem;">
            Already have an account?
            <a href="${pageContext.request.contextPath}/user?action=login" class="fw-600">Sign in here</a>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .auth-features { list-style: none; padding: 0; margin: 0; }
  .auth-features li { padding: .32rem 0; font-size: .9rem; color: rgba(255,255,255,.8); }
  .text-accent { color: var(--c-cyan) !important; }
</style>

<script>
  document.getElementById('registrationForm').addEventListener('submit', function (e) {
    var pw  = document.getElementById('password').value;
    var cpw = document.getElementById('confirmPassword');
    if (pw !== cpw.value) {
      cpw.setCustomValidity('Passwords do not match');
      cpw.classList.add('is-invalid');
      e.preventDefault();
      e.stopPropagation();
    } else {
      cpw.setCustomValidity('');
    }
    if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
    this.classList.add('was-validated');
  });
</script>

<jsp:include page="footer.jsp"/>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Edit Profile"/>
</jsp:include>

<nav aria-label="breadcrumb" class="mb-3">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/user?action=profile">Profile</a></li>
    <li class="breadcrumb-item active">Edit Profile</li>
  </ol>
</nav>

<div class="row justify-content-center reveal">
  <div class="col-lg-8 col-xl-7">

    <c:if test="${error != null}">
      <div class="alert alert-danger"><i class="bi bi-exclamation-circle-fill me-1"></i>${error}</div>
    </c:if>
    <c:if test="${message != null}">
      <div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle-fill me-1"></i>${message}</div>
    </c:if>

    <c:choose>
      <c:when test="${sessionScope.user != null}">

        <%-- Avatar header --%>
        <div class="d-flex align-items-center gap-3 mb-4">
          <div class="profile-avatar">${sessionScope.user.name.substring(0,1)}</div>
          <div>
            <h4 class="fw-700 mb-0">Edit Profile</h4>
            <p class="text-secondary mb-0" style="font-size:.9rem;">Update your personal information below</p>
          </div>
        </div>

        <div class="card" style="border-radius:var(--r-xl);">
          <div class="card-header bg-primary">
            <i class="bi bi-pencil-square me-1"></i> Update Information
          </div>
          <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/user" method="post"
                  id="editProfileForm" novalidate>
              <input type="hidden" name="action" value="update">

              <div class="row g-3">
                <div class="col-sm-12">
                  <label for="name" class="form-label">Full Name <span class="text-danger">*</span></label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" id="name" name="name"
                           value="${sessionScope.user.name}" required minlength="2" maxlength="100">
                  </div>
                  <div class="invalid-feedback">Please provide your full name.</div>
                </div>

                <div class="col-sm-6">
                  <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" id="email" name="email"
                           value="${sessionScope.user.email}" required>
                  </div>
                  <div class="invalid-feedback">Please provide a valid email.</div>
                </div>

                <div class="col-sm-6">
                  <label for="phone" class="form-label">Phone Number <span class="text-danger">*</span></label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-phone"></i></span>
                    <input type="tel" class="form-control" id="phone" name="phone"
                           value="${sessionScope.user.phone}" required pattern="[0-9\-\+\s]{10,15}">
                  </div>
                  <div class="invalid-feedback">Please provide a valid phone number.</div>
                </div>
              </div>

              <hr class="divider my-4">

              <h6 class="fw-700 text-uppercase text-muted mb-3" style="font-size:.72rem;letter-spacing:.07em;">
                <i class="bi bi-lock me-1"></i> Change Password
                <span class="fw-400 text-lowercase" style="font-size:.9em;">(leave blank to keep current)</span>
              </h6>
              <div class="row g-3">
                <div class="col-sm-6">
                  <label for="password" class="form-label">New Password</label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Leave blank to keep current" minlength="6" maxlength="50">
                  </div>
                  <small id="pwStrength" class="form-text"></small>
                </div>
                <div class="col-sm-6">
                  <label for="confirmPassword" class="form-label">Confirm New Password</label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                    <input type="password" class="form-control" id="confirmPassword"
                           name="confirmPassword" placeholder="Re-enter new password"
                           minlength="6" maxlength="50">
                  </div>
                  <div class="invalid-feedback">Passwords do not match.</div>
                </div>
              </div>

              <div class="d-flex gap-2 mt-4">
                <button type="submit" class="btn btn-primary btn-lg flex-grow-1">
                  <i class="bi bi-check-circle"></i> Save Changes
                </button>
                <a href="${pageContext.request.contextPath}/user?action=profile"
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
          <i class="bi bi-lock"></i>
          <h5>Not Signed In</h5>
          <p>You must be signed in to edit your profile.</p>
          <a href="${pageContext.request.contextPath}/user?action=login" class="btn btn-primary">Sign In</a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
  var editProfileForm = document.getElementById('editProfileForm');
  if (editProfileForm) {
    editProfileForm.addEventListener('submit', function (e) {
      var pw  = document.getElementById('password').value;
      var cpw = document.getElementById('confirmPassword');
      if (pw && pw !== cpw.value) {
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
  }
</script>

<jsp:include page="footer.jsp"/>

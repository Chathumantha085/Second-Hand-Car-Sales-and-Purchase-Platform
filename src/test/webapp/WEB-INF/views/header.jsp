<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${param.title != null ? param.title.concat(' — CarHub') : 'CarHub · Car Rental & Purchase'}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,400;0,9..40,500;0,9..40,700&family=Space+Grotesk:wght@500;700;800&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/site.css?v=3">
</head>
<body class="app-body">

<nav class="navbar navbar-expand-lg navbar-dark site-navbar">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/">
      <i class="bi bi-car-front-fill brand-mark"></i> CarHub
    </a>

    <button class="navbar-toggler" type="button"
            data-bs-toggle="collapse" data-bs-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav me-auto gap-1">
        <li class="nav-item">
          <a class="nav-link" data-nav="/vehicle" href="${pageContext.request.contextPath}/vehicle?action=list">
            <i class="bi bi-car-front"></i> Vehicles
          </a>
        </li>
        <c:if test="${sessionScope.user != null}">
          <li class="nav-item">
            <a class="nav-link" data-nav="/rental" href="${pageContext.request.contextPath}/rental?action=list">
              <i class="bi bi-calendar-event"></i> My Rentals
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-nav="/purchase" href="${pageContext.request.contextPath}/purchase?action=list">
              <i class="bi bi-bag-check"></i> My Purchases
            </a>
          </li>
          <c:if test="${sessionScope.userRole == 'ADMIN'}">
            <li class="nav-item">
              <a class="nav-link" data-nav="action=add" href="${pageContext.request.contextPath}/vehicle?action=add">
                <i class="bi bi-plus-circle"></i> Add Vehicle
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" data-nav="action=list" href="${pageContext.request.contextPath}/user?action=list">
                <i class="bi bi-people"></i> Users
              </a>
            </li>
          </c:if>
        </c:if>
      </ul>

      <ul class="navbar-nav align-items-center gap-2">
        <c:choose>
          <c:when test="${sessionScope.user != null}">
            <li class="nav-item dropdown">
              <a class="nav-user-pill dropdown-toggle" href="#"
                 id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                <span class="nav-avatar">${sessionScope.user.name.substring(0,1)}</span>
                <span class="d-none d-md-inline">${sessionScope.user.name}</span>
                <c:if test="${sessionScope.userRole == 'ADMIN'}">
                  <span class="badge bg-primary ms-1" style="font-size:.65rem;">Admin</span>
                </c:if>
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li>
                  <a class="dropdown-item" href="${pageContext.request.contextPath}/user?action=profile">
                    <i class="bi bi-person-circle"></i> My Profile
                  </a>
                </li>
                <li>
                  <a class="dropdown-item" href="${pageContext.request.contextPath}/rental?action=list">
                    <i class="bi bi-calendar-event"></i> My Rentals
                  </a>
                </li>
                <li>
                  <a class="dropdown-item" href="${pageContext.request.contextPath}/purchase?action=list">
                    <i class="bi bi-bag-check"></i> My Purchases
                  </a>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                  <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/user?action=logout">
                    <i class="bi bi-box-arrow-right"></i> Sign Out
                  </a>
                </li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="btn-nav-ghost" data-nav="action=login"
                 href="${pageContext.request.contextPath}/user?action=login">Login</a>
            </li>
            <li class="nav-item">
              <a class="btn-nav-primary"
                 href="${pageContext.request.contextPath}/user?action=register">Create Account</a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<main class="app-main container">

<%-- Flash message from session (set before redirect in servlets) --%>
<c:if test="${not empty sessionScope.flashMsg}">
  <div class="flash-bar flash-${sessionScope.flashType == 'error' ? 'error' : 'success'} auto-dismiss">
    <i class="bi bi-${sessionScope.flashType == 'error' ? 'exclamation-circle' : 'check-circle'}"></i>
    ${sessionScope.flashMsg}
  </div>
  <% session.removeAttribute("flashMsg"); session.removeAttribute("flashType"); %>
</c:if>

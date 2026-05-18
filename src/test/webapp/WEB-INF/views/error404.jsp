<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Page Not Found"/>
</jsp:include>

<div class="row justify-content-center reveal" style="min-height:55vh;align-items:center;">
  <div class="col-md-8 col-lg-6 text-center">
    <div class="mb-4" style="font-size:6rem;font-weight:800;font-family:'Space Grotesk',sans-serif;
                              background:linear-gradient(135deg,var(--c-navy),var(--c-cyan));
                              -webkit-background-clip:text;-webkit-text-fill-color:transparent;
                              background-clip:text;line-height:1;">
      404
    </div>
    <div class="mb-3" style="font-size:4rem;opacity:.2;">
      <i class="bi bi-car-front-fill"></i>
    </div>
    <h3 class="fw-700 mb-2">Page Not Found</h3>
    <p class="text-secondary mb-4" style="font-size:1.0625rem;">
      Looks like this road leads nowhere. The page you're looking for doesn't exist or has been moved.
    </p>
    <div class="d-flex gap-3 justify-content-center flex-wrap">
      <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">
        <i class="bi bi-house"></i> Back to Home
      </a>
      <a href="${pageContext.request.contextPath}/vehicle?action=list" class="btn btn-outline-primary btn-lg">
        <i class="bi bi-car-front"></i> Browse Vehicles
      </a>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>

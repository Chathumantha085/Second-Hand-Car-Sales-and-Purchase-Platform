<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Server Error"/>
</jsp:include>

<div class="row justify-content-center reveal" style="min-height:55vh;align-items:center;">
  <div class="col-md-8 col-lg-6 text-center">
    <div class="mb-4" style="font-size:6rem;font-weight:800;font-family:'Space Grotesk',sans-serif;
                              background:linear-gradient(135deg,#dc2626,#f87171);
                              -webkit-background-clip:text;-webkit-text-fill-color:transparent;
                              background-clip:text;line-height:1;">
      500
    </div>
    <div class="mb-3" style="font-size:3.5rem;opacity:.2;">
      <i class="bi bi-exclamation-triangle-fill"></i>
    </div>
    <h3 class="fw-700 mb-2">Something Went Wrong</h3>
    <p class="text-secondary mb-4" style="font-size:1.0625rem;">
      We hit an unexpected bump in the road. Our team has been notified. Please try again in a moment.
    </p>
    <div class="d-flex gap-3 justify-content-center flex-wrap">
      <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">
        <i class="bi bi-house"></i> Back to Home
      </a>
      <a href="javascript:history.back()" class="btn btn-secondary btn-lg">
        <i class="bi bi-arrow-left"></i> Go Back
      </a>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>

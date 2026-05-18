<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp">
  <jsp:param name="title" value="Find Your Perfect Car"/>
</jsp:include>

<%-- Hero --%>
<section class="home-hero reveal">
  <div class="row align-items-center g-5">
    <div class="col-lg-6">
      <span class="home-pill"><i class="bi bi-patch-check-fill"></i> Premium Marketplace</span>
      <h1 class="home-hero-title">
        Rent fast.<br><span>Buy smart.</span>
      </h1>
      <p class="home-hero-sub">
        The ultimate destination for luxury car enthusiasts. Whether you're looking for a weekend thrill or a permanent upgrade,
        CarHub delivers excellence at every mile.
      </p>
      <div class="home-hero-actions">
        <a class="btn btn-xl btn-primary"
           href="${pageContext.request.contextPath}/vehicle?action=list">
          Explore Inventory
        </a>
        <a class="btn btn-xl btn-outline-light"
           href="#how-it-works">
          How it works
        </a>
      </div>

      <div class="home-metrics">
        <div class="home-metric">
          <span class="metric-value">500+</span>
          <span class="metric-label">Listings</span>
        </div>
        <div class="home-metric">
          <span class="metric-value">12k+</span>
          <span class="metric-label">Users</span>
        </div>
        <div class="home-metric">
          <span class="metric-value">4.9/5</span>
          <span class="metric-label">Rating</span>
        </div>
      </div>
    </div>

    <div class="col-lg-6 d-none d-lg-block">
      <div class="home-hero-card">
        <div class="home-hero-media">
          <div class="hero-media-image">
                <img src="${pageContext.request.contextPath}/images/car-image.avif"
                 alt="Featured car" loading="lazy">
          </div>
        </div>
        <div class="home-cert-badge">
          <span class="cert-icon"><i class="bi bi-shield-check"></i></span>
          <div>
            <p class="cert-title">Certified Choice</p>
            <p class="cert-sub">Inspected by experts</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<%-- Features --%>
<section class="home-features reveal delay-1">
  <div class="section-header text-center mb-5">
    <h2 class="section-title">Everything you need, nothing you don't</h2>
    <p class="section-subtitle">Streamlined services designed to make your automotive journey as smooth as a fresh stretch of asphalt.</p>
  </div>
  <div class="row g-4">
    <div class="col-md-4">
      <div class="home-feature-card">
        <div class="feature-icon-chip"><i class="bi bi-search"></i></div>
        <h5 class="fw-700 mb-2">Find exact matches</h5>
        <p class="feature-desc">Our advanced AI-driven search helps you locate the perfect vehicle based on your specific lifestyle needs.</p>
        <a href="#" class="feature-link">Learn more <i class="bi bi-arrow-right"></i></a>
      </div>
    </div>
    <div class="col-md-4">
      <div class="home-feature-card">
        <div class="feature-icon-chip"><i class="bi bi-calendar-check"></i></div>
        <h5 class="fw-700 mb-2">Rent without hassle</h5>
        <p class="feature-desc">Experience premium mobility with flexible rental terms and doorstep delivery options for any occasion.</p>
        <a href="#" class="feature-link">View Fleet <i class="bi bi-arrow-right"></i></a>
      </div>
    </div>
    <div class="col-md-4">
      <div class="home-feature-card">
        <div class="feature-icon-chip"><i class="bi bi-bag-check"></i></div>
        <h5 class="fw-700 mb-2">Purchase with confidence</h5>
        <p class="feature-desc">Every purchase includes a comprehensive history report and a 12-month limited warranty for peace of mind.</p>
        <a href="#" class="feature-link">Start buying <i class="bi bi-arrow-right"></i></a>
      </div>
    </div>
  </div>
</section>

<%-- How it works --%>
<section id="how-it-works" class="home-steps reveal delay-2">
  <div class="section-header text-center mb-5">
    <h2 class="section-title">Get started in 3 easy steps</h2>
  </div>

  <div class="row g-5 align-items-center">
    <div class="col-lg-6">
      <div class="step-list">
        <div class="step-row">
          <span class="step-badge">1</span>
          <div>
            <h5 class="fw-700 mb-1">Choose your vehicle</h5>
            <p class="text-secondary mb-0">Browse our curated collection of verified cars and select the one that fits your dreams.</p>
          </div>
        </div>
        <div class="step-row">
          <span class="step-badge">2</span>
          <div>
            <h5 class="fw-700 mb-1">Secure financing</h5>
            <p class="text-secondary mb-0">Get instant approval with our integrated financing partners at competitive market rates.</p>
          </div>
        </div>
        <div class="step-row">
          <span class="step-badge">3</span>
          <div>
            <h5 class="fw-700 mb-1">Drive it home</h5>
            <p class="text-secondary mb-0">Complete the paperwork digitally and have your car delivered or pick it up at a hub.</p>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-6">
      <div class="steps-media">
        <div class="steps-image">
          <img src="${pageContext.request.contextPath}/images/rent-image.jpg"
               alt="Rental car" loading="lazy">
        </div>
        <div class="steps-quote">
          <div class="quote-stars">
            <i class="bi bi-star-fill"></i>
            <i class="bi bi-star-fill"></i>
            <i class="bi bi-star-fill"></i>
            <i class="bi bi-star-fill"></i>
            <i class="bi bi-star-fill"></i>
          </div>
          <p class="quote-text">"The smoothest car buying experience I've ever had. No pressure, full transparency, and I love my new ride!"</p>
          <p class="quote-author">Marcus Sterling</p>
          <p class="quote-role">Verified Buyer</p>
        </div>
      </div>
    </div>
  </div>

  <div class="text-center mt-5">
    <a class="btn btn-lg btn-primary" href="${pageContext.request.contextPath}/vehicle?action=list">
      Browse All Vehicles
    </a>
  </div>
</section>

<jsp:include page="footer.jsp"/>

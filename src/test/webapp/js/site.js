document.addEventListener("DOMContentLoaded", function () {
  /* ── Nav active link ── */
  var path = window.location.pathname;
  var query = window.location.search;

  document
    .querySelectorAll(".site-navbar .nav-link[data-nav]")
    .forEach(function (link) {
      var nav = link.getAttribute("data-nav");
      if (!nav) return;
      if (path.indexOf(nav) !== -1 || query.indexOf(nav) !== -1) {
        link.classList.add("active");
      }
    });

  /* ── Auto-dismiss flash / alert messages after 5s ── */
  document
    .querySelectorAll(".flash-bar, .alert.auto-dismiss")
    .forEach(function (el) {
      setTimeout(function () {
        el.style.transition =
          "opacity .5s ease, max-height .5s ease, margin .5s ease, padding .5s ease";
        el.style.opacity = "0";
        el.style.maxHeight = "0";
        el.style.overflow = "hidden";
        el.style.margin = "0";
        el.style.padding = "0";
        setTimeout(function () {
          el.remove();
        }, 520);
      }, 5000);
    });

  /* ── Number formatting helper ── */
  window.fmtLKR = function (n) {
    return (
      "LKR " +
      Number(n).toLocaleString("en-LK", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      })
    );
  };

  /* ── Vehicle list: client-side sort + pagination ── */
  var vehicleGrid = document.getElementById("vehicleGrid");
  var sortSelect = document.getElementById("sortBy");
  var vehiclePagination = document.getElementById("vehiclePagination");
  var vehiclesPerPage = 6;
  var currentVehiclePage = 1;

  if (vehicleGrid) {
    if (sortSelect) {
      sortSelect.addEventListener("change", sortVehicles);
    }
    renderVehiclePage(1);
  }

  function getVehicleCards() {
    if (!vehicleGrid) return [];
    return Array.from(vehicleGrid.querySelectorAll("[data-price]"));
  }

  function sortVehicles() {
    if (!vehicleGrid || !sortSelect) return;
    var cards = getVehicleCards();
    var sortVal = sortSelect.value;
    cards.sort(function (a, b) {
      var pa = parseFloat(a.getAttribute("data-price")) || 0;
      var pb = parseFloat(b.getAttribute("data-price")) || 0;
      if (sortVal === "price_low") return pa - pb;
      if (sortVal === "price_high") return pb - pa;
      return 0;
    });
    cards.forEach(function (c) {
      vehicleGrid.appendChild(c);
    });
    renderVehiclePage(1);
  }

  function renderVehiclePage(page) {
    var cards = getVehicleCards();
    if (!cards.length) {
      if (vehiclePagination) vehiclePagination.innerHTML = "";
      return;
    }

    var totalPages = Math.ceil(cards.length / vehiclesPerPage);
    if (page < 1) page = 1;
    if (page > totalPages) page = totalPages;
    currentVehiclePage = page;

    var startIndex = (currentVehiclePage - 1) * vehiclesPerPage;
    var endIndex = startIndex + vehiclesPerPage;

    cards.forEach(function (card, index) {
      card.style.display =
        index >= startIndex && index < endIndex ? "" : "none";
    });

    renderVehiclePagination(totalPages);
  }

  function renderVehiclePagination(totalPages) {
    if (!vehiclePagination) return;
    if (totalPages <= 1) {
      vehiclePagination.innerHTML = "";
      return;
    }

    var html = [];
    html.push(
      '<button type="button" class="vp-btn" data-page="' +
        (currentVehiclePage - 1) +
        '" ' +
        (currentVehiclePage === 1 ? "disabled" : "") +
        ">Previous</button>",
    );

    for (var i = 1; i <= totalPages; i++) {
      html.push(
        '<button type="button" class="vp-page ' +
          (i === currentVehiclePage ? "active" : "") +
          '" data-page="' +
          i +
          '">' +
          i +
          "</button>",
      );
    }

    html.push(
      '<button type="button" class="vp-btn" data-page="' +
        (currentVehiclePage + 1) +
        '" ' +
        (currentVehiclePage === totalPages ? "disabled" : "") +
        ">Next</button>",
    );

    vehiclePagination.innerHTML = html.join("");

    vehiclePagination
      .querySelectorAll("button[data-page]")
      .forEach(function (btn) {
        btn.addEventListener("click", function () {
          var nextPage = parseInt(btn.getAttribute("data-page"), 10);
          if (!isNaN(nextPage)) {
            renderVehiclePage(nextPage);
          }
        });
      });
  }

  /* ── Booking date validation feedback ── */
  var startDateEl = document.getElementById("startDate");
  var endDateEl = document.getElementById("endDate");
  if (startDateEl && endDateEl) {
    function checkDates() {
      var s = new Date(startDateEl.value);
      var e = new Date(endDateEl.value);
      if (startDateEl.value && endDateEl.value && e <= s) {
        endDateEl.setCustomValidity("End date must be after start date");
        endDateEl.classList.add("is-invalid");
      } else {
        endDateEl.setCustomValidity("");
        endDateEl.classList.remove("is-invalid");
      }
    }
    startDateEl.addEventListener("change", checkDates);
    endDateEl.addEventListener("change", checkDates);
  }

  /* ── Confirm dangerous actions ── */
  document.querySelectorAll("[data-confirm]").forEach(function (el) {
    el.addEventListener("click", function (e) {
      var msg = el.getAttribute("data-confirm") || "Are you sure?";
      if (!confirm(msg)) e.preventDefault();
    });
  });

  /* ── Password strength hint ── */
  var pwInput = document.getElementById("password");
  var pwHint = document.getElementById("pwStrength");
  if (pwInput && pwHint) {
    pwInput.addEventListener("input", function () {
      var len = pwInput.value.length;
      if (len === 0) {
        pwHint.textContent = "";
        pwHint.className = "form-text";
      } else if (len < 6) {
        pwHint.textContent = "Too short";
        pwHint.className = "form-text text-danger";
      } else if (len < 10) {
        pwHint.textContent = "Acceptable";
        pwHint.className = "form-text text-warning";
      } else {
        pwHint.textContent = "Strong";
        pwHint.className = "form-text text-success";
      }
    });
  }
});

// Navbar efecto al scroll (opcional PRO)
window.addEventListener("scroll", () => {
  const navbar = document.querySelector(".navbar");
  navbar.style.background =
    window.scrollY > 60
      ? "rgba(30,25,20,0.95)"
      : "rgba(30,25,20,0.85)";
});

// HERO: mejora percepción de carga
document.addEventListener("DOMContentLoaded", () => {
  const hero = document.querySelector(".hero");
  if (hero) {
    hero.classList.add("is-loaded");
  }
});

/* =========================
   UI GLOBAL
========================= */
const navbar = document.querySelector(".navbar");

window.addEventListener("scroll", () => {
  if (!navbar) return;

  navbar.style.background =
    window.scrollY > 60
      ? "rgba(30,25,20,0.95)"
      : "rgba(30,25,20,0.85)";
});

/* =========================
   HERO
========================= */
document.addEventListener("DOMContentLoaded", () => {
  const hero = document.querySelector(".hero");
  hero?.classList.add("is-loaded");
});

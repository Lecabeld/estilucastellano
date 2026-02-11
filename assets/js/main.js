/* ===================================================
   ESTILU CASTELLANO – MAIN JS PRO
=================================================== */

document.addEventListener("DOMContentLoaded", () => {
  const navbar = document.querySelector(".navbar");
  const hero = document.querySelector(".hero");

  /* ================= NAVBAR SCROLL ================= */
  if (navbar) {
    const handleScroll = () => {
      navbar.classList.toggle("is-scrolled", window.scrollY > 60);
    };

    handleScroll(); // estado inicial
    window.addEventListener("scroll", handleScroll);
  }

  /* ================= HERO LOAD ================= */
  if (hero) {
    hero.classList.add("is-loaded");
  }
});

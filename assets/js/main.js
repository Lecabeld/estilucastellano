// Navbar efecto al scroll (opcional PRO)
window.addEventListener("scroll", () => {
  const navbar = document.querySelector(".navbar");
  navbar.style.background =
    window.scrollY > 60
      ? "rgba(30,25,20,0.95)"
      : "rgba(30,25,20,0.85)";
});

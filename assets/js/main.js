// ================= NAVBAR SCROLL =================
const navbar = document.querySelector('.navbar');

window.addEventListener('scroll', () => {
  if (window.scrollY > 50) {
    navbar.classList.add('is-scrolled');
  } else {
    navbar.classList.remove('is-scrolled');
  }
});

// ================= HERO LOAD =================
const hero = document.querySelector('.hero');

window.addEventListener('load', () => {
  if (hero) hero.classList.add('is-loaded');
});

// ================= FADE-IN ANIMATIONS =================
const faders = document.querySelectorAll('.fade-in');

const appearOptions = {
  threshold: 0.1,
  rootMargin: "0px 0px -50px 0px"
};

const appearOnScroll = new IntersectionObserver((entries, appearOnScroll) => {
  entries.forEach(entry => {
    if (!entry.isIntersecting) return;
    entry.target.classList.add('is-visible');
    appearOnScroll.unobserve(entry.target);
  });
}, appearOptions);

faders.forEach(fader => {
  appearOnScroll.observe(fader);
});

// ================= MOBILE MENU TOGGLE =================
const menuToggle = document.querySelector('.menu-toggle');
const menu = document.querySelector('.menu');

if (menuToggle && menu) {
  menuToggle.addEventListener('click', () => {
    menu.classList.toggle('is-open');
    menuToggle.classList.toggle('is-active');
  });
}

// ================= GATED LINKS =================
const gatedLinks = document.querySelectorAll('.is-locked');

gatedLinks.forEach(link => {
  link.addEventListener('click', e => {
    e.preventDefault();
    alert('🔒 Esta sección es PRO. Debes estar logueado o suscrito para acceder.');
  });
});

// ================= UTILITY =================
const scrollToSection = (selector) => {
  const el = document.querySelector(selector);
  if (el) {
    window.scrollTo({
      top: el.offsetTop - navbar.offsetHeight,
      behavior: 'smooth'
    });
  }
};

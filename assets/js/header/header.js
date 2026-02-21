// Cambia el estilo del header al hacer scroll
window.addEventListener('scroll', () => {
  const header = document.getElementById('header')
  if (window.scrollY > 50) {
    header.classList.add('scrolled')
  } else {
    header.classList.remove('scrolled')
  }
})

// Menu hamburguesa toggle
const hamburger = document.querySelector('.hamburger')
const navList = document.querySelector('.nav-list')

hamburger.addEventListener('click', () => {
  navList.classList.toggle('active')
})

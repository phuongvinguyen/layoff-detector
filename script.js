const pins = document.querySelectorAll('.pin-item');
const sections = document.querySelectorAll('main section, main header');
const map = { top: null };
pins.forEach(p => map[p.dataset.target] = p);

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      pins.forEach(p => p.classList.remove('active'));
      const id = entry.target.id;
      if (map[id]) map[id].classList.add('active');
    }
  });
}, { rootMargin: '-40% 0px -50% 0px', threshold: 0 });

sections.forEach(s => { if (s.id) observer.observe(s); });

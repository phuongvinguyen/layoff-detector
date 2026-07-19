const pins = document.querySelectorAll('.pin-item');
const sections = [...document.querySelectorAll('main header, main section')];
const subLinks = document.querySelectorAll('.sub-links a');
const subTargets = [...document.querySelectorAll('[id^="problem-"], [id^="data-"], [id^="ethics-"], [id^="analysis-"], [id^="viz-"]')];

const map = { top: null };
pins.forEach(p => map[p.dataset.target] = p);
map.top = map.problem; // hero counts as part of section 01 so the nav isn't left with no active item on load

// Reference line: how far down the viewport counts as "currently being read".
// Using a line near the top of the screen means it lines up with where an
// anchor jump / smooth-scroll actually lands the target element.
function referenceLine() {
  return window.innerHeight * 0.35;
}

function setActivePin(id) {
  pins.forEach(p => p.classList.remove('active'));
  if (map[id]) map[id].classList.add('active');
}

function setActiveSub(id) {
  subLinks.forEach(a => a.classList.remove('active'));
  const match = document.querySelector(`.sub-links a[data-sub="${id}"]`);
  if (match) match.classList.add('active');
}

// Find the last element (in document order) whose top has scrolled above
// the reference line. Elements are in document order and don't overlap
// vertically, so this correctly identifies "what's currently in view".
function findCurrent(elements) {
  let current = elements[0] || null;
  const line = referenceLine();
  for (const el of elements) {
    if (el.getBoundingClientRect().top <= line) {
      current = el;
    } else {
      break;
    }
  }
  return current;
}

function updateActiveStates() {
  const currentSection = findCurrent(sections);
  if (currentSection) setActivePin(currentSection.id);

  const currentSub = findCurrent(subTargets);
  if (currentSub) setActiveSub(currentSub.id);
}

// Throttle with requestAnimationFrame so this runs at most once per frame.
let ticking = false;
function onScrollOrResize() {
  if (!ticking) {
    window.requestAnimationFrame(() => {
      updateActiveStates();
      ticking = false;
    });
    ticking = true;
  }
}

window.addEventListener('scroll', onScrollOrResize, { passive: true });
window.addEventListener('resize', onScrollOrResize);
window.addEventListener('load', updateActiveStates);
updateActiveStates();

// Instant feedback on click, in addition to the scroll-driven sync above.
subLinks.forEach(a => {
  a.addEventListener('click', () => {
    subLinks.forEach(l => l.classList.remove('active'));
    a.classList.add('active');
  });
});

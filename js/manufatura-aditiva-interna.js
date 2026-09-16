document.addEventListener('DOMContentLoaded', function () {
  var cards = document.querySelectorAll('.ma-project-card');
  var details = document.querySelectorAll('.ma-project-details');
  var closes = document.querySelectorAll('.ma-project-close');

  function closeAll() {
    details.forEach(function (detail) { detail.classList.remove('active'); });
    cards.forEach(function (card) { card.setAttribute('aria-expanded', 'false'); });
  }

  cards.forEach(function (card) {
    card.addEventListener('click', function () {
      var id = card.getAttribute('data-project');
      var target = document.getElementById(id);
      var wasActive = target.classList.contains('active');
      closeAll();

      if (!wasActive) {
        target.classList.add('active');
        card.setAttribute('aria-expanded', 'true');
        setTimeout(function () {
          target.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }, 50);
      }
    });
  });

  closes.forEach(function (button) {
    button.addEventListener('click', function () {
      var detail = button.closest('.ma-project-details');
      detail.classList.remove('active');
      var card = document.querySelector('.ma-project-card[data-project="' + detail.id + '"]');
      if (card) {
        card.setAttribute('aria-expanded', 'false');
        card.focus();
      }
    });
  });

  var mobile = document.querySelector('.mobile-menu');
  var menu = document.querySelector('.primary-menu');
  if (mobile && menu) {
    mobile.addEventListener('click', function () { menu.classList.toggle('ma-menu-open'); });
    menu.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () { menu.classList.remove('ma-menu-open'); });
    });
  }
});
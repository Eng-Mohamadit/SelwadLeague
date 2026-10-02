// Slider: ألصق هذا الكود في آخر wwwroot/js/site.js
(function () {
    var slider = document.querySelector('.slider');
    if (!slider) return;
    var track = slider.querySelector('.slides');
    var slides = slider.querySelectorAll('.slide');
    var dotsBox = slider.querySelector('.dots');
    var i = 0, timer, startX = null;

    slides.forEach(function (_, n) {
        var b = document.createElement('button');
        b.type = 'button';
        b.setAttribute('aria-label', 'الشريحة ' + (n + 1));
        b.onclick = function () { go(n); restart(); };
        dotsBox.appendChild(b);
    });
    var dots = dotsBox.querySelectorAll('button');

    function go(n) {
        i = (n + slides.length) % slides.length;
        track.style.transform = 'translateX(' + (-i * 100) + '%)';
        dots.forEach(function (d, k) { d.classList.toggle('on', k === i); });
    }
    function restart() {
        clearInterval(timer);
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
        timer = setInterval(function () { go(i + 1); }, 5000);
    }

    slider.querySelector('.next').onclick = function () { go(i + 1); restart(); };
    slider.querySelector('.prev').onclick = function () { go(i - 1); restart(); };
    slider.addEventListener('mouseenter', function () { clearInterval(timer); });
    slider.addEventListener('mouseleave', restart);
    slider.addEventListener('touchstart', function (e) { startX = e.touches[0].clientX; }, { passive: true });
    slider.addEventListener('touchend', function (e) {
        if (startX === null) return;
        var dx = e.changedTouches[0].clientX - startX;
        if (Math.abs(dx) > 40) { go(dx < 0 ? i + 1 : i - 1); restart(); }
        startX = null;
    });

    go(0);
    restart();
})();

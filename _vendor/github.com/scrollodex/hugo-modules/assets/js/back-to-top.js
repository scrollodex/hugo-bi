/*!
 * back-to-top.js
 */
const throttle = (fn, wait) => {
    let inThrottle, lastFn, lastTime;
    return function() {
        const context = this,
              args = arguments;
        if (!inThrottle) {
            fn.apply(context, args);
            lastTime = Date.now();
            inThrottle = true;
        } else {
            clearTimeout(lastFn);
            lastFn = setTimeout(function() {
                if (Date.now() - lastTime >= wait) {
                    fn.apply(context, args);
                    lastTime = Date.now();
                }
            }, Math.max(wait - (Date.now() - lastTime), 0));
        }
    };
};

const delayTime = 420;

const backToTop = document.getElementById('back-to-top');

if (backToTop !== null) {
	window.addEventListener(
		'scroll',
		throttle(function() {
			window.scrollY > 100 ? backToTop.classList.add('show') : backToTop.classList.remove('show');
		}, delayTime)
	);
}

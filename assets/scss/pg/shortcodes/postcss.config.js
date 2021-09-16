const purgecss = require('@fullhuman/postcss-purgecss')
const autoprefixer = require('autoprefixer')

module.exports = {
	plugins: [
		purgecss({
			content: [
				'themes/**/shortcodes/**/*.html',
				'themes/**/layouts/shortcodes/offer-cards-100.html',
				'themes/**/layouts/shortcodes/offer-cards-grid.html',
				
				//'themes/**/_default/**/*.html',
				//'themes/**/layouts/**/*.svg',
				// 'themes/**/*.js',
			]
		}),
		autoprefixer({
			Browserslist: [
				"last 2 versions",
				"Explorer >= 8",
			]
		})
	]
}
const purgecss = require("@fullhuman/postcss-purgecss");
const autoprefixer = require("autoprefixer");

module.exports = {
  plugins: [
    purgecss({
      content: [
        "themes/**/shortcodes/**/*.html",
        //'themes/**/_default/**/*.html',
        //'themes/**/layouts/**/*.svg',
        // 'themes/**/*.js',
      ],
    }),
    autoprefixer({
      overrideBrowserslist: ["last 2 versions", "not dead"],
    }),
  ],
};

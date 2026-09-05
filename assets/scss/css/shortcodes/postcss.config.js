const purgecssModule = require("@fullhuman/postcss-purgecss");
const purgecss = typeof purgecssModule === "function" ? purgecssModule : purgecssModule.default;
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

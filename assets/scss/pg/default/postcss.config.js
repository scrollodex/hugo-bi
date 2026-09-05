const purgecssModule = require("@fullhuman/postcss-purgecss");
const purgecss = typeof purgecssModule === "function" ? purgecssModule : purgecssModule.default;
const autoprefixer = require("autoprefixer");

module.exports = {
  plugins: [
    purgecss({
      content: ["layouts/**/**/*.html", "layouts/**/**/*.svg"],
    }),
    autoprefixer({
      overrideBrowserslist: ["last 2 versions", "not dead"],
    }),
  ],
};

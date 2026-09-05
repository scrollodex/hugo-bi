const purgecss = require("@fullhuman/postcss-purgecss");
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

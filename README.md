# SOLOPX

[BI deploy here](https://hugo-bi.pages.dev/)
[POLY deploy here](https://hugo-poly.pages.dev/)

## ho to build

1. run "npm i"
2. run "node hugo.js"
3. Force deploy run  "hugo --minify"
3. Run locally: hugo --minify server -w -D


## Use icons from Font Awsome 

you can brouse the icons and use the one that are [free](https://fontawesome.com/)

If first+last+credentials are all empty:

  (Bold) Company name
  (Italics) JobTitle            << Skip if blank
  Short Description             << Skip if blank

  Web1                          << Skip if blank
  Web2                          << Skip if blank

  ICON Phone1  ICON Phone2  ICON Fax   << Skip the blank ones

  Long description  (First 10 words then [expand])

else:

  (Bold) First Last, Credentials
  (Italics) JobTitle            << Skip if blank
  Company name                  << Skip if blank
  Short Description             << Skip if blank

  Web1                          << Skip if blank
  Web2                          << Skip if blank

  ICON Phone1  ICON Phone2  ICON Fax   << Skip the blank ones

  Long description  (First 10 words then [expand])

  

# Sites

- [bizone](https://www.bizone.org/bap/index.html)
- [polyfriendly](https://www.polyfriendly.org/)

# Hugo Data to Pages

Allows for generating pages (or any archetypes) from data (json/yaml) on [Hugo](https://github.com/gohugoio/hugo).
Related to issues [#140](https://github.com/gohugoio/hugo/issues/140) and [5074](https://github.com/gohugoio/hugo/issues/5074).

## Getting Started

This script is a simple wrapper that:
- Generates the pages under your content folder
- Runs Hugo
- And finally, removes the generated pages

The entire script is in `hugo.js`, the `example/` is just an example hugo site.

### Prerequisites

- hugo
- node & npm

### Installing & Running

- Run `npm install` to install dependencies
- Run `node hugo.js` to build
- (optional) Run `chmod +x hugo.js` to allow for direct execution, i.e. `./hugo.js`
- Go to `localhost:1313` to see links to the generated pages

#### Commands

There are 3 available commands:

- `./hugo.js` (basically hugo build to public directory)
- `./hugo.js generate` (only generate folders/files from data, same as above but without executing hugo build)
- `./hugo.js server` (basically hugo server, with cleanup on exit)
- `./hugo.js clean` (trigger cleanup in case the script didn't remove the generated folders)

Flags:
- `-c FILE.json` or `--configFile FILE.json` flag to override default config (check hugoConfig-example.json)
- `-f` or `--force` flag to skip folder removal prompts (be careful with this one!)

## Author

[kidsil](https://github.com/kidsil)

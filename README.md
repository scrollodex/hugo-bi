# scrolloserver for hugo-bi and hugo-poly

Site:    https://www.bizone.org
Rebuild: https://www.bizone.org/.build

Site:    https://www.polyfriendly.org
Rebuild: https://www.polyfriendly.org/.build

## Architecture Overview

This is the README for bizone.org and polyfriendly.org.

The hugo-bi (and hugo-poly) repos contain the hugo files required to build the
website. However the data (the individual resource entriese) is stored on
airtable.com. To download the data and store it in a format that Hugo will
understand, we must "populate" (download) the repo.  This creates/updates files
that are not stored in git (the filenames are in in .gitignore).

Static: You can generate the files locally ("make gen"). This is useful when
debugging.

Web server: The "dyngo" program is a simple webserver that returns the static
content generated by Hugo.  However, if you hit the "/.build" link, it will
download the data from Airtable and re-run Hugo ("make populate generate").  On
startup it runs the process (no need to hit "/.build" yourself).  It has locks
to prevent two of the processes from running concurrently. This simple web
server can be put behind a load balancer for general-purpose use.

## Commands


$ make populate
    Download the data from Airtable.com and create JSON files for Hugo.

$ make gen
    Generate the static website.
    (Note: "make populate gen" is required if the database changes.)

$ make local
    Run the the web server on your desktop:
    Site:  http://localhost:8080
    Panel: http://localhost:8080/.build
    
$ make remote
    Push the containers to Digital Ocean's container registry, which
    automatically deploys to production.

$ make clean
    Remove any downloaded data from Airtable.


## How it all works?

"make build" creates a Docker image with hugo and the "dyngo" binaries.
Hugo is, hugo.  Dygo is a webserver I wrote that returns static
content and handles "/.build" processing.

## Maintenance

### npm

Run "npm i" occationally to update the npm software.

### Update the seach index

FILL IN

---

# Stuff from the old README.md


3. Force deploy run  "hugo --minify"
3. Run locally: hugo --minify server -w -D

## Updating CSS

hugo-poly/layouts must be an exact copy of hugo-bi/layouts

My workflow:
1. update bizone repo and push
2. on Poly run
   - hugo mod get -u
   - hugo mod vendor
3. Copy the folder locally in order to optimize css with "@fullhuman/postcss-purgecss":


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


# Hugo Data to Pages

Allows for generating pages (or any archetypes) from data (json/yaml) on [Hugo](https://github.com/gohugoio/hugo).
Related to issues [#140](https://github.com/gohugoio/hugo/issues/140) and [5074](https://github.com/gohugoio/hugo/issues/5074).

## Getting Started

...

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


## Authors

* [kidsil](https://github.com/kidsil)
* [TomOnTime](https://github.com/TomOnTime)

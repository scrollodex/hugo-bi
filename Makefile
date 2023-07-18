all: build

# Delete any airtable data:
clean: cleanairtable

# Generate files locally:
gen: build generate

# Run server locally:
local: build dyngo

# Push to live site:
remote: build push

#set APPNAME to either hugo-bi or hugo-poly
APPNAME := $(shell cat .appname)

# Build the image with all utilities, etc.
.PHONY: build
build:
	mkdir -p scrolloserver
	rsync -avP --exclude=.git --inplace --delete ../scrolloserver/. scrolloserver/.
	chmod a+rx bin/docker-entrypoint.sh
	docker buildx build --platform linux/amd64 -f Dockerfile -t $(APPNAME) .

# Populate the JSON files from Airtable data.
.PHONY: populate
populate:
	@[ "${AIRTABLE_APIKEY}" ] || ( echo ">> var AIRTABLE_APIKEY is not set"; exit 1 )
	@[ "${AIRTABLE_BASE_ID}" ] || ( echo ">> var AIRTABLE_BASE_ID is not set"; exit 1 )
	docker run --rm \
		-e AIRTABLE_APIKEY=${AIRTABLE_APIKEY} \
		-e AIRTABLE_BASE_ID=${AIRTABLE_BASE_ID} \
		-v $$(pwd)/content:/$(APPNAME)/content/ \
		-v $$(pwd)/public:/$(APPNAME)/public/ \
		-it $(APPNAME) populate

# Generate pages using the local files.
.PHONY: generate
generate:
	docker run --rm \
		-v $$(pwd)/content:/$(APPNAME)/content/ \
		-v $$(pwd)/public:/$(APPNAME)/public/ \
		-it $(APPNAME) generate

# Run the dynamic hugo (dyngo) server.  open http://localhost:8080/
.PHONY: dyngo
dyngo:
	@[ "${AIRTABLE_APIKEY}" ] || ( echo ">> var AIRTABLE_APIKEY is not set"; exit 1 )
	@[ "${AIRTABLE_BASE_ID}" ] || ( echo ">> var AIRTABLE_BASE_ID is not set"; exit 1 )
	docker run --rm \
		-e AIRTABLE_APIKEY=${AIRTABLE_APIKEY} \
		-e AIRTABLE_BASE_ID=${AIRTABLE_BASE_ID} \
		-v $$(pwd)/content:/$(APPNAME)/content/ \
		-v $$(pwd)/public:/$(APPNAME)/public/ \
		-p 8080:8080 \
		-it $(APPNAME) dyngo

# Remove Airtable data from repo:
cleanairtable:
	rm -rf content/entry public/entry
	cat </dev/null >data/entries.yaml

# Update repo with latest airtable data
update: cleanairtable populate generate
	git add data/entries.yaml

# Before "push" will work:
# 1. Install Digital Ocean cli tool: brew install doctl
# 2. Digital Ocean login: doctl auth init
# 3. Digital Ocean registry login: doctl registry login
# 4. Install docker: Download from https://docker.com
# 5. Docker login: docker login 

# Push the latest image:
.PHONY: push
push:
	docker tag $(APPNAME) registry.digitalocean.com/resourceguide/$(APPNAME)
	docker push registry.digitalocean.com/resourceguide/$(APPNAME)

update_from_master:
# hugo-bi contains the master for many files. Sync them to hugo-poly.
# NOTE: hugo-modules is imported by hugo's modules facility. Those are
# not synced here.
	# Verify we are on the correct repo:
	@[ "${APPNAME}" == "hugo-poly" ] || ( echo ">> run this from ../hugo-poly. Exiting."; exit 1 )
	# Sync the files, excluding _variables_.scss and theme.scss (which
	# are specific to each repo):
	rsync --delete -avP --exclude=_variables_.scss --exclude=theme.scss ../hugo-bi/assets/. assets/.
	rsync --delete -avP ../hugo-bi/layouts/. layouts/.
	# Change term.html to be about Poly:
	sed -i.bak 's/bisexuality-aware professionals/polyamory-friendly professionals/'  layouts/_default/term.html
	rm -f layouts/_default/term.html.bak
	# Copy the files from hugo-bi (Dockerfile Makefile README.md):
	( cd ../hugo-bi && cp Dockerfile Makefile README.md ../hugo-poly/. )
	cp ../hugo-bi/bin/docker-entrypoint.sh bin/docker-entrypoint.sh
	chmod a+rx bin/docker-entrypoint.sh
	# Fix Dockerfile to be about hugo-poly:
	sed -i.bak 's/hugo-bi/hugo-poly/g'  Dockerfile
	rm -f Dockerfile.bak

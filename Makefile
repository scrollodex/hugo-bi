all: build

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

# To log in run:
# Install docker
# Install doctl: brew install doctl
# Docker login: docker login 
# DO login: doctl registry login

# Push the latest image:
.PHONY: push
push:
	docker tag $(APPNAME) registry.digitalocean.com/resourceguide/$(APPNAME)
	docker push registry.digitalocean.com/resourceguide/$(APPNAME)

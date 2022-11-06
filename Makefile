
all: build

APPNAME=hugo-bi

.PHONY: build
build:
	mkdir -p scrolloserver
	rsync -avP --exclude=.git --inplace --delete ../scrolloserver/. scrolloserver/.
	docker buildx build --platform linux/amd64 -f Dockerfile -t $(APPNAME) .

.PHONY: run
run:
	@[ "${AIRTABLE_APIKEY}" ] || ( echo ">> var AIRTABLE_APIKEY is not set"; exit 1 )
	@[ "${AIRTABLE_BASE_ID}" ] || ( echo ">> var AIRTABLE_BASE_ID is not set"; exit 1 )
	docker run --rm \
		-e AIRTABLE_APIKEY=${AIRTABLE_APIKEY} \
		-e AIRTABLE_BASE_ID=${AIRTABLE_BASE_ID} \
		-v $$(pwd)/content:/$(APPNAME)/content/ \
		-v $$(pwd)/public:/$(APPNAME)/public/ \
		-it $(APPNAME) $(APPNAME)

# The default is to run the server.

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
		-it $(APPNAME)

# To log in run: docker login registry.digitalocean.com

.PHONY: push
push:
	docker tag $(APPNAME) registry.digitalocean.com/resourceguide/$(APPNAME)
	docker push registry.digitalocean.com/resourceguide/$(APPNAME)

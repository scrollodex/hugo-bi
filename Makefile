
all: build


.PHONY: build
build:
	mkdir -p scrolloserver
	rsync -avP --exclude=.git --inplace --delete ../scrolloserver/. scrolloserver/.
	docker build -f Dockerfile -t hugo-bi .

.PHONY: run
run:
	@[ "${AIRTABLE_APIKEY}" ] || ( echo ">> var AIRTABLE_APIKEY is not set"; exit 1 )
	@[ "${AIRTABLE_BASE_ID}" ] || ( echo ">> var AIRTABLE_BASE_ID is not set"; exit 1 )
	docker run --rm \
		-e AIRTABLE_APIKEY=${AIRTABLE_APIKEY} \
		-e AIRTABLE_BASE_ID=${AIRTABLE_BASE_ID} \
		-v $$(pwd)/content:/hugo-bi/content/ \
		-v $$(pwd)/public:/hugo-bi/public/ \
		-it hugo-bi hugo-bi 

# The default is to run the server.

.PHONY: dyngo
dyngo:
	@[ "${AIRTABLE_APIKEY}" ] || ( echo ">> var AIRTABLE_APIKEY is not set"; exit 1 )
	@[ "${AIRTABLE_BASE_ID}" ] || ( echo ">> var AIRTABLE_BASE_ID is not set"; exit 1 )
	docker run --rm \
		-e AIRTABLE_APIKEY=${AIRTABLE_APIKEY} \
		-e AIRTABLE_BASE_ID=${AIRTABLE_BASE_ID} \
		-v $$(pwd)/content:/hugo-bi/content/ \
		-v $$(pwd)/public:/hugo-bi/public/ \
		-p 8080:8080 \
		-it hugo-bi

# To log in run: docker login registry.digitalocean.com

.PHONY: push
push:
	docker tag hugo-bi registry.digitalocean.com/resourceguide/hugo-bi
	docker push registry.digitalocean.com/resourceguide/hugo-bi

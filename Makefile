
all: build


.PHONY: build
build:
	mkdir -p scrolloserver
	rsync -avP --exclude=.git --inplace --delete ../scrolloserver/. scrolloserver/.
	docker build -f Dockerfile.air2hugo -t hugo-bi .

run:
	@[ "${AIRTABLE_APIKEY}" ] || ( echo ">> var AIRTABLE_APIKEY is not set"; exit 1 )
	@[ "${AIRTABLE_BASE_ID}" ] || ( echo ">> var AIRTABLE_BASE_ID is not set"; exit 1 )
	docker run --rm \
		-e AIRTABLE_APIKEY=${AIRTABLE_APIKEY} \
		-e AIRTABLE_BASE_ID=${AIRTABLE_BASE_ID} \
		-v $$(pwd)/content:/hugo-bi/content/ \
		-v $$(pwd)/public:/hugo-bi/public/ \
		-it hugo-bi

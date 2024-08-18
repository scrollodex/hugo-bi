#!/bin/sh
#
docker run --rm \
  --env-file ../env/.env-bi-main -v $(pwd):/hugo-bi -it hugo-bi populate

#!/bin/sh

echo I am in docker-entrypoint.sh

set -x

mkdir -p public
mkdir -p /hugo-bi/public
dyngo >> public/buildlog.txt

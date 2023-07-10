#!/bin/sh

echo I am in docker-entrypoint.sh

set -x

echo ARGV="$@"

mkdir -p public
mkdir -p /hugo-bi/public
dyngo >> public/buildlog.txt

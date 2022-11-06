#!/bin/sh

set -x

mkdir -p public
dyngo >> public/buildlog.txt

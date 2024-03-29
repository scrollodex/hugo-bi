#!/bin/sh

echo I am in docker-entrypoint.sh

set -e

function prep() {
  export PATH=/usr/local/bin:/usr/local/go/bin:"$PATH"
  mkdir -p public
  mkdir -p /"$APPNAME"/public/entry
  mkdir -p /"$APPNAME"/content/entry
}

function run_dyngo() {
    prep
    dyngo "$@"
    # dyngo >> public/buildlog.txt
}

function run_populate() {
    prep
    air2hugo "$@"
}

function run_generate() {
    prep
    hugo "$@"
}

# Initialize and validate globals

export APPNAME=$(cat .appname)
case "$APPNAME" in
  hugo-bi)
    ;;
  hugo-poly)
    ;;
  *)
    echo "Error!  Invalid appname."
    echo APPNAME="$APPNAME"
    exit 1
    ;;
esac

# Print debugging info
echo APPNAME="$APPNAME"
echo COUNT="$#" ARGV="$@"
echo ARGV0="$0" ARGV1="$1" ARGV2="$2" ARGV3="$3" ARGV4="$4"

# Run the appropriate commands.

# No args?  Default to running the server.
if [[ $# -lt 1 ]]; then
  set - dyngo
fi

# First arg is the command
CMD="$1" ; shift

case "$CMD" in
  dyngo)
    echo "STARTING: DYNGO SERVER"
    run_dyngo "$@"
    ;;
  populate)
    echo "STARTING: POPULATING REPO"
    run_populate "$@"
    ;;
  generate)
    echo "STARTING: GENERATING PAGES"
    run_generate "$@"
    ;;
  *)
    echo "EXITING: Unknown command '$CMD'"
    ;;
esac

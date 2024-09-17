#!/bin/sh

echo I am in docker-entrypoint.sh

set -e

function prep() {
  export PATH=/usr/local/bin:/usr/local/go/bin:"$PATH"
  #mkdir -p public
  #mkdir -p /"$APPNAME"/public/entry
  #mkdir -p /"$APPNAME"/content/entry
  echo 'MAKING DIRS'
  pwd
  #mkdir public/entry
  #mkdir content/entry
  ls -lad public public/entry
  ls -lad content content/entry
}

function run_dyngo() {
    run_generate
    dyngo "$@"
    # dyngo >> public/buildlog.txt
}

function run_populate() {
    prep
    air2hugo "$@"
}

function run_version() {
    hugo version "$@"
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
echo APPNAME="$APPNAME" COUNT="$#" ARGV="$@"
#echo ARGV0="$0" ARGV1="$1" ARGV2="$2" ARGV3="$3" ARGV4="$4"

echo ========== DEBUG START
set -x
pwd
cd /data
pwd
ls
ls /data/public
echo ========== DEBUG END

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
  version)
    echo "STARTING: VERSION"
    run_version "$@"
    ;;
  generate)
    echo "STARTING: GENERATING PAGES"
    run_generate "$@"
    ;;
  *)
    echo "EXITING: Unknown command '$CMD'"
    ;;
esac

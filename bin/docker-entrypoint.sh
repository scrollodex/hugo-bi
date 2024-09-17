#!/bin/sh

echo I am in docker-entrypoint.sh

set -e

function containerdata() {
  echo '========== WORKING ON ${APPNAME} =========='
  echo 'RUNNING OUT OF:' "$(pwd)"
}

function externaldata() {
  echo '========== WORKING ON /data =========='
  # Modify the data outside the container, mounted at /data
  cd /data
  echo 'RUNNING OUT OF:' "$(pwd)"
}

function prep() {
  echo '========== PREP =========='
  # Set PATH
  export PATH=/usr/local/bin:/usr/local/go/bin:"$PATH"

  # Make sure destination dirs exist.
  mkdir -p public/entry
  mkdir -p content/entry
}

function run_dyngo() {
  echo '========== DYNGO =========='
    dyngo "$@"
    # dyngo >> public/buildlog.txt
}

function run_populate() {
  echo '========== POPULATE =========='
    air2hugo "$@"
}

function run_version() {
  echo '========== VERSION =========='
    hugo version "$@"
}

function run_generate() {
  echo '========== GENERATE =========='
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

# No args?  Default to running the server.
if [[ $# -lt 1 ]]; then
  set - dyngo
fi

# Run the appropriate commands.

# First arg is the command
CMD="$1" ; shift
case "$CMD" in
  version)
    echo "STARTING: VERSION"
    containerdata
    run_version "$@"
    ;;
  dyngo)
    echo "STARTING: DYNGO SERVER"
    containerdata
    prep
    run_populate
    run_generate
    run_dyngo "$@"
    ;;
  populate)
    echo "STARTING: POPULATING REPO (writing to external /data)"
    externaldata
    prep
    run_populate "$@"
    ;;
  generate)
    echo "STARTING: GENERATING PAGES (writing to external /data)"
    externaldata
    prep
    run_generate "$@"
    ;;
  *)
    echo "EXITING: Unknown command '$CMD'"
    ;;
esac

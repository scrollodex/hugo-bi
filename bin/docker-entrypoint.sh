#!/bin/sh

echo I am in docker-entrypoint.sh

set -e

function prep() {
  export PATH=/usr/local/bin:/usr/local/go/bin:"$PATH"
}

function run_dyngo() {
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

# If /data exists, we run from there. (because we are running from a
# container on someone's desktop)
# ELSE, run from the current directory. The entire hugo-{bi,poly}
# repo was copied into this container without any entries. The
# "populate" command will download the entries from Airtable.

if [ -d /data ]; then
  echo 'RUNNING OUT OF: /data'
  cd /data
else
  echo 'RUNNING OUT OF: WORKDIR' "($pwd)"
fi

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

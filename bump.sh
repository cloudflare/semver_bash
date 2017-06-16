#!/usr/bin/env bash

set -e

VERSION="$1"
BUMP="$2"

if [ -z "${VERSION}" ]; then
  echo "Need a version to bump."
  echo "Usage: bump.sh $VERSION < patch | minor | major | default = patch >"
  exit 1
fi

if [ -z "${BUMP}" ]; then
  BUMP="patch"
fi

bump() {
  echo $(( $1 + 1 ))
}

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${SCRIPTS_DIR}/semver.sh

MAJOR=0
MINOR=0
PATCH=0
SPECIAL=""

semverParseInto "${VERSION}" MAJOR MINOR PATCH SPECIAL

case "${BUMP}" in
"patch"*)
  PATCH=$( bump ${PATCH} )
  ;;
"minor"*)
  MINOR=$( bump ${MINOR} )
  PATCH=0
  ;;
"major"*)
  MAJOR=$( bump ${MAJOR} )
  MINOR=0
  PATCH=0
  ;;
*)
  echo "Cannot bump ${BUMP}."
  exit 2
esac

echo ${MAJOR}.${MINOR}.${PATCH}

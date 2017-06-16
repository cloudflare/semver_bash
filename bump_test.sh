#!/usr/bin/env bash

set -e

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bumpTest() {
  local A=R1.3.2
  local B=R2.3.2
  local C=R1.4.2
  local D=R1.3.3
  local E=R1.3.2a
  local F=R1.3.2b
  local G=R1.2.3

  [ $( ${SCRIPTS_DIR}/bump.sh "$A" ) == $( ${SCRIPTS_DIR}/bump.sh "$A" "patch" ) ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$A" "minor" ) == "1.4.0" ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$A" "major" ) == "2.0.0" ]

  [ $( ${SCRIPTS_DIR}/bump.sh "$B" ) == $( ${SCRIPTS_DIR}/bump.sh "$B" "patch" ) ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$B" "minor" ) == "2.4.0" ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$B" "major" ) == "3.0.0" ]

  [ $( ${SCRIPTS_DIR}/bump.sh "$C" ) == $( ${SCRIPTS_DIR}/bump.sh "$C" "patch" ) ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$C" "minor" ) == "1.5.0" ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$C" "major" ) == "2.0.0" ]

  [ $( ${SCRIPTS_DIR}/bump.sh "$D" ) == $( ${SCRIPTS_DIR}/bump.sh "$D" "patch" ) ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$D" "minor" ) == "1.4.0" ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$D" "major" ) == "2.0.0" ]

  [ $( ${SCRIPTS_DIR}/bump.sh "$E" ) == $( ${SCRIPTS_DIR}/bump.sh "$E" "patch" ) ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$E" "minor" ) == "1.4.0" ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$E" "major" ) == "2.0.0" ]

  [ $( ${SCRIPTS_DIR}/bump.sh "$F" ) == $( ${SCRIPTS_DIR}/bump.sh "$F" "patch" ) ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$F" "minor" ) == "1.4.0" ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$F" "major" ) == "2.0.0" ]

  [ $( ${SCRIPTS_DIR}/bump.sh "$G" ) == $( ${SCRIPTS_DIR}/bump.sh "$G" "patch" ) ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$G" "minor" ) == "1.3.0" ]
  [ $( ${SCRIPTS_DIR}/bump.sh "$G" "major" ) == "2.0.0" ]
}

bumpTest

echo "All tests passed!"

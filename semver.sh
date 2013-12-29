#!/usr/bin/env sh

function semverParseInto() {
    local RE='[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)[-]\{0,1\}\([0-9A-Za-z-]*\)'
    #MAJOR
    eval $2=`echo $1 | sed -e "s#$RE#\1#"`
    #MINOR
    eval $3=`echo $1 | sed -e "s#$RE#\2#"`
    #MINOR
    eval $4=`echo $1 | sed -e "s#$RE#\3#"`
    #SPECIAL
    eval $5=`echo $1 | sed -e "s#$RE#\4#"`
}

function semverConstruct() {
    if [ "$5" != "" ]; then
        eval $5=`echo "$1.$2.$3-$4"`
    fi

    eval $4=`echo "$1.$2.$3"`
}

function semverCmp() {
    local MAJOR_A=0
    local MINOR_A=0
    local PATCH_A=0
    local SPECIAL_A=0

    local MAJOR_B=0
    local MINOR_B=0
    local PATCH_B=0
    local SPECIAL_B=0

    semverParseInto $1 MAJOR_A MINOR_A PATCH_A SPECIAL_A
    semverParseInto $2 MAJOR_B MINOR_B PATCH_B SPECIAL_B

    # major
    if [ $MAJOR_A -lt $MAJOR_B ]; then
        return -1
    fi

    if [ $MAJOR_A -gt $MAJOR_B ]; then
        return 1
    fi

    # minor
    if [ $MINOR_A -lt $MINOR_B ]; then
        return -1
    fi

    if [ $MINOR_A -gt $MINOR_B ]; then
        return 1
    fi

    # patch
    if [ $PATCH_A -lt $PATCH_B ]; then
        return -1
    fi

    if [ $PATCH_A -gt $PATCH_B ]; then
        return 1
    fi

    # special
    if [[ "$SPECIAL_A" < "$SPECIAL_B" ]]; then
        return -1
    fi

    if [[ "$SPECIAL_A" > "$SPECIAL_B" ]]; then
        return 1
    fi

    # equal
    return 0
}

function semverEQ() {
    semverCmp $1 $2
    local RESULT=$?

    if [ $RESULT -ne 0 ]; then
        # not equal
        return 1
    fi

    return 0
}

function semverLT() {
    semverCmp $1 $2
    local RESULT=$?

    # XXX: compare to 255, as returning -1 becomes return value 255
    if [ $RESULT -ne 255 ]; then
        # not lesser than
        return 1
    fi

    return 0
}

function semverGT() {
    semverCmp $1 $2
    local RESULT=$?

    if [ $RESULT -ne 1 ]; then
        # not greater than
        return 1
    fi

    return 0
}

function semverBumpMajor() {
    local MAJOR=0
    local MINOR=0
    local PATCH=0
    local SPECIAL=""

    semverParseInto $1 MAJOR MINOR PATCH SPECIAL
    MAJOR=$(($MAJOR + 1))
    MINOR=0
    PATCH=0
    SPECIAL=""

    semverConstruct $MAJOR $MINOR $PATCH $SPECIAL $2
}

function semverBumpMinor() {
    local MAJOR=0
    local MINOR=0
    local PATCH=0
    local SPECIAL=""

    semverParseInto $1 MAJOR MINOR PATCH SPECIAL
    MINOR=$(($MINOR + 1))
    PATCH=0
    SPECIAL=""

    semverConstruct $MAJOR $MINOR $PATCH $SPECIAL $2
}

function semverBumpPatch() {
    local MAJOR=0
    local MINOR=0
    local PATCH=0
    local SPECIAL=0

    semverParseInto $1 MAJOR MINOR PATCH SPECIAL
    PATCH=$(($PATCH + 1))
    SPECIAL=""

    semverConstruct $MAJOR $MINOR $PATCH $SPECIAL $2
}

if [ "___semver.sh" == "___`basename $0`" ]; then
    if [ "$2" == "" ]; then
        echo "$0 <version> <command> [version]"
        echo "Commands: cmp, eq, lt, gt, bump_major, bump_minor, bump_patch"
        echo ""
        echo "cmp: compares left version against right version, return 0 if equal, 255 (-1) if left is lower than right, 1 if left is higher than right"
        echo "eq: compares left version against right version, returns 0 if both versions are equal"
        echo "lt: compares left version against right version, returns 0 if left version is less than right version"
        echo "gt: compares left version against right version, returns 0 if left version is greater than than right version"
        echo ""
        echo "bump_major: bumps major of version, setting minor and patch to 0, removing special"
        echo "bump_minor: bumps minor of version, setting patch to 0, removing special"
        echo "bump_patch: bumps patch of version, removing special"
        exit 255
    fi

    if [ "$2" == "cmp" ]; then
        semverCmp $1 $3
        RESULT=$?
        echo $RESULT
        exit $RESULT
    fi

    if [ "$2" == "eq" ]; then
        semverEQ $1 $3
        RESULT=$?
        echo $RESULT
        exit $RESULT
    fi

    if [ "$2" == "lt" ]; then
        semverLT $1 $3
        RESULT=$?
        echo $RESULT
        exit $RESULT
    fi

    if [ "$2" == "gt" ]; then
        semverGT $1 $3
        RESULT=$?
        echo $RESULT
        exit $RESULT
    fi

    if [ "$2" == "bump_major" ]; then
        semverBumpMajor $1 VERSION
        echo ${VERSION}
        exit 0
    fi

    if [ "$2" == "bump_minor" ]; then
        semverBumpMinor $1 VERSION
        echo ${VERSION}
        exit 0
    fi

    if [ "$2" == "bump_patch" ]; then
        semverBumpPatch $1 VERSION
        echo ${VERSION}
        exit 0
    fi
fi

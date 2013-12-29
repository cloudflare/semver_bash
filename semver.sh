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

function semverEQ() {
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

    if [ $MAJOR_A -ne $MAJOR_B ]; then
        return 1
    fi

    if [ $MINOR_A -ne $MINOR_B ]; then
        return 1
    fi

    if [ $PATCH_A -ne $PATCH_B ]; then
        return 1
    fi

    if [[ "_$SPECIAL_A" != "_$SPECIAL_B" ]]; then
        return 1
    fi


    return 0

}

function semverLT() {
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

    if [ $MAJOR_A -lt $MAJOR_B ]; then
        return 0
    fi

    if [[ $MAJOR_A -le $MAJOR_B  && $MINOR_A -lt $MINOR_B ]]; then
        return 0
    fi

    if [[ $MAJOR_A -le $MAJOR_B  && $MINOR_A -le $MINOR_B && $PATCH_A -lt $PATCH_B ]]; then
        return 0
    fi

    if [[ "_$SPECIAL_A"  == "_" ]] && [[ "_$SPECIAL_B"  == "_" ]] ; then
        return 1
    fi
    if [[ "_$SPECIAL_A"  == "_" ]] && [[ "_$SPECIAL_B"  != "_" ]] ; then
        return 1
    fi
    if [[ "_$SPECIAL_A"  != "_" ]] && [[ "_$SPECIAL_B"  == "_" ]] ; then
        return 0
    fi

    if [[ "_$SPECIAL_A" < "_$SPECIAL_B" ]]; then
        return 0
    fi

    return 1

}

function semverGT() {
    semverEQ $1 $2
    local EQ=$?

    semverLT $1 $2
    local LT=$?

    if [ $EQ -ne 0 ] && [ $LT -ne 0 ]; then
        return 0
    else
        return 1
    fi
}

function semverBumpMajor() {
    local MAJOR=0
    local MINOR=0
    local PATCH=0
    local SPECIAL=0

    semverParseInto $1 MAJOR MINOR PATCH SPECIAL
    MAJOR=$(($MAJOR + 1))

    semverConstruct $MAJOR $MINOR $PATCH $SPECIAL $2
}

function semverBumpMinor() {
    local MAJOR=0
    local MINOR=0
    local PATCH=0
    local SPECIAL=0

    semverParseInto $1 MAJOR MINOR PATCH SPECIAL
    MINOR=$(($MINOR + 1))

    semverConstruct $MAJOR $MINOR $PATCH $SPECIAL $2
}

function semverBumpPatch() {
    local MAJOR=0
    local MINOR=0
    local PATCH=0
    local SPECIAL=0

    semverParseInto $1 MAJOR MINOR PATCH SPECIAL
    PATCH=$(($PATCH + 1))

    semverConstruct $MAJOR $MINOR $PATCH $SPECIAL $2
}

if [ "___semver.sh" == "___`basename $0`" ]; then
    if [ "$2" == "" ]; then
        echo "$0 <version> <command> [version]"
        echo "Commands: eq, lt, gt, bump_major, bump_minor, bump_patch"
        echo ""
        echo "eq: compares left version against right version, returns 0 if both versions are equal"
        echo "lt: compares left version against right version, returns 0 if left version is less than right version"
        echo "gt: compares left version against right version, returns 0 if left version is greater than than right version"
        echo "bump_major: bumps major of version"
        echo "bump_minor: bumps minor of version"
        echo "bump_patch: bumps patch of version"
        exit 255
    fi

    if [ "$2" == "eq" ]; then
        semverEQ $1 $3
        exit $?
    fi

    if [ "$2" == "lt" ]; then
        semverLT $1 $3
        exit $?
    fi

    if [ "$2" == "gt" ]; then
        semverGT $1 $3
        echo $?
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

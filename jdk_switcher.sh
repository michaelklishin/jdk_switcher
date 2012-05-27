#!/bin/sh

if uname -a | grep x86_64 >/dev/null ; then
    ARCH_SUFFIX=amd64
else
    ARCH_SUFFIX=i386
fi

# UJA is for update-java-alternatives
OPENJDK6_UJA_ALIAS="java-1.6.0-openjdk"
OPENJDK6_JAVA_HOME="/usr/lib/jvm/java-6-openjdk"

OPENJDK7_UJA_ALIAS="java-1.7.0-openjdk-$ARCH_SUFFIX"
OPENJDK7_JAVA_HOME="/usr/lib/jvm/java-7-openjdk-$ARCH_SUFFIX"

# java::oraclejdk7 recipe in the github.com/travis-ci/travis-cookbooks
# takes care of this alias. We take it for granted here. MK.
ORACLEJDK7_UJA_ALIAS="java-7-oracle"
ORACLEJDK7_JAVA_HOME="/usr/lib/jvm/java-7-oracle"

UJA="update-java-alternatives"

switch_to_openjdk6 () {
    echo "Switching to OpenJDK6 ($OPENJDK6_UJA_ALIAS), JAVA_HOME will be set to $OPENJDK6_JAVA_HOME"
    sudo $UJA --set "$OPENJDK6_UJA_ALIAS"
    export JAVA_HOME="$OPENJDK6_JAVA_HOME"
}

switch_to_openjdk7 () {
    echo "Switching to OpenJDK7 ($OPENJDK7_UJA_ALIAS), JAVA_HOME will be set to $OPENJDK7_JAVA_HOME"
    sudo $UJA --set "$OPENJDK7_UJA_ALIAS"
    export JAVA_HOME="$OPENJDK7_JAVA_HOME"
}

switch_to_oraclejdk7 () {
    echo "Switching to Oracle JDK7 ($ORACLEJDK7_UJA_ALIAS), JAVA_HOME will be set to $ORACLEJDK7_JAVA_HOME"
    sudo $UJA --set "$ORACLEJDK7_UJA_ALIAS"
    export JAVA_HOME="$ORACLEJDK7_JAVA_HOME"
}

print_home_of_openjdk6 () {
    echo "$OPENJDK6_JAVA_HOME"
}

print_home_of_openjdk7 () {
    echo "$OPENJDK7_JAVA_HOME"
}

print_home_of_oraclejdk7 () {
    echo "$ORACLEJDK7_JAVA_HOME"
}

switch_to_sunjdk6 () {
    echo "Sun JDK 6 is not supported. It will be EOL in November 2012, consider moving on to OpenJDK 7 or Oracle JDK 7." >&2
}

switch_jdk()
{
    case "${1:-default}" in
        *gcj*)
            echo "We do not support GCJ. I mean, come on. Are you Richard Stallman?" >&2;
            false
            ;;
        openjdk6|openjdk1.6|openjdk1.6.0|jdk6|1.6.0|1.6|6.0)
            switch_to_openjdk6
            ;;
        openjdk7|jdk7|1.7.0|1.7|7.0)
            switch_to_openjdk7
            ;;
        oraclejdk7|oraclejdk1.7|oraclejdk1.7.0|oracle7|oracle1.7.0|oracle7.0|oracle|sunjdk7|sun7|sun)
            switch_to_oraclejdk7
            ;;
        default)
            # will be OpenJDK 7 as soon as multiple JDKs support
            # on travis-ci.org is finished, documented and announced. For now
            # we have to stick to OpenJDK 6 for compatibility for a few more weeks. MK.
            switch_to_openjdk6
            ;;
    esac
}


print_java_home()
{
    typeset JDK
    JDK="$1"

    if echo "$JDK" | grep gcj > /dev/null ; then
        echo "We do not support GCJ. I mean, come on. Are you Richard Stallman?" >&2;
        exit 1;
    fi

    case "$JDK" in
        openjdk6)
            print_home_of_openjdk6
            ;;
        openjdk1.6)
            print_home_of_openjdk6
            ;;
        openjdk1.6.0)
            print_home_of_openjdk6
            ;;
        jdk6)
            print_home_of_openjdk6
            ;;
        1.6.0)
            print_home_of_openjdk6
            ;;
        1.6)
            print_home_of_openjdk6
            ;;
        6.0)
            print_home_of_openjdk6
            ;;
        openjdk7)
            print_home_of_openjdk7
            ;;
        jdk7)
            print_home_of_openjdk7
            ;;
        1.7.0)
            print_home_of_openjdk7
            ;;
        1.7)
            print_home_of_openjdk7
            ;;
        7.0)
            print_home_of_openjdk7
            ;;
        oraclejdk7)
            print_home_of_oraclejdk7
            ;;
        oraclejdk1.7)
            print_home_of_oraclejdk7
            ;;
        oraclejdk1.7.0)
            print_home_of_oraclejdk7
            ;;
        oracle7)
            print_home_of_oraclejdk7
            ;;
        oracle1.7.0)
            print_home_of_oraclejdk7
            ;;
        oracle7.0)
            print_home_of_oraclejdk7
            ;;
        oracle)
            print_home_of_oraclejdk7
            ;;
        sunjdk7)
            print_home_of_oraclejdk7
            ;;
        sun7)
            print_home_of_oraclejdk7
            ;;
        sun)
            print_home_of_oraclejdk7
            ;;
        default)
            print_home_of_openjdk6
            ;;
    esac
}


jdk_switcher()
{
    typeset COMMAND JDK 
    COMMAND="$1"
    JDK="$2"

    case "$COMMAND" in
        use)
            switch_jdk "$JDK"
            ;;
        home)
            print_java_home "$JDK"
            ;;
        *)
            echo "Usage: $0 {use|home} [ JDK version ]" >&2
            false
            ;;
    esac

    return $?
}

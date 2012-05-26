#!/bin/sh

set -e

COMMAND="$1"
JDK="$2"

RETVAL=0

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
    RETVAL=0
}

switch_to_openjdk7 () {
    echo "Switching to OpenJDK7 ($OPENJDK7_UJA_ALIAS), JAVA_HOME will be set to $OPENJDK7_JAVA_HOME"
    sudo $UJA --set "$OPENJDK7_UJA_ALIAS"
    export JAVA_HOME="$OPENJDK7_JAVA_HOME"
    RETVAL=0
}

switch_to_oraclejdk7 () {
    echo "Switching to Oracle JDK7 ($ORACLEJDK7_UJA_ALIAS), JAVA_HOME will be set to $ORACLEJDK7_JAVA_HOME"
    sudo $UJA --set "$ORACLEJDK7_UJA_ALIAS"
    export JAVA_HOME="$ORACLEJDK7_JAVA_HOME"
    RETVAL=0
}

switch_to_sunjdk6 () {
    echo "Sun JDK 6 is not supported. It will be EOL in November 2012, consider moving on to OpenJDK 7 or Oracle JDK 7." >&2
    RETVAL=1
}

switch_jdk () {
     case "$JDK" in
        openjdk6)
            switch_to_openjdk6
            ;;
        openjdk1.6)
            switch_to_openjdk6
            ;;
        openjdk1.6.0)
            switch_to_openjdk6
            ;;
        jdk6)
            switch_to_openjdk6
            ;;
        1.6.0)
            switch_to_openjdk6
            ;;
        6.0)
            switch_to_openjdk6
            ;;
        openjdk7)
            switch_to_openjdk7
            ;;
        jdk7)
            switch_to_openjdk7
            ;;
        1.7.0)
            switch_to_openjdk7
            ;;
        7.0)
            switch_to_openjdk7
            ;;
        oraclejdk7)
            switch_to_oraclejdk7
            ;;
        oraclejdk1.7)
            switch_to_oraclejdk7
            ;;
        oraclejdk1.7.0)
            switch_to_oraclejdk7
            ;;
        oracle7)
            switch_to_oraclejdk7
            ;;
        oracle1.7.0)
            switch_to_oraclejdk7
            ;;
        oracle7.0)
            switch_to_oraclejdk7
            ;;
        oracle)
            switch_to_oraclejdk7
            ;;
        sunjdk7)
            switch_to_oraclejdk7
            ;;
        sun7)
            switch_to_oraclejdk7
            ;;
        sun)
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

case "$COMMAND" in
    use)
        echo -n "Switching to $JDK...\n"
        switch_jdk
        ;;
    *)
        echo "Usage: $0 {use}" >&2
        RETVAL=1
        ;;
esac


exit $RETVAL

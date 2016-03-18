# What JDK switcher is

This is a yet another Ubuntu/Debian-specific script that switches between multiple JDK
versions (including those that may not have been installed via apt).

It is meant to be used in the [travis-ci.org CI environment](https://github.com/travis-ci/travis-cookbooks) but
may be useful in other environments, too.

## Usage

Install one or more JDKs that register themselves with the `update-java-alternatives` tools by
installing a `.jinfo` file under `/usr/lib/jvm`.

Then source `jdk_switcher.sh` in the repository root and use the `jdk_switcher` function it two arguments,
a command and the JDK to use:

``` bash
. ./jdk_switcher.sh

jdk_switcher  use openjdk7

jdk_switcher home oraclejdk7
```

### Commands

 * `use`: switches active JDK (updates `PATH` alternatives and exports `JAVA_HOME`)
 * `home`: prints `JAVA_HOME` value for the specified JDK. Does not change anything in the environment.

### JDK aliases

Supported aliases are:

 * `oraclejdk8`
 * `oraclejdk7` or `jdk7` or `default`
 * `openjdk7`
 * `openjdk6` or `jdk6`

Sun JDK 6 will be EOL in November 2012 and is not supported. Ubuntu 12.04 and next Fedora release
both will use OpenJDK 7 by default. Time to upgrade, JDK 7 is backwards compatible and packed with
improvements.


## How does it work?

The switcher uses [update-java-alternatives](http://manpages.ubuntu.com/manpages/hardy/man8/update-java-alternatives.8.html) (see also [this intro](http://wiki.debian.org/Java/#Java_and_Debian)) under the hood to update `/etc/alternatives/*` symlinks for
`java`, `javac`, `javap` and other JDK tools. As such, the switcher itself primary handles aliasing of
JDKs (`update-java-alternatives` aliases are too hard to remember) and updating `JAVA_HOME` value.

`JAVA_HOME` changes is the reason why `jdk_switcher` is implemented as a function.


## Why was this tool necessary?

`JAVA_HOME` updates is the key reason for it to exist: `update-java-alternatives` and related Debian tools
in general do a great job of managing alternatives but won't touch or even define `JAVA_HOME`. Even though most
JVM ecosystem tools (from Leiningen to Elastic Search, HBase and Cassandra) will
try hard to detect `JAVA_HOME` value but unfortunately, Maven 3 does it in a way that is heavily biased
towards OpenJDK 6.

For travis-ci.org to support multiple JDKs for Clojure, Groovy, Java, Scala and JRuby, it is crucially
important that all the tools we provision will use the JDK version specified for a build. We cannot let
Maven always use OpenJDK 6.



## License & Copyright

MIT LICENSE

Copyright (c) 2012-2016 Michael S. Klishin and Travis CI Development Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


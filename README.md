# What JDK switcher is

This is a yet another Ubuntu/Debian-specific script that switches between multiple JDK
versions (including those that may not have been installed via apt).

It is meant to be used in the [travis-ci.org CI environment](https://github.com/travis-ci/travis-cookbooks) but
may be useful in other environments, too.

## Usage

Install one or more JDKs that register themselves with the `update-java-alternatives` tools by
installing a `.jinfo` file under `/usr/lib/jvm`.

Then copy `jdk_switcher.sh` in the repository root anywhere on the `PATH` and pass it two arguments:

``` bash
./jdk_switcher.sh use openjdk7
```

Supported aliases are:

 * `openjdk7` or `jdk7` or `default`
 * `openjdk6` or `jdk6`
 * `oraclejdk7`

Sun JDK 6 will be EOL in November 2012 and is not supported. Ubuntu 12.04 and next Fedora release
both will use OpenJDK 7 by default. Time to upgrade, JDK 7 is backwards compatible and packed with
improvements.



## License & Copyright

MIT LICENSE

Copyright (c) 2012 Michael S. Klishin and Travis CI Development Team

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

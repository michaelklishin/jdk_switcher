#!/usr/bin/env bats

setup() {
  source "$(git rev-parse --show-toplevel)/jdk_switcher.sh"
  mkdir -p "${BATS_TMPDIR}/bats.bin"
  cat >"${BATS_TMPDIR}/bats.bin/fake" <<EOF
#!/bin/bash
echo "---> Running: \$(basename "\${0}")" "\$@"
EOF
  chmod +x "${BATS_TMPDIR}/bats.bin/fake"
  for stub_exe in sudo; do
    ln -sf "${BATS_TMPDIR}/bats.bin/fake" "${BATS_TMPDIR}/bats.bin/${stub_exe}"
  done
  export PATH="${BATS_TMPDIR}/bats.bin:${PATH}"
  unset JAVA_HOME
}

@test "defines jdk_switcher function" {
  [[ "$(type jdk_switcher | head -1)" =~ function ]]
}

@test "shows usage on absent command" {
  run jdk_switcher
  [ "${status}" -eq 1 ]
  [ "${output}" = "Usage: jdk_switcher {use|home} [ JDK version ]" ]
}

@test "shows usage on unknown command" {
  run jdk_switcher wat
  [ "${status}" -eq 1 ]
  [ "${output}" = "Usage: jdk_switcher {use|home} [ JDK version ]" ]
}

@test "can switch to default jdk" {
  [[ "${JDK_SWITCHER_DEFAULT}" = openjdk8 ]]
  run jdk_switcher use default
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ "Switching to OpenJDK8" ]]
  [[ "${output}" =~ "---> Running: sudo update-java-alternatives --set java-1.8.0-openjdk" ]]
}

@test "can print default jdk home" {
  [[ "${JDK_SWITCHER_DEFAULT}" = openjdk8 ]]
  run jdk_switcher home default
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ "/usr/lib/jvm/java-8-openjdk" ]]
}

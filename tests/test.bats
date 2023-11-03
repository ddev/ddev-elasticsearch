setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-elasticsearch
  mkdir -p $TESTDIR
  export PROJNAME=test-elasticsearch
  export ADDON_PATH="ddev/ddev-elasticsearch"
  export USE_VERSION8=false
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

execute_test() {
  echo "# ddev get ${ADDON_PATH} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${ADDON_PATH} >/dev/null
  if [ "${USE_VERSION8}" = true ]; then
    cp .ddev/elasticsearch/docker-compose.elasticsearch8.yaml .ddev/
  fi
  ddev restart >/dev/null
  health_checks
}

health_checks() {
  ddev exec "curl -s elasticsearch:9200" | grep "${PROJNAME}-elasticsearch"
}

teardown() {
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  ADDON_PATH="${DIR}"
  execute_test
}

@test "install from release" {
  execute_test
}

@test "install version 8 from directory" {
  ADDON_PATH="${DIR}"
  USE_VERSION8=true
  execute_test
}

# enable after release of https://github.com/ddev/ddev-elasticsearch/pull/16
# @test "install version 8 from release" {
#   USE_VERSION8=true
#   execute_test
# }

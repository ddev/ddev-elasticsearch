setup() {
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/testelasticsearch
  mkdir -p $TESTDIR
  export PROJNAME=testelasticsearch
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} || true
  cd "${TESTDIR}"
  ddev config global --simple-formatting
  ddev config --project-name=${PROJNAME} --project-type=php
  ddev start -y
}

teardown() {
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${DDEV_SITENAME}
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  ddev exec "curl -s elasticsearch:9200" | grep "${PROJNAME}-elasticsearch"
}

@test "install from release" {
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get drud/ddev-elasticsearch with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get drud/ddev-elasticsearch
  ddev restart
  ddev exec "curl -s elasticsearch:9200" | grep "${PROJNAME}-elasticsearch"
}

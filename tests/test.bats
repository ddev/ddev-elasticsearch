#!/usr/bin/env bats

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests/test.bats
# To exclude release tests:
#   bats ./tests/test.bats --filter-tags '!release'
# For debugging:
#   bats ./tests/test.bats --show-output-of-passing-tests --verbose-run --print-output-on-failure

setup() {
  set -eu -o pipefail

  # Override this variable for your add-on:
  export GITHUB_REPO=ddev/ddev-elasticsearch

  TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  export BATS_LIB_PATH="${BATS_LIB_PATH}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"
  bats_load_library bats-assert
  bats_load_library bats-file
  bats_load_library bats-support

  export DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
  export PROJNAME="test-$(basename "${GITHUB_REPO}")"
  mkdir -p ~/tmp
  export TESTDIR=$(mktemp -d ~/tmp/${PROJNAME}.XXXXXX)
  export DDEV_NONINTERACTIVE=true
  export DDEV_NO_INSTRUMENTATION=true
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  run ddev config --project-name="${PROJNAME}" --project-tld=ddev.site
  assert_success
  run ddev start -y
  assert_success
}

health_checks() {
  run curl -sfI https://${PROJNAME}.ddev.site:9201
  assert_success
  assert_output --partial "HTTP/2 200"
  assert_output --partial "x-elastic-product: Elasticsearch"

  run curl -sf https://${PROJNAME}.ddev.site:9201
  assert_success
  assert_output --partial "${PROJNAME}-elasticsearch"
  assert_output --partial "${ELASTICSEARCH_VERSION}"
}

teardown() {
  set -eu -o pipefail
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail

  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success

  export ELASTICSEARCH_VERSION=7.17.14
  run ddev dotenv set .ddev/.env.elasticsearch --elasticsearch-docker-image=elasticsearch:${ELASTICSEARCH_VERSION}
  assert_success
  assert_file_exist .ddev/.env.elasticsearch

  run ddev restart -y
  assert_success

  health_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail

  echo "# ddev add-on get ${GITHUB_REPO} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${GITHUB_REPO}"
  assert_success

  export ELASTICSEARCH_VERSION=7.17.14
  run ddev dotenv set .ddev/.env.elasticsearch --elasticsearch-docker-image=elasticsearch:${ELASTICSEARCH_VERSION}
  assert_success
  assert_file_exist .ddev/.env.elasticsearch

  run ddev restart -y
  assert_success

  health_checks
}

@test "install version 8 from directory" {
  set -eu -o pipefail

  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success

  cp .ddev/elasticsearch/docker-compose.elasticsearch8.yaml .ddev/
  assert_file_exist .ddev/docker-compose.elasticsearch8.yaml

  export ELASTICSEARCH_VERSION=8.10.2
  run ddev dotenv set .ddev/.env.elasticsearch --elasticsearch-docker-image=elasticsearch:${ELASTICSEARCH_VERSION}
  assert_success
  assert_file_exist .ddev/.env.elasticsearch

  run ddev restart -y
  assert_success

  health_checks
}

# bats test_tags=release
@test "install version 8 from release" {
  set -eu -o pipefail

  echo "# ddev add-on get ${GITHUB_REPO} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${GITHUB_REPO}"
  assert_success

  cp .ddev/elasticsearch/docker-compose.elasticsearch8.yaml .ddev/
  assert_file_exist .ddev/docker-compose.elasticsearch8.yaml

  export ELASTICSEARCH_VERSION=8.10.2
  run ddev dotenv set .ddev/.env.elasticsearch --elasticsearch-docker-image=elasticsearch:${ELASTICSEARCH_VERSION}
  assert_success
  assert_file_exist .ddev/.env.elasticsearch

  run ddev restart -y
  assert_success

  health_checks
}

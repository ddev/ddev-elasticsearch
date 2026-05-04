#!/usr/bin/env bats

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests
# To exclude release tests:
#   bats ./tests --filter-tags '!release'
# For debugging:
#   bats ./tests --show-output-of-passing-tests --verbose-run --print-output-on-failure

setup() {
  load setup.sh
}

health_checks() {
  load health_checks.sh
}

teardown() {
  load teardown.sh
}

@test "install default version from directory" {
  set -eu -o pipefail

  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success

  export ELASTICSEARCH_VERSION=9.3.3
  run ddev dotenv set .ddev/.env.elasticsearch --elasticsearch-docker-image=elasticsearch:${ELASTICSEARCH_VERSION}
  assert_success
  assert_file_exist .ddev/.env.elasticsearch

  run ddev restart -y
  assert_success

  health_checks
}

# bats test_tags=release
@test "install default version from release" {
  set -eu -o pipefail

  echo "# ddev add-on get ${GITHUB_REPO} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${GITHUB_REPO}"
  assert_success

  export ELASTICSEARCH_VERSION=9.3.3
  run ddev dotenv set .ddev/.env.elasticsearch --elasticsearch-docker-image=elasticsearch:${ELASTICSEARCH_VERSION}
  assert_success
  assert_file_exist .ddev/.env.elasticsearch

  run ddev restart -y
  assert_success

  health_checks
}

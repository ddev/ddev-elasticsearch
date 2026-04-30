#!/usr/bin/env bash

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests
# To exclude release tests:
#   bats ./tests/test.bats --filter-tags '!release'
# For debugging:
#   bats ./tests/test.bats --show-output-of-passing-tests --verbose-run --print-output-on-failure

bats_require_minimum_version 1.8.0

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

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

ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
[ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}

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

run curl -sfI https://${PROJNAME}.ddev.site:9201
assert_success
assert_output --partial "HTTP/2 200"
assert_output --partial "x-elastic-product: Elasticsearch"

run curl -sf https://${PROJNAME}.ddev.site:9201
assert_success
assert_output --partial "${PROJNAME}-elasticsearch"
assert_output --partial "${ELASTICSEARCH_VERSION}"

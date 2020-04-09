#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset
# Exit script if a statement returns a non-true return value.
set -o errexit
# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail

sha256_result=$(openssl sha256 < ./dist/newrelic-cli_0.6.3-test_Darwin_x86_64.tar.gz)

printf "\n"
echo "${sha256_result}"

printf "\n"

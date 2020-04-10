#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset
# Exit script if a statement returns a non-true return value.
set -o errexit
# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail

printf "\n"
echo "TAG_TEST_1: ${TAG_TEST}"
echo "TAG_TEST_2: ${TAG_TEST}"
echo "CIRCLE_TAG: ${CIRCLE_TAG}"
echo "TAG: ${TAG}"
echo $PWD
printf "\n"

ls -la $PWD/dist

asset_path="${PWD}/dist/newrelic-cli_${TAG}_Darwin_x86_64.tar.gz"

printf "\n"
echo ${asset_path}
printf "\n"

openssl sha256 < ${asset_path}

# sha256_result=$(openssl sha256 < /home/circleci/project/dist/newrelic-cli_0.6.3-test_Darwin_x86_64.tar.gz)

# echo "SHA result: ${sha256_result}"

printf "\n"

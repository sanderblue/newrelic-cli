#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset
# Exit script if a statement returns a non-true return value.
set -o errexit
# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail

printf "\n"
# echo "TAG_TEST_1: ${TAG_TEST_1}"
# echo "TAG_TEST_2: ${TAG_TEST_2}"
# echo "CIRCLE_TAG: $1"
echo "GIT_TAG: ${GIT_TAG}"
echo $PWD
printf "\n"

ls -la $PWD/dist

asset_darwin="${PWD}/dist/newrelic-cli_${GIT_TAG}_Darwin_x86_64.tar.gz"
asset_linux="${PWD}/dist/newrelic-cli_${GIT_TAG}_Linux_x86_64.tar.gz"
asset_windows="${PWD}/dist/newrelic-cli_${GIT_TAG}_Windows_x86_64.zip"
asset_formula="${PWD}/dist/newrelic.rb"

printf "\n"
echo ${asset_darwin}
echo ${asset_linux}
echo ${asset_windows}
printf "\n"

sha256_darwin=$(openssl sha256 < $asset_darwin)
sha256_linux=$(openssl sha256 < $asset_linux)
sha256_windows=$(openssl sha256 < $asset_windows)

echo "sha256_darwin:  ${sha256_darwin}"
echo "sha256_linux:   ${sha256_linux}"
echo "sha256_windows: ${sha256_windows}"

cat $asset_formula

printf "\n"

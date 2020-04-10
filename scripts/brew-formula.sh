#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure,
# rather than that of the last item in a pipeline.
set -o pipefail

printf "\n***********************************************\n"
echo "Generating Homebrew formula for git tag: ${GIT_TAG}"
printf "***********************************************\n"

ls -la $PWD

asset_darwin="${PWD}/dist/newrelic-cli_${GIT_TAG}_Darwin_x86_64.tar.gz"
asset_formula="${PWD}/dist/newrelic-cli.rb"

printf "\n\n"
echo ${asset_darwin}
printf "\n\n"

export SHA256=$(openssl sha256 < $asset_darwin)

printf "\n***********************************************\n"
echo "New asset sha256: ${SHA256}"
printf "***********************************************\n"

# Inject the current git tag and updated sha into the newrelic-cli Homebrew formula
sed -e 's/GIT_TAG/'"${GIT_TAG}"'/g' -e 's/SHA256/'"${SHA256}"'/g' scripts/newrelic.rb.tmpl > $asset_formula

printf "\n***********************************************\n"
echo "Updated formula: ${asset_formula}"
printf "***********************************************\n"
cat ${asset_formula}


printf "\n"

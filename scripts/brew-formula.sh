#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
# set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure,
# rather than that of the last item in a pipeline.
set -o pipefail

printf "\n***********************************************\n"
echo "Generating Homebrew formula for git tag: ${GIT_TAG}"

asset_darwin="${PWD}/dist/newrelic-cli_${GIT_TAG}_Darwin_x86_64.tar.gz"
asset_formula="${PWD}/dist/newrelic-cli.rb"
formula_template=scripts/newrelic-cli.rb.tmpl

printf "\n"
echo "Asset gzip: ${asset_darwin}"

shaRaw="$(openssl sha256 < $asset_darwin)"
shaRaw1="$(echo -n "foo" | openssl sha256)"
shaRaw2="$(echo -n "foo" | openssl sha256 -hex)"
shaRaw3="$(openssl sha256 -hex < $asset_darwin)"

export SHA256=${shaRaw#*= } # need to trim `(stdin)= ` from the output

printf "shaRaw: ${shaRaw} \n"
printf "shaRaw1: ${shaRaw1} \n"
printf "shaRaw2: ${shaRaw2} \n"
printf "shaRaw3: ${shaRaw3} \n"

printf  "Asset sha256: ${SHA256}"
printf "\n\n"

echo "Updating formula...\n"

# Inject the current git tag and updated sha into the newrelic-cli Homebrew formula
sed -e 's/\$GIT_TAG/'"${GIT_TAG}"'/g' -e 's/\$SHA256/'"$SHA256"'/g' $formula_template > $asset_formula

echo "Updated formula: ${asset_formula}"

cat ${asset_formula}

printf "\n***********************************************\n"

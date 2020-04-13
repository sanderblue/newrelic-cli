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

asset_darwin="${PWD}/dist/newrelic-cli_${GIT_TAG}_Darwin_x86_64.tar.gz"
asset_formula="${PWD}/dist/newrelic-cli.rb"
formula_template=scripts/newrelic-cli.rb.tmpl

printf "\n"
echo "Asset gzip: ${asset_darwin}"

# TODO: Need to figure out how remove the `(stdin)= `prefix
# from the raw variable value. It only does this during CI.
stdinSha256="$(openssl sha256 < $asset_darwin)"

# Set the sha env varible, remove `(stdin)= ` from the string.
export SHA256=${stdinSha256#*= }

printf "Asset sha256: ${SHA256}"
printf "\n\n"

echo "Updating formula...\n"

# Inject the current git tag and updated sha into the newrelic-cli Homebrew formula
sed -e 's/\$GIT_TAG/'"${GIT_TAG}"'/g' -e 's/\$SHA256/'"${SHA256}"'/g' $formula_template > $asset_formula

echo "Updated formula: ${asset_formula} "

cat ${asset_formula}

printf "\n***********************************************\n"

printf "Generating pull request to newrelic-forks/homebrew-core..."
sleep 3

git clone git@github.com:newrelic-forks/homebrew-core.git

mv $asset_formula ${PWD}/homebrew-core/Formula

cd homebrew-core && git status

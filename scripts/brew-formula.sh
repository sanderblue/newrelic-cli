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

# Change this to `newrelic-forks/homebrew-core`!!!!!
homebrew_repo_name="sanderblue/homebrew-core"
upstream_homebrew="git@github.com:${homebrew_repo_name}.git"

printf "\n"
printf "Preparing pull request to ${homebrew_repo_name}..."
printf "\n"
sleep 3

# Change this to `newrelic-forks`!!!!!

printf "Cloning ${homebrew_repo_name}...\n"

git config -l
sleep 3 # TODO: FOR TESTING PURPOSES ONLY! REMOVE WHEN READY

git config --global user.email "william.a.blue@gmail.com"
git config --global user.name "sanderblue"

git clone ${upstream_homebrew}

mv $asset_formula ${PWD}/homebrew-core/Formula

# Change to local homebrew-core and output updates
cd homebrew-core

git config user.email
git config user.name

# change to local copy of forked homebrew-core and output updates
# TODO: FOR TESTING PURPOSES ONLY! REMOVE WHEN READY
git status

# Display diff without a pager so script can continue
git --no-pager diff
sleep 3 # TODO: FOR TESTING PURPOSES ONLY! REMOVE WHEN READY

homebrew_release_branch="release/${GIT_TAG}"

git checkout -b ${homebrew_release_branch}
git add Formula/newrelic-cli.rb
git status
sleep 3 # TODO: FOR TESTING PURPOSES ONLY! REMOVE WHEN READY

git commit -m "newrelic-cli ${GIT_TAG}"
git push --set-upstream sanderblue ${homebrew_release_branch}

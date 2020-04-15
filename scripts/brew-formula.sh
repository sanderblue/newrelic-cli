#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
# set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure,
# rather than that of the last item in a pipeline.
set -o pipefail

printf "\n**************************************************\n"
printf "Generating Homebrew formula for git tag: ${GIT_TAG} \n"

asset_file=$(find ${PWD}/dist -name "newrelic-cli_${GIT_TAG}_Darwin_x86_64*")

asset_formula="${PWD}/dist/newrelic-cli.rb"
formula_template=s"${PWD}/scripts/newrelic-cli.rb.tmpl"

printf "\nAsset gzip: ${asset_file}"

SHA256="$(openssl sha256 < $asset_file | sed 's/(stdin)= //')"

printf "\nNew SHA256: ${SHA256} \n"
printf "\n**************************************************\n"

echo "Updating formula...\n"

# Inject the current git tag and updated sha into the newrelic-cli Homebrew formula
sed -e 's/\$GIT_TAG/'"${GIT_TAG}"'/g' -e 's/\$SHA256/'"${SHA256}"'/g' $formula_template > $asset_formula

formula_url='  url "https:\/\/github.com\/newrelic\/newrelic-cli\/archive\/v'${GIT_TAG}'.tar.gz"'
formula_sha256='  sha256 "'${SHA256}'"'

sed -e '4s/.*/'"${formula_url}"'/' -e '5s/.*/'"${formula_sha256}"'/' scripts/newrelic-cli.rb.tmpl > scripts/newrelic-cli.rb

echo "Updated formula: ${asset_formula} "

cat ${asset_formula}

printf "\n***********************************************\n"

exit 0

# Change this to `newrelic-forks/homebrew-core`!!!!!
homebrew_repo_name="sanderblue/homebrew-core"
upstream_homebrew="git@github.com:${homebrew_repo_name}.git"

printf "\n"
printf "Preparing pull request to ${homebrew_repo_name}..."
printf "\n"
sleep 3

# Change this to `newrelic-forks`!!!!!

printf "Cloning ${homebrew_repo_name}...\n"

printf "\n\n"
git config -l
printf "\n\n *** config *** \n\n"
sleep 3 # TODO: FOR TESTING PURPOSES ONLY! REMOVE WHEN READY

git config --global user.email "william.a.blue@gmail.com"
git config --global user.name "sanderblue"

git clone ${upstream_homebrew}

mv $asset_formula ${PWD}/homebrew-core/Formula

# Change to local homebrew-core and output updates
cd homebrew-core

printf "\n\n homebrew-core \n\n "
git config -l
printf "\n\n *** config *** \n\n"
sleep 3 # TODO: FOR TESTING PURPOSES ONLY! REMOVE WHEN READY

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
git push origin ${homebrew_release_branch}

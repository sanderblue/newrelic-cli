#!/usr/bin/env bash

##
# https://circleci.com/docs/2.0/using-shell-scripts/#set-error-flags
##

# Exit script if you try to use an uninitialized variable.
# set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure,
# rather than that of the last item in a pipeline.
set -o pipefail

printf "\n**************************************************\n"

export GIT_TAG=$(git describe --tags | tr -d "v")

printf "Generating Homebrew formula for git tag: ${GIT_TAG} \n"

printf "Directory - ${PWD} \n"
printf "Actor - ${GITHUB_ACTOR} \n"
printf "Git user email: \n"
git config -l || true
printf "\n\n"

asset_file=$(find ${PWD}/dist -type f -name "newrelic-cli_${GIT_TAG}_Darwin_x86_64*")

printf "\nAsset gzip: ${asset_file}"

SHA256="$(openssl sha256 < $asset_file | sed 's/(stdin)= //')"

printf "\nNew SHA256: ${SHA256} \n"
printf "\n**************************************************\n"

homebrew_repo_name="sanderblue/homebrew-core"
upstream_homebrew="git@github.com:${homebrew_repo_name}.git"

# Change to local homebrew-core and output updates
cd homebrew-core

# printf "\nSetting ssh key...\n\n"
# mkdir ~/.ssh
# echo "${PERSONAL_SSH_KEY}" > ~/.ssh/id_rsa
# chmod 600 ~/.ssh/id_rsa

printf "\nGit remote: "
git remote -v
printf "Switching remote origin to use SSH...\n\n"

# Set remote repo to SSH auth
# git remote set-url origin $upstream_homebrew

git_username="sanderblue"

git remote set-url origin "https://${git_username}:${GITHUB_TOKEN}@github.com/${homebrew_repo_name}"

# Set git config to our GitHub "machine user" nr-developer-toolkit
# https://developer.github.com/v3/guides/managing-deploy-keys/#machine-users
git config --local user.email "william.a.blue@gmail.com"
git config --local user.name "Sander Blue"
# git config user.password ${PAT}
# echo "::set-env name=GIT_USER::${GITHUB_ACTOR}:${PAT}"

homebrew_formula_file='Formula/newrelic-cli.rb'
tmp_formula_file='Formula/newrelic-cli.rb.tmp'

# Set variables for lines to replace in the formula (lines 4 and 5)
formula_url='  url "https:\/\/github.com\/newrelic\/newrelic-cli\/archive\/v'${GIT_TAG}'.tar.gz"'
formula_sha256='  sha256 "'${SHA256}'"'

# Make temporary copy of existing formula file
cp $homebrew_formula_file $tmp_formula_file

# Replace lines 4 and 5 in the formula file, using the .tmp file as a template
sed -e '4s/.*/'"${formula_url}"'/' -e '5s/.*/'"${formula_sha256}"'/' $tmp_formula_file > $homebrew_formula_file

# Remove the temporary file
rm $tmp_formula_file

# Display diff (without a pager so script can continue)
git --no-pager diff

printf "\n"
git config -l
printf "\n"

# Create new branch, commit updates, push new release branch to newrelic-forks/homebrew-core
homebrew_release_branch="release/${GIT_TAG}"
printf "\n Checkout...\n"
git checkout -b $homebrew_release_branch
printf "\n git add...\n"
git add Formula/newrelic-cli.rb
git status
git commit -m "newrelic-cli ${GIT_TAG}" # homebrew recommended commit message format

printf "Pushing up new release branch: ${homebrew_release_branch}"

git push --set-upstream origin $homebrew_release_branch

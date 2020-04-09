sha256_result=$(openssl sha256 < ./dist/newrelic-cli_0.6.3-test_Darwin_x86_64.tar.gz)

printf "\n"
echo "${sha256_result}"

printf "\n"

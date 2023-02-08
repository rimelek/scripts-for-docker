#!/usr/bin/env bash

set -eu -o pipefail

URL_PULL="https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull"
URL_MANIFEST="https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest"

function get_limits() {
  local user=""
  local pass=""
  local user_args=()
  local headers

  if [[ "$#" -eq 1 ]]; then
    echo >&2 "Error: missing password"
    return 1
  fi

  if [[ "$#" -eq 2 ]]; then
    user="$1"
    pass="$2"
    user_args=("--user" "$user:$pass")
  fi

  token=$(curl --silent "$URL_PULL" "${user_args[@]}" | jq -r .token)
  headers=$(curl --silent --head -H "Authorization: Bearer $token" "$URL_MANIFEST")

  ratelimits=$(echo "$headers" | grep "^RateLimit-")

  echo -n "{"
  echo -n "$ratelimits" |
    awk '{ printf "%s", tolower(gensub(/^RateLimit-([^:]+): ([0-9]+);w=([0-9]+).*$/, "\"\\1\":{\"value\": \\2, \"interval\": \\3},", "g", $0)) }' |
    head -c-1
  echo -n "}"
}

user=""
pass=""

if [[ "$#" -eq 1 ]]; then
  echo >&2 "Error: missing password"
  exit 1
fi

if [[ "$#" -eq 2 ]]; then
  user="$1"
  pass="$2"
fi

ratelimits_anon=$(get_limits)

# show the result
echo -n "{"
echo -n '"anonymous":'
echo -n "$ratelimits_anon"

if [[ -n "$pass" ]]; then
  ratelimits_auth=$(get_limits "$user" "$pass")
  echo -n ","
  echo -n '"authenticated":'
  echo -n "$ratelimits_auth"
fi

echo -n "}"

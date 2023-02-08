#!/usr/bin/env bash

set -eu

function main() {
  local cmd="${1}"
  case "${cmd}" in
  groupByName)
    groupByName
    ;;
  groupById)
    groupById
    ;;
  *)
    echo "Unknown commands. Commands: groupByName, groupById"
    ;;
  esac
}

function trim() {
  cat - \
  | sed -e 's/^[[:space:]]*//' \
  | sed -e 's/[[:space:]]*$//'
}

function groupById() {
  for i in $(docker image ls -q | uniq); do
    printf "%s:        " "$i"
    docker image inspect -f '{{range $i:=.RepoTags}}{{printf "%s\n                     " $i}}{{end}}' "${i}"
  done
}

function groupByName() {
  local prevRegistry=""
  local prevOwner=""
  local prevImage=""
  local repository=""
  local restOf=""
  local registry=""
  local owner=""
  local image=""
  local unsortedList=""

  IFS_ORIG="${IFS}"
  IFS=$'\n'

  for i in $(docker image ls | tail -n+2); do
    repository="//$(echo "${i}" | cut -d" " -f1 | trim)"
    restOf="$(echo "${i}" | cut -d" " -f2- | trim)"
    registry="$(echo "${repository}" | awk -F/ '{ print $(NF-2) }')"
    owner="$(echo "${repository}" | awk -F/ '{ print $(NF-1) }')"
    image="$(echo "${repository}" | awk -F/ '{ print $(NF-0) }')"
    if [[ -z "${registry}" ]]; then
      if [[ "${owner}" == "docker.io" ]]; then
        registry="${owner}"
        owner="library"
      fi
    fi

    if [[ -z "${registry}" ]]; then
      registry="docker.io"
    fi

    if [[ -z "${owner}" ]]; then
      owner="library"
    fi
    repository="${registry}/${owner}/${image}"

    unsortedList="$(printf "%s\n%s    %s" "${unsortedList}" "${repository}" "${restOf}")"
  done

  for i in $(echo "${unsortedList}" | tail -n+2 | sort -k 1n); do
    repository="$(echo "${i}" | cut -d" " -f1 | trim)"
    registry="$(echo "${repository}" | cut -d/ -f1)"
    owner="$(echo "${repository}" | cut -d/ -f2)"
    image="$(echo "${repository}" | cut -d/ -f3)"

    restOf="$(echo "${i}" | cut -d" " -f2- | trim)"
    if [[ "${registry}" != "${prevRegistry}" ]]; then
      echo
     printf "\e[32m%s\e[0m\n" "$registry"
    fi
    if [[ "${owner}" != "${prevOwner}" ]]; then
      printf "  \e[33m%s\e[0m\n" "$owner"
    fi
    if [[ "${image}" != "${prevImage}" ]]; then
      printf "    \e[34m%s\e[0m\n" "$image"
    fi
    echo "      ${restOf}"

    prevRegistry="${registry}"
    prevOwner="${owner}"
    prevImage="${image}"
  done
  IFS="${IFS_ORIG}"
}

main "$@"

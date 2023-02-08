#!/usr/bin/env bash

: ${1:?First argument is required}

VOL_SRC=${1}
FOLDER=${2}

VOL_SRC_CHECK=$(docker volume ls -q -f name="^${VOL_SRC}$")

if [ "${VOL_SRC}" != "${VOL_SRC_CHECK}" ]; then
  echo >&2 'Volume "'${VOL_SRC}'" does not exist'
  exit 1
fi

docker run --rm -v ${VOL_SRC}:/volume --workdir=/volume busybox sh -c "ls -la ${FOLDER}"

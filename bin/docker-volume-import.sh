#!/usr/bin/env bash

function getFullPath() {
  local SRC=${1}
  if [ -z "$(which readlink 2>/dev/null)" ]; then
    realpath ${SRC}
  else
    readlink -f ${SRC}
  fi
}

: ${1:?First argument is required}
: ${2:?Second argument is required}

VOL_SRC=${1}
VOL_DST=${2}

VOL_DST_CHECK=$(docker volume ls -q -f name="^${VOL_DST}$")
VOL_SRC_CHECK=$(ls ${VOL_SRC} 2>/dev/null)

if [ "${VOL_SRC}" != "${VOL_SRC_CHECK}" ]; then
  echo >&2 'File not found: "'${VOL_SRC}'"'
  exit 1
fi

echo -n '"'${VOL_SRC}'" will be imported to volume "'${VOL_DST}'" [y/N] '

read ANSWER

if [ "${ANSWER}" != "y" ]; then
  echo 'Canceled'
  exit 0
fi

if [ "${VOL_DST}" == "${VOL_DST_CHECK}" ]; then
  echo -n 'Destination volume "'${VOL_DST}'" already exists. It will be overwritten. [y/N] '
  read ANSWER
  if [ "${ANSWER}" != "y" ]; then
    echo 'Canceled'
    exit 0
  fi
  docker volume rm ${VOL_DST}
fi

echo "Import in progress"

FULL_PATH=$(getFullPath ${VOL_SRC})
docker run --rm \
  -v ${FULL_PATH}:/volume.tgz \
  -v ${VOL_DST}:/volume \
  --workdir=/volume \
  busybox sh -c 'tar -xf /volume.tgz'

#!/usr/bin/env bash

: ${1:?First argument is required}
: ${2:?Second argument is required}

VOL_SRC=${1}
VOL_DST=${2}

VOL_SRC_CHECK=$(docker volume ls -q -f name="^${VOL_SRC}$")
VOL_DST_CHECK=$(docker volume ls -q -f name="^${VOL_DST}$")

if [ "${VOL_SRC}" != "${VOL_SRC_CHECK}" ]; then
  echo >&2 'Volume "'${VOL_SRC}'" does not exist'
  exit 1
fi

echo -n 'Volume "'${VOL_SRC}'" will be copied as "'${VOL_DST}'" [y/N] '

read ANSWER

if [ "${ANSWER}" != "y" ]; then
  echo 'Canceled'
  exit 0
fi

if [ "${VOL_DST}" == "${VOL_DST_CHECK}" ]; then
  echo -n 'Destination volume "'${VOL_DST}'" already exists. Data on the volume will be completely lost [y/N] '
  read ANSWER
  if [ "${ANSWER}" != "y" ]; then
    echo 'Canceled'
    exit 0
  fi
  docker volume rm ${VOL_DST}
fi

echo "Copy in progress"
docker run --rm \
  -v ${VOL_SRC}:/volume-src \
  -v ${VOL_DST}:/volume-dst \
  busybox sh -c 'cp -rp /volume-src/. /volume-dst/'

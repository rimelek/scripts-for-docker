#!/usr/bin/env bash

: ${1:?First argument is required}
: ${2:?Second argument is required}
: ${3:?Third argument is required}

VOL_SRC=${1}
SSH_REMOTE_SRV=${2}
SSH_REMOTE_PORT=${3}
VOL_DST=${4:-${VOL_SRC}}

SSH_TPL="ssh -p ${SSH_REMOTE_PORT} ${SSH_REMOTE_SRV}"

VOL_SRC_CHECK=$(docker volume ls -q -f name="^${VOL_SRC}$")
VOL_DST_CHECK=$(${SSH_TPL} "docker volume ls -q -f name=^${VOL_DST}$ 2>/dev/null")

if [ "${VOL_SRC}" != "${VOL_SRC_CHECK}" ]; then
  echo >&2 'Volume "'${VOL_SRC}'" does not exist'
  exit 1
fi

echo -n 'Volume "'${VOL_SRC}'" will be copied as "'${VOL_DST}' to the remote server" [y/N] '

read ANSWER

if [ "${ANSWER}" != "y" ]; then
  echo 'Canceled'
  exit 0
fi

if [ "${VOL_DST}" == "${VOL_DST_CHECK}" ]; then
  echo -n 'Destination volume "'${VOL_DST}'" already exists on the remote server. It will be overwritten. [y/N] '
  read ANSWER
  if [ "${ANSWER}" != "y" ]; then
    echo 'Canceled'
    exit 0
  fi
  ${SSH_TPL} "docker volume rm ${VOL_DST}"
fi

echo "Copy in progress"
docker run --rm \
  -v ${VOL_SRC}:/volume \
  --workdir=/volume \
  busybox sh -c 'tar -cOzf - .' | ${SSH_TPL} "docker run -i --rm -v ${VOL_DST}:/volume --workdir=/volume busybox sh -c 'tar -xzf -'"

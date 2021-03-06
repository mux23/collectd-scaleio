#!/bin/bash
USER=$1; shift
PASS=$1; shift

echoerr() { echo "$@" 1>&2; }

(
  flock -w 10 205 || exit 1

  # login
  login_out=$(scli --login --username ${USER} --password ${PASS} 2>&1)
  if [ $? -gt 0 ]; then
    echoerr "Error while logging in:\n${login_out}"
    exit 129
  fi

  # run cmd
  scli "$@"
  ec=$?

  # logout
  logout_out=$(scli --logout 2>&1)
  if [ $? -gt 0 ]; then
    echoerr "Error while logging out:\n${logout_out}"
    exit 129
  fi
  exit $ec

) 205>/var/lock/scli_wrap.lock

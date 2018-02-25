#!/bin/bash

#
# source common include
#
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.nginx-common.bash"

#
# start nginx service
#
writeActionSummary 'Checking %s service' "${SYSTEMCTL_NGINX}"

${SYSTEMCTL_BIN} ${SYSTEMCTL_OPT} is-active ${SYSTEMCTL_NGINX} &> /dev/null
_R=$?

systemctlWaitPeriod

if [[ ${_R} -eq 0 ]]; then
  writeActionResult 'STARTED' 'pids: %s' "${NGINX_PIDS}"
else
  writeActionResult 'STOPPED' 'exit: %d' ${_R}
fi

echo 'start:' >> /tmp/cbc.actions

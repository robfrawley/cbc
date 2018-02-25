#!/bin/bash

#
# source common include
#
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.nginx-common.bash"

#
# stop nginx service
#
writeActionSummary 'Stopping %s service' "${SYSTEMCTL_NGINX}"

${SYSTEMCTL_BIN} ${SYSTEMCTL_OPT} stop ${SYSTEMCTL_NGINX} &> /dev/null
_R=$?

systemctlWaitPeriod

if [[ ${_R} -eq 0 ]]; then
  writeActionResultOkay 'pids killed: %s' "${NGINX_PIDS}"
else
  writeActionResultFail 'exit: %d, pids active: %s' ${_R} "$(pidof nginx)"
fi

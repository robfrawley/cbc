#!/bin/bash

#
# source common include
#
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.nginx-common.bash"

#
# start nginx service
#
writeActionSummary 'Starting %s service' "${SYSTEMCTL_NGINX}"

${SYSTEMCTL_BIN} ${SYSTEMCTL_OPT} start ${SYSTEMCTL_NGINX} &> /dev/null
_R=$?

systemctlWaitPeriod

if [[ ${_R} -eq 0 ]]; then
  writeActionResultOkay 'pids: %s' "$(pidof nginx)"
else
  writeActionResultFail 'code: %d' ${_R}
fi

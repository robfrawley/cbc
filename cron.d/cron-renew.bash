#!/bin/bash

#
# source common include
#
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.cron-common.bash"

#
# configure opts
#
if [[ -x "${CERTBOT_RENEW_HOOK_PRE}" ]]; then
  CERTBOT_RENEW_OPTS="${CERTBOT_RENEW_OPTS} --pre-hook="${CERTBOT_RENEW_HOOK_PRE}""
fi
if [[ -x "${CERTBOT_RENEW_HOOK_POST}" ]]; then
  CERTBOT_RENEW_OPTS="${CERTBOT_RENEW_OPTS} --post-hook="${CERTBOT_RENEW_HOOK_POST}""
fi

echo "${CERTBOT_BIN} ${CERTBOT_RENEW_OPTS} &> "${CBC_LOG_FILE}""
exit

#
# renew certificates
#
writeActionSummary 'Running %s renew operation' "${CERTBOT_BIN}"

${CERTBOT_BIN} ${CERTBOT_RENEW_OPTS} &> "${CBC_LOG_FILE}"
_R=$?

if [[ ${_R} -eq 0 ]]; then
  writeActionResultOkay 'logs: %s' "${CBC_LOG_FILE}"
else
  writeActionResultFail 'logs: %s' "${CBC_LOG_FILE}"
fi

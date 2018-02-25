#!/bin/bash

#
# resolve real path to self
#
readonly _HOOK_COMMON_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"

#
# source common include
#
source "${_HOOK_COMMON_PATH}../.cbc-common.bash"

#
# nginx configuration options
#
SYSTEMCTL_NGINX="nginx.service"
NGINX_PIDS="$(pidof nginx)"

#
# require scalated privilages
#
requireEscalatedPrivileges

#
# write information about context
#
writeSection 'Performing "%s" unit operations' "${SYSTEMCTL_NGINX}"

#!/bin/bash

#
# resolve real path to self
#
readonly _CRON_COMMON_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"

#
# source common include
#
source "${_CRON_COMMON_PATH}../.cbc-common.bash"

#
# require scalated privilages
#
requireEscalatedPrivileges

#
# write information about context
#
writeSection 'Performing cron operation'

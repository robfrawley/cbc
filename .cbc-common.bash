#!/bin/bash

#
# resolve real path to self
#
readonly _CBC_COMMON_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"
readonly _CBC_HOOKS_PATH="${_CBC_COMMON_PATH}hook.d/"
readonly _CBC_CRONS_PATH="${_CBC_COMMON_PATH}cron.d/"

#
# general configuration options
#
DOMAIN_NAMES=("silverpapillon.com" "www.silverpapillon.com" "dev.silverpapillon.com" "api.silverpapillon.com")
SYSTEMCTL_BIN="$(which systemctl)"
SYSTEMCTL_OPT="--no-ask-password --no-pager --full --output=cat"
CERTBOT_BIN="$(which certbot)"
CERTBOT_OPT="--verbose --debug --non-interactive --staple-ocsp --keep-until-expiring"
CBC_LOG_FILE="/tmp/cbc.date +%s.log"

#
# certbot renewal configuration options
#
CERTBOT_RENEW_HOOK_PRE="${_CBC_HOOKS_PATH}nginx-stop.bash"
CERTBOT_RENEW_HOOK_POST="${_CBC_HOOKS_PATH}nginx-start.bash"
CERTBOT_RENEW_OPTS="renew ${CERTBOT_OPT} --standalone --agree-tos"

#
# write new line
#
function writeNewLine()
{
  printf '\n'
}

#
# write text
#
function writeText()
{
  local format="${1:-}"
  shift

  printf "${format}" "$@"
}

#
# write line
#
function writePrefix()
{
  local timeTodayNow=$(date +%j:%k%M%S)
  local timeMicroSec=$(date +%N)
  local char="${1}${1}"

  writeText '%s %s %s ' "${timeTodayNow}.${timeMicroSec:0:4}" "${2,,}" "${char}"
}

#
# write line
#
function writeLine()
{
  local prefixChar="${1:-----}"
  shift
  local prefixType="${1:-INFO}"
  shift
  local format="${1:-}"
  shift

  writePrefix "${prefixChar}" "${prefixType}"
  printf -- "${format}" "$@"
  writeNewLine
}

#
# write empty line
#
function writeNullLine()
{
  writeLine '-' '----'
}

#
# write critical line and exit
#
function writeCrit()
{
  local exitCode=${1:-255}
  shift
  local format="${1:-Encountered an unrecoverable error; halting script execution...}"
  shift

  writeLine '!' 'CRIT' "${format}" "$@"
  exit ${exitCode}
}

#
# write warn line
#
function writeWarn()
{
  local format="${1}"
  shift

  writeLine '!' 'warn' "${format}" "$@"
}

#
# write info line
#
function writeInfo()
{
  local format="${1}"
  shift

  writeLine '-' 'info' "${format}" "$@"
}

#
# repeat character the length of passed string
#
function fillStringLength()
{
  local string="${1:-}"
  local filler="${2:- }"
  local buffer=""

  for i in $(seq 1 ${#string}); do
    buffer="${buffer}${filler}"
  done

  echo -n "${buffer}"
}

#
# write section line
#
function writeSection()
{
  local format="${1}"
  shift

  local buffer="$(writeText "${format}" "$@")"

  #writeLine '#' 'head' "$(fillStringLength "${buffer}" '-')"
  writeLine '#' 'head' "${buffer^^}"
  #writeLine '#' 'head' "$(fillStringLength "${buffer}" '-')"
  writeNullLine
}

#
# write action summary
#
function writeActionSummary()
{
  local format="${1:-Performing operation}"
  shift

  writePrefix '>' 'acts'
  writeText "${format} ... " "$@"
}

#
# write action result
#
function writeActionResult()
{
  local result="${1}"
  shift
  local extras="${1:-x}"
  shift

  writeText '[ %s ]' "${result^^}"

  if [[ "x" != "${extras}" ]]; then
    writeNewLine
    writePrefix '>' 'info'
    writeText " (${extras})" "${@}"
  fi

  writeNewLine
}

#
# write action okay result
#
function writeActionResultOkay()
{
  writeActionResult "SUCCESS" "${@}"
}

#
# write action fail result
#
function writeActionResultFail()
{
  writeActionResult "FAILURE" "${@}"
}

#
# require escalated privileges (check for root user id)
#
function requireEscalatedPrivileges()
{
  if [[ $EUID -ne 0 ]]; then
     writeCrit 255 'This script must be run as root; try using sudo or escalating privileges another way...'
  fi
}

#
# sleep for period before querying for processes
#
function systemctlWaitPeriod()
{
  sleep 0.25
}

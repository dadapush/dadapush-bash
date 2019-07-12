#!/usr/bin/env bash

# Default config vars
CURL="$(which curl)"
DADAPUSH_URL="https://www.dadapush.com/api/v1/message"
TOKEN="" # May be set in dadapush.conf or given on command line
CURL_OPTS=""

# Functions used elsewhere in this script
usage() {
    echo "${0} <options> <message>"
    echo " -T <TOKEN>"
    echo " -M <msg_file>"
    exit 1
}

send_message() {
    curl_cmd="\"${CURL}\" --silent --write-out "HTTPSTATUS:%{http_code}" -X POST \"${DADAPUSH_URL}\" \
        ${CURL_OPTS} \
        -H 'cache-control: no-cache' \
        -H 'content-type: application/json' \
        -H 'x-channel-token: ${TOKEN}' \
        -d @\"${message}\"
        "
    # echo $curl_cmd
    # execute and return exit code from curl command
    HTTP_RESPONSE="$(eval "${curl_cmd}")"
    # extract the body
    HTTP_BODY=$(echo $HTTP_RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')

    # extract the status
    HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

    # print the body
    echo "$HTTP_BODY"

    # example using the status
    if [ ! $HTTP_STATUS -eq 200  ]; then
    echo "Error [HTTP status: $HTTP_STATUS]"
    exit 1
    fi

    r="${?}"
    if [ "${r}" -ne 0 ]; then
        echo "${0}: Failed to send message" >&2
    fi

    return "${r}"
}

# Option parsing

optstring="T:m:"

# Process the remaining options
OPTIND=1
while getopts ${optstring} c; do
    case ${c} in
        T) TOKEN="${OPTARG}" ;;
        m) msg_file="${OPTARG}" ;;
        [h\?]) usage ;;
    esac
done
shift $((OPTIND-1))

# Is there anything left?
if [ "$#" -lt 1 -a "$msg_file" = "" ]; then
    usage
fi
message="$*"

# load the rest of the message from the file
if [ "$msg_file" != "" ] ; then
    if [ ! -f "$msg_file" ] ; then
	echo "failed to read message file: $msg_file"
	exit 1
    fi
    message="$msg_file"
fi	

# Check for required config variables
if [ ! -x "${CURL}" ]; then
    echo "CURL is unset, empty, or does not point to curl executable. This script requires curl!" >&2
    exit 1
fi

send_message
r=${?}

exit "${r}"

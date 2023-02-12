#!/bin/bash


source common_settings.txt

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "Usage: set_filter_value.sh <filter> <value>"

F_NAME=$1
F_VALUE=$2
JQ_STRING=".GetConfigJson.value | fromjson | .filters.${F_NAME}.parameters.gain = ${F_VALUE} | tojson"
WS_REQ=$(echo '"GetConfigJson"' | websocat ws://127.0.0.1:$CAMILLA_PORT | jq "$JQ_STRING")

echo  '{"SetConfigJson": '$WS_REQ'}' | websocat ws://127.0.0.1:$CAMILLA_PORT

#MAX_GAIN = $(echo '"GetConfigJson"' | websocat ws://127.0.0.1:1234 | jq '.GetConfigJson.value | fromjson | .filters |  del(.Gain) | [.[].parameters.gain] | max')
#CURRENT_GAIN = $(echo '"GetConfigJson"' | websocat ws://127.0.0.1:1234 | jq '.GetConfigJson.value | fromjson | .filters.Gain.parameters.gain')


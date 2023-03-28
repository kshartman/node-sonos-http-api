#!/usr/bin/env bash
if (( $# >= 1 )); then
   BUILDFOR=$1
else
    BUILDFOR=$(echo "${HOSTNAME%%.*}" | tr '[:upper:]' '[:lower:]')
fi    

if [ -f ../private/settings-${BUILDFOR}.json ]; then
    rm settings.json
    cp ../private/settings-${BUILDFOR}.json settings.json
    rm settings-${BUILDFOR}.json
    ln -s ../private/settings-${BUILDFOR}.json .
else
    echo error: no such settings ../private/settings-${BUILDFOR}.json
    exit 1
fi

    cp ../private/settings-${BUILDFOR}.json settings.json
    rm settings-${BUILDFOR}.json
    ln -s ../private/settings-${BUILDFOR}.json .

if [ -d ../sonosd-presets/presets-${BUILDFOR} ]; then
    if [ -L ./presets ]; then
        rm ./presets 
    elif [ -d ./presets ]; then
        rm -rf ./presets
    elif [ -f ./presets ]; then
        rm ./presets
    fi
    mkdir ./presets
    (cd ../sonosd-presets/presets-${BUILDFOR} && tar cf - .) | (cd ./presets && tar xfv -)
 else
    echo error: no such settings ../sonosd-settings/settings-${BUILDFOR}.json
    exit 1
fi

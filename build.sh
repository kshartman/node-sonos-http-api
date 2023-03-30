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


# image name
IMAGE=sonosd
# ensure we're up to date
git pull
# update the version file
version=`npm run version --silent`
oldversion=$(cat VERSION 2> /dev/null)
echo $version > VERSION
echo "version: $version"
# run build
docker compose build
# tag it
if [[ "${version}" != "${oldversion}" )); then
    git add -A
    git commit -m "version $version"
    git tag -a "$version" -m "version $version"
    git push
    git push --tags
fi
docker tag $IMAGE:latest $IMAGE:$version

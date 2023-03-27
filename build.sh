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

# image name
IMAGE=sonosd
# ensure we're up to date
git pull
# update the version file
version=`npm run version --silent`
echo $version > VERSION
echo "version: $version"
# run build
docker compose build
# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags
docker tag $IMAGE:latest $IMAGE:$version

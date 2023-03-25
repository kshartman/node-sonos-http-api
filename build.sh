#!/usr/bin/env bash

# image name
IMAGE=sonosd
# ensure we're up to date
git pull
# update the version file
version=`npm run version --silent`
echo $version > VERSION
echo "version: $version"
# run build
docker-compose build
# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags
docker tag $IMAGE:latest $IMAGE:$version

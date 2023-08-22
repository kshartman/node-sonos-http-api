#!/usr/bin/env bash

VERSION=`npm run version --silent`
if $(command -v docker-compose); then
    docker-compose up -d node
else
    docker compose  up -d node
fi


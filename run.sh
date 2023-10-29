#!/usr/bin/env bash

VERSION=`npm run version --silent`
if command -v docker-compose &>/dev/null; then
    echo docker-compose up --detach node
    docker-compose up --detach node
else
   echo docker compose up -d node 
   docker compose up -d node
fi


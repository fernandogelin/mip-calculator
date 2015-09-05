#!/bin/bash
docker-compose run --rm npm install
docker-compose run --rm bower install
docker-compose up server

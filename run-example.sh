#!/bin/bash

docker run -e ACCOUNT_NAME="account_name@developer.gserviceaccount.com" \
 -e KEY_FILE="key-file.json" \
 -e PROJECT="project_id" \
 -v ~/path-to-key-file.json:/key-file.json \
 -it enxebre/bazooka -n test-cluster
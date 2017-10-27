# Bazooka

[![Build Status](https://travis-ci.org/enxebre/bazooka.svg?branch=master)](https://travis-ci.org/enxebre/bazooka)

A [gcloud](https://cloud.google.com/sdk/gcloud/reference/) wrapper for bulk deleting resources by applying filters.
Currently the only filter supported is resources namespaced with cluster-name* , i.e. ```--filter="name~my-cluster-name.*")```

If running docker and you want to be asked before deleting the resources make sure you have stdin interaction enable by using ```-it```.
```
docker run -e ACCOUNT_NAME="account_name@developer.gserviceaccount.com" \
 -e KEY_FILE="key-file.json" \
 -e PROJECT="project_id" \
 -v ~/path-to-key-file.json:/key-file.json \
 -it enxebre/bazooka -n test-cluster
 ```
 See [run-example.sh](run-example.sh)

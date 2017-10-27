#!/bin/bash
#
# gcloud wrapper for deleting resources namespaced with cluster-name*

declare -r ACCOUNT_NAME="${ACCOUNT_NAME:-}"
declare -r KEY_FILE="${KEY_FILE:-}"
declare -r PROJECT="${PROJECT:-}"
declare CLUSTER_NAME=""
declare FORCE=false

function login() {
  gcloud auth activate-service-account "${ACCOUNT_NAME}" --key-file "${KEY_FILE}" || exit 1
  gcloud config set project "${PROJECT}"
}

function usage() {
  echo "Usage: $0 [-n <cluster-name>] [-f <true|false>]" 1>&2; exit 1;
}

function set_parameters() {
  FORCE=false
  # shellcheck disable=SC2034
  local OPTIND n f
  while getopts ":n:f:" o; do
      case "${o}" in
          f)
              f=${OPTARG}
              if [ "${f}" != "true" ] && [ "${f}" != "false" ]; then
                usage
              fi
              FORCE=${OPTARG}
              ;;
          n)
              CLUSTER_NAME=${OPTARG}
              ;;
          *)
              usage
              ;;
      esac
  done
  readonly FORCE
  readonly CLUSTER_NAME
  shift $((OPTIND-1))

  if [ -z "${CLUSTER_NAME}" ]; then
      usage
  fi  
}

function destroy_resources() {
  local RESOURCES=(
    'firewall-rules'
    'forwarding-rules'
    'addresses'
    'routers'
    'routes'
    'target-tcp-proxies'
    'backend-services'
    'instance-groups managed'
    'instance-templates'
    'instances'
    'target-pools'  
    'health-checks'
    'http-health-checks'
    'https-health-checks'
    'networks subnets'
    'networks'
  )

  echo -e "\033[0;31mWARNING: You will destroy resources namespaced with ${CLUSTER_NAME} belonging to ${PROJECT} project\033[0m"
  echo -e "\033[0;31mWARNING: FORCE parameter is ${FORCE}\033[0m"
  trap "exit" INT
  for resource in "${RESOURCES[@]}"; do
    # shellcheck disable=SC2086
    echo "EXECUTING: gcloud compute ${resource} list --uri --filter="name~${CLUSTER_NAME}.*""
    local resource_list
    # shellcheck disable=SC2086
    resource_list="$(gcloud compute ${resource} list --uri --filter="name~${CLUSTER_NAME}.*")"
    [ -z "${resource_list}" ] && continue

    echo "EXECUTING: gcloud compute ${resource} delete ${resource_list}"
    if [ "$FORCE" = true ]; then
      # shellcheck disable=SC2086
      echo "Y" | gcloud compute ${resource} delete ${resource_list}
    else
      # shellcheck disable=SC2086
      gcloud compute ${resource} delete ${resource_list}
    fi
  done  
}

login
set_parameters "$@"
destroy_resources


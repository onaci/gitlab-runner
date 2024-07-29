#!/bin/bash -e

error() { echo "$@" >&2 ; exit 1 ; }

# Check for some required environment variables
[[ -n "${GITLABURL}" ]] || error "GITLABURL environment variable must be set"
[[ -n "${TOKEN}" ]] || error "TOKEN environment variable must be set"

# Set some sensible default values
: "${EXECUTOR:=docker}"
: "${DOCKERIMAGE:=alpine:latest}"

echo "GITLABURL: ${GITLABURL}"
echo "TOKEN: [redacted]"
echo "EXECUTOR: ${EXECUTOR}"
echo "DOCKERIMAGE: ${DOCKERIMAGE}"
echo "MOUNTDOCKERSOCKET: ${MOUNTDOCKERSOCKET}"
echo "DOCKERNETWORKMODE: ${DOCKERNETWORKMODE}"

BUILDS_DIR="/tmp/builds"
CACHE_DIR="/tmp/cache"

# Translate some environment variables to command line flags
options=()
if [[ -n "${MOUNTDOCKERSOCKET}" ]]; then
    options+=( "--docker-volumes" "${MOUNTDOCKERSOCKET}" )
fi
if [[ -n "${DOCKERNETWORKMODE}" ]]; then
    options+=( "--docker-network-mode" "${DOCKERNETWORKMODE}" )
fi

if [[ -n "${SSHUSER}" ]]; then
    options+=( "--ssh-user" "${SSHUSER}" )
fi
if [[ -n "${SSHKEY}" ]]; then
    options+=( "--ssh-identity-file" "${SSHKEY}" )
fi
if [[ -n "${SSHHOST}" ]]; then
    options+=( "--ssh-host" "${SSHHOST}" )
fi
if [[ -n "${SSHPORT}" ]]; then
    options+=( "--ssh-port" "${SSHPORT}" )
fi

if [[ -n "${CLONE_URL}" ]]; then
    options+=( "--clone-url" "${CLONE_URL}" )
fi

if [[ "${ENABLECACHE}" == "1" ]]; then
	options+=( "--docker-volumes" "${CACHE_DIR}" )
fi

mkdir -p -m 777 "${BUILDS_DIR}" "${CACHE_DIR}"

gitlab-runner register \
    --non-interactive \
    --url "${GITLABURL}" \
    --token "${TOKEN}" \
    --executor "${EXECUTOR}" \
    --docker-image "${DOCKERIMAGE}" \
    --builds-dir "${BUILDS_DIR}" \
    --cache-dir "${CACHE_DIR}" \
    "${options[@]}"

exec /entrypoint "$@"

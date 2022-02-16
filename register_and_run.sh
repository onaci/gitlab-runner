#!/bin/bash -ex

# Set some sensible default values
: "${EXECUTOR:=docker}"
: "${DOCKERIMAGE:=alpine:latest}"
: "${RUNNERNAME:=gitlab runner}"
: "${TAGLIST:=docker,auto}"

echo "GITLABURL: ${GITLABURL}"
echo "RUNNERTOKEN: ${RUNNERTOKEN}"
echo "EXECUTOR: ${EXECUTOR}"
echo "DOCKERIMAGE: ${DOCKERIMAGE}"
echo "RUNNERNAME: ${RUNNERNAME}"
echo "TAGLIST: ${TAGLIST}"
echo "MOUNTDOCKERSOCKET: ${MOUNTDOCKERSOCKET}"
echo "DOCKERNETWORKMODE: ${DOCKERNETWORKMODE}"

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

BUILDS_DIR="/tmp/builds"
CACHE_DIR="/tmp/cache"

mkdir -p -m 777 "${BUILDS_DIR}" "${CACHE_DIR}"

gitlab-runner register \
    --non-interactive \
    --builds-dir "${BUILDS_DIR}" \
    --cache-dir "${CACHE_DIR}" \
    --url "${GITLABURL}" \
    --registration-token "${RUNNERTOKEN}" \
    --executor "${EXECUTOR}" \
    --docker-image "${DOCKERIMAGE}" \
    "${options[@]}" \
    --description "${RUNNERNAME}" \
    --tag-list "${TAGLIST}" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"

exec /entrypoint "$@"

#!/bin/bash -ex

echo "GITLABURL: ${GITLABURL}"
echo "RUNNERTOKEN: ${RUNNERTOKEN}"
echo "EXECUTOR: ${EXECUTOR:-docker}"
echo "DOCKERIMAGE: ${DOCKERIMAGE:-alpine:latest}"
echo "RUNNERNAME: ${RUNNERNAME:-gitlab runner}"
echo "TAGLIST: ${TAGLIST:-docker,auto}"
echo "MOUNTDOCKERSOCKET: ${MOUNTDOCKERSOCKET}"
echo "DOCKERNETWORKMODE: ${DOCKERNETWORKMODE}"
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

if [[ -n "${CLONE}_URL" ]]; then
    options+=( "--clone-url" "${CLONE_URL}" )
fi

mkdir -p /tmp/builds
chmod 777 /tmp/builds
mkdir -p /tmp/cache
chmod 777 /tmp/cache

gitlab-runner register \
    --non-interactive \
    --builds-dir=/tmp/builds \
    --cache-dir=/tmp/cache \
    --url "${GITLABURL}" \
    --registration-token "${RUNNERTOKEN}" \
    --executor "${EXECUTOR:-docker}" \
    --docker-image "${DOCKERIMAGE:-alpine:latest}" \
    "${options[@]}" \
    --description "${RUNNERNAME:-gitlab runner}" \
    --tag-list "${TAGLIST:-docker,auto}" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"

exec /entrypoint "$@"

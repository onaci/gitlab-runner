#!/bin/bash -ex

echo "GITLABURL: ${GITLABURL}"
echo "RUNNERTOKEN: ${RUNNERTOKEN}"
echo "EXECUTOR: ${EXECUTOR:-docker}"
echo "DOCKERIMAGE: ${DOCKERIMAGE:-alpine:latest}"
echo "RUNNERNAME: ${RUNNERNAME:-gitlab runner}"
echo "TAGLIST: ${TAGLIST:-docker,auto}"
echo "MOUNTDOCKERSOCKET: ${MOUNTDOCKERSOCKET}"
if [[ "${MOUNTDOCKERSOCKET}" != "" ]]; then
    MOUNTDOCKERSOCKET="--docker-volumes ${MOUNTDOCKERSOCKET}"
fi
echo "DOCKERNETWORKMODE: ${DOCKERNETWORKMODE}"
if [[ "${DOCKERNETWORKMODE}" != "" ]]; then
    DOCKERNETWORKMODE="--docker-network-mode ${DOCKERNETWORKMODE}"
fi

if [[ "$SSHUSER" != "" ]]; then
    SSH="--ssh-user=$SSHUSER $SSH"
fi
if [[ "$SSHKEY" != "" ]]; then
    SSH="--ssh-identity-file=$SSHKEY $SSH"
fi
if [[ "$SSHHOST" != "" ]]; then
    SSH="--ssh-host=$SSHHOST $SSH"
fi
if [[ "$SSHPORT" != "" ]]; then
    SSH="--ssh-port=$SSHPORT $SSH"
fi

if [[ "$CLONE_URL" != "" ]]; then
    CLONE_URL="--clone-url ${CLONE_URL}"
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
    ${MOUNTDOCKERSOCKET} \
    ${DOCKERNETWORKMODE} \
    ${SSH} \
    ${CLONE_URL} \
    --description "${RUNNERNAME:-gitlab runner}" \
    --tag-list "${TAGLIST:-docker,auto}" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"

exec /entrypoint "$@"
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

mkdir -p /builds
chmod 777 /builds
mkdir -p /cache
chmod 777 /cache

gitlab-runner register \
    --non-interactive \
    --builds-dir=/builds \
    --cache-dir=/cache \
    --url "${GITLABURL}" \
    --registration-token "${RUNNERTOKEN}" \
    --executor "${EXECUTOR:-docker}" \
    --docker-image "${DOCKERIMAGE:-alpine:latest}" \
    ${MOUNTDOCKERSOCKET} \
    ${DOCKERNETWORKMODE} \
    ${SSH} \
    --description "${RUNNERNAME:-gitlab runner}" \
    --tag-list "${TAGLIST:-docker,auto}" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"

exec /entrypoint "$@"
#!/bin/bash -ex

echo "GITLABURL: ${GITLABURL}"
echo "RUNNERTOKEN: ${RUNNERTOKEN}"
echo "EXECUTOR: ${EXECUTOR:-docker}"
echo "DOCKERIMAGE: ${DOCKERIMAGE:-alpine:latest}"
echo "RUNNERNAME: ${RUNNERNAME:-gitlab runner}"
echo "TAGLIST: ${TAGLIST:-docker,auto}"

gitlab-runner register \
    --non-interactive \
    --url "${GITLABURL}" \
    --registration-token "${RUNNERTOKEN}" \
    --executor "${EXECUTOR:-docker}" \
    --docker-image "${DOCKERIMAGE:-alpine:latest}" \
    --description "${RUNNERNAME:-gitlab runner}" \
    --tag-list "${TAGLIST:-docker,auto}" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"

exec /entrypoint "$@"
#!/bin/bash

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
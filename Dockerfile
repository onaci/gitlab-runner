FROM gitlab/gitlab-runner:alpine-v17.4.0

RUN apk update \
    && apk upgrade \
    && apk --no-cache add \
        bash \
        ca-certificates

ADD register_and_run.sh /
ENTRYPOINT ["/register_and_run.sh"]

FROM gitlab/gitlab-runner:alpine

RUN apk update \
    && apk upgrade \
    && apk --no-cache add \
        bash \
        ca-certificates

ADD register_and_run.sh /

FROM gitlab/gitlab-runner:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD register_and_run.sh /

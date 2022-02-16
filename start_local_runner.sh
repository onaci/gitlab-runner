#!/bin/bash

docker_image="onaci/gitlab-runner:alpine"
runner_name="test-runner-$HOSTNAME"

_fold() {
	if command -v fold &>/dev/null ; then
		fold
	else
		cat
	fi
}

intro() { _fold <<INTRO
Start a Gitlab CI runner on your local machine. This runner will connect to the
specified Gitlab instance and run CI jobs. This script can be used to:

  - adding a temporary runner for a project, without needing admin access
  - test modifications to the onaci/gitlab-runner image
  - debugging issues with a pipeline by running the jobs locally
INTRO

}
usage() { _fold <<USAGE
Usage:
	$0 [--image docker-image] [--name runner-name]
		<gitlab-url> <runner-token>
		[-- docker options]

Parameters:
	<gitlab-url>:
		The URL of the Gitlab instance
	<runner-token>:
		The runner token provided by Gitlab
	-- docker options:
		Anything after '--' is passed to 'docker run'.
		Use this to set extra environment variables, for example.

Options:
	-h, --help:
		Display this help
	-i, --image "docker-image":
		The docker image to use ($docker_image)
	-n, --name "runner-name":
		The name of the runner, used in the Gitlab administration
		($runner_name)
USAGE
}

options=$( getopt -n "$0" -l "help,image:,name:" -o "hi:n:" -- "$@" )
if [[ $? != 0 ]] ; then
	usage >&2
	exit 1
fi

eval set -- "$options"
while true ; do
	case "$1" in
		-h|--help) intro ; echo ; usage ; exit 0 ;;
		-i|--image) docker_image=$2 ; shift 2 ;;
		-n|--name) runner_name=$2 ; shift 2 ;;
		--) shift ; break ;;
		*) echo "Unknown option $1" >&2 ; exit 1 ;;
	esac
done

if [[ $# < 2 ]] ; then
	usage >&2
	exit 1
fi

gitlab_url=$1
runner_token=$2
shift 2

exec docker run --rm \
	--entrypoint "/register_and_run.sh" \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-e GITLABURL="$gitlab_url" \
	-e RUNNERTOKEN="$runner_token" \
	-e RUNNERNAME="$runner_name" \
	"$@" \
	"$docker_image" \
	run --user=gitlab-runner --working-directory=/home/gitlab-runner

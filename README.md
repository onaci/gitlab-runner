# gitlab-runner

A variation on gitlab/gitlab-runner that is able to automatically register itself with GitLab when it is created.

## Testing

Make any modifications you need, then build the image and run a container locally:

```shell
$ docker build . -t onaci/gitlab-runner:dev
$ ./start_local_runner.sh \
	--image onaci/gitlab-runner:dev \
	https://git.ona.im/ "runner-token"
```

## Publishing a new image

Build the image with the right tag, and push it to Docker Hub:

```shell
$ docker build . -t onaci/gitlab-runner:alpine
$ docker push onaci/gitlab-runner:alpine
```

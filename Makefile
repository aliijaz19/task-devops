docker_build:
	docker build . -f Dockerfile  -t aliijaz/coding-task-devops

docker_tag: docker_build
	docker tag aliijaz/coding-task-devops aliijaz/coding-task-devops:${GITHUB_SHA}

docker_auth:
	echo "$$DOCKERHUB_PASSWORD" | docker login -u "$$DOCKERHUB_USERNAME" --password-stdin

docker_push: docker_tag docker_auth ## push to docker hub
	docker push 'aliijaz/coding-task-devops:latest'
	docker push "aliijaz/coding-task-devops:${GITHUB_SHA}"

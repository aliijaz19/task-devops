docker_build:
	docker build . -f Dockerfile  -t EmeraldLabs/coding-task-devops

docker_tag: docker_build
	docker tag EmeraldLabs/coding-task-devops EmeraldLabs/coding-task-devops:${GITHUB_SHA}

docker_auth:
	echo "$$DOCKERHUB_PASSWORD" | docker login -u "$$DOCKERHUB_USERNAME" --password-stdin

docker_push: docker_tag docker_auth ## push to docker hub
	docker push 'EmeraldLabs/coding-task-devops:latest'
	docker push "EmeraldLabs/coding-task-devops:${GITHUB_SHA}"

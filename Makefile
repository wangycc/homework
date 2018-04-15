all: docker

DOCKER_IMAGE_NAME     ?= 19931028/homework/web
DOCKER_IMAGE_TAG      ?= $(subst /,-,$(shell git rev-parse --abbrev-ref HEAD))

docker:
	@echo ">> building docker image"
	docker build -t "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" $(CURDIR)

docker_push: docker
	@echo ">> docker push $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) $(CURDIR)"
	docker push $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

docker-compose:
	@echo ">> docker-compose"
	docker-compose up -d 

install:
	@sh -c "$(CURDIR)/run.sh install"

setup:
	make docker-compose


.PHONY: docker-conpose docker docker_push

# Makefile for docker image

DOCKER_IMAGE = dhylands/gcc
DOCKER_TAG = 1.0

build:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) --progress=plain .

pull:
	docker pull $(DOCKER_IMAGE):$(DOCKER_TAG)

push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

install:
	mkdir -p ~/bin
	ln -s $(realpath ./run-gcc) ~/bin/run-gcc

run:
	./gcc-run

test:
	echo "test"

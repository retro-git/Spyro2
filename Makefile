IMAGE_NAME 	:= spyro2-build:latest
DOCKER 		:= docker
CURRENT_DIR := $(shell pwd)
MAKE 		:= make

# print current_dir
.PHONY: container

# Build the docker image. Will rebuild if Dockerfile changes.
image_creation.timestamp: Dockerfile
	docker build -t $(IMAGE_NAME) .
	touch $@

# Run docker container. Will build image if image_creation_timestamp is not present or is older than Dockerfile.
container: image_creation.timestamp
	docker run --rm -it -v $(CURRENT_DIR):/spyro2 -w /spyro2 $(IMAGE_NAME)

isodump/spyro2.xml: spyro2.bin
	dumpsxiso spyro2.bin -x ./isodump -s ./isodump/spyro2.xml

game/SCUS_944.25: isodump/spyro2.xml
	cp isodump/SCUS_944.25 game

game/split.timestamp: game/SCUS_944.25
	$(MAKE) -C game split

game/build/SCUS_944.25: game/split.timestamp
	$(MAKE) -C game
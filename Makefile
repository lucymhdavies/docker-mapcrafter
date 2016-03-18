DOCKER_IMAGE_NAME    := danguita/mapcrafter
DOCKER_BUILD         := docker build --file Dockerfile
MINECRAFT_WORLD_NAME := "MyWorld"
MINECRAFT_SAVES_PATH := "$(HOME)/Library/Application Support/minecraft/saves"
DOCKER_RUN           := docker run -it --rm -v $(shell pwd):/data -v $(MINECRAFT_SAVES_PATH):/data/worlds

build: Dockerfile
	$(DOCKER_BUILD) --tag $(DOCKER_IMAGE_NAME) .

clean_build: Dockerfile
	$(DOCKER_BUILD) --no-cache --tag $(DOCKER_IMAGE_NAME) .

run:
	$(DOCKER_RUN) -e WORLD_NAME=$(MINECRAFT_WORLD_NAME) $(DOCKER_IMAGE_NAME) /data/run.sh

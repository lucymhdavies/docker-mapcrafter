MINECRAFT_WORLD_NAME := "Davinhart Kingdom"
MINECRAFT_SAVES_PATH := "$(HOME)/Library/Application Support/minecraft/saves"
DOCKER_IMAGE_NAME    := lucymhdavies/mapcrafter
DOCKER_BUILD         := docker build --file Dockerfile
DOCKER_RUN           := docker run -it --rm -v $(shell pwd):/data #-v $(MINECRAFT_SAVES_PATH):/data/worlds

build: Dockerfile
	$(DOCKER_BUILD) --tag $(DOCKER_IMAGE_NAME) .

clean_build: Dockerfile
	$(DOCKER_BUILD) --no-cache --tag $(DOCKER_IMAGE_NAME) .

download:
	$(DOCKER_RUN) $(DOCKER_IMAGE_NAME) /data/download.sh

run:
	#$(DOCKER_RUN) -e WORLD_NAME=$(MINECRAFT_WORLD_NAME) $(DOCKER_IMAGE_NAME) /data/run.sh
	echo $(docker rmi lucymhdavies/mapcrafter-dockerfile:latest) # in a shell, to ensure exit status 0
	docker run -it --rm -v $(shell pwd):/data lucymhdavies/mapcrafter-dockerfile:latest -c /data/render.conf

force_run:
	$(DOCKER_RUN) -e WORLD_NAME=$(MINECRAFT_WORLD_NAME) $(DOCKER_IMAGE_NAME) /data/run.sh -F

serve:
	docker run --name minecraft-map -v $(shell pwd)/render/Davinhart\ Kingdom/:/usr/share/nginx/html:ro -p 80:80 -d nginx

ngrok:
	docker run --name minecraft-map -v $(shell pwd)/render/Davinhart\ Kingdom/:/usr/share/nginx/html:ro -p 8080:80 -d nginx
	ngrok http -region eu 8080
	docker rm -f minecraft-map

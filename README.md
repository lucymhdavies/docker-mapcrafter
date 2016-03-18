# Mapcrafter Docker image and configuration tool

This image contains [Mapcrafter](http://mapcrafter.org/index) 2.1 and all its dependencies.

There is also a [config file template](render.template.conf) which will be processed within a `run` script, and a `Makefile` to assist users on repeating tasks, providing the following targets:

```shell
$ make build
$ make clean_build
$ make run
```

There're two variables that should be setted in the `Makefile` before executing the rendering process:

- `MINECRAFT_WORLD_NAME` (as in the saves path)
- `MINECRAFT_SAVES_PATH`

As a sample Docker container initialization, the `make run` target will execute the following command:

```shell
$ docker run -it --rm -v .:/data -v "/Users/david/Library/Application Support/minecraft/saves:/data/worlds" -e WORLD_NAME=MyWorld danguita/mapcrafter /data/run.sh
```

There's a `/data` volume to sync any starting config files, and `/data/worlds` one to access any Minecraft saves. Any rendered maps are going to be stored in `/data/render`, which means `./render` in your host filesystem.

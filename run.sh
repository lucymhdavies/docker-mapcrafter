#!/usr/bin/env bash

sed "s/\$WORLD_NAME/$WORLD_NAME/g" /data/render.template.conf > /data/render.conf
mapcrafter -c /data/render.conf -j $(nproc --all)

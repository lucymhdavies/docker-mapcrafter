#!/bin/bash

source creds

while : ; do

	curl "https://slack.com/api/chat.postMessage?token=$SLACK_TOKEN&channel=%23mapcrafter&text=Updating%20map...&username=Mapcrafter&icon_url=http%3A%2F%2Fwww.rw-designer.com%2Ficon-image%2F5547-256x256x8.png"

	echo
	echo ================================================================================
	echo Downloading...
	echo ================================================================================

	make download


	# TODO: add a `make build` or `make force_build` in here too?

	echo
	echo ================================================================================
	echo Generating map
	echo ================================================================================

	make run

	curl "https://slack.com/api/chat.postMessage?token=$SLACK_TOKEN&channel=%23mapcrafter&text=Map%20Rendered%3A%20http%3A%2F%2Fmap.minecraft.lmhd.me&username=Mapcrafter&icon_url=http%3A%2F%2Fwww.rw-designer.com%2Ficon-image%2F5547-256x256x8.png"

	./wait.sh


done

#!/bin/bash

source creds

while : ; do

	./wait.sh

	curl "https://slack.com/api/chat.postMessage?token=$SLACK_TOKEN&channel=%23mapcrafter&text=Downloading%20world...&username=Mapcrafter&icon_url=http%3A%2F%2Fwww.rw-designer.com%2Ficon-image%2F5547-256x256x8.png"

	echo
	echo ================================================================================
	echo Downloading...
	echo ================================================================================

	make download


	# TODO: add a `make build` or `make force_build` in here too?

	curl "https://slack.com/api/chat.postMessage?token=$SLACK_TOKEN&channel=%23mapcrafter&text=Updating%20map...&username=Mapcrafter&icon_url=http%3A%2F%2Fwww.rw-designer.com%2Ficon-image%2F5547-256x256x8.png"

	echo
	echo ================================================================================
	echo Generating map
	echo ================================================================================

	make run

	curl "https://slack.com/api/chat.postMessage?token=$SLACK_TOKEN&channel=%23mapcrafter&text=Map%20Rendered%3A%20http%3A%2F%2Fmap.minecraft.lmhd.me&username=Mapcrafter&icon_url=http%3A%2F%2Fwww.rw-designer.com%2Ficon-image%2F5547-256x256x8.png"

	echo
	echo ================================================================================
	echo Sleeping for at least 3 hours
	echo ================================================================================

	# Sleep 3h
	sleep 10800

done

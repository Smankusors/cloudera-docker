#!/bin/bash
docker run \
	--hostname=wawa \
	-t -i -d \
	--name cdh6.3_wawa \
	--network host \
	cdh6.3_nonparcel \
	/bin/bash

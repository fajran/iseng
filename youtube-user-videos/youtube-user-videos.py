#!/usr/bin/env python

#
# Get video list of a user
#
# Requirement: Google Data API
# License: Public Domain
#
# Usage: ./youtube-user-videos.py <username>
#

import sys
import gdata.youtube
import gdata.youtube.service

if len(sys.argv) < 2:
	print "Usage: %s <username>" % sys.argv[0]
	sys.exit(1)

username = sys.argv[1]

max = 50

yt_service = gdata.youtube.service.YouTubeService()
query = gdata.youtube.service.YouTubeVideoQuery()
query.author = username
query.max_results = max
query.orderby = 'published'
query.time = 'all_time'

start = 1
cnt = 0
while True:
	query.start_index = start
	start += max

	feed = yt_service.YouTubeQuery(query)
	for item in feed.entry:
		cnt += 1
		data = (cnt,
			item.media.player.url, 
			item.media.duration.seconds,
			item.media.title.text)
		print "%d\t%s\t%s\t%s" % data

	if len(feed.entry) < max:
		break

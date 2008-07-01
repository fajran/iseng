#!/usr/bin/env python

#
# Get contact list of a user
#
# Requirements: 
# - flickrapi: http://pypi.python.org/pypi/flickrapi
# - simplejson: http://pypi.python.org/pypi/simplejson/
# 
# License: Public Domain
# 
# Usage: ./flickr-user-contacts.py <username|userid>
#

# Set your Flickr API Key here!
flickr_key = ''



import sys
import flickrapi
import simplejson

if len(sys.argv) < 1:
	print "Usage: %s <username|userid>" % sys.argv[0]
	sys.exit(1)

if flickr_key == '':
	print "Please set your Flickr API Key!"
	sys.exit(1)

def parseResult(res):
	json = res[14:-1]
	return simplejson.loads(json)


flickr = flickrapi.FlickrAPI(flickr_key, format="json")

# Get User Id

user = sys.argv[1]
res = flickr.urls_lookupUser(url="http://flickr.com/people/%s" % user)
data = parseResult(res)

id = data['user']['id']

# Get Contacts

contacts = {}

page = 1
while True:
	res = flickr.contacts_getPublicList(user_id=id, page=page)
	data = parseResult(res)

	items = data['contacts'].get('contact', None)
	
	if not items:
		break

	for item in items:
		contacts[item['nsid']] = item['username']

	page += 1

for key in contacts:
	print key, contacts[key].encode('ascii', 'replace')



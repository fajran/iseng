#!/usr/bin/env python

import sys
import getopt
import os
import time

opts, args = getopt.getopt(sys.argv[1:], "s:d:p:h")

source = None
destination = None
show_help = False
pattern = "%Y-%m-%d"

for o, a in opts:
	if o == "-s":
		source = a
	elif o == "-d":
		destination = a
	elif o == "-p":
		pattern = a
	elif o == "h":
		show_help = True

def help():
	print """Usage: %s -s source-dir -d destination-dir [-p pattern]

Options
 -s SOURCE         directory that contains the files
 -d DESTINATION    target directory
 -p PATTERN        directory pattern, uses Python's date.strftime format""" % sys.argv[0]

if source == None or destination == None or show_help:
	help()
	sys.exit(1)


files = {}

for file in os.listdir(source):
	
	fullname = os.path.join(source, file)

	if not os.path.isfile(fullname):
		continue

	try:
		mtime = os.path.getmtime(fullname)
		dir = time.strftime(pattern, time.localtime(mtime))

		group = files.get(dir, [])
		group.append(file)
		files[dir] = group

	except:
		print >>sys.stderr, "error getting file attribute of %s" % file

print "#!/bin/sh"

for dir in files:
	print "mkdir -p %s" % os.path.join(destination, dir)
	
	for file in files[dir]:
		print "mv \"%s\" \"%s\"" % (os.path.join(source, file), os.path.join(destination, dir, file))



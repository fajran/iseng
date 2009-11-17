#!/bin/sh

# Download Debian Repository's Package Index

# Author: Fajran Iman Rusadi
# License: Public Domain

# Usage:
#
#     ./download-dists [repo base url] [dists] [sections] [archs] [target]
#
#     - repo base url is the base URL of a Debian repository
#       i.e. http://ftp.debian.org/debian/
#     - dists is a comma separated distribution/release names
#       i.e. lenny
#     - sections is a list of repository sections, separated by a comma
#       i.e. main,contrib,non-free
#     - archs is a list of architectures, separated by a comma
#       i.e. i386,amd64
#     - target is the target download directory
#       i.e. /home/you/debian/
#
# Example:
#
#     ./download-dists \
#          http://kambing.ui.ac.id/ubuntu/ \
#          karmic,karmic-updates,karmic-security \
#          main,restricted,universe,multiverse
#          i386 \
#          ubuntu/
#

BASE=$1
DISTS=$2
SECTIONS=$3
ARCHS=$4
TARGET=$5

IFS_ORIG=$IFS
IFS=","

for dist in $DISTS
do
	for section in $SECTIONS
	do
		for arch in $ARCHS
		do
			DIR=dists/$dist/$section/binary-$arch
			URL=$BASE/$DIR/Packages.gz
			TO=$TARGET/$DIR/Packages.gz

			mkdir -p $TARGET/$DIR
			wget -c -O $TO $URL
		done
	done

	wget -c -O $TARGET/dists/$dist/Release $BASE/dists/$dist/Release
	wget -c -O $TARGET/dists/$dist/Release.gpg $BASE/dists/$dist/Release.gpg
done


#!/bin/sh

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


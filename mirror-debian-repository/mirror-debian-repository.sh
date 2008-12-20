#!/usr/bin/env bash

# License: Public Domain

DIST=hoary
SECTIONS="main restricted universe multiverse"
ARCH=i386

TARGET=ubuntu/
BASE=http://old-releases.ubuntu.com/ubuntu/
CUT=1


for sect in $SECTIONS
do
	mkdir -p $TARGET/dists/$DIST/$sect/binary-$ARCH/
	wget -c -O $TARGET/dists/$DIST/$sect/binary-$ARCH/Packages.gz $BASE/dists/$DIST/$sect/binary-$ARCH/Packages.gz
	gunzip -c $TARGET/dists/$DIST/$sect/binary-$ARCH/Packages.gz > $TARGET/dists/$DIST/$sect/binary-$ARCH/Packages
done

LIST=$TARGET/.list.txt
[ -f $LIST ] && rm -f $LIST

for sect in $SECTIONS
do
	grep ^Filename: $TARGET/dists/$DIST/$sect/binary-$ARCH/Packages | cut -d' ' -f 2 >> $LIST
done

cat $LIST | while read url
do
	wget -r -nH --cut-dirs=$CUT -P $TARGET -c $BASE/$url
done


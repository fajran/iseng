#!/bin/bash

#
# Download a Debian mirror using wget.
#
# This is a revised version of the previous mirror-debian-repository
# http://github.com/fajran/iseng/tree/master/mirror-debian-repository
#

# WARNING: This is not suitable to update your live mirror
#          since wget overwrite the file as it downloads.

# Author: Fajran Iman Rusadi <fajran@ubuntu.com>
# License: Public Domain, or in other words..
#          do whatever you want with this script but
#          I'm not responsible for whatever you do

MIRROR=http://nl.archive.ubuntu.com/ubuntu/
DIST="hardy"
SECTION="restricted"
ARCH="i386"
TARGET="ubuntu"

TMPPREFIX="tmp"

###########################################################################

function get_cut_dirs {
	base=$1
	protocol="`echo $base | cut -d':' -f1`:"
	cnt=0

	str=$base
	while [ "$str" != "$protocol" ]; do
		str=`dirname $str`
		cnt=$(( cnt + 1 ))
	done

	cnt=$(( cnt - 1 ))
	echo $cnt
}

echo "Downloading Packages files.."

TMP="$TMPPREFIX-list"
for dist in $DIST; do
	for section in $SECTION; do
		for arch in $ARCH; do
			PKGDIR="dists/$dist/$section/binary-$arch"
			URL=$MIRROR/$PKGDIR

			BASE=$dist-$section-$arch
			mkdir -p $TARGET/$PKGDIR

			wget -q -O - $URL/Packages.gz | tee $TARGET/$PKGDIR/Packages.gz | gunzip -c > $TARGET/$PKGDIR/Packages
			
			echo "- $dist $section $arch"
		done
	done
done

CUT=`get_cut_dirs $MIRROR`

echo "Downloading files.."
TMP=$TMPPREFIX-list
for dist in $DIST; do
	for section in $SECTION; do
		for arch in $ARCH; do
			PKGDIR="dists/$dist/$section/binary-$arch"
			PACKAGES=$TARGET/$PKGDIR/Packages
			
			grep ^Filename $PACKAGES | cut -d' ' -f 2 > $TMP

			echo "- $dist $section $arch"

			wget -c -x -nH -nv -B $MIRROR/ --cut-dirs $CUT -P $TARGET -i $TMP
		done
	done
done

rm -f $TMP


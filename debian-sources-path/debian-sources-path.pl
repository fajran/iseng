#!/usr/bin/env perl

# License: Public domain

#
# Usage:
#
# 1. Download all Sources, Sources.gz, or Sources.bz2 from
#    http://ftp.debian.org/dists/etch/{main,contrib,non-free}/source/
#
# 2. Save/extract to Sources.main, Sources.contrib, and Sources.non-free
#
# 3. cat Sources.* | grep '^Directory\|^ ' | ./debian-sources-path.pl
#

my $dir = '';
while (<STDIN>) {
	chop;
	if (/^Directory/) {
		($dir) = /Directory: (.+)/;
	}
	else {
		($md5sum, $size, $file) = /\ ([^\s]+) ([^\s]+) ([^\s]+)/;
		print "$dir/$file\n";
	}
}


#!/usr/local/bin/perl -w
#
# @@@ Modified to use an illegal OID
# @@@ (to check whether a correct error message is generated)
#
# Demonstration code for table walking
#
# This script should serve as an example of how to "correctly"
# traverse the rows of a table.  This functionality is implemented in
# the map_table() subroutine.  The example script displays a few
# columns of the RFC 1213 interface table and Cisco's locIfTable.  The
# tables share the same index, so they can be handled by a single
# invocation of map_table().

require 5.003;

use strict;

use BER;
use SNMP_Session;

my $host = shift @ARGV || die;
my $community = shift @ARGV || die;

my $ifDescr = [1,3,6,1,2,1,2,2,1,2];
my $ifInOctets = [1,3,6,1,2,1,2,2,1,10];
my $ifOutOctets = [1,3,6,1,2,1,2,2,1,16];
my $locIfInBitsSec = [1,3,6,1,4,1,9,2,2,1,1,6];
# @@@
my $locIfOutBitsSec = [9,2,2,1,1,8];
# @@@
my $locIfDescr = [1,3,6,1,4,1,9,2,2,1,1,28];

sub out_interface {
  my ($index, $descr, $in, $out, $comment) = @_;

  grep (defined $_ && ($_=pretty_print $_),
	($descr, $in, $out, $comment));
  printf "%2d  %-24s %10s %10s %s\n",
  $index,
  defined $descr ? $descr : '',
  defined $in ? $in/1000.0 : '-',
  defined $out ? $out/1000.0 : '-',
  defined $comment ? $comment : '';
}

my $session = SNMP_Session->open ($host, $community, 161)
  || die "Opening SNMP_Session";
$session->map_table ([$ifDescr,$locIfInBitsSec,$locIfOutBitsSec,$locIfDescr],
		     \&out_interface);
1;

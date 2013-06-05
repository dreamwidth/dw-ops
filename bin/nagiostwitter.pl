#!/usr/bin/perl -w
#
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
#
# The Original Code is the Bugzilla Status Bot
#
# The Initial Developer of the Original Code is David D. Miller.
# Portions developed by David D. Miller are Copyright (C) 2002-3
# David D. Miller.  All Rights Reserved.
#
# Contributor(s): David Miller <justdave@syndicomm.com>
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# This script has been rewritten to use the Twitter 1.1 API
# by Jen Griffin <kareila@dreamwidth.org> - 2013/06/04

use strict;
use POSIX "sys_wait_h";

use Net::Twitter::Lite;
use Net::OAuth;

# define %dw_alert_info
our %dw_alert_info;
require "$ENV{HOME}/.twitterrc";

my $nagioslog = "/var/log/nagios3/nagios.log";
my $nagioscmd = "/var/log/nagios/rw/nagios.cmd";

open NAGIOS, "<$nagioslog";
seek NAGIOS, 0, 2; # seek to end

my @cmdqueue = ();
my $ACKCT = 0;
my @ACKS;
my $laststat = 0;

print "starting...\n";
while (1) {
  while (defined (my $line = <NAGIOS>)) {
    chomp($line);
    if ($line =~ /^\[\d+\]\s(HOST|SERVICE) NOTIFICATION: ((?:mark);.*)$/) {
        my ($type, $msg) = ($1, $2);
        my ($who, $host, $service, $state, $how, $output);
        if ($type eq "HOST") {
            ($who, $host, $state, $how, $output) = split(";",$msg,5);
            $msg = "$host is $state: $output";
        }
        else {
            ($who, $host, $service, $state, $how, $output) = split(";",$msg,6);
            $msg = "$host:$service is $state: $output";
        }
        $service ||= "";

        # TWEET IT!!!!
        $msg = substr( $msg, 0, 137 ) . '...' if length( $msg ) > 140;
        my $time = localtime();
        warn "$time [$msg]\n";

        my $tw = Net::Twitter::Lite->new( %dw_alert_info, legacy_lists_api => 0 )
            or die;
        eval { $tw->update( $msg ) };
        warn "Twitter error: $@\n" if $@;
    }
  }

  if ((time - $laststat) > 30) {
    # we don't want to constantly stat the file or we'll hammer the disk.
    # keep it to once every 30 seconds.  Here we compare the inode of the
    # file we have open and the file at the path we're expecting and see
    # if they match.  If they don't, then the log has been rotated, so we
    # close and reopen it to pick up the new logfile.  We also only do it
    # if we don't read a line from the file, so that way we make sure
    # actually gotten to the end of the current file before we check for
    # a rotation.
    $laststat = time;
    if ((stat NAGIOS)[1] != (stat $nagioslog)[1]) {
        close NAGIOS;
        open NAGIOS, "<$nagioslog";
    }
  }

  sleep 1;
}

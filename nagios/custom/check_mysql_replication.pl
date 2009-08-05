#!/usr/bin/perl

use strict;
use DBI;
use Getopt::Long;

my ( $user, $pass, $host );
GetOptions(
        'host|H=s' => \$host,
        'user=s' => \$user,
        'password=s' => \$pass,
    ) or usage();
usage()
    unless $user && $pass && $host;

# connect to the database
my $dbh = DBI->connect( "DBI:mysql:host=$host", $user, $pass )
    or crit( 'Unable to connect to database.' );

my $rep = $dbh->selectrow_hashref( 'SHOW SLAVE STATUS' );
crit( 'Database error or database not a slave.' )
    unless $rep && $rep->{Slave_IO_State};
crit( "Replication stopped: IO=$rep->{Slave_IO_Running}, SQL=$rep->{Slave_SQL_Running}." )
    unless $rep->{Slave_IO_Running} eq 'Yes' &&
           $rep->{Slave_SQL_Running} eq 'Yes';

# loose limits because we don't actively use slaves for anything
# that we care about for realtime serving.  also, the codebase knows
# how to avoid a slave that is falling behind.
crit( "Replication very far behind: $rep->{Seconds_Behind_Master}." )
    if $rep->{Seconds_Behind_Master} > 3600;
_warn( "Replication behind: $rep->{Seconds_Behind_Master}." )
    if $rep->{Seconds_Behind_Master} > 1800;

ok( 'Replication okay.' );

# return usage information on this script
sub usage {
    print <<EOF;
check_mysql_replication.pl -- easy way to monitor replication
EOF
    exit 3;
}

# nagios return codes
sub crit {
    print "$_[0]\n";
    exit 2;
}

sub _warn {
    print "$_[0]\n";
    exit 1;
}

sub ok {
    print "$_[0]\n";
    exit 0;
}

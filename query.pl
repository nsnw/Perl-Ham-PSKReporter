#!/usr/bin/perl

# query.pl
# (c)2011 Andy Smith <andy@m0vkg.org.uk>
#
# A dirty bit of example code to show how Ham::PSKReporter works.
# 

use lib "Ham/PSKReporter";
use DBI;

require Ham::PSKReporter;
require Ham::Locator;
use Data::Dumper;
use Class::Date qw(:errors date localdate gmdate now -DateParse -EnvC);
use strict;
use warnings;
use CGI;

my $dbh = DBI->connect('DBI:mysql:dbname', 'dbuser', 'dbpassword') || die "Could not connect to database: ".$DBI::errstr;
$dbh->trace(0);

# Prepared statements
my $q_exist = $dbh->prepare("SELECT * FROM pskreporter WHERE hash = ?");
my $q_insert = $dbh->prepare("INSERT INTO pskreporter (guid, hash, sender_callsign, receiver_callsign, sender_locator, receiver_locator, timestamp, mode, frequency, sender_lt, sender_ln, receiver_lt, receiver_ln) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

my $call = $ARGV[0];

my $w = new Ham::PSKReporter;
$w->init();
$w->set_sender_callsign($call);
print ">>> Querying for $call as sender...\n";
&query($w);
$w = new Ham::PSKReporter;
$w->init();
$w->set_receiver_callsign($call);
print ">>> Querying for $call as reporter...\n";
&query($w);


sub query
{
	my ($w) = @_;
	print "Querying pskreporter.info... ";
	$w->retrieve_data();
	print "[32;1mok[0m\n";

	my $m = new Ham::Locator;
	my $count = 0;
	my $added = 0;
	my $skipped = 0;
	my $errored = 0;

	print "Processing... ";

	while (my ($key, $value) = each(%{$w->get_spots->{spot}}))
	{
		$count++;
		#print "Processing spot $key (spot of ".$value->{sender_callsign}." by ".$value->{receiver_callsign}.")...\n";

		# Check to see if it exists in the DB already
		$q_exist->execute($value->{hash});

		if($q_exist->rows ne 0)
		{
			#print "> entry exists, skipping...\n";
			$skipped++;
		}
		else
		{
			#print "> entry does not exist... inserting into database...";
			$m->set_loc($value->{sender_locator});
			my ($c_lt, $c_ln) = $m->loc2latlng;
			$m->set_loc($value->{receiver_locator});
			my ($s_lt, $s_ln) = $m->loc2latlng;
			$q_insert->execute($value->{id},
								$value->{hash},
								$value->{sender_callsign},
								$value->{receiver_callsign},
								$value->{sender_locator},
								$value->{receiver_locator},
								$value->{flow_start_seconds},
								$value->{mode},
								$value->{frequency},
								$c_lt,
								$c_ln,
								$s_lt,
								$s_ln);
			if($@)
			{
				#print $@."\n";
				$errored++;
			}
			else
			{
				#print "ok.\n";
				$added++;
			}
		}
	}
	print "[32;1mok[0m\n";

	print "Completed: [32;1m$added added[0m, [33;1m$skipped skipped[0m, [31;1m$errored errored[0m - [36;1m$count total[0m\n";
}


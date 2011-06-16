#!/usr/bin/perl

package Ham::PSKReporter;

use strict;
use warnings;
use Ham::PSKReporter;
use Ham::PSKReporter::Spot;

our $VERSION = '0.001';

use base qw(Class::Accessor);
use Carp qw(cluck croak confess);
use Data::Dumper;
use LWP::Simple;
use XML::Simple;
use Class::Date qw(:errors date localdate gmdate now -DateParse -EnvC);
use namespace::clean;

__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors( qw(spots sender_callsign receiver_callsign lwp request_uri) );
__PACKAGE__->mk_ro_accessors( qw(spots xml_spots) );

our $pskreporter_url_base = "http://retrieve.pskreporter.info/query?";

sub init
{
	my ($self) = @_;

	$self->_init_lwp();

	# Set some default options
	$self->set_sender_callsign("");
	$self->set_receiver_callsign("");

	if($@)
	{
		return 1;
	} else {
		return 0;
	}
}
	
sub _build_request_uri
{
	my ($self) = @_;

	my $uri = $pskreporter_url_base."?rronly=1&";
	$uri .= "senderCallsign=".$self->get_sender_callsign;
	$uri .= "&receiverCallsign=".$self->get_receiver_callsign;

	$self->set_request_uri($uri);

	return 1;
}

sub _init_lwp
{
	my ($self) = @_;

	# Initiate a new LWP::UserAgent object and store it within the parent object
	my $ua = LWP::UserAgent->new();
	$ua->default_header('Accept-Encoding' => 'gzip');
	$ua->agent('Ham::PSKReporter/'.$VERSION);
	$self->set_lwp($ua);

	# Return false if we have any problems, otherwise return true
	if($@)
	{
		return 0;
	} else {
		return 1;
	}
}

sub retrieve_data
{
	my ($self) = @_;

	# Build the request URI
	$self->_build_request_uri;

	my $req = HTTP::Request->new(GET => $self->get_request_uri());
#	$req->header('Accept' => 'text/html');

	my $res = $self->get_lwp->request($req);

	if($res->is_success)
	{
		$self->_parse_content($res->decoded_content());
	}
	else
	{
		print "Error requesting ".$self->get_request_uri().": ".$res->status_line."\n";
		print Dumper($res);
	}
}

sub _parse_content
{
	my ($self, $content) = @_;

	my $x = XMLin($content);

	# Loop through reception reports
	foreach my $r (@{$x->{'receptionReport'}})
	{
		my $spot = Ham::PSKReporter::Spot->new({'receiver_callsign' => $r->{'receiverCallsign'},
												'receiver_locator' => $r->{'receiverLocator'},
												'sender_callsign' => $r->{'senderCallsign'},
												'sender_locator' => $r->{'senderLocator'},
												'frequency' => $r->{'frequency'},
												'flow_start_seconds' => $r->{'flowStartSeconds'},
												'mode' => $r->{'mode'}});

		$spot->commit;
		$self->{spots}->{'spot'}{$spot->get_id} = $spot;
	}

	$self->{spots}->{'pskreporter-url'} = $self->get_request_uri();
	my $date = now;
	$self->{spots}->{'date'} = $date;
	my $xml = XML::Simple->new('RootName' => 'pskreporter-spots', 'XMLDecl' => 1, 'NoAttr' => 1);

	$self->{xml_spots} = $xml->XMLout($self->{spots});
}

1;

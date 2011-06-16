#!/usr/bin/perl

package Ham::PSKReporter::Spot;

use strict;
use warnings;

our $VERSION = '0.001';

use base qw(Class::Accessor);
use Carp qw(cluck croak confess);
use Data::Dumper;
use Data::GUID;
use Digest::MD5 qw(md5_hex);
use namespace::clean;

__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors( qw(sender_locator receiver_dxcc_code flow_start_seconds sender_callsign mode is_sender sender_eqsl_ag receiver_locator frequency receiver_dxcc receiver_callsign ) );
__PACKAGE__->mk_ro_accessors( qw(id hash) );

sub commit
{
	my ($self) = @_;

	# Generate GUID
	my $guid = Data::GUID->new;
	$self->{id} = $guid->as_string();

	# Calculate hash
	$self->{hash} = $self->calculate_hash($self->get_sender_callsign, $self->get_receiver_callsign, $self->get_flow_start_seconds, $self->get_frequency, $self->get_mode);

	if($@)
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

sub calculate_hash
{
	my ($self, $sender_callsign, $receiver_callsign, $flow_start_seconds, $frequency, $mode) = @_;

	if(!$frequency)
	{
		$frequency = 0;
	}

	if(!$receiver_callsign)
	{
		$receiver_callsign = "UNKNOWN";
	}

	my $hash_source = "$sender_callsign~$receiver_callsign~$flow_start_seconds~$frequency~$mode";
	my $hash = md5_hex($hash_source);

	return $hash;
}
	
1;

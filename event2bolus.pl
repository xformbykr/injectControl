#!/usr/bin/perl

# perl script to convert events to pumphistory

#  usage : perl convertEvents.pl DATESTRING <USER_EVENTS.json>
use strict;
use warnings;
use JSON qw( decode_json );

$/ = '';    # 

my $DATESTRING = $ARGV[0];
my $infile = $ARGV[1];
open(INFILE, $infile);

my $json = <INFILE>;
close INFILE; 

my $decoded = decode_json($json);

my @filtered = grep { $_->{'display_time'} =~ /$DATESTRING/ &&
	$_->{'event_type'} =~ /INSULIN/ } @{$decoded} ;

my @rev_filtered = reverse @filtered;

if ( scalar @filtered > 1 ) { print "[\n"; }

while( scalar @filtered > 0 ) 
{
    my $event = shift (@filtered);
    unless ( $event->{'display_time'} =~ /$DATESTRING/ ) { next; }
    if ( $event->{'event_type'} =~ /INSULIN/ )
	{
    		print "  {\n";
		print "\t\"_type\": ","\"Bolus\",\n";
		print "\t\"timestamp\":  ","\"$event->{'display_time'}\",\n";
		print "\t\"amount\": ","$event->{'event_value'},\n";
		print "\t\"duration\": ","0,\n";
		print "\t\"type\": ","\"normal\"\n";
    		print "  }";
    		if ( @filtered ) { print ",\n"; }
    		else { print "\n"; }
	}

}

if ( scalar @rev_filtered > 1 ) { print "]\n"; }




### end of script
###

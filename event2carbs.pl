#!/usr/bin/perl

# perl script to convert events to carbs history

#  usage : perl event2carbs.pl DATESTRING <USER_EVENTS.json>
use strict;
use warnings;
use JSON qw( decode_json );

$/ = '';    # input record separate
#print "$json\n";

my $DATESTRING = $ARGV[0];
my $infile = $ARGV[1];
open(INFILE, $infile);

my $json = <INFILE>;
close INFILE; 

my $decoded = decode_json($json);

if (0==1) {
	print "Number of items: ";
	print scalar @{$decoded};
	print "\n";
}

my @filtered = grep { $_->{'display_time'} =~ /$DATESTRING/ &&
	$_->{'event_type'} =~ /CARBS/ } @{$decoded} ;

my @rev_filtered = reverse @filtered;

if ( scalar @filtered > 1 ) { print "[\n"; }

while( scalar @filtered > 0 ) 
{
    my $event = shift (@filtered);
    unless ( $event->{'display_time'} =~ /$DATESTRING/ ) { next; }
    if ( $event->{'event_type'} =~ /CARBS/ )
	{
    		print "  {\n";

		print "\t\"created_at\":  ","\"$event->{'display_time'}\",\n";
		print "\t\"carbs\": ","$event->{'event_value'}\n";

    		print "  }";
    		if ( @filtered ) { print ",\n"; }
    		else { print "\n"; }
	}

}

if ( scalar @rev_filtered > 1 ) { print "]\n"; }




### end of script
###

#!/usr/bin/perl

# perl script to convert glucose to openaps style json.

#  usage : perl convertGlucose.pl DATESTRING <GLUCOSE.json>
use strict;
use warnings;
use JSON qw( decode_json );
use Date::Manip::Base; 


$/ = '';    # null input record separator

my $DATESTRING = $ARGV[0];
my $infile = $ARGV[1];
open(INFILE, $infile);

my $json = <INFILE>;
close INFILE;
#print "$json\n";


my $decoded = decode_json($json);


if (0==1) {
    print "Number of items: ";
    print scalar @{$decoded};
    print "\n";
}
my @presort = grep { $_->{'display_time'} =~ /$DATESTRING/  } @{$decoded} ;
my @rev_presort = reverse @presort;

my @filtered = 
    reverse 
    sort { getseconds($a->{'display_time'}) <=> getseconds($b->{'display_time'}) }
         @presort;

if ( scalar @filtered > 1 ) { print "[\n"; }

while( scalar @filtered > 0 ) 
{
    my $event = shift (@filtered);
    print "  {\n";
    print "\t\"trend_arrow\": ", "\"$event->{'trend_arrow'}\"";
    print ",\n";
    print "\t\"system_time\":  ","\"$event->{'system_time'}\"";
    print ",\n";
    print "\t\"dateString\":  ","\"$event->{'display_time'}\"";
    print ",\n";
    print "\t\"glucose\":  ","$event->{'glucose'}";
    print "\n  }";
    if ( @filtered ) { print ",\n"; }
    else { print "\n"; }
}

if ( scalar @rev_presort > 1 ) { print "]\n"; }


sub getseconds {
    my $string = shift;
    $string        =~ s/^.*T//;
    my ($hrs, $mins, $secs) = split(':', $string);
    my $seconds = 3600*$hrs + 60*$mins + $secs;
    $seconds;
}


### end of script
###

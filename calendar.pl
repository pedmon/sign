#!/usr/bin/perl
#This code will parse and iCal file and produce what events are happening today.  It will then copy them to a html file#
#Modules#
use strict;
use warnings;
use iCal::Parser;
use Data::Dumper;

#First we need to open up our file handles#
open (infile, '<example.html');
open (outfile, '>example-new.html');

#We are now going to copy the old file into the new file#
#This variable stores where the beginning of the editable section is#
my $beginaside="<!--Begin-->\n";
my $currentline="";

while ($currentline ne $beginaside) {
	$currentline = <infile>;
	print outfile $currentline;
	}

#Now that we have found the section we wish to edit we will now construct our calendar#

#Get the Current Date#
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);

#Variable for New Month and Day
my $newmon;
my $newmday;

#Adds one to the current month as localtime runs from 0-11#

$mon=$mon+1;

#This variable will store the month with a 0 prefix if needed
my $month;

$month=$mon;

#Pads the day and month with zeros if needed#

if ($mday < 10) {
	$mday="0$mday";
	}

if ($mon < 10) {
	$month="0$mon";
	} 

#Localtime provides years since 1900 so we need to correct for that#

$year=$year+1900;

#Puts together the startdate string needed by the parser#
my $startdate="$year$month$mday";

#Adds a day to calculate the enddate#
$newmday = $mday+1;

#Pads the day with zeroes#
if ($newmday < 10) {
	$newmday="0$newmday";
	}

#Detects if day is at the end of the month and wraps around if it is#
if (($newmday == 32) && (($mon == 1) || ($mon == 3) || ($mon == 5) || ($mon == 7) || ($mon == 8) || ($mon == 10))) {
	$newmon=$mon+1;
	$month=$newmon;
	$newmday="01";

	if ($newmon < 10) {
		$month="0$newmon";
		} 
	}
elsif (($newmday == 31) && (($mon == 4) || ($mon == 6) || ($mon == 9) || ($mon == 11))) {
	$newmon=$mon+1;
	$month=$newmon;
	$newmday="01";

	if ($newmon < 10) {
		$month="0$newmon";
		} 
	}
elsif (($mon == 2) && ($newmday == 29)) {
	$newmon=$mon+1;
	$month=$newmon;
	$newmday="01";

	if ($newmon < 10) {
		$month="0$newmon";
		} 
	}
elsif (($newmday == 32) && ($mon == 12)) {
	$newmon="1";
	$month="01";
	$newmday="01";
	$year=$year+1;
	}

#Caculates the enddate string needed by the parser#
my $enddate="$year$month$newmday";

#Gets rid of the padding for the day because we don't need it anymore.
$mday=$mday+0;

#print "$startdate \n";
#print "$enddate \n";

#print "$mon \n";
#print "$mday \n";

#Now that we have the date we will work on the calendars that need to be parsed.#
#However first we will write our header for the section to the outfile#
#We will start with todays events#
print outfile "<h1>Today's Events</h1>\n";

#We will start with the Regular Calendar
#Name of the calendar file to be read in and parsed#
my $calen="calendar.ics";

#Now we will parse it#
my $ical_parser=iCal::Parser->new('start' => $startdate, 'end' => $enddate);
my $ical=$ical_parser->parse($calen);

#print Dumper($ical->{events}{$year}{$mon}{$mday});

#print keys %{$ical->{'events'}{$year}{$mon}{$mday}};

#print "\n";


#Will iterate through the events for the day and print different facts about them.
my $temp;
my $title;
my $location;
my $starttime;
my $starthr;
my $startmin;
my $endtime;
my $endhr;
my $endmin;
my $ampm;

for $temp ( keys %{$ical->{'events'}{$year}{$mon}{$mday}}) {
#	print keys %{$ical->{'events'}{$year}{$mon}{$mday}{$temp}};
#	print "\n";
	$title=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'SUMMARY'};
	$location=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'LOCATION'};
	$starthr=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'DTSTART'}{'local_c'}{'hour'};
	$startmin=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'DTSTART'}{'local_c'}{'minute'};

	#Removes back slashes if they appear.#
	$title =~ s%(?<!<)\\%%g;

	#Converts 24 hr time to 12 hr time#
	$ampm="am";

	if ($starthr == 12) {
		$ampm="pm";
		}

	if ($starthr > 12) {
		$starthr=$starthr-12;
		$ampm="pm";
		}

	if ($starthr == 0) {
		$starthr=12;
		}

	if ($startmin == 0) {
		$startmin="00";
		}

	$starttime="$starthr:$startmin$ampm";

	$endhr=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'DTEND'}{'local_c'}{'hour'};
	$endmin=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'DTEND'}{'local_c'}{'minute'};

	#Converts 24 hr time to 12 hr time#
	$ampm="am";

	if ($endhr == 12) {
		$ampm="pm";
		}

	if ($endhr > 12) {
		$endhr=$endhr-12;
		$ampm="pm";
		}

	if ($endhr == 0) {
		$endhr=12;
		}

	if ($endmin == 0) {
		$endmin="00"
		}

	$endtime="$endhr:$endmin$ampm";
#	print "$title\n";
#	print "$location\n";
#	print "$starttime-$endtime\n";

	print outfile "<h2>$title</h2>\n";
	print outfile "<h3>$starttime-$endtime<h3>\n";
	print outfile "<h3>$location<h3>\n";
	print outfile "<br>\n";
	}

#-----------------------------------------------------------------#

#Next Calendar2#
#Yes I should have made this into a subroutine but I don't feel like learning how to do that in Perl right now.  So off to good old fashioned copy and paste.#
#Name of the calendar file to be read in and parsed#
$calen="calendar2.ics";

#Now we will parse it#
$ical_parser=iCal::Parser->new('start' => $startdate, 'end' => $enddate);
$ical=$ical_parser->parse($calen);

#print Dumper($ical->{events}{$year}{$mon}{$mday});

#print keys %{$ical->{'events'}{$year}{$mon}{$mday}};

#print "\n";


#Will iterate through the events for the day and print different facts about them.

for $temp ( keys %{$ical->{'events'}{$year}{$mon}{$mday}}) {
#	print keys %{$ical->{'events'}{$year}{$mon}{$mday}{$temp}};
#	print "\n";
	$title=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'SUMMARY'};
	$location=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'LOCATION'};
	$starthr=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'DTSTART'}{'local_c'}{'hour'};
	$startmin=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'DTSTART'}{'local_c'}{'minute'};

	#Removes back slashes if they appear.#
	$title =~ s%(?<!<)\\%%g;	

	#Converts 24 hr time to 12 hr time#
	$ampm="am";

	if ($starthr == 12) {
		$ampm="pm";
		}

	if ($starthr > 12) {
		$starthr=$starthr-12;
		$ampm="pm";
		}

	if ($starthr == 0) {
		$starthr=12;
		}

	if ($startmin == 0) {
		$startmin="00";
		}

	$starttime="$starthr:$startmin$ampm";

	$endhr=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'DTEND'}{'local_c'}{'hour'};
	$endmin=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'DTEND'}{'local_c'}{'minute'};

	#Converts 24 hr time to 12 hr time#
	$ampm="am";

	if ($endhr == 12) {
		$ampm="pm";
		}

	if ($endhr > 12) {
		$endhr=$endhr-12;
		$ampm="pm";
		}

	if ($endhr == 0) {
		$endhr=12;
		}

	if ($endmin == 0) {
		$endmin="00"
		}

	$endtime="$endhr:$endmin$ampm";
#	print "$title\n";
#	print "$location\n";
#	print "$starttime-$endtime\n";

	print outfile "<h2>$title</h2>\n";
	print outfile "<h3>$starttime-$endtime<h3>\n";
	print outfile "<h3>$location<h3>\n";
	print outfile "<br>\n";
	}

#----------------------------------------------------------------------------------------------#

#Next we will print out the visitors for today#
print outfile "<br><br><br>\n";
print outfile "<h1>Visitors</h1>\n";

#Name of the calendar file to be read in and parsed#
$calen="visitor.ics";

#Now we will parse it#
$ical_parser=iCal::Parser->new('start' => $startdate, 'end' => $enddate);
$ical=$ical_parser->parse($calen);

#print Dumper($ical->{events}{$year}{$mon}{$mday});

#print keys %{$ical->{'events'}{$year}{$mon}{$mday}};

#print "\n";

#Will iterate through the events for the day and print different facts about them.

for $temp ( keys %{$ical->{'events'}{$year}{$mon}{$mday}}) {
	#print keys %{$ical->{'events'}{$year}{$mon}{$mday}{$temp}};
	#print "\n";
	$title=$ical->{'events'}{$year}{$mon}{$mday}{$temp}{'SUMMARY'};

	#print "$title\n";

	#Removes the "Visiting: "header from the string#
	$title = substr($title, 10);

	#Removes back slashes if they appear.#
	$title =~ s%(?<!<)\\%%g;

	print outfile "<h2>$title</h2>\n";
	}

#Now that we have completed this section we need to have the infile catch up#
my $endaside="<!--End-->\n";
while ($currentline ne $endaside) {
	$currentline = <infile>;
	}

#Now we will print the final line of the modified section and copy the rest of the file#
print outfile $currentline;

my $endoffile="</html>\n";
while ($currentline ne $endoffile) {
	$currentline = <infile>;
	print outfile $currentline;
	}

#Closes the file handles#
close(infile);
close (outfile);

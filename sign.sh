#!/bin/bash
#This script updates the webpage which runs the digital signage#

#We need to grab the calendars that we will need to generate the new page#
#Calendar 1
wget --no-check-certificate https://www.google.com/calendar/ical/example.calendar/public/basic.ics

mv basic.ics calendar.ics

#Calendar 2
wget --no-check-certificate https://www.google.com/calendar/ical/example.calendar2/public/basic.ics

mv basic.ics calendar2.ics

#Visitor Schedule#
wget --no-check-certificate https://www.google.com/calendar/ical/vistor.calendar/public/basic.ics

mv basic.ics visitor.ics

#Now we will run the script which parses the calendars and inserts them into the webpage.#
perl ./calendar.pl

mv example-new.html example.html



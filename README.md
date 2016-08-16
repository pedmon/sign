# Sign

This series of scripts sets up digital signage that can pull calendar information from iCal formats, specifically from Google Calendars.  The sign itself is simply a webpage with a looping series of videos.

## Usage

This is basically a poor man's attempt at digital signage.  May not be pretty but it gets the job done.  Essentially the two scripts here update the webpage which then is the actual sign.

The first script is sign.sh which pulls down the calendars that you need to update the webpage.  In this case it is Google but it could be any .ics format calendars.

The second script is calendar.pl.  This script parses the calendars and pulls out the relevant events for the day.  It then prints those to the webpage.

The entire show is based on the example.html and relevant style sheets.  All the scripts simply edit this file and display it.  The design of the html file is fairly straight forward.  First there is a line which refreshes the page every hour.  This makes sure that the page has the latest version. There are two sets of Javascripts at the beginning.  The first runs the movie playlist.  To add a movie simply deposit it in OGV Theora format in the movies directory.  Then add the path to the playlist.  The second, one line, script gets rid of the browser scrollbar.  The body of the html file is all in HTML5.  The PERL script which runs the calendar only touches the portion of the file between the Begin and End comments.  The other sections run the footer and the movie.  All the styles are handled in the style.css sheet.   If you make any changes to the HTML file be sure to make a backup copy.  That way if the scripts mess up for some reason there is a clean copy around.

All you need to do is run sign.sh as a cron and have your favorite web browser up in full screen mode and you have yourself a simple digital sign.

## Support and Disclaimer
I don't provide any support for this.  This code is use at your own risk.  You are welcome to use or contribute to this if you want.

# Meetup_MineR
An algorithm to mine www.meetup.com to identify best activity groups to attend in a city.

# What is the problem?
[Meetup.com](https://www.meetup.com/) is fantastic way to meet new people and do fun activities. However, identifying the correct meetup groups can be a challenge. Some meetup groups are older and inactive whereas others just do not have enough people attending them. 

This R script fetches upcoming meetup events from trending groups in a user-specified location and exports the list as weekly files. Since many meetup groups have low attendees, the script also exports an additional filtered version of the data showing only events with at least X number (user-specified threshhold) attendees. After running this script for a few months, I analysed the data to identify the best meetup groups in a location, ie the meetups with frequent events and decent amount of attendees.

# Minimal working example

1. This script requires access to meetup's API. You can get your key by registering at https://secure.meetup.com/meetup_api/key/. Store your key in the **apikey** variable.

2. Location information. The script indirectly passes location information as GET request. For example, the bit corresponding to Boulder, Colorado, USA is stored in the location variable (shown below). 
```r
location <- "country=us&city=boulder&state=co"
```
Setting the location information may require trial and error. You can also supply latitude and longitude as 'lat' and 'lon' in the above format. See https://www.meetup.com/meetup_api/docs/2/open_events/ for more information. 

If everything is correct, the script should print out a number corresponding to the number of upcoming events.

3. Filter and export data. The rest of script is straightforward. It will export two files for each week in [/upcoming_events](/upcoming_events) folder: all events and filtered events. I uploaded the exported files for Boulder as an example. 

4. Analysis of meetups: What are the best meetups to attend in Boulder? 







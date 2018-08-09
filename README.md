# Meetup_MineR
An algorithm to mine www.meetup.com to identify best activity groups to attend in a city.

# What is the problem?
[Meetup.com](https://www.meetup.com/) is fantastic way to meet new people and do fun activities. However, identifying the right meetup groups can be a challenge. Some groups are older and inactive whereas others just do not have enough people attending them. 

This R script fetches upcoming meetup events from trending groups in a user-specified location and exports the list as weekly files. Since many meetup groups have low attendees, the script also exports an additional filtered version of the data showing only events with at least X number (user-specified threshhold) attendees. After running this script for a few months, I analysed the data to identify the best meetup groups in a location, ie the meetups with frequent events and decent amount of attendees.

# Minimal working example
## 1. Get API key from meetup.com
This script requires access to meetup's API. You can get your key by registering at https://secure.meetup.com/meetup_api/key/.


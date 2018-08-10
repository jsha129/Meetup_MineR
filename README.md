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

# Analysis of meetups: What are the best meetups to attend in Boulder? 
The script was run almost weekly to collect data from November 2017 to August 2018; however, there are some weeks where the data was not collected.

## Which day is better to attend a meetup event in Boulder?
I empirically noticed that Sundays have lowest number of meetups. Here, I plotted the number of attendees/RSVP versus each day of the week to see how it varies in a week. 
!(/best_day.png)

In addition, I used one-way ANOVA to see if any changes observed are statistically significant. Code snippet below. 
```r
print("Using One way ANOVA to see if a specific day in a week has more attendees than rest")
fit <- aov(RSVP ~ WeekDay, df)
summary(fit)
stat <- as.data.frame(TukeyHSD(fit)[[1]])
print(stat[stat$`p adj` < 0.05, ])
```
Outcome
```r
                        diff       lwr       upr        p adj
Wednesday-Sunday    4.401224  2.279118  6.523329 4.409442e-08
Wednesday-Saturday  3.759404  1.920911  5.597897 5.936262e-08
Wednesday-Friday    4.357021  2.209332  6.504711 7.185972e-08
Wednesday-Thursday  3.973141  2.061353  5.884928 4.246177e-08
Tuesday-Wednesday  -3.500400 -5.327718 -1.673081 3.800073e-07
Monday-Wednesday   -3.433965 -5.215838 -1.652093 3.159554e-07
```


## Best meetups
Meetup groups with highest number of events and attendees (top 25% for both criteria) were deemed as the 'best' ([Boulder_meetup_analysis.R](/Boulder_meetup_analysis.R)).
![](/best_meetups.png)







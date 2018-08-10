rm(list = ls())
loadPackages <- function(x){
  for( i in x ){
    #  require returns TRUE invisibly if it was able to load package
    if( ! require( i , character.only = TRUE ) ){
      #  If package was not able to be loaded then re-install
      install.packages( i , dependencies = TRUE )
      #  Load package after installing
      require( i , character.only = TRUE )
    }
  }
}
Sys.setenv(TZ = "America/Denver")
msToDate <- function(tempTime){
  timeFormat <- "MST"
  temp <- strptime(as.POSIXct(tempTime/1000,
                             origin ="1970-01-01"),
                  format="%Y-%m-%d",tz = timeFormat)
  return(as.character(temp))
}

loadPackages( c("purrr", "readxl", "dplyr" ))
path <- paste0(getwd(),"/upcoming_events", sep = "")
files <- list.files(path = path)
files <- files[grep("Boulder_all_events_unfiltered2", files)]
files <- files[grep(".txt", files)]

df <- read.delim(paste0(path, "/",files[1]))

for(i in 2:length(files)){
  # print(files[i])
  df <- rbind(df, read.delim(paste0(path, "/",files[i])))
}
df <- subset(df, GroupName !="")
df$Date <- msToDate(df$Date_ms)
df[,"UniqueID"] <-  paste(as.character(df[,"GroupName"]), as.character(df[,"Date"]), sep ="_")
df <- distinct(df, UniqueID, .keep_all = T)

# - Begin analysis
## which day of a wekk has meetups with most RSVP
weekDays <- c("Monday", "Tuesday", "Wednesday","Thursday","Friday",
              "Saturday", "Sunday")
weekDays <- sapply(0:6, function(i){return(weekDays[7-i])})

df[,"WeekDay"] <- weekdays(as.Date(df$Date))
df$WeekDay <- factor(df$WeekDay, 
                     levels = weekDays)
png("best_day.png")
par(mar = c(4,6,3,1))
boxplot(RSVP ~ WeekDay, df, horizontal = T, las = 2, col ="grey80",
        main = "Which day has meetups with most attendees?",
        cex.main = 1.2,
        xlab ="Number of attendees")
dev.off()

## which meetup group has high events and RSVPs
unique.groups <- as.data.frame(t(table(df$GroupName)))[,2:3]
colnames(unique.groups) <- c("GroupName", "Total_Events")

group.median <- as.data.frame(tapply(df$RSVP, df$GroupName, median))
group.median[,"GroupName"] <- rownames(group.median)
colnames(group.median)[1] <- "Median_RSVPs"
df2 <- merge(unique.groups, group.median)

df2.subset <- subset(df2, Total_Events >= quantile(df2$Total_Events, 0.75, na.rm = T) & 
                       Median_RSVPs >= quantile(df2$Median_RSVPs, 0.75, na.rm = T)) 


df2.subset <- df2.subset[order(df2.subset$Median_RSVPs, decreasing = F),]
par(mar = c(4,20,1,1))
p <- barplot(df2.subset$Median_RSVPs, horiz = T,
             xlim = c(0,max(df2.subset$Median_RSVPs)+10),
             cex.names = 1, las = 2,
             xlab = "Median RSVP (number of events on the rightside of the bars)",
             col = rev(gray.colors(max(df2.subset$Total_Events)))[df2.subset$Total_Events])
axis(2, at = p, labels = NA)
text(y = p, x =  df2.subset$Median_RSVPs + 2, 
     labels = df2.subset$Total_Events)


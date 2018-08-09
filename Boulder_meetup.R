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

#  Then try/install packages...
loadPackages( c("rjson" , "R.utils" , "purrr", "dplyr" ))
Sys.setenv(TZ = "America/Denver")
location <- "country=us&city=boulder&state=co"# in the query format 

setwd(paste0(getwd(),"/upcoming_events"))
apikey <- "" # Registrer 
output <- paste0(substr(Sys.time(),1,10), "_Boulder")
startTime <- paste(round(currentTimeMillis.System()),"1w", sep=",") #1week from start or 1m
thr <- 15 # minimum number of RSVPs in meetups

timeFormat <- "MST" # for Denver/Boulder, USA

msToDate <- function(tempTime){
  return(as.character(as.POSIXct(tempTime/1000,
                                 tz=timeFormat, 
                                 origin ="1970-01-01")))
}


q.my.events <- paste0("&sign=true&photo-host=public&", location,"&time=")
url <- paste0("https://api.meetup.com/2/open_events?",q.my.events,
              startTime,"&page=200&order=trending&desc=true&radius=10&api&key=",apikey) # searches meetups within 10 miles of the location
raw.data <- readLines(url, warn="F")
rd  <- fromJSON(raw.data)[[1]]
length(rd)

times <- msToDate(map_dbl(rd,"time"))
df <- data.frame(EventName = map_chr(rd, "name"), 
                 GroupName = map_chr(rd,c("group","name")),
                 RSVP = map_dbl(rd, "yes_rsvp_count"),
                 Date_ms= map_dbl(rd,"time") ,
                 Date = strftime (times, format = "%Y-%m-%d",tz=timeFormat),
                 Time= strftime (times, format = "%r",tz=timeFormat),
                 Fees = map(rd, c("fee", "amount")) %>% as.character,
                 Location = map(rd, c("venue", "name")) %>% as.character,
                 Address = map(rd, c("venue", "address_1")) %>% as.character,
                 Desp = map(rd, "description") %>% as.character, 
                 url = map(rd, "event_url") %>% as.character)
df <- df[order(df$Date_ms),]
df <- df[, which(colnames(df) != "Desp")]
write.table(df,file=paste0(output,"_all_events_unfiltered2.txt"), row.names = F, sep ="\t")
df <- subset(df, RSVP >= thr)
df <- df[order(df$RSVP, decreasing  = T),]
write.table(df,file=paste0(output,"_all_events_filtered2.txt"), row.names = F, sep ="\t")



# 1st: Keywords
# Stream keywords used to filter tweets
# q <- paste0("hillaryclinton,imwithher,realdonaldtrump,maga,electionday")
# Stream US geolocated tweets
# q <- c(-125,26,-65,49)
# Stream random stream
q <-  ""

# 2nd: Time between each file
# minutes * 60 seconds
streamtime <- 60

# 3rd: Where to save the files
# Location
location <- "~/twitter-sample/data/" 

# 4th: Stop time
# stopTime
stopTime <- "2017-10-18 16:06:00 EDT"

## ------------------------------------------------------------------------

## Name of dedicated rtweet data directory
rtweet.folder <- path.expand(location)

## Create dedicated rtweet data directory
if (!dir.exists(rtweet.folder)) {
  dir.create(rtweet.folder)
}

# Execute

while(Sys.time() < stopTime){
  # get a time stamp of the time
  time <- gsub("[: -]", "" , Sys.time(), perl=TRUE)
  # write a file with that time stamp
  file <- paste0(location,time,".json")
  # run stream tweets for the next streamtime seconds
  rtweet::stream_tweets(q = q, parse = FALSE, timeout = streamtime, file_name = file)
}

## parse ------------------------------------------------------------------

files <- list.files(rtweet.folder)

# initialize with first file
t <- parse_stream(paste0(location,files[1])) 

# run through all files (excluding the first)
for (i in files[-1]){
  temp <- parse_stream(paste0(location,i)) 
  # add new file to the total dataset
  t <- rbind(t,temp)
}




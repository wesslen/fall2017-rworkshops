## Stream keywords used to filter tweets
q <- c("#metoo")
## Stream US geolocated tweets
# q <- c(-125,26,-65,49)
## Stream random stream
# q <-  ""

## Stream time in seconds so for one minute set timeout = 60
## For larger chunks of time, I recommend multiplying 60 by the number
## of desired minutes. This method scales up to hours as well
## (x * 60 = x mins, x * 60 * 60 = x hours)
## Stream for 1 minute
streamtime <- 1 * 60

## Filename to save json data (backup)
file <- "~/Downloads/sample-tweets.json"

rtweet::stream_tweets(q = q, parse = FALSE, timeout = 60, file_name = file)

t <- parse_stream(file)

## Parse from json file
rt <- parse_stream(filename)

## Preview tweets data
head(rt$text)

## Preview users data
userLevel <- users_data(rt)

ts_plot(rt, by = "secs")

## run tidy text analysis ------------------------------------------------
# see http://tidytextmining.com/tfidf.html

library(tidytext); library(tidyverse)
data("stop_words")
extraStop <- c("https","amp","t.co")

wordCounts <- t %>% # take dataframe
  unnest_tokens(word, text) %>% # tokenize 
  anti_join(stop_words) %>% # remove stop words
  count(word, sort = TRUE) %>% # count by word
  filter(!(word %in% extraStop))  # remove extra stop words

top <- 50
cnt <- nrow(wordCounts)

wordCounts %>%
  arrange(desc(n)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  head(n=top) %>%
  ggplot(aes(x = as.factor(word), y = n/cnt)) +
  geom_bar(stat="identity") + coord_flip() +
  labs(title = "Top Words", x = "Word", y = "Word Frequency per Tweet")
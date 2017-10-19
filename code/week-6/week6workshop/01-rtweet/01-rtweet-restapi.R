
##http://rtweet.info/articles/auth.html

## install from CRAN (uncomment out)
# install.packages("rtweet")

# load rtweet & tidyverse
library(rtweet); library(tidyverse)

## authorization ---------------------------

## name assigned to created app
appname <- "rtweet_token"
## api key (example below is not a real key)
key <- "xxx"
## api secret (example below is not a real key)
secret <- "yyy"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)

## path of home directory
home_directory <- path.expand("~/credentials")

## combine with name for token
file_name <- file.path(home_directory, "twitter_token_rtweet.rds")

## save token to home directory
saveRDS(twitter_token, file = file_name)

## env variable: optional (very helpful)
## see instructions
# create text file (.Renviron) in home directory... set as TWITTER_PAT=/Users/mwk/twitter_token.rds

## then run once
#cat(paste0("TWITTER_PAT=", file_name),
#    file = file.path(home_directory, ".Renviron"),
#    append = TRUE)

# twitter_token <- readRDS("~/apicredentials/twitter_token.rds")

## rate limit
rate_limit(twitter_token)

## user stream --------------------------------

## return 3200 tweets from @realDonaldTrump timeline
trump <- get_timeline("realDonaldTrump", n = 3200)
head(trump)

## extract Trump's user data
userTrump <- users_data(trump)
head(userTrump)

## dplyr + ggplot
trump %>%
  mutate(Date = as.Date(trump$created_at)) %>%
  count(Date) %>%
  ggplot(aes(x = Date, y = n)) +
  geom_line() +
  geom_smooth(span = 0.1) + 
  labs(x = "Day", y = "Number of Tweets", title = "@realDonaldTrump Tweets")

# search for 500 users using "#kek" as a keyword
usersKek <- search_users("#kek", n = 500) %>%
  arrange(desc(followers_count))

head(usersKek$description)

# extract most recent tweets data 
tweetKek <- tweets_data(usersKek)

## lookup users by screen_name or user_id
users <- strsplit(trump$mentions_screen_name," ") %>%
  unlist() %>%
  tibble(screen_name = .) %>%
  filter(screen_name != "NA") %>%
  unique() 

famous_tweeters <- lookup_users(users$screen_name[1:50])

famous_tweeters %>%
  arrange(desc(followers_count)) %>%
  ggplot(aes(x = screen_name, y = followers_count)) +
  geom_point() +
  coord_flip()

# extract most recent tweets data from the famous tweeters
tweets_data(famous_tweeters)

## or get user IDs of people following stephen colbert
colbert_nation <- get_followers("stephenathome", n = 18000)

## get even more by using the next_cursor function
page <- next_cursor(colbert_nation)

## use the page object to continue where you left off
colbert_nation_ii <- get_followers("stephenathome", n = 18000, page = page)
colbert_nation <- c(unlist(colbert_nation), unlist(colbert_nation_ii))

## and then lookup data on those users (if hit rate limit, run as two parts)
colbert_nation <- lookup_users(colbert_nation)
colbert_nation

## or get user IDs of people followed *by* President Obama
obama1 <- get_friends("BarackObama")
obama2 <- get_friends("BarackObama", page = next_cursor(obama1))

## and lookup data on Obama's friends
lookup_users(c(unlist(obama1), unlist(obama2)))


## keyword stream -----------------------------

tweets <- search_tweets("beer+wine", n=100)

# two terms: one positive (includes), one negative (excludes)
tweets <- search_tweets("trump -donald", n=100)

# two terms: OR
tweets <- search_tweets("hat OR cat", n=100)

# more advanced keywords
q <- "(happy OR party) (holiday OR house) -(birthday OR democratic OR republican)"
tweets <- search_tweets(q, n=100)

# only tweets to a person
tweets <- search_tweets("to:realDonaldTrump", n=100)

# tweets from a person
tweets <- search_tweets("from:realDonaldTrump", n=100)

# language
tweets <- search_tweets("beer+wine", n=100, lang="en")

## retrieving trends --------------------------

## get trending hashtags, mentions, and topics worldwide
prestige_worldwide <- get_trends()
prestige_worldwide

## or narrow down to a particular country
usa_usa_usa <- get_trends("United States")
usa_usa_usa

## or narrow down to a popular city
trendsAvailable <- trends_available(token = twitter_token)
clt <- get_trends(woeid = 2378426)
clt


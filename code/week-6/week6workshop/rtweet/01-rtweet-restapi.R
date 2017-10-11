
library(rtweet)
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
home_directory <- path.expand("./")

## combine with name for token
file_name <- file.path(home_directory, "twitter_token_rtweet.rds")

## save token to home directory
saveRDS(twitter_token, file = file_name)

## rate limit
rate_limit(twitter_token)

## return 3200 tweets from @KyloR3n's timeline
oreilly <- get_timeline("billoreilly", n = 3200)
head(oreilly)

## extract emo kylo ren's user data
t2 <- users_data(oreilly)

max_id <- FoxNews$status_id[200]
foxNews <- get_timeline("FoxNews", max_id = max_id, n = 3200)

## search

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

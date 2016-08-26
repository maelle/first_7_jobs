library("rtweet")
library("dplyr")
first7jobs <- search_tweets(q = "#firstsevenjobs", n = 18000, type = "recent",
                            token = twitter_tokens[[1]])
first7jobs <- rbind(first7jobs,
                    search_tweets(q = "first7jobs", n = 18000, type = "recent",
                                  token = twitter_tokens[[1]]))
first7jobs <- unique(first7jobs)
first7jobs <- filter(first7jobs, lang == "en")
first7jobs <- dplyr::filter(first7jobs, is_retweet == FALSE)
save(first7jobs, file = "data/first7jobs.RData")

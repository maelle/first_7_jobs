library("monkeylearn")
library("dplyr")
load("data/parsed_first7jobs.RData")
request <- c(first7jobs_parsed$wordsgroup)
# classify with Job Roles Classifier
# https://app.monkeylearn.com/main/classifiers/cl_i7vMzUB7/
output <- monkeylearn_classify(request,
                               classifier_id = "cl_i7vMzUB7")
dim(output)
save(output, file = "data/output.RData")
# Output has same length as request, so here no need to join by MD5.

output_with_words <- bind_cols(output, first7jobs_parsed)

# filter high probabilities
output_with_words_high <- filter(output_with_words,
                                 probability > 0.75)

# arrange by probability
output_with_words_high <- arrange(output_with_words_high,
                                  desc(probability))

output_with_words_high %>% head() %>% knitr::kable()

# sum by label
summary_label <- output_with_words_high %>%
  group_by(label) %>%
  summarize(sum = n(),
            median_rank = median(rank),
            words = toString(sort(unique(wordsgroup)))) %>%
  arrange(desc(sum))


summary_label %>% knitr::kable()
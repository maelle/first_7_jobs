library("dplyr")
library("monkeylearn")
load("data/output.RData")
load("data/parsed_first7jobs.RData")


find_keywords <- function(df){
  output <- monkeylearn_extract(request = df$jobs,
                                extractor_id = "ex_y7BPYzNG",
                                params = list(max_keywords = 5))
}

# Output has same length as request, so here no need to join by MD5.

output_with_words <- bind_cols(output, first7jobs_parsed)

output_with_words <- output_with_words %>% 
  group_by(label) %>%
  summarize(jobs = toString(wordsgroup)) 

keywords <- output_with_words %>%
  purrr::by_row(find_keywords)

keywords <- keywords %>%
  tidyr::unnest(.out) %>%
  select(label, relevance, keyword, count)

readr::write_csv(keywords, path = "data/keywords_by_industry.csv")

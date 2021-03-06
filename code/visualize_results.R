library("dplyr")
library("tidyr")
library("ggplot2")
library("viridis")
load("data/output.RData")
load("data/parsed_first7jobs.RData")
# Output has same length as request, so here no need to join by MD5.

output_with_words <- bind_cols(output, first7jobs_parsed)


filter(output_with_words,
       probability > 0.5) %>%
  ggplot() +
  geom_bar(aes(label))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_viridis(discrete = TRUE)
ggsave(file = "figures/count_categories.png", width = 8, height = 6)

filter(output_with_words,
       probability > 0.5) %>%
ggplot() +
  geom_bar(aes(label, fill = as.factor(rank)),
           position = "fill")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_viridis(discrete = TRUE)
ggsave(file = "figures/rank_by_category.png", width = 8, height = 6)

# filter high probabilities
output_with_words_high <- filter(output_with_words,
                                 probability > 0.5)


# plot trajectories
# only for complete trajectories
output_with_words_high %>%
  group_by(status_id) %>%
  filter(n() == 7) %>%
  ungroup()  %>%
ggplot() +
  geom_tile(aes(rank, status_id, fill = label)) +
  scale_fill_viridis(discrete = TRUE) +
  theme(legend.position = "none")



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
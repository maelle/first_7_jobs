library("dplyr")
library("stringr")
load("data/first7jobs.RData")

separators <- c("\\?", "\\.", "\\!", "\\;",
                "\\,", "\\\n", "\\/", "[1-7]")


first7jobs_parsed <- first7jobs  %>%
  select(status_id, text) %>%
  group_by(status_id) %>%
  # count the potential separators
  mutate(no_interrogation = str_count(text, "\\?")) %>%
  mutate(no_point = str_count(text, "\\.")) %>%
  mutate(no_exclamation = str_count(text, "\\!")) %>%
  mutate(no_semicolumn = str_count(text, "\\;")) %>%
  mutate(no_comma = str_count(text, "\\,")) %>%
  mutate(no_newline = str_count(text, "\\\n")) %>%
  mutate(no_backslash = str_count(text, "\\/")) %>%
  mutate(no_number = str_count(text, "[1-7]")) %>% 
  mutate(separator = separators[order(c(no_interrogation,
                                        no_point,
                                        no_exclamation,
                                        no_semicolumn,
                                        no_comma,
                                        no_newline,
                                        no_backslash,
                                        no_number),
                                      decreasing = TRUE)[1]]) %>%
  # no numbers
  mutate(text = gsub("[1-9].", "", text)) %>%
  # no parenthesis
  mutate(text = gsub("[\\(\\)]", "", text)) %>%
  # no username
  mutate(text = gsub("\\@.*", "", text)) %>%
  # no RT part
  filter(!grepl("RT \\@", text)) %>%
  # don't keep the polluting hashtags#FirstSevenJobs
  filter(!grepl("\\#NameofFirstPet", text)) %>%
  mutate(text = gsub("\\#[Ff]irstobs", "", text)) %>%
  mutate(text = gsub("\\#[fF]irst[sS]even[jJ]obs:", "", text)) %>%
  mutate(text = gsub("\\#[fF]irst[sS]even[jJ]obs", "", text)) %>%
  mutate(text = gsub("\\#firstsevenjobs", "", text)) %>%
  mutate(text = gsub("\\#firstobs", "", text)) %>%
  filter(!grepl("\\#MothersMaidenName", text)) %>%
  filter(!grepl("\\#HighSchoolMascot", text)) %>%
  # no polluting sentence "Can we get these trending too"
  filter(!grepl("Can we get these trending too", text)) %>%
  # no hyphen
  mutate(text = gsub("-", " ", text)) %>%
  mutate(text = gsub("  ", " ", text)) %>%
  mutate(text = gsub("- ", "", text)) %>%
  # no empty
  filter(text != "") %>%
  filter(text != " ") %>%
  filter(text != "RT") %>%
  filter(text != "RT ") %>%
  # split by these in order to separate the jobs
  do(str_split(.$text, .$separator) %>%
       unlist %>% 
       data_frame(wordsgroup = .)) %>%
  # no empty
  filter(wordsgroup != "") %>%
  filter(wordsgroup != " ") %>%
  filter(wordsgroup != "RT") %>%
  filter(wordsgroup != "RT ") %>%
  mutate(rank = 1:n()) %>%
  # remove remaining new lines
  mutate(wordsgroup = gsub("\\\n","",wordsgroup)) %>%
  ungroup()


save(first7jobs_parsed, file = "data/parsed_first7jobs.RData")
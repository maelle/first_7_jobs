library("circlize")
library("dplyr")
load("data/output.RData")
load("data/parsed_first7jobs.RData")
png(filename="figures/circle.png",
    width = 1000, height = 1000)
# Output has same length as request, so here no need to join by MD5.

output_with_words <- bind_cols(output, first7jobs_parsed)
output_with_words <- mutate(output_with_words,
                            label = substr(label, 1, 11))
output_with_words_high <- filter(output_with_words,
                                 probability > 0.5)

# get data with from and to
count <- output_with_words_high %>%
  tibble::as_tibble() %>%
  select(status_id, label) %>%
  group_by(status_id) %>%
  mutate(category_from = lag(label)) %>%
  rename(category_to = label) %>%
  filter(!is.na(category_from)) %>%
  ungroup() %>%
  group_by(category_to, category_from) %>%
  filter(n() > 10)

df <- tibble::as_tibble(table(count$category_to, count$category_from))
df <- rename(df, src = Var1, target = Var2)


category = c(structure(df$src, names=df$src), 
          structure(df$target, names= df$target))
category = category[!duplicated(names(category))]
category = category[order(category, names(category))]
category_color = identity(viridis::viridis_pal(option = "plasma")(length(unique(c(df$src, df$target)))))


gap.degree = do.call("c", lapply(table(category), function(i) c(rep(2, i-1), 8)))
circos.par(gap.degree = gap.degree)

chordDiagram(df, order = names(category), grid.col = category_color,
             directional = 1, annotationTrack = "grid",
             preAllocateTracks = list(
               list(track.height = 0.02))
)

for(b in 1:length(category)) {
  highlight.sector(sector.index = category[b], track.index = 1, col = "white", 
                   text = category[b], 
                   facing = "bending.outside",
                   niceFacing = TRUE)
}

circos.clear()
dev.off()


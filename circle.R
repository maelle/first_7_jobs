library("circlize")
library("dplyr")
load("data/output.RData")
load("data/parsed_first7jobs.RData")
# Output has same length as request, so here no need to join by MD5.

output_with_words <- bind_cols(output, first7jobs_parsed)
output_with_words_high <- filter(output_with_words,
                                 probability > 0.5)

# get data with from and to
count <- output_with_words_high %>%
  tibble::as_tibble() %>%
  select(status_id, label) %>%
  group_by(status_id) %>%
  mutate(category_from = lag(label)) %>%
  rename(category_to = label) %>%
  filter(!is.na(category_from))

df <- tibble::as_tibble(table(count$category_to, count$category_from))
df <- rename(df, src = Var1, target = Var2)



brand = c(structure(df$src, names=df$src), 
          structure(df$target, names= df$target))
brand = brand[!duplicated(names(brand))]
brand = brand[order(brand, names(brand))]
brand_color = viridis::viridis_pal()(31)


gap.degree = do.call("c", lapply(table(brand), function(i) c(rep(2, i-1), 8)))
circos.par(gap.degree = gap.degree)

chordDiagram(df, order = names(brand), grid.col = brand_color,
             directional = 1, annotationTrack = "grid", preAllocateTracks = list(
               list(track.height = 0.02))
)


for(b in 1:length(brand)) {
  model = brand[b]
  highlight.sector(sector.index = model, track.index = 1, col = brand_color[b], 
                   text = b, text.vjust = -1, niceFacing = FALSE)
}

circos.clear()

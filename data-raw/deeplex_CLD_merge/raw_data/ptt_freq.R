library(dplyr)

ptt <- jsonlite::fromJSON("relative_freq_by_year_interval.json")
ptt2 <- bind_rows(ptt) %>% 
  bind_cols(lu = names(ptt)) %>%
  select(lu, everything()) %>%
  rename(pttFreq.all = all,
         pttFreq.2004_2009 = `2004-2009`,
         pttFreq.2010_2014 = `2010-2014`,
         pttFreq.2015_2019 = `2015-2019`)
saveRDS(ptt2, "pttFreq.rds")


# Check whether equal
out <- vector("numeric", length(ptt))
for (i in seq_along(ptt)) {
  out[i] = ptt[[i]][[1]]  
}

sum(dplyr::near(out, ptt2$all))

ptt2$all[1:5] == out[1:5]

library(dplyr)

###### Load RDS ######
deeplex <- readRDS("Data_summary/deeplex.rds")
cld <- readRDS("Data_summary/cld.rds")
cwn <- readRDS("Data_summary/cwn.rds")

###### Merge ######
trans <- ropencc::converter(ropencc::S2T)

# Left join: CLD as basis (search with simplified chinese)
cld_merged <- left_join(cld, deeplex, by = c("cld.Word" = "dl.lu_sim")) %>%
  left_join(cwn, by = c("cld.Word" = "cwn.lemma_sim")) %>%
  mutate(cld.Word_trad = ropencc::run_convert(trans, cld.Word)) %>%
  select(cld.Word_trad, cld.Word, everything(), -dl.lu, -cwn.lemma) %>%
  rename(lu_trad = cld.Word_trad,
         lu_simp = cld.Word)

# Left join: DeepLex as basis (search with traditional chinese)
deeplex_merged <- left_join(deeplex, cld, by = c("dl.lu_sim" = "cld.Word")) %>%
  left_join(cwn, by = c("dl.lu" = "cwn.lemma")) %>%
  select(dl.lu, dl.lu_sim, everything(), -cwn.lemma_sim) %>%
  rename(lu_trad = dl.lu,
         lu_simp = dl.lu_sim)


#saveRDS(merged_full, "cld_DL_merged_full.rds")
saveRDS(cld_merged, "cld_base_merged.rds")
saveRDS(deeplex_merged, "deeplex_base_merged.rds")


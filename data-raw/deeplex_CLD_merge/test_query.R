library(dplyr)

cld <- readRDS("cld_base_merged.rds")
dl <- readRDS("deeplex_base_merged.rds")


x = dl %>% filter(grepl("我", lu_trad))
y = cld %>% filter(grepl("我", lu_trad))
z1 = full_join(x, y, by = c("lu_trad", "lu_simp"))

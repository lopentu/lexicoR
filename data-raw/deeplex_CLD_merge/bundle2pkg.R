cld <- readRDS("cld_base_merged.rds")
deeplex <- readRDS("deeplex_base_merged.rds")

cld = as.data.frame(cld)
deeplex = as.data.frame(deeplex)

save(cld, deeplex, file = "database.rda")

# Save to lexicoR
#usethis::use_data(as.data.frame(cld),
#                  as.data.frame(deeplex),
#                  internal = TRUE)


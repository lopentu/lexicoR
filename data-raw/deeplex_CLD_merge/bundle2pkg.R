cld <- readRDS("cld_base_merged.rds")
deeplex <- readRDS("deeplex_base_merged.rds")

# Save to lexicoR
usethis::use_data(as.data.frame(cld),
                  as.data.frame(deeplex),
                  internal = TRUE)

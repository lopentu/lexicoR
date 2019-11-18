library(ropencc)
library(dplyr)

# Process deeplex
deeplex <- readr::read_csv("raw_data/deeplexicon.csv")

# Process CWN
cwn <- readr::read_csv("raw_data/CWN_sense_counts.csv")
colnames(cwn) <- c("lemma", "n_sense")
trans <- ropencc::converter(ropencc::T2S)
cwn$lemma_sim <- ropencc::run_convert(trans, cwn$lemma)
colnames(cwn) <- paste0('cwn.', colnames(cwn))

# Process cld
load("raw_data/chineselexicaldatabase2.1.rda")
colnames(cld) <- paste0('cld.', colnames(cld))
cld <- as_tibble(cld)


# Save RDS to Data_summary/
saveRDS(deeplex, "Data_summary/deeplex.rds")
saveRDS(cwn, "Data_summary/cwn.rds")
saveRDS(cld, "Data_summary/cld.rds")

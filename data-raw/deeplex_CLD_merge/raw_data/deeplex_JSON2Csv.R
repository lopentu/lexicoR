library(jsonlite)
library(dplyr)
library(ropencc)

deeplex <- fromJSON("deeplexicon.json", flatten = TRUE)
colnames(deeplex)[-1] <- substring(colnames(deeplex)[-1], 6)
colnames(deeplex) <- paste0("dl.", colnames(deeplex))

# translate traditional to simplify in deeplex
trans <- converter(T2S)
deeplex$dl.lu_sim <- run_convert(trans, deeplex$dl.lu)
deeplex <- deeplex %>% select(dl.lu, dl.lu_sim, everything())



readr::write_csv(deeplex, "deeplexicon.csv")
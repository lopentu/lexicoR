#' Query lexical data stored in local databases.
#'
#' @param query A string. A string that matches the words (or lexical units)
#'   in the databases.
#' @param regex Logical. Whether to use a regular expression pattern in
#'   the argument \code{query}. Defaults to \code{FALSE}, which searches
#'   for exact matches.
#' @param db Character. The databases to be searched. Currently only
#'   \code{deeplex} and \code{cld} (Chinese Lexical Database) are available.
#' @param as_tibble Logical. Whether to convert the query results to
#'   a \code{tibble} (a special type of \code{data.frame} provided by
#'   the package \pkg{tibble}). Defaults to \code{TRUE}, which makes the data
#'   frame printed out in the console to have a nicer look.
#' @return A data frame (\code{tibble}).
#' @export
query_local <- function(query, regex = FALSE, db = c("deeplex", "cld"), as_tibble = TRUE) {
  # Check argument
  if (FALSE %in% (db %in% c("deeplex", "cld")))
      stop("db: `", paste(db, collapse = "` or `"), "` not available.")

  # Query each database
  db <- paste0('lexicoR:::', db)
  q_result <- vector("list", length(db))
  for (i in seq_along(q_result)) {
      # query db
      database <- eval(parse(text = db[i]))  # get db
      if (regex)
        test <- grepl(query, database$lu_trad) | grepl(query, database$lu_simp)
      else
        test <- (query == database$lu_trad) | (query == database$lu_simp)

      # Save query result to list
      q_result[[i]] <- database[test, ]
  }

  # Merge query results
  merged_query_df <- Reduce(
      function(df1, df2) merge(df1, df2, by = c("lu_trad", "lu_simp"), all = TRUE),
      q_result
      )

  # Clean up both NA in lu_simp & lu_trad
  isNA <- is.na(merged_query_df$lu_simp) & is.na(merged_query_df$lu_trad)
  merged_query_df <- merged_query_df[!isNA, ]
  # Convert to tibble
  if (as_tibble)
      merged_query_df <- tibble::as_tibble(merged_query_df)

  return(merged_query_df)
}

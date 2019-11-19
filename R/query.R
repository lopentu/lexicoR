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

    # Load database
    load_database.rda()

    # Query each database
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
    suppressMessages({
        df <- dplyr::full_join(q_result[[1]], q_result[[2]])
        })

    #df <- Reduce(function(df1, df2) merge(df1, df2), q_result)

    # Clean up both NA in `lu_simp` & `lu_trad`
    isNA <- is.na(df$lu_simp) & is.na(df$lu_trad)
    df <- df[!isNA, ]

    # Convert to tibble
    if (as_tibble)
        df <- tibble::as_tibble(df)

    return(df)
}


#' Load databases
#'
#' Load \code{database.rda} stored in \code{lexicoR}.
#'
#' @keyword internal
load_database.rda <- function() {

    db_path <- system.file("database.rda", package = "lexicoR")
    # install database.rda from the internet
    if (db_path == "") {
        cat("Can't find `database.rda`\nDo you want to download it?\n")
        permission <- readline("Press 'y' to download: ")
        if (permission %in% c("y", "Y")) {
            # Download `database.zip` from the web
            lexicoR::install_db(install = c(cwn = F, db = T))
            db_path <- system.file("database.rda", package = "lexicoR")
        }
    }

    # Load db
    if (!(exists('cld') && is.data.frame(get('cld'))))
        message('Loading `database.rds`...\n')
        load(db_path, envir = globalenv())
    if (!(exists('deeplex') && is.data.frame(get('deeplex'))))
        message('Loading `database.rds`...\n')
        load(db_path, envir = globalenv())
}

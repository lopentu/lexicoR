#' Query lemma frequencies in ASBC
#'
#' @param lemma A string. The lemma to be queried in ASBC corpus.
#' @param regex A string. Whether to use RegEx pattern for query.
#' @return A list with each element specifying the frequency of
#'   occurrence of the lemma with a particular Part-Of-Speech tag.
#' @export
asbcFreq <- function(lemma, regex = FALSE) {

    # Load database for first call
    load_database.asbc_freq()

    # show total freq info
    message("Total number of words: ", attr(asbc_wordFreq.internal, "total_freq"))

    if (regex) {
        matched_words <- grepl(lemma, attr(asbc_wordFreq.internal, "words"))
        return(asbc_wordFreq.internal[matched_words])
    } else {
        if (!lemma %in% attr(asbc_wordFreq.internal, "words")) {
            warning(lemma, " not found!")
            return(NULL)
        }
        return(asbc_wordFreq.internal[lemma])
    }
}



#' Query lemma frequencies on PTT
#'
#' @param lemma A string. The lemma to be queried on PTT.
#' @param board A string. The board on PTT to search for.
#' @param year Integer. The year to search for.
#' @return A list with each element specifying the frequency of
#'   occurrence of the lemma with a particular Part-Of-Speech tag.
#' @export
pttFreq <- function(lemma, board, year = 2019) {
    baseURL <- 'http://140.112.147.125:8976/'

    # Get ptt available boards
    if (is.null(getOption("pttAvailBoards"))) {
        req <- httr::GET(baseURL, path = 'available_boards')
        check_status(req)
        # Save available PTT boards in `getOption("pttAvailBoards")`
        options(pttAvailBoards = unlist(httr::content(req)))
    }
    availBoards <- getOption("pttAvailBoards")
    # Check if board is available
    if (!board %in% availBoards) {
        warning("`", board, "` not available.\n\n",
                "Only the following boards are available:\n",
                paste(availBoards, collapse = ', '))
        return(NULL)
    }

    # Query data from server
    req <- httr::GET(baseURL, path = "query",
                     query = list(lemma = lemma,
                                  board = board,
                                  year = year)
                     )
    check_status(req)

    # Parse results
    data <- httr::content(req)
    if (data$result == 0) {
        message('Queried data not found in the database.')
        return(NULL)
    }
    return(data$freq)
}

#' Query lexical databases
#'
#' @param lu A string. The lexical unit to be queried in the databases.
#' @param isSimp Logical. Whether \code{lu} is in simplified Chinese.
#'   Defaults to \code{FALSE}, which treat \code{lu} as traditional Chinese.
#' @param regex Logical. Whether to use a regular expression pattern in
#'   the argument \code{lu} for searching. Defaults to \code{FALSE},
#'   which searches for exact matches.
#' @param db Character. The databases to be searched. Currently only
#'   \code{deeplex} and \code{cld} (Chinese Lexical Database) are available.
#' @param as_tibble Logical. Whether to convert the query results to
#'   a \code{tibble} (a special type of \code{data.frame} provided by
#'   the package \pkg{tibble}). Defaults to \code{TRUE}, which makes the data
#'   frame printed out in the console to have a nicer look.
#' @return A data frame (\code{tibble}).
#' @export
query.lu <- function(lu, isSimp = FALSE, regex = FALSE, db = c("deeplex", "cld"), as_tibble = TRUE) {
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
            if (isSimp)
                test <- grepl(lu, database$lu_simp)
            else
                test <- grepl(lu, database$lu_trad)
        else
            if (isSimp)
                test <- lu == database$lu_simp
            else
                test <- lu == database$lu_trad

        # Save query result to list
        q_result[[i]] <- database[test, ]
    }

    # Merge query results
    df <- dplyr::distinct(dplyr::bind_rows(q_result))

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
            lexicoR:::install_db(install = c(cwn = F, db = T))
            db_path <- system.file("database.rda", package = "lexicoR")
        }
    }

    # Load db if not in Global environment
    if (!(exists('cld') && is.data.frame(get('cld'))))
        message('Loading `database.rds`...\n')
        load(db_path, envir = globalenv())
    if (!(exists('deeplex') && is.data.frame(get('deeplex'))))
        message('Loading `database.rds`...\n')
        load(db_path, envir = globalenv())
}



#' Load ASBC Freq Data
#'
#' @keywords internal
load_database.asbc_freq <- function() {

    db_path <- system.file("ASBC_freq.rda", package = "lexicoR")
    # install ASBC_freq.rda from the internet
    if (db_path == "") {
        cat("Can't find `ASBC_freq.rda`\nDo you want to download it?\n")
        permission <- readline("Press 'y' to download: ")
        if (permission %in% c("y", "Y")) {
            # Download `ASBC_freq.rda` from the web
            lexicoR:::install_db(install = c(cwn = F, db = F, asbc_freq = T))
            db_path <- system.file("ASBC_freq.rda", package = "lexicoR")
        }
    }

    # Load db if not in Global environment
    if (!exists('asbc_wordFreq.internal')) {
        message('Loading `ASBC_freq.rda`...\n')
        load(db_path, envir = globalenv())
    }
}

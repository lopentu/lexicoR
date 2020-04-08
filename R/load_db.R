#' Install databases from local file paths or urls
#'
#' @param cwn_path A string. The path to \code{CwnGraph.zip}.
#'   Defaults to \code{NULL}, which downloads \code{CwnGraph.zip}
#'   from the internet and installs it to \code{lexicoR}.
#' @param db_path A string. The path to \code{database.rda} or
#'   \code{database.zip}. Defaults to \code{NULL}, which
#'   downloads \code{database.zip} from the internet and
#'   installs it to \code{lexicoR}.
#' @param install Logical. A logical vector specifying which
#'   databases to install.
#' @return The path to the directory where the databases
#'   were installed.
#' @keyword internal
install_db <- function(cwn_path = NULL, db_path = NULL, asbc_freq_path = NULL,
                       install = c(cwn = TRUE, db = TRUE, asbc_freq = TRUE)) {
    if (is.null(cwn_path) & install[1]) {
        url <- 'https://lopentu.github.io/lexicoR-data/inst/CwnGraph.zip'
        cwn_path <- tempfile()
        download.file(url, destfile = cwn_path)
    }
    if (is.null(db_path) & install[2]) {
        url <- 'https://lopentu.github.io/lexicoR-data/inst/database.zip'
        db_path <- tempfile()
        download.file(url, destfile = db_path)
    }
    if (is.null(asbc_freq_path) & install[3]) {
        url <- 'https://lopentu.github.io/lexicoR-data/inst/ASBC_freq.zip'
        asbc_freq_path <- tempfile()
        download.file(url, destfile = asbc_freq_path)
    }

    # Move file to destination
    pkg_path <- system.file(package = "lexicoR")

    # CwnGraph.zip
    if (install[1])
        unzip(cwn_path, exdir = pkg_path)

    # database.rds or database.zip
    if (install[2]) {
        if (!is.null(db_path) & grepl(pattern = "\\.rds$", db_path)) {
            file.copy(from = db_path, to = pkg_path)
        } else {
            unzip(db_path, exdir = pkg_path)
        }
    }

    # ASBC_freq.zip
    if (install[3])
        unzip(asbc_freq_path, exdir = pkg_path)

    return(pkg_path)
}

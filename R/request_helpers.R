#' Request helpers
check_status <- function(req) {
    if (!(req[["status_code"]] == 200))
        stop("Request to ", req[["url"]], " failed with status: ", req[["status_code"]])
}

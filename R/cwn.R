#' Load CwnGraph from python
#'
#' @param python_path Path to Python binary, directory of virtualenv,
#'   or name of Conda environment. Defaults to \code{NULL}.
#'   See \code{\link[reticulate]{use_python}} for details.
#' @param type A string. One of \code{virtualenv}, \code{condaenv}, and \code{python},
#'   which calls \code{\link[reticulate]{use_virtualenv}},
#'   \code{\link[reticulate]{use_condaenv}}, and \code{\link[reticulate]{use_python}},
#'   respectively.
#'
#' @return Various python objects, among which the most important is
#'   \code{cwn}.
#'
#' @export
load_cwn <- function(python_path = NULL, type = c("virtualenv", "condaenv", "python"), ...) {
  load_cwn <- system.file(package = "lexicoR", "CwnGraph", "load_cwn.py")
  cwd <- getwd()

  tryCatch({
    setwd(dirname(load_cwn))

    # Load python path
    if (!is.null(python_path)) {
      stopifnot(type[1] %in% c("virtualenv", "condaenv", "python"))
      eval(parse(text = paste0('use_python <- reticulate::use_', type[1])))
      use_python(python_path, required = TRUE, ...)
    }

    # Load CwnGraph
    reticulate::source_python(load_cwn, envir = globalenv(), convert = F)
    },
  finally = setwd(cwd))
}

#' Reticulate alias
#'
#' See \code{\link[reticulate]{py_to_r}}.
#'
#' @export
py_to_r <- function(...) reticulate::py_to_r(...)


#lemma0 <- cwn$find_lemma("電腦")
#cwn$find_senses(definition="輪子")[1]

#reticulate::py_to_r(cwn$find_senses(lemma="花費")[0]$all_examples())



#reticulate::py_to_r(lemma0[0]$senses[1]$data())






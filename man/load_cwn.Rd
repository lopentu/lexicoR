% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cwn.R
\name{load_cwn}
\alias{load_cwn}
\title{Load CwnGraph from python}
\usage{
load_cwn(python_path = NULL, type = c("virtualenv", "condaenv", "python"), ...)
}
\arguments{
\item{python_path}{Path to Python 3 binary, directory of virtualenv,
or name of Conda environment. Defaults to \code{NULL}.
See \code{\link[reticulate]{use_python}} for details.}

\item{type}{A string. One of \code{virtualenv}, \code{condaenv}, and \code{python},
which calls \code{\link[reticulate]{use_virtualenv}},
\code{\link[reticulate]{use_condaenv}}, and \code{\link[reticulate]{use_python}},
respectively.}
}
\value{
Various python objects, among which the most important is
  \code{cwn}.
}
\description{
Load CwnGraph from python
}

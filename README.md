[![Support R Version](https://img.shields.io/badge/R-≥%203.6.0-blue.svg)](https://cran.r-project.org/)

# lexicoR

R interface to access Chinese lexical resources.

## Installation

```r
#install.packages('remotes')
remotes::install_github('lopentu/lexicoR', ref = "lite")
```

## Notes for Developers

#### Build pkg website

```r
pkgdown::build_site(examples = F)
```

#### Clean up large data

1. On `branch:master`, commit and push to GitHub.
1. On `branch:master`, run: 
    
    ```sh
    bash push2lite.sh
    ```

    This pushes a cleaned-up version of the package to `branch:lite` on GitHub.


#### Rebuild binaries from raw data

On `branch:master`, cd to `data-raw/deeplex_CLD_merge/` and run the commands below in order:

```sh
Rscript toRDS.R
Rscript merge.R
Rscript bundle2pkg.R
```

This creates `database.rda` in the current directory. Compress and copy this file to `lopentu/lexicoR-data/inst/`.
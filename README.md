
<!-- README.md is generated from README.Rmd. Please edit that file -->

# instr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/instr)](https://CRAN.R-project.org/package=instr)
<!-- badges: end -->

The goal of `instr` is to wrap the
[instaloader](https://github.com/instaloader/instaloader) Python module.
`instr` is a updated fork of [Fabio
Votta](https://github.com/favstats)’s
[instaloadeR](https://github.com/favstats/instaloadeR).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("JBGruber/instr")
```

After installing the R package, you also need the Python backend. We
provide a function that sets this up automatically:

``` r
library(instr)
install_instaloader()
```

## Learn More

Learn more at <https://jbgruber.github.io/instr/>

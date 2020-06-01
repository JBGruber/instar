
<!-- README.md is generated from README.Rmd. Please edit that file -->

# instaloadeR

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/instaloadeR)](https://CRAN.R-project.org/package=instaloadeR)
<!-- badges: end -->

The goal of `instaloadeR` is to provide a scraper for the image-sharing
social networking service
[Instagram](http://https://www.instagram.com/). Mostly inspired by this
Scraping Tool:
[digitalmethodsinitiative/4cat](https://github.com/digitalmethodsinitiative/4cat).
Wraps this Python module
[instaloader](https://github.com/instaloader/instaloader). You will need
Python 3.6 or higher to use `instaloader`.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("favstats/instaloadeR")
```

Load library

``` r
library(instaloadeR)
```

Install necessary Python libraries

``` r
install_instaloadeR()
```

## Example

This is a basic example which shows you how to solve a common problem:

Make sure to use your preferred Python installation

``` r
library(reticulate)

use_python(py_config()$python)
```

Initialize `instaloadeR`

``` r
readr::write_lines(py_instaloader, "script.py")
reticulate::source_python("script.py")
```

### Get Posts with Hashtag

Return a tibble with 10 Instagram posts that use `#coronavirus`.

``` r

corona <- insta_posts(query = "coronavirus", 
                         scope = "hashtag",
                         max_posts = 10, 
                         scrape_comments = F)


corona
```

Also return comments and replies to comments for the 10 last
`#coronavirus` posts.

``` r
corona_comments <- insta_posts(query = "corona", 
                         scope = "hashtag",
                         max_posts = 10, 
                         scrape_comments = T)

corona_comments
```

### Get Posts from a Specific User

Return a tibble with the 10 Instagram posts by `francediplo`.

``` r

francediplo <- insta_posts(query = "francediplo", 
                         scope = "username",
                         max_posts = 10, 
                         scrape_comments = F)


francediplo
```

Retrieve comments as well:

``` r

francediplo_comments <- insta_posts(query = "francediplo", 
                         scope = "username",
                         max_posts = 10, 
                         scrape_comments = T)


francediplo_comments
```

## Save output to csv

As function scrapes, the data is saved and continously appended to a
`.csv` file (for when you have long scraping tasks).

``` r
francediplo_comments <- insta_posts(query = "francediplo", 
                         scope = "username",
                         max_posts = 10, 
                         scrape_comments = T, 
                         save_path = "francediplo.csv")


readr::read_csv("francediplo.csv")
```

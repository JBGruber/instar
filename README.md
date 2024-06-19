
<!-- README.md is generated from README.Rmd. Please edit that file -->

# instar

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/instar)](https://CRAN.R-project.org/package=instar)
<!-- badges: end -->

The goal of `instar` is to provide a scraper for the image-sharing
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
devtools::install_github("JBGruber/instar")
```

Load library

``` r
library(instar)
```

Make sure to use your preferred Python installation

``` r
library(reticulate)

use_python(py_config()$python)
```

Install necessary Python libraries

``` r
install_instar()
```

## Example

This is a basic example which shows you how to solve a common problem:

Initialize `instar`

``` r
init_instar()
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
corona_comments <- insta_posts(query = "coronavirus", 
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
`.csv` file (for when you have long scraping tasks). Just specify a path
for the `save_path` argument.

``` r
francediplo_comments <- insta_posts(query = "francediplo", 
                         scope = "username",
                         max_posts = 10, 
                         scrape_comments = T, 
                         save_path = "francediplo.csv")


readr::read_csv("francediplo.csv")
```

## Get User or Hashtag posts in specific timerange

Just specify both an argument for `since` (latest date) and `until`
(earliest date) and get Instagram posts in specific timerange.

``` r

covidgoodnews <- insta_posts(query = "covidgoodnews",
                         scope = "username",
                         max_posts = 10,
                         scrape_comments = F,
                         since = "2020-06-01",
                         until = "2020-01-01")



covidgoodnews
```

## Login with your Instagram account

Some functionalities (like scraping followers from an account) are only
available if you login with your Instagram account. For this purpose,
`instar` functions will read from your environment variables.

In order to add the info to your environment file, you can use the
function `edit_r_environ()` from the [`usethis`
package](https://usethis.r-lib.org/).

``` r
usethis::edit_r_environ()
```

This will open your .Renviron file in your text editor. Now, you can add
the following line(s) to it:

``` r
INSTAGRAM_LOGIN=YOUR_USERNAME
INSTAGRAM_PW=YOUR_PW
```

Save the file and restart R for the changes to take effect.

The password line is optional and can also be provided via a prompt
which will appear if you run `insta_login` without specifying the
`passwd` argument (if you are icky about typing out your password which
you should always be).

Now you can use `insta_login` in the following way:

``` r
insta_login(save = T)
```

`save = T` will save your credentials, so next time you can just do
`load = T` and you don’t need to specify your password again:

``` r
insta_login(load = T)
```

## Get followers of an account

You can all followers of an Instagram account with `get_followers` but
only if you are logged in as an Instagram user. The function
`get_followers` retrieves a character vector with all usernames that
follow the specified account.

``` r
insta_login(load = T)


get_followers("willsmith_fan_")
```

## Get similar or suggested accounts

``` r
insta_login(load = T)


similar_accounts <- get_similar_accounts("willsmith_fan_")

similar_accounts
```

## TODO

  - Geotags
  - Download Images/videos
  - …

the <- new.env()
the$fail_counter <- 0

#' from_unix
#'
#' @description Converts UNIX timestamp to datetime format
#' @param x UNIX timestamp to be converted to datetime
#' @export
from_unix <- function(x) {
  as.POSIXct(as.numeric(x), origin = "1970-01-01", tz = "UTC")
}


#' Convert an Instagram URL to a shortcode
#'
#' @param url vector of URLs
#'
#' @return character vector of shortcodes
#' @export
#'
#' @examples
#' url2shortcode("https://www.instagram.com/p/C5gQOiiC08D/")
url2shortcode <- function(url) {
  gsub(".*instagram\\.com/p/([^/]+)/?.*", "\\1", url)
}


#' @keywords internal
from_dict <- function(x) {
  tibble::as_tibble(purrr::map(x, function(c) {
    if (length(x) != 1) {
      c <- list(c)
    }
    c
  }))
}


#' @keywords internal
check_init <- function(fail = TRUE) {
  init <- !is.null(the$init)
  if (fail & !init) {
    cli::cli_abort("You need to initialise instaloader first: {.code init_instr()}")
  }
  invisible(init)
}

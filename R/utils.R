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

check_init <- function(fail = TRUE) {
  init <- !is.null(the$init)
  if (fail & !init) {
    cli::cli_abort("You need to initialise instaloader first: {.code init_instr()}")
  }
  invisible(init)
}

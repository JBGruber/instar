#' init_instar
#'
#' @description Initializes the instaloader python functions. Only works when \code{install_instar()} has ben executed.
#' @export
init_instar <- function() {
  reticulate::source_python(system.file("python", "instaloader.py",
    package = "instar"
  ))

  message("instaloader initialized")
}

#' install_instar
#'
#'
#' @description Installs the instaloader Python module
#' @param envname specify Python environment name for module installation
#' @export
install_instar <- function(envname = NULL) {
  reticulate::py_install(c("instaloader"), pip = TRUE, envname = envname)
}

#' from_unix
#'
#' @description Converts UNIX timestamp to datetime format
#' @param x UNIX timestamp to be converted to datetime
#' @export
from_unix <- function(x) {
  as.POSIXct(as.numeric(x), origin = "1970-01-01", tz = "UTC")
}

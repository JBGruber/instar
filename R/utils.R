<<<<<<< HEAD
#' init_instar
#'
#' @description Initializes the instaloader python functions. Only works when \code{install_instar()} has ben executed.
#' @export
init_instar <- function() {
  reticulate::source_python(system.file("python", "instar.py",
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
=======
the <- new.env()
the$fail_counter <- 0
>>>>>>> 4e67927f0e1efc8170c8464148dddc52485d976e

#' from_unix
#'
#' @description Converts UNIX timestamp to datetime format
#' @param x UNIX timestamp to be converted to datetime
#' @export
from_unix <- function(x) {
  as.POSIXct(as.numeric(x), origin = "1970-01-01", tz = "UTC")
}

#' init_instr
#'
#' @description Initializes the instaloader python functions. Only works when \code{install_instr()} has ben executed.
#' @param envname initialise in a specific virtual environment
#' @export
init_instr <- function(envname = NULL) {
  if (is.null(envname))
    envname <- Sys.getenv("instr_PYTHON", unset = "r-instr")
  check_instaloader_installed(envname)
  reticulate::use_virtualenv(envname)
  reticulate::source_python(system.file("python", "insta.py",
                                        package = "instr"
  ))

  instaloader_version <- get_instaloader_version(envname)
  the$init <- TRUE
  cli::cli_alert_success(
    "instaloader v{cli::style_italic(instaloader_version)} initialized"
  )
}

#' @keywords internal
check_instaloader_installed <- function(envname = NULL,
                                        is_error = TRUE,
                                        cache = TRUE) {

  if (is.null(envname))
    envname <- Sys.getenv("instr_PYTHON", unset = "r-instr")

  if (is.null(the$installed) || !cache) {
    p <- try(reticulate::py_list_packages(envname = envname), silent = TRUE)
    the$installed <- "instaloader" %in% purrr::pluck(p, "package")
  }

  if (!the$installed & is_error) {
    cli::cli_abort("The instaloader backend is not installed. Try See {.code install_instaloader()}.")
  }

  return(the$installed)
}


#' install instaloader
#'
#'
#' @description Installs the instaloader Python module
#' @param envname The name of, or path to, a Python virtual environment. Default
#'   is to use "r-instr" unless set in environment variable instr_PYTHON
#'   (through `Sys.setenv()`).
#' @param instaloader_version give a specific version if you want.
#' @param ask set `FALSE` for unattended install.
#'
#' @return `TRUE` if everything worked.
#' @export
install_instaloader <- function(envname = NULL,
                                instaloader_version = NULL,
                                ask = TRUE) {
  if (is.null(envname))
    envname <- Sys.getenv("instr_PYTHON", unset = "r-instr")
  if (!check_instaloader_installed(envname, is_error = FALSE))
    safe_create(envname, ask)
  if (is.null(instaloader_version)) {
    instaloader_version <- "instaloader"
  } else {
    instaloader_version <- paste0("instaloader==", instaloader_version)
  }
  reticulate::virtualenv_install(envname,
                                 packages = instaloader_version,
                                 ignore_installed = TRUE)

  instaloader_version <- get_instaloader_version(envname)
  cli::cli_alert_success(
    "Instaloader version v{cli::style_italic(instaloader_version)} succesfully installed!"
  )
  invisible(TRUE)
}


#' @keywords internal
safe_create <- function(envname, ask) {
  if (the$fail_counter > 2) {
    ask <- TRUE
  }
  t <- try(reticulate::virtualenv_create(envname), silent = TRUE)
  if (methods::is(t, "try-error")) {
    the$fail_counter <- the$fail_counter + 1
    install_python(ask)
    safe_create(envname, ask)
  }
}


#' @keywords internal
install_python <- function(ask) {
  permission <- TRUE
  if (ask) permission <- utils::askYesNo(paste0(
    "No suitable Python installation was found on your system. ",
    "Do you want to run `reticulate::install_python()` to install it?"
  ))

  if (permission) {
    if (utils::packageVersion("reticulate") < "1.19")
      cli::cli_abort("Your version or reticulate is too old for this action. Please update it")
    reticulate::install_python()
  } else {
    cli::cli_abort("Aborted by user")
  }
}


#' Check the version of instaloader
#'
#' @inheritParams install_instaloader
#'
#' @return string with version of Whisper
#' @export
get_instaloader_version <- function(envname = NULL) {
  if (is.null(envname))
    envname <- Sys.getenv("instr_PYTHON", unset = "r-instr")
  check_instaloader_installed(envname, cache = FALSE)
  packages <- reticulate::py_list_packages(envname)
  packages$version[packages$package == "instaloader"]
}

#' Log into Instagram
#'
#' @param user,password Specify your Instagram user and password. It's better to
#'   leave this empty, in which case a secure prompt will ask you for input.
#' @param save save your session to the cache, so you don't need to specify
#'   password again.
#' @param force_refresh overwrite existing sessions in cache.
#' @export
insta_login <- function(user,
                        password,
                        save = TRUE,
                        force_refresh = FALSE) {

  check_init()

  cache <- tools::R_user_dir("instr", "cache")

  if (missing(user)) {
    # look for logins
    user <- logged_in_users()[1]
    # if none are found, authenticate
    if (is.na(user)) {
      rlang::check_installed("askpass")
      user <- askpass::askpass(
        "Please enter your username"
      )
      if (missing(password)) {
        rlang::check_installed("askpass")
        password <- askpass::askpass(
          "Please enter your password"
        )
      }
    } else {
      password <- NULL
    }
  }
  fname <- paste0(cache, "/", user, "-session")
  if (file.exists(fname) || force_refresh) {
    sess <- reticulate::py$insta_login_py(user, file = fname)
  } else {
    sess <- reticulate::py$insta_login_py(user, password, fname,
                                          save = save,
                                          force_refresh = force_refresh)
  }
  cli::cli_alert_success("Logged in as {user}")
  invisible(sess)
}


#' Looked for logged in users
#'
#' @return a vector of usernames
#' @export
logged_in_users <- function() {
  cache <- tools::R_user_dir("instr", "cache")
  gsub("-session", "", list.files(cache), fixed = TRUE)
}

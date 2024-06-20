"C8XNI2tIZ6Z"

#' Get posts by URL or shortcode
#'
#' @param x URLs or shortcodes
#'
#' @return tibble with metadata about posts
#' @export
#'
#' @examples
#' \dontrun{
#' get_post("https://www.instagram.com/p/C8XNI2tIZ6Z/")
#' }
get_post <- function(x) {
  check_init()
  x <- url2shortcode(x)
  out <- purrr::map(x, function(p) {
    post <- reticulate::py$get_post(SHORTCODE = p)
    from_dict(post)
  }, .progress = TRUE)
  purrr::list_rbind(out)
}

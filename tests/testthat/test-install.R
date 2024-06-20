test_that("installation to explicit env works", {
  tmp <- file.path(tempdir(), "env")
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE, after = FALSE)
  expect_equal(check_instaloader_installed(tmp, is_error = FALSE, cache = FALSE),
               FALSE)
  expect_type({
    install_instaloader(envname = tmp)
    get_instaloader_version(envname = tmp)
  }, "character")
})

test_that("installation to instr_PYTHON works", {
  tmp <- file.path(tempdir(), "env2")
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE, after = FALSE)
  Sys.setenv(instr_PYTHON = tmp)
  expect_equal(check_instaloader_installed(tmp, is_error = FALSE, cache = FALSE),
               FALSE)
  expect_type({
    install_instaloader()
    message(tmp)
    get_instaloader_version()
  }, "character")
})

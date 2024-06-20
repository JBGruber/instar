test_that("list logged in users", {
  expect_type(logged_in_users(), "character")
})

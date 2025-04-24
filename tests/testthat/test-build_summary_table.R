
test_that("Summary table is built correctly", {
  tbl <- build_summary_table()
  expect_equal(as.character(class(tbl)), c("tbl_df", "tbl", "data.frame"))
  expect_equal(nrow(tbl), 0)
  expect_equal(names(tbl), c("user_login", "batch_id", "symbol", "status", "n_rows", "message"))
})

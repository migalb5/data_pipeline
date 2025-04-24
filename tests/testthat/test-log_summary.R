
test_that("A new log record is added to Summary Table when financial records have been added to the DB", {
  logs <- build_summary_table()
  logs <- log_summary(logs, "miguel", -1, data.frame(symbol = c("AAPL", "META")), 4)
  expect_equal(nrow(logs), 1)
})

test_that("A new log record is added to Summary Table even when no financial records have been added to the DB", {
  logs <- build_summary_table()
  logs <- log_summary(logs, "miguel", -1, data.frame(symbol = c("AAPL", "META")), 0)
  expect_equal(nrow(logs), 1)
})

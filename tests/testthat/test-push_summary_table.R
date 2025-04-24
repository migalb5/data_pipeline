
test_that("Summary table is correctly written to DB", {
  logs <- build_summary_table()
  logs <- log_summary(logs, "miguel", -1, data.frame(symbol = c("AAPL", "META")), -2)
  conn <- connect_db()
  result <- push_summary_table(conn, logs)
  DBI::dbDisconnect(conn)
  expect_true(result)
})

test_that("Summary table is not written to DB, in case of empty Summary Table or DB connectivity problems", {
  logs <- build_summary_table()
  conn <- connect_db()
  result <- push_summary_table(conn, logs)
  DBI::dbDisconnect(conn)
  expect_false(result)

  logs <- build_summary_table()
  logs <- log_summary(logs, "miguel", -1, data.frame(symbol = c("AAPL", "META")), -2)
  result <- push_summary_table(conn, logs)
  expect_false(result)
})

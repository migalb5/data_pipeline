
test_that("Yahoo!Finance financial data is correctly obtained", {
  chunk <- data.frame(symbol = c("AAPL", "META"))
  date_from = "2024-04-01"
  date_to = "2024-04-03"
  fin_data <- yahoo_query_data(chunk, date_from, date_to)
  expect_equal(nrow(fin_data), nrow(chunk) * 2)
  expect_true("symbol" %in% names(fin_data))
  expect_true("open" %in% names(fin_data))
  expect_true("high" %in% names(fin_data))
  expect_true("low" %in% names(fin_data))
  expect_true("close" %in% names(fin_data))
  expect_true("volume" %in% names(fin_data))
  expect_true("adjusted" %in% names(fin_data))
})

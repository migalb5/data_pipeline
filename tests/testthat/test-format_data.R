
test_that("Yahoo!Finance financial data is correctly re-structured / formatted", {
  fin_data <- yahoo_query_data(data.frame(symbol = c("AAPL", "META")), "2024-04-01", "2024-04-03")
  data_restructured <- format_data(fin_data, data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta")))
  expect_equal(nrow(data_restructured), 5 * nrow(fin_data))
  expect_null(data_restructured$adjusted)
  expect_null(data_restructured$symbol)
})

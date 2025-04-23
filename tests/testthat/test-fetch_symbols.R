
test_that("symbols can be fetched", {
  conn <- connect_db()
  df <- fetch_symbols(conn)
  DBI::dbDisconnect(conn)
  expect_equal(as.character(class(df)), "data.frame")
  expect_gte(nrow(df), 1)
  expect_gte(ncol(df), 2)
  expect_equal(names(df)[1], "index_ts")
  expect_equal(names(df)[2], "symbol")
})

test_that("symbols cannot be fetched when a non-valid DB connection is passed to the function", {
  df <- fetch_symbols(conn)
  expect_false(df)
})

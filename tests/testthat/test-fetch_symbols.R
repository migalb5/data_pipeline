
test_that("Symbols can be fetched", {
  conn <- connect_db()
  df <- fetch_symbols(conn)
  DBI::dbDisconnect(conn)
  expect_equal(as.character(class(df)), "data.frame")
  expect_gte(nrow(df), 1)
  expect_gte(ncol(df), 2)
  expect_equal(names(df)[1], "index_ts")
  expect_equal(names(df)[2], "symbol")
})

test_that("Symbols cannot be fetched when a non-existing or non-valid DB connection is passed to the function", {
  conn <- connect_db()
  DBI::dbDisconnect(conn)
  df <- fetch_symbols(conn)
  expect_null(df)
})

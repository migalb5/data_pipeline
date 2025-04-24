
test_that("Batch is split correctly", {
  conn <- connect_db()
  batch <- fetch_symbols(conn)
  DBI::dbDisconnect(conn)
  chunk_size = 20
  batch_chunks <- split_batch(batch, chunk_size)
  expect_equal(as.character(class(batch_chunks)), "list")
  expect_gte(length(batch_chunks), 1)
  for (chunk in batch_chunks) {
    expect_equal(as.character(class(chunk)), "data.frame")
    expect_lte(nrow(chunk), chunk_size)
    expect_equal(names(chunk)[1], "symbol")
  }
})

test_that("Batch is still split correctly even when an invalid chunk size is specified", {
  conn <- connect_db()
  batch <- fetch_symbols(conn)
  DBI::dbDisconnect(conn)
  batch_chunks <- split_batch(batch, "abc")
  expect_equal(as.character(class(batch_chunks)), "list")
  expect_gte(length(batch_chunks), 1)
  for (chunk in batch_chunks) {
    expect_equal(as.character(class(chunk)), "data.frame")
    expect_lte(nrow(chunk), 10)
    expect_equal(names(chunk)[1], "symbol")
  }
  batch_chunks <- split_batch(batch, 0)
  expect_equal(as.character(class(batch_chunks)), "list")
  expect_gte(length(batch_chunks), 1)
  for (chunk in batch_chunks) {
    expect_equal(as.character(class(chunk)), "data.frame")
    expect_lte(nrow(chunk), 10)
    expect_equal(names(chunk)[1], "symbol")
  }
})

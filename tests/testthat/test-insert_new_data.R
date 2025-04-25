
test_that("A set of financial records is correctly appended to the DB", {
  date_from = "2024-03-26"
  date_to = "2024-03-27"
  index_ts1 = "apple_inc_aapl"
  index_ts2 = "meta_platforms_meta"

  conn <- connect_db()
  batch <- data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta"))
  batch_chunks <- split_batch(batch, 5)
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
    rows_inserted <- insert_new_data(conn, 0, formatted_data)
    expect_gte(rows_inserted, 1)
  }
  query = glue::glue_sql("DELETE FROM student_miguel.data_sp500
                          WHERE date = {date_from} AND
                         (index_ts = {index_ts1} OR index_ts = {index_ts2})", .con = conn)
  DBI::dbExecute(conn, query)
  DBI::dbDisconnect(conn)

  conn <- connect_db()
  batch <- data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta"))
  batch_chunks <- split_batch(batch, 5)
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
    rows_inserted <- insert_new_data(conn, 285, formatted_data)
    expect_gte(rows_inserted, 1)
  }
  query = glue::glue_sql("DELETE FROM student_miguel.data_sp500
                          WHERE date = {date_from} AND
                         (index_ts = {index_ts1} OR index_ts = {index_ts2})", .con = conn)
  DBI::dbExecute(conn, query)
  DBI::dbDisconnect(conn)

  conn <- connect_db()
  batch <- data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta"))
  batch_chunks <- split_batch(batch, 5)
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
    rows_inserted <- insert_new_data(conn = conn, formatted_data = formatted_data)
    expect_gte(rows_inserted, 1)
  }
  query = glue::glue_sql("DELETE FROM student_miguel.data_sp500
                          WHERE date = {date_from} AND
                         (index_ts = {index_ts1} OR index_ts = {index_ts2})", .con = conn)
  DBI::dbExecute(conn, query)
  DBI::dbDisconnect(conn)
  Sys.sleep(5)
})



test_that("A set of financial records is not appended to the DB because they are duplicate or because the DB connection is invalid", {
  date_from = "2024-03-26"
  date_to = "2024-03-27"
  index_ts1 = "apple_inc_aapl"
  index_ts2 = "meta_platforms_meta"

  conn <- connect_db()
  batch <- data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta"))
  batch_chunks <- split_batch(batch, 5)
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
    rows_appended <- insert_new_data(conn, 0, formatted_data)
    expect_equal(rows_appended, nrow(batch) * 5 * (27-26))
  }
  DBI::dbDisconnect(conn)
  Sys.sleep(5)

  conn <- connect_db()
  batch <- data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta"))
  batch_chunks <- split_batch(batch, 5)
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
    rows_appended <- insert_new_data(conn, 0, formatted_data)
    expect_equal(rows_appended, 0)
  }
  query = glue::glue_sql("DELETE FROM student_miguel.data_sp500
                          WHERE date = {date_from} AND
                         (index_ts = {index_ts1} OR index_ts = {index_ts2})", .con = conn)
  DBI::dbExecute(conn, query)
  DBI::dbDisconnect(conn)



  date_from = "2024-03-28"
  date_to = "2024-03-29"

  batch <- data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta"))
  batch_chunks <- split_batch(batch, 5)
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
    rows_inserted <- insert_new_data(conn, 0, formatted_data)
    expect_equal(rows_inserted, -1)
  }
})

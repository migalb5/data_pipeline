
conn <- connect_db()
DBI::dbBegin(conn)

test_that("A set of financial records is correctly appended to the DB", {
  date_from = "2024-03-26"
  date_to = "2024-03-27"
  index_ts1 = "apple_inc_aapl"
  index_ts2 = "meta_platforms_meta"
  batch <- data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta"))
  batch_chunks <- split_batch(batch, 5)

#  conn <- connect_db()
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
#    DBI::dbBegin(conn)
    rows_inserted <- insert_new_data(conn, 0, formatted_data)
#    DBI::dbCommit(conn)
    expect_gte(rows_inserted, 1)
  }
#  DBI::dbBegin(conn)
  query = glue::glue_sql("DELETE FROM student_miguel.data_sp500
                          WHERE date = {date_from} AND
                         (index_ts = {index_ts1} OR index_ts = {index_ts2})", .con = conn)
  DBI::dbExecute(conn, query)
#  DBI::dbCommit(conn)
#  DBI::dbDisconnect(conn)

#  conn <- connect_db()
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
#    DBI::dbBegin(conn)
    rows_inserted <- insert_new_data(conn, 285, formatted_data)
#    DBI::dbCommit(conn)
    expect_gte(rows_inserted, 1)
  }
#  DBI::dbBegin(conn)
  query = glue::glue_sql("DELETE FROM student_miguel.data_sp500
                          WHERE date = {date_from} AND
                         (index_ts = {index_ts1} OR index_ts = {index_ts2})", .con = conn)
  DBI::dbExecute(conn, query)
#  DBI::dbCommit(conn)
#  DBI::dbDisconnect(conn)

#  conn <- connect_db()
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
#    DBI::dbBegin(conn)
    rows_inserted <- insert_new_data(conn = conn, formatted_data = formatted_data)
#    DBI::dbCommit(conn)
    expect_gte(rows_inserted, 1)
  }
#  DBI::dbBegin(conn)
  query = glue::glue_sql("DELETE FROM student_miguel.data_sp500
                          WHERE date = {date_from} AND
                         (index_ts = {index_ts1} OR index_ts = {index_ts2})", .con = conn)
  DBI::dbExecute(conn, query)
  DBI::dbCommit(conn)
  DBI::dbDisconnect(conn)
  Sys.sleep(10)
})





test_that("A set of financial records is not appended to the DB because they are duplicate or because the DB connection is invalid", {
  date_from = "2024-03-27"
  date_to = "2024-03-28"
  index_ts1 = "apple_inc_aapl"
  index_ts2 = "meta_platforms_meta"
  batch <- data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta"))
  batch_chunks <- split_batch(batch, 5)

  conn <- connect_db()
  DBI::dbBegin(conn)
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
#    DBI::dbBegin(conn)
    rows_appended <- insert_new_data(conn, 0, formatted_data)
#    DBI::dbCommit(conn)
    expect_gte(rows_appended, 1)
  }
#  DBI::dbDisconnect(conn)
#  Sys.sleep(10)

#  conn <- connect_db()
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
#    DBI::dbBegin(conn)
    rows_appended <- insert_new_data(conn, 0, formatted_data)
#    DBI::dbCommit(conn)
    expect_equal(rows_appended, 0)
  }
#  DBI::dbBegin(conn)
  query = glue::glue_sql("DELETE FROM student_miguel.data_sp500
                          WHERE date = {date_from} AND
                         (index_ts = {index_ts1} OR index_ts = {index_ts2})", .con = conn)
  DBI::dbExecute(conn, query)
  DBI::dbCommit(conn)
  DBI::dbDisconnect(conn)



  date_from = "2024-03-28"
  date_to = "2024-03-29"

  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, date_from, date_to)
    formatted_data <- format_data(fin_data, batch)
    rows_inserted <- insert_new_data(conn, 0, formatted_data)
    expect_equal(rows_inserted, -1)
  }

  conn <- connect_db()
  query = glue::glue_sql("DELETE FROM student_miguel.data_sp500
                          WHERE date = {date_from} AND
                         (index_ts = {index_ts1} OR index_ts = {index_ts2})", .con = conn)
  DBI::dbExecute(conn, query)
  DBI::dbDisconnect(conn)
})


start_pipeline <- function () {
  conn <- connect_db()
  batch <- fetch_symbols(conn)
  batch_log <- build_summary_table()
  batch_chunks <- split_batch(batch, 20)
  i = 1
  for (chunk in batch_chunks) {
    fin_data <- yahoo_query_data(chunk, "2024-04-01", "2024-04-03")
    formatted_data <- format_data(fin_data, batch)
    tot_rows_inserted <- insert_new_data(conn, 0, formatted_data)
    batch_log <- log_summary(conn, batch_log, Sys.getenv("PG_USER"), i, chunk, tot_rows_inserted)
    i = i + 1
  }
  push_summary_table(conn, batch_log)
  DBI::dbDisconnect(conn)
}


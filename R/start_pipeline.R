
#' Runs a data-fetching iteration of the data pipeline
#'
#' @param start_date The date (as a string in the format YYYY-MM-DD) of the first day for which data is to be fetched. By default, it is the date of yesterday.
#' @param end_date The date (as a string in the format YYYY-MM-DD) of the day after the last day for which data is to be fetched. By default, it is the date of today.
#' @param chunk_size The size upon which the batch (of company symbols) will be split, for processing (financial data acquisition from Yahoo!Finance). Default value is 20.
#'
#' @returns Nothing.
#' @export
#'
#' @examples
#' \dontrun{
#' start_pipeline()
#' start_pipeline("2024-04-01", "2024-04-03")
#' start_pipeline("2024-04-01", "2024-04-30")
#' start_pipeline("2024-05-01", "2024-05-31", 35)
#' start_pipeline(chunk_size = 25)
#' }
start_pipeline <- function (start_date = Sys.Date() - 1, end_date = Sys.Date(), chunk_size = 20) {
  # check validity of all function arguments: missing
  message(paste("Data fetching process started. Period: ", start_date, " to ", end_date))
  conn <- connect_db()
  batch <- fetch_symbols(conn)
  if (!is.null(batch)) {
    batch_log <- build_summary_table()
    batch_chunks <- split_batch(batch, as.integer(chunk_size))
    i = 1
    tot_rows_inserted = 0
    for (chunk in batch_chunks) {
      message(paste("Batch chunk: ", i ))
      message(paste("Symbols: ", chunk))
      fin_data <- yahoo_query_data(chunk, start_date, end_date)
      formatted_data <- format_data(fin_data, batch)
      rows_inserted <- insert_new_data(conn, 0, formatted_data)
      if (rows_inserted >= 0) {
        batch_log <- log_summary(batch_log, Sys.getenv("PG_USER"), i, chunk, rows_inserted)
        tot_rows_inserted = tot_rows_inserted + rows_inserted
      }
      i = i + 1
    }
    message(paste("Total symbol records inserted: ", tot_rows_inserted))
    message(paste("Symbol quantity: ", nrow(batch)))
    push_summary_table(conn, batch_log)
    DBI::dbDisconnect(conn)
  } else {
    message("Error: Batch of symbols could not be created. Aborting...")
  }
  message("Data fetching process completed.")
}


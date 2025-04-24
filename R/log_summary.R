
#' Generates and stores a (log) record with details about the processing of batch chunk in the Summary Table (a tibble).
#'
#' @param batch_log The existing Summary Table (as a tibble -- should be created by build_summary_table() or updated by this function).
#' @param user_login The username (a string) of the user connecting to the DB.
#' @param chunk_id The chunk count identifier (for the batch): an integer starting at 1.
#' @param symbols The list of company symbols and corresponding index_ts. (index_ts data is missing in the examples and in the tests!)
#' @param rows_inserted The quantity of financial records inserted in the DB.
#'
#' @returns The updated version of the Summary Table, with the log record added; a record is added to the log regardless of if financial records are added or not to the DB (in the student_miguel.data_sp500 table).
#'
#' @examples
#' \dontrun{
#' log <- log_summary(log, "miguel", 1, data.frame(symbol = c("AAPL", "META")), 4)
#' log <- log_summary(log, "miguel", 5, data.frame(symbol = c("AAPL", "META")), 0)
#' }
log_summary <- function (batch_log, user_login, chunk_id, symbols, rows_inserted) {
#  browser()
  if (rows_inserted > 0) {
    batch_log <- dplyr::add_row(batch_log, user_login = user_login,
                                           batch_id = chunk_id,
                                           symbol = paste(symbols$symbol, collapse = ","),
                                           status = "ok",
                                           n_rows = rows_inserted,
                                           message = "Batch chunk processed.")
  } else {
    batch_log <- dplyr::add_row(batch_log, user_login = user_login,
                                           batch_id = chunk_id,
                                           symbol = paste(symbols$symbol, collapse = ","),
                                           status = "ok",
                                           n_rows = 0,
                                           message = "No new records to insert.")
  }
#  browser()
  return(batch_log)
}


#' Title
#'
#' @param conn
#' @param batch_log
#' @param user_login
#' @param chunk_id
#' @param symbols
#'
#' @returns
#' @export
#'
#' @examples
log_summary <- function (conn, batch_log, user_login, chunk_id, symbols, tot_rows_inserted) {
#  browser()
  if (tot_rows_inserted > 0) {
    batch_log <- add_row(batch_log, user_login = user_login,
                                    batch_id = chunk_id,
                                    symbol = paste(symbols$symbol, collapse = ","),
                                    status = "ok",
                                    n_rows = tot_rows_inserted,
                                    message = "Batch chunk processed.")
  } else {
    batch_log <- add_row(batch_log, user_login = user_login,
                                    batch_id = chunk_id,
                                    symbol = paste(symbols$symbol, collapse = ","),
                                    status = "ok",
                                    n_rows = 0,
                                    message = "No new records to insert.")
  }
#  browser()
  return(batch_log)
}

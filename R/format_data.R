
#' Re-structures financial data received from Yahoo!Finance API call into a structure directly compatible with DB table student_miguel.data_sp500 (for straightforward appending of records).
#'
#' @param fin_data The financial data (a data frame) obtained from Yahoo!Finance.
#' @param symbols A set of company symbols and associated index_ts, typically covering all the same symbols present in the financial data.
#'
#' @returns A data frame containing the same data (as fin_data) but with the required pre-defined structure / format.
#'
#' @examples
#' \dontrun{
#' df <- data.frame(symbol = c("AAPL", "META"), index_ts = c("apple_inc_aapl", "meta_platforms_meta"))
#' data_restructured <- format_data(fin_data, df)
#' }
format_data <- function (fin_data, symbols) {
  fin_data$adjusted = NULL
#  browser()
  longer <- tidyr::pivot_longer(fin_data, cols = c(open, high, low, close, volume), names_to = "metric", values_to = "value")
#  browser()
  joined <- dplyr::left_join(longer, symbols, by = "symbol")
  joined$symbol = NULL
#  browser()
  return(joined)
}


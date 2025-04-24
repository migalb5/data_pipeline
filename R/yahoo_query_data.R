
#' Obtains financial data for the set of company symbols provided for the date period specified (including date_from, but excluding date_to).
#'
#' @param chunk Set of company symbols (data frame of 1 column named "symbol").
#' @param date_from Date (string in format "YYYY-MM-DD") since when financial data should be obtained.
#' @param date_to Date (string in format "YYYY-MM-DD") until when financial data should be obtained (data is only obtained until the day before the date provided).
#'
#' @returns A data frame containing the financial data as obtained from the call to Yahoo!Finance's API.
#'
#' @examples
#' \dontrun{
#' fin_data <- yahoo_query_data(data.frame(symbol = c("AAPL", "META")), "2024-04-01", "2024-04-03")
#' fin_data <- yahoo_query_data(data.frame(symbol = c("AAPL", "META")), "2024-04-04", "2024-04-05")
#' }
yahoo_query_data <- function (chunk, date_from, date_to) {
  df <- tidyquant::tq_get(x = chunk, from = date_from, to = date_to)
#  browser()
  return(df)
}

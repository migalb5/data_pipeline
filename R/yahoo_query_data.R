
#' Title
#'
#' @param chunk
#' @param date_from
#' @param date_to
#'
#' @returns
#' @export
#'
#' @examples
yahoo_query_data <- function (chunk, date_from, date_to) {
  df <- tidyquant::tq_get(x = chunk, from = date_from, to = date_to)
#  browser()
  return(df)
}

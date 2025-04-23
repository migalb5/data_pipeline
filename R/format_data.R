
#' Title
#'
#' @param fin_data
#' @param symbols
#'
#' @returns
#' @export
#'
#' @examples
format_data <- function (fin_data, symbols) {
  fin_data$adjusted = NULL
#  browser()
  longer <- pivot_longer(fin_data, cols = c(open, high, low, close, volume), names_to = "metric", values_to = "value")
#  browser()
  joined <- left_join(longer, symbols, by = "symbol")
  joined$symbol = NULL
#  browser()
  return(joined)
}


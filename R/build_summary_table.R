
#' Title
#'
#' @returns
#' @export
#'
#' @examples
build_summary_table <- function () {
  tbl <- tibble(
    user_login = character(),
    batch_id = numeric(),
    symbol = character(),
    status = character(),
    n_rows = numeric(),
    message = character()
  )
  return(tbl)
}



#' Generates an empty summary table (as a tibble ready for storing log records (1 for each batch chunk processed)).
#'
#' @returns A tibble (data frame) ready for storing data fetching log records (with the predefined structure ready for inserting in the student_miguel.pipeline_logs DB table).
#'
#' @examples
#' \dontrun{
#' tbl <- build_summary_table()
#' }
build_summary_table <- function () {
  tbl <- tibble::tibble(
    user_login = character(),
    batch_id = numeric(),
    symbol = character(),
    status = character(),
    n_rows = numeric(),
    message = character()
  )
  return(tbl)
}


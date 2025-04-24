
#' Appends a summary table to the student_miguel.pipeline_logs DB table.
#'
#' @param conn A DB connection.
#' @param batch_log The summary table (as a tibble) containing the records to be appended (and using a structure matching the DB table); this object should be created using build_summary_table() and populated using log_summary().
#'
#' @returns TRUE, if the append operation was successful; FALSE, otherwise.
#'
#' @examples
#' \dontrun{
#' result <- push_summary_table(conn, batch_log)
#' }
push_summary_table <- function (conn, batch_log) {
#  browser()
  if (DBI::dbIsValid(conn)) {
    result <- RPostgres::dbAppendTable(conn, DBI::Id(schema = "student_miguel", table = "pipeline_logs"), batch_log)
    if (result > 0) {
      message("Summary table successfully written to DB.")
      return(TRUE)
    }
  }
  message("Error: Summary table not written to DB!")
  return(FALSE)
}


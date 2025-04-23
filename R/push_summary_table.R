
#' Title
#'
#' @param conn
#' @param batch_log
#'
#' @returns
#' @export
#'
#' @examples
push_summary_table <- function (conn, batch_log) {
#  browser()
  if (DBI::dbIsValid(conn)) {
    DBI::dbAppendTable(conn, Id(schema = "student_miguel", table = "pipeline_logs"), batch_log)
  }
}


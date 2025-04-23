
#' Title
#'
#' @param conn
#' @param next_id
#' @param formatted_data
#'
#' @returns
#' @export
#'
#' @examples
insert_new_data <- function (conn, next_id = 0, formatted_data) {
  query = glue::glue_sql("SELECT MAX(id) FROM student_miguel.data_sp500", .con = conn)
  df <- DBI::dbGetQuery(conn, query)
  last_id <- as.integer(df[[1]])
#  browser()
  if (next_id <= last_id) next_id = last_id + 1
  formatted_data$id <- seq(from = next_id, by = 1, length.out = nrow(formatted_data))
#  browser()

  # checking for duplicate records
  #tuples_to_check <- formatted_data %>% group_by(index_ts, date)
  query = glue::glue_sql("SELECT index_ts, date FROM student_miguel.data_sp500
                         GROUP BY index_ts, date
                         ORDER BY index_ts ASC", .con = conn)
  tuples_already_inserted <- DBI::dbGetQuery(conn, query)
#  browser()
  new_data <- anti_join(formatted_data, tuples_already_inserted, by = c("index_ts", "date"))
#  browser()

  if (nrow(new_data) > 0) {
    if (DBI::dbIsValid(conn)) {
      tot_rows_inserted <- DBI::dbAppendTable(conn, Id(schema = "student_miguel", table = "data_sp500"), new_data)
      message(paste(tot_rows_inserted, "(new) chunk records appended to DB."))
      return(tot_rows_inserted)
    } else {
      message(paste("Error: Appending (new) chunk records to DB has failed! Starting record ID: "), next_id)
      return(FALSE)
    }
  } else {
    message("Warning: No new chunk records found to be appended to DB.")
    return(0)
  }
}



#' Appends a group of financial records (corresponding to a chunk) to the student_miguel.data_sp500 DB table; all records are tested for duplicates (with regard to data already in the DB table).
#'
#' @param conn A DB connection.
#' @param next_id The next valid / available record identifier (an integer) to use as the starting unique identifier for the (first record of the) group of records to be inserted; if not specified, it is zero by default, which will trigger its automatic determination based on the last (highest value) currently in the DB table.
#' @param formatted_data The group of financial records to be inserted (already formatted for direct appending to the DB table -- as per format_data()).
#'
#' @returns The quantity of records actually inserted in the DB, or, otherwise, the value -1 (in case a DB connection is not valid when needed).
#'
#' @examples
#' \dontrun{
#' result <- insert_new_data(conn, formatted_data = formatted_data)
#' result <- insert_new_data(conn, 0, formatted_data)
#' result <- insert_new_data(conn, 999999999, formatted_data)
#' }
insert_new_data <- function (conn, next_id = 0, formatted_data) {
  if (DBI::dbIsValid(conn)) {
    query = glue::glue_sql("SELECT MAX(id) FROM student_miguel.data_sp500", .con = conn)
    df <- DBI::dbGetQuery(conn, query)
  } else {
    return(-1)
  }
  last_id <- as.integer(df[[1]])
#  browser()
  if (next_id <= last_id) next_id = last_id + 1
  formatted_data$id <- seq(from = next_id, by = 1, length.out = nrow(formatted_data))
#  browser()

  # checking for duplicate records
  #tuples_to_check <- formatted_data %>% group_by(index_ts, date)
  if (DBI::dbIsValid(conn)) {
    query = glue::glue_sql("SELECT index_ts, date FROM student_miguel.data_sp500
                           GROUP BY index_ts, date
                           ORDER BY index_ts ASC", .con = conn)
    tuples_already_inserted <- DBI::dbGetQuery(conn, query)
  } else {
    return(-1)
  }
#  browser()
  new_data <- dplyr::anti_join(formatted_data, tuples_already_inserted, by = c("index_ts", "date"))
#  browser()

  if (nrow(new_data) > 0) {
    if (DBI::dbIsValid(conn)) {
      rows_inserted <- RPostgres::dbAppendTable(conn, DBI::Id(schema = "student_miguel", table = "data_sp500"), new_data)
      message(paste(rows_inserted, "(new) chunk records appended to DB."))
      return(rows_inserted)
    } else {
      message(paste("Error: Appending (new) chunk records to DB has failed! Starting record ID: "), next_id)
      return(-1)
    }
  } else {
    message("Warning: No new chunk records found to be appended to DB.")
    return(0)
  }
}


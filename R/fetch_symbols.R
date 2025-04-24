
#' Obtains a list of index_ts and symbol pairs
#'
#' @param conn A (DBI/Postgres) connection to the database from which reference data is read and result data is written to.
#'
#' @returns A data frame containing the pairs (index_ts, symbol) found in the reference data table; or NULL, in case of a non-valid DB connection.
#'
#' @examples
#' \dontrun{
#' conn <- connect_db()
#' symbols <- fetch_symbols(conn)
#' }
fetch_symbols <- function (conn) {
  if (DBI::dbIsValid(conn)) {
    query = glue::glue_sql("SELECT DISTINCT index_ts, symbol FROM sp500.info
                          ORDER BY symbol ASC", .con = conn)
    df <- DBI::dbGetQuery(conn, query)
    return(df)
  }
  return(NULL)
}

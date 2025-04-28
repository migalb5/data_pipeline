
#' Divides the list of symbols (the batch) into separate sections (chunks), so that the Yahoo!Finance API does not get overloaded when the calls are made.
#'
#' @param batch A data frame containing a list of symbols (with at least 1 column named "symbol").
#' @param chunk_size The size (an integer greater than zero) of each section (chunk).
#'
#' @returns A list of data frames containing each 1 column (named "symbol") of size equal to chunk_size; in case chunk_size is invalid, then a default value of 20 is assumed.
#'
#' @examples
#' \dontrun{
#' batch_chunks <- split_batch(batch, 50)
#' }
split_batch <- function (batch, chunk_size) {
  batch <- batch[, "symbol", drop = FALSE] # removes all columns from original data frame except the one named "symbol"

  if (!is.numeric(chunk_size) || as.numeric(chunk_size) < 1) chunk_size = 20

  return(split(batch, ceiling(seq_len(nrow(batch)) / chunk_size)))
}

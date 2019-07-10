#' Converts icite_api information into a dataframe
#'
#' \code{to_dataframe} converts the parsed csv from icite_api into a dataframe
#'
#' @param info S3. The S3 object returned from \code{icite_api}
#' @param error logical. Indicates whether the \code{icite_api} call resulted in an error.
#'
#' @return All values from the icite_api reformatted into a dataframe.
#' see \url{https://icite.od.nih.gov/api} for details.
#'
#' @keywords internal
to_dataframe <- function (info, error = FALSE) {

  # If there's no error, return the data in a dataframe--------
  if (error==FALSE) {
    out <- info$content
    return(out)
  }

  # If there is an error, return NA's--------------------------
  if (error==TRUE) {
    out <- data.frame(pmid                        = info,
                      doi                         = NA,
                      authors                     = NA,
                      citation_count              = NA,
                      citations_per_year          = NA,
                      expected_citations_per_year = NA,
                      field_citation_rate         = NA,
                      is_research_article         = NA,
                      journal                     = NA,
                      nih_percentile              = NA,
                      relative_citation_ratio     = NA,
                      title                       = NA,
                      year                        = NA)
  }

}

#' takes a vector of PMIDs and returns the icite information for them.
#'
#' \code{get_metrics} is the main function for iCiteR. It takes a vector
#' of character pubmed ids and returns a dataframe of the information yielded
#' by the icite api.
#'
#' @param pmids character. A vector of pubmed IDs
#'
#' @return All values from the icite_api reformatted into a dataframe.
#' see \url{https://icite.od.nih.gov/api} for details.
#'
#' @examples
#' get_metrics('27599104')
#' @export
get_metrics <- function (pmids) {

  # split into chunks of 200 pmids ----------------------------
  chunk_size = 200
  n_iterations = ceiling(length(pmids) / chunk_size)
  if (n_iterations > 1) pb = txtProgressBar(label="Accessing iCite API:", style=3)

  # make empty dataframe to catch results ---------------------
  tempdat <- data.frame()
  for (i in 0:(n_iterations - 1)) {
    if (n_iterations > 1) setTxtProgressBar(pb, i / (n_iterations - 1))
    start = 1 + i * chunk_size
    end = min(length(pmids), chunk_size * (i + 1))
    out <- tryCatch( {
      to_dataframe(icite_api(pmids[start:end]))
    },
    error = function (err) {
      return(to_dataframe(pmids[start:end], error=TRUE))
    })
    tempdat <- rbind(tempdat, out)

    # sleep briefly between each call to be polite ------------
    Sys.sleep(.1)
  }
  return(tempdat)
}

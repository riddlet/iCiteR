#' Query the iCite api
#'
#' \code{icite_api} returns the parsed results of a single call to the iCite api
#'
#' @param pmids character vector. The pubmed ID to be queried
#'
#' @return If the call runs without error, the output is a simple S3 object
#' @examples
#' dat <- icite_api('27599104')
#' print(dat)
#' @export
icite_api <- function (pmids) {
  # include integer IDs
  pmids_valid = stats::na.omit(as.integer(pmids))
  if (length(pmids_valid) == 0) {
    stop("No valid pubmed IDs detected. Please provide integer values, or
         their character representation. Try: 27599104")
  }

  # construct the API query ----------------------------------
  pth <- paste0('icite/api/pubs?pmids=', paste(pmids_valid, collapse=","), "&format=csv")
  url <- httr::modify_url('https://itools-test.od.nih.gov/', path=pth)
  resp <- httr::GET(url)

  # If csv is returned, parse it ----------------------------
  if (httr::http_type(resp) != 'text/csv') {
    stop('API did not return csv.', call. = FALSE)
  }
  parsed <- utils::read.csv(textConnection(httr::content(resp, 'text', encoding = 'UTF-8')), stringsAsFactors = F, encoding = "UTF-8")

  # If the request fails, print the reason -------------------
  if (httr::http_error(resp)) {
    stop(if (resp$status_code == 404) {
      sprintf(
        "
        iCite API request failed [%s] : %s\n\n
        Check your pubmed ID. iCite provides citation data back to 1995, and
        recent papers may not be available. See https://icite.od.nih.gov/stats
        and https://icite.od.nih.gov/help for details of the available data.
        ",
        httr::status_code(resp),
        parsed$error
      )
    } else{
      sprintf("iCite API request failed [%s]\n%s",
              httr::status_code(resp),
              parsed$error)
      call. = FALSE
    })
  }

  # structure the content of the response --------------------
  structure(
    list(
      content = parsed,
      path = pth,
      response = resp
    ),
    class='icite_api'
  )
}

#' A simple print method for the icite_api function
#'
#' \code{print.icite_api} prints the data returned from the icite_api function
#'
#' @param x S3. The S3 object yielded from \code{icite_api}
#' @param ... Additional arguments that would be passed to \code{print}
#'
#' @examples
#' dat <- icite_api('27599104')
#' print(dat)
#' @importFrom utils str
#' @export
print.icite_api <- function (x, ...) {
  cat('<iCite ', x$path, '>\n', sep='')
  str(x$content)
  invisible(x)
}

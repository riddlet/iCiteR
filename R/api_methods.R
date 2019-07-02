#' Query the iCite api
#'
#' \code{icite_api} returns the parsed results of a single call to the iCite api
#'
#' @param pmid character. The pubmed ID to be queried
#'
#' @return If the call runs without error, the output is a simple S3 object
#' @examples
#' dat <- icite_api('27599104')
#' print(dat)
#' @export
icite_api <- function (pmid) {

  # construct the API query ----------------------------------
  pth <- paste('api/pubs/', pmid, sep='')
  url <- httr::modify_url('https://icite.od.nih.gov/', path=pth)
  resp <- httr::GET(url)

  # If json is returned, parse it ----------------------------
  if (httr::http_type(resp) != 'application/json') {
    stop('API did not return json.', call. = FALSE)
  }
  parsed <- jsonlite::fromJSON(httr::content(resp, 'text'), simplifyVector=FALSE)

  # If the request fials, print the reason -------------------
  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "iCite API request failed [%s]\n%s",
        httr::status_code(resp),
        parsed$error
      ),
      call. = FALSE
    )
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

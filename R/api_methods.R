#' Query the iCite api
#'
#' \code{icite_api} returns the parsed results of a single call to the iCite API
#'
#' @param pmids character vector. The pubmed ID to be queried
#'
#' @return If the call runs without error, the output is a simple S3 object
#' @examples
#' dat <- icite_api('27599104')
#' print(dat)
#' @export
icite_api <- function(pmids) {


    # construct the API query ----------------------------------
    pth <- construct_query(query_type='pmid', pmids=pmids)
    url <- httr::modify_url("https://icite.od.nih.gov/", path = pth)
    resp <- httr::GET(url)

    # If csv is returned, parse it ----------------------------
    if (httr::http_type(resp) != "text/csv") {
        stop("API did not return csv.", call. = FALSE)
    }
    parsed <- utils::read.csv(textConnection(
      httr::content(resp, "text", encoding = "UTF-8")),
      stringsAsFactors = F, encoding = "UTF-8")

    # If the request fails, print the reason -------------------
    if (httr::http_error(resp)) {
        stop(if (resp$status_code == 404) {
            sprintf("
        iCite API request failed [%s] : %s\n\n
        Check your pubmed ID. iCite provides citation data back to 1995, and
        recent papers may not be available. See https://icite.od.nih.gov/stats
        and https://icite.od.nih.gov/user_guide?page_id=ug_overview for details of the available data.
        ",
                httr::status_code(resp), parsed$error)
        } else {
            sprintf("iCite API request failed [%s]\n%s",
                    httr::status_code(resp), parsed$error)
            call. = FALSE
        })
    }

    # structure the content of the response --------------------
    structure(list(content = parsed, path = pth, response = resp), class = "icite_api")
}

#' create the url extension for an iCite API call
#'
#' \code{construct_query} constructs the url extension for an iCite API call
#'
#' @param query_type character. The type of query being constructed. Limited to
#'   'pmid' or 'search'. If 'pmid', then you must provide a vector of pmids.
#' @param pmids character or numeric. A vector of pmids to be queried. If
#'   `query_type` is set to 'pmid', this is the only argument used. All others
#'   will be ignored.
#'
#' @param year character or numeric. The year to be searched.
#' @param offset character. The lowest PMID to be returned.
#' @param limit character. Maximum number of entries to return.
#' @keywords internal
#'
construct_query <- function(query_type = 'pmid', pmids = NA,
                            year = NA, offset = NA, limit = NA){

  # pmid queries are much simpler ----------------------------
  if (query_type=='pmid'){
    # include integer IDs
    pmids_valid = stats::na.omit(as.integer(pmids))
    if (length(pmids_valid) == 0) {
      stop("No valid pubmed IDs detected. Please provide integer values, or
         their character representation. Try: 27599104")
    }
    pth <- paste0("api/pubs?pmids=",
                  paste(pmids_valid, collapse = ","), "&format=csv")

  } else {

    # construct the API query ----------------------------------
    pth <- 'api/pubs?'
    first <- TRUE

    # need to keep track of which is first & prepend '&' to subsequent args ---
    if(!is.na(year)){
      pth <- paste0(pth, 'year=', year)
      first <- FALSE
    }
    if(!is.na(offset)) {
      if(first==TRUE){
        pth <- paste0(pth, 'offset=', offset)
        first <- FALSE
      } else {
        pth <- paste0(pth, '&offset=', offset)
      }
    }
    if(!is.na(limit)) {
      if(first==TRUE){
        pth <- paste0(pth, 'limit=', limit)
        first <- FALSE
      } else {
        pth <- paste0(pth, '&limit=', limit)
      }
    }
    pth <- paste0(pth, '&format=csv')
  }

  return(pth)
}

#' Query the iCite API using a search strategy
#'
#' \code{icite_search} returns the parsed results of a single call to the iCite API
#'
#' @param year character or numeric. The year whose data you would like
#' @param offset character. The minimum PMID you would like to
#' have returned
#' @param limit character. The maximum number of records you would
#' like returned. There is a maximum of 1000 for a single call.
#'
#' @return If the call runs without error, the output is a simple S3 object
#' @examples
#' dat <- icite_search(year=2012, offset = 18008027, limit=10)
#' print(dat)
#' @export
icite_search <- function(year=NA, offset=NA, limit=NA) {

  # Warn user about the conflict between limit & page -------------
  if (!is.na(limit) && as.numeric(limit)>1000) {
    stop("A single call can return a maximum of 1000 records. Set limit to 1000 or less",
         call. = FALSE)
  }

  # send the request ----------------------------------------
  pth <- construct_query(query_type='search', year=year,
                         offset=offset, limit=limit)
  url <- httr::modify_url("https://icite.od.nih.gov/", path = pth)
  resp <- httr::GET(url)

  # If csv is returned, parse it ----------------------------
  if (httr::http_type(resp) != "text/csv") {
    stop("API did not return csv.", call. = FALSE)
  }
  parsed <- utils::read.csv(textConnection(
    httr::content(resp, "text", encoding = "UTF-8")),
    stringsAsFactors = F, encoding = "UTF-8")

  # If the request fails, print the reason -------------------
  if (httr::http_error(resp)) {
    sprintf("iCite API request to %s failed [%s]\n%s",
            pth, httr::status_code(resp), parsed$error)
    call. = FALSE
    }

  # structure the content of the response --------------------
  structure(list(content = parsed,
                 path = pth, response = resp), class = "icite_api")
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
print.icite_api <- function(x, ...) {
    cat("<iCite request: ", x$path, ">\n", sep = "")
    str(x$content)
    invisible(x)
}

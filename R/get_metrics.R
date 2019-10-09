#' Converts icite_api information into a dataframe
#'
#' \code{to_dataframe} converts the parsed csv from icite_api into a dataframe
#'
#' @param info S3. The S3 object returned from \code{icite_api}
#' @param error logical. Indicates whether the \code{icite_api} call resulted
#' in an error.
#' @param call_type character. Indicates whether the data is from a call to
#' \code{icite_api} (`pmid`) or \code{icite_search} (`search`)
#'
#' @return All values from the icite_api reformatted into a dataframe.
#' see \url{https://icite.od.nih.gov/api} for details.
#'
#' @keywords internal
to_dataframe <- function(info, error = FALSE, call_type = 'pmid') {

    # If there's no error, return the data in a dataframe--------
    if (error == FALSE) {
        out <- info$content
        return(out)
    }

    # If there is an error, return appropriate info---------------
    if (error == TRUE) {
      # for a pmid query, just fill a df with NAs-----------------
      if (call_type=='pmid'){
        out <- data.frame(pmid = info,
                          year = NA,
                          title = NA,
                          authors = NA,
                          journal = NA,
                          is_research_article = NA,
                          relative_citation_ratio = NA,
                          nih_percentile = NA,
                          human = NA,
                          animal = NA,
                          molecular_cellular = NA,
                          apt = NA,
                          is_clinical = NA,
                          citation_count = NA,
                          citations_per_year = NA,
                          expected_citations_per_year = NA,
                          field_citation_rate = NA,
                          provisional = NA,
                          x_coord = NA,
                          y_coord = NA,
                          cited_by_clin = NA,
                          cited_by = NA,
                          references = NA,
                          doi = NA)

        # for a search query, return the info from the http request -----------
      } else {
        message('There was an error in the API request: ')
        print(info)
      }
    }

}

#' takes a vector of PMIDs and returns the iCite information for them.
#'
#' \code{get_metrics} takes a vector of character pubmed ids and returns a
#' dataframe of the information yielded by the iCite API.
#'
#' @param pmids character. A vector of pubmed IDs
#'
#' @return All values from the iCite API reformatted into a dataframe.
#' see \url{https://icite.od.nih.gov/api} for details.
#'
#' @examples
#' get_metrics('27599104')
#' @export
get_metrics <- function(pmids) {

    # split into chunks of 200 pmids ----------------------------
    chunk_size <- 200
    n_iterations <- ceiling(length(pmids)/chunk_size)
    if (n_iterations > 1)
        pb <- utils::txtProgressBar(label = "Accessing iCite API:", style = 3)

    # make empty dataframe to catch results ---------------------
    tempdat <- data.frame()
    for (i in 0:(n_iterations - 1)) {
        if (n_iterations > 1)
            utils::setTxtProgressBar(pb, i/(n_iterations - 1))
        start <- 1 + i * chunk_size
        end <- min(length(pmids), chunk_size * (i + 1))
        out <- tryCatch({
            to_dataframe(icite_api(pmids[start:end]))
        }, error = function(err) {
            return(to_dataframe(pmids[start:end], error = TRUE,
                                call_type='pmid'))
        })
        tempdat <- rbind(tempdat, out)

        # sleep briefly between each call to be polite ------------
        Sys.sleep(0.1)
    }
    return(tempdat)
}

#' Searches the icite database for entries that match the entered criteria
#'
#' \code{search metrics} takes a set of search criteria and returns a dataframe
#' of the information yielded by the iCite API.
#'
#' @param year character or numeric. The year whose data you would like
#' @param offset character. The minimum PMID you would like to have
#'   returned
#' @param limit character. The maximum number of records you would
#'   like returned. There is a maximum of 1000 for a single call.
#' @param page logical. Do you want to continue paging through the API until
#'   there is no new data returned (paging without a limit may take several
#'   hours to complete)?
#'
#' @return All values from the icite_api reformatted into a dataframe. See
#'   \url{https://icite.od.nih.gov/api} for details.
#'
#' @examples
#' search_metrics(year=2012, offset='1800000', limit='2000', page=TRUE)
#' @export
search_metrics <- function(year=NA, offset = NA, limit=NA, page = FALSE) {

  # we need character input to avoid automated scientific notation formatting -
  limit <- as.numeric(limit)

  if(page==TRUE){
    if(is.na(limit)){

      # Warn the user that paging with no limit could take a while -------------
      message('A call to search_metrics without a limit may take up to several hours to complete')
      tempdat <- page_no_limit(year=year, offset=offset)

      } else {

        tempdat <- page_limited(year=year, offset=offset, limit=limit)
    }

    # paging turned off -------------------------------------
  } else {

    # settings, warnings ------------------------------------
    pushed_limit <- as.character(min(1000, limit))
    if(!is.na(limit)){
      if(limit>1000) {
        message('Only returning 1000 entries. If you want more, turn set page=TRUE')
      }
    }

    tempdat <- tryCatch({
      dat <- icite_search(year=year, offset=offset, limit=pushed_limit)

      # if there call is misspecified -----------------------
      if ('error' %in% names(dat$content)){
        to_dataframe(dat, error = TRUE, call_type='search')
      } else {
        to_dataframe(dat)
      }
      #handling any other errors that may occur ------------------
    }, error = function(err) {
      to_dataframe(construct_query(query_type='search', year=year,
                                   offset=offset, limit=pushed_limit),
                   error = TRUE, call_type='search')
    })

  }
  return(tempdat)
}

#' Pages through iCite results until there is no new data
#'
#' \code{page_no_limit} aggregates results from iCite until there is no new
#' data returned
#'
#' @param year character. The year whose data you would like
#' @param offset character. The minimum PMID you would like to have
#'   returned
#'
#' @return All values from the icite_api reformatted into a dataframe.
#' see \url{https://icite.od.nih.gov/api} for details.
#'
#' @keywords internal
page_no_limit <- function(year=year, offset=offset) {

  #settings for the while loop to check -------------------
  remaining_dat <- TRUE
  page <- 1
  start <- Sys.time()

  # make empty dataframe to catch results ---------------------
  tempdat <- data.frame()

  while(remaining_dat == TRUE){
    out <- tryCatch({
      dat <- icite_search(year=year, offset=offset)

      # misspecified calls still return data, so handle it as follows
      if ('error' %in% names(dat$content)){
        to_dataframe(dat, error = TRUE, call_type='search')

      } else {
        to_dataframe(dat)
      }
      #handling any other errors that may occur -------------------
    }, error = function(err) {
      to_dataframe(construct_query(query_type='search', year=year,
                                   offset=offset),
                   error = TRUE, call_type='search')
    })

    # revise settings for while loop -----------------------------
    if(is.data.frame(out)){
      suppressWarnings(offset <- max(out$pmid))
      tempdat <- rbind(tempdat, out)
      if(dim(out)[1]==0) remaining_dat <- FALSE
    }

    # update user on how things are going -----------------------
    if (page %% 10 == 0) {
      now <- Sys.time()
      d <- difftime(now, start)
      cat(sprintf('search_metrics has been running for %s %s and has made %i API calls. The dataframe is currently %i rows long.', round(d[[1]], 2),
                  attr(d, 'units'), page, dim(tempdat)[1]))
    }
    page <- page+1
    # sleep briefly between each call to be polite ------------
    Sys.sleep(0.1)
  }
  return(tempdat)
}

#' Pages through iCite results until the limit is reached or there is no
#' new data
#'
#' \code{page_no_limit} aggregates results from iCite until the limit is
#' reached or there is no new data
#'
#' @param year character. The year whose data you would like
#' @param offset character. The minimum PMID you would like to have
#' @param limit character. The maximum number of records you would
#'   like returned. There is a maximum of 1000 for a single call.
#'
#' @return All values from the icite_api reformatted into a dataframe.
#' see \url{https://icite.od.nih.gov/api} for details.
#'
#' @keywords internal
page_limited <- function(year=year, offset=offset, limit=limit) {

  # make empty dataframe to catch results ---------------------
  tempdat <- data.frame()

  # how many page calls will this take? ---------------------
  page <- 1
  start <- Sys.time()
  n_iterations <- ceiling(limit/1000)
  if (n_iterations > 1){
    pb <- utils::txtProgressBar(label = "Searching iCite API:", style = 3)
  }

  # settings for the while loop to check -----------------------
  remaining_dat <- TRUE
  limit_reached <- FALSE
  pushed_limit <- as.character(min(1000, limit))

  while(remaining_dat == TRUE && limit_reached==FALSE){
    out <- tryCatch({
      dat <- icite_search(year=year, offset=offset, limit=pushed_limit)

      # misspecified calls still return data, so handle it as follows
      if ('error' %in% names(dat$content)){
        to_dataframe(dat, error = TRUE, call_type='search')

      } else {
        to_dataframe(dat)
      }
      #handling any other errors that may occur -------------------
    }, error = function(err) {
      to_dataframe(construct_query(query_type='search', year=year,
                                   offset=offset, limit=pushed_limit),
                   error = TRUE, call_type='search')
    })

    # progress bar ----------------------------------------
    if (n_iterations > 1){
      utils::setTxtProgressBar(pb, page/(n_iterations - 1))
    }

    # revise settings for while loop ----------------------
    if(is.data.frame(out)){
      suppressWarnings(offset <- max(out$pmid))
      tempdat <- rbind(tempdat, out)
      if(dim(out)[1]==0) remaining_dat <- FALSE
      limit <- limit-as.numeric(pushed_limit)
      if(limit==0) limit_reached <- TRUE
      page <- page+1
    }
  }
  return(tempdat)
}

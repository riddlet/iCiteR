% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_metrics.R
\name{page_limited}
\alias{page_limited}
\title{Pages through iCite results until the limit is reached or there is no
new data}
\usage{
page_limited(year = year, offset = offset, limit = limit)
}
\arguments{
\item{year}{character. The year whose data you would like}

\item{offset}{character. The minimum PMID you would like to have}

\item{limit}{character. The maximum number of records you would
like returned. There is a maximum of 1000 for a single call.}
}
\value{
All values from the icite_api reformatted into a dataframe.
see \url{https://icite.od.nih.gov/api} for details.
}
\description{
\code{page_no_limit} aggregates results from iCite until the limit is
reached or there is no new data
}
\keyword{internal}

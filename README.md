
<!-- README.md is generated from README.Rmd. Please edit that file -->

# iCiteR

<!-- badges: start -->

[![Build
Status](https://travis-ci.org/riddlet/iCiteR.svg?branch=master)](https://travis-ci.org/riddlet/iCiteR)
<!-- badges: end -->

The iCiteR package is a minimal R package designed to help users
retrieve data from the NIH’s [iCite API](https://icite.od.nih.gov/api).
This includes the relative citation ratio, which you can read about
[here](https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002541).

## Installation

iCiteR is on [CRAN](https://CRAN.R-project.org) and can be installed
with:

``` r
install.packages("iCiteR")
```

Or you can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("riddlet/iCiteR")
```

## Example

There is just one function that will be of interest to most users:
`get_metrics`. This function takes as input a a vector of pubmed IDs and
returns all the information yielded by the iCite API.

Likely, most users will already have the PMIDs that correspond to the
articles for which they wish to obtain data. For a given article in
pubmed, the ID is also printed on the page

![The PMID for the Relative Citation Rate paper on
Pubmed](vignettes/RCR_PMID.jpg)

For a given PMID(s), one can get the relative citation rate and all
other data returned by the iCite API as follows

``` r
library(iCiteR)
get_metrics('27599104')
#>       pmid                          doi
#> 1 27599104 10.1371/journal.pbio.1002541
#>                                                           authors
#> 1 B Ian Hutchins, Xin Yuan, James M Anderson, George M Santangelo
#>   citation_count citations_per_year expected_citations_per_year
#> 1             47           15.66667                    2.930151
#>   field_citation_rate is_research_article    journal nih_percentile
#> 1            6.943039                TRUE PLoS Biol.           94.3
#>   relative_citation_ratio
#> 1                 5.34671
#>                                                                                                             title
#> 1 Relative Citation Ratio (RCR): A New Metric That Uses Citation Rates to Measure Influence at the Article Level.
#>   year
#> 1 2016
```

The function also takes a vector of PMIDS:

``` r
get_metrics(c('27599104', '27830815', '28968388', '28968381'))
#>       pmid                          doi
#> 1 27599104 10.1371/journal.pbio.1002541
#> 2 27830815              10.1038/539150a
#> 3 28968388 10.1371/journal.pbio.2002536
#> 4 28968381 10.1371/journal.pbio.2003552
#>                                                                                     authors
#> 1                           B Ian Hutchins, Xin Yuan, James M Anderson, George M Santangelo
#> 2                                                                               Gautam Naik
#> 3                    A Cecile J W Janssens, Michael Goodman, Kimberly R Powell, Marta Gwinn
#> 4 B Ian Hutchins, Travis A Hoppe, Rebecca A Meseroll, James M Anderson, George M Santangelo
#>   citation_count citations_per_year expected_citations_per_year
#> 1             47          15.666667                    2.930151
#> 2              5           1.666667                    3.807898
#> 3              4           2.000000                    3.126775
#> 4              1           0.500000                    2.298696
#>   field_citation_rate is_research_article    journal nih_percentile
#> 1            6.943039                TRUE PLoS Biol.           94.3
#> 2            9.204976               FALSE     Nature           23.4
#> 3            8.482253               FALSE PLoS Biol.           34.2
#> 4            6.235857               FALSE PLoS Biol.           10.9
#>   relative_citation_ratio
#> 1                5.346710
#> 2                0.437687
#> 3                0.639637
#> 4                0.217515
#>                                                                                                             title
#> 1 Relative Citation Ratio (RCR): A New Metric That Uses Citation Rates to Measure Influence at the Article Level.
#> 2                                                                     The quiet rise of the NIH's hot new metric.
#> 3                                A critical evaluation of the algorithm behind the Relative Citation Ratio (RCR).
#> 4                          Additional support for RCR: A validated article-level measure of scientific influence.
#>   year
#> 1 2016
#> 2 2016
#> 3 2017
#> 4 2017
```

If you would rather not have the results in a dataframe, it is possible
to obtain an S3 object for the data by using the `icite_api` function

``` r
dat <- icite_api('27599104')

print(dat)
#> <iCite api/pubs/27599104>
#> List of 13
#>  $ pmid                       : int 27599104
#>  $ doi                        : chr "10.1371/journal.pbio.1002541"
#>  $ authors                    : chr "B Ian Hutchins, Xin Yuan, James M Anderson, George M Santangelo"
#>  $ citation_count             : int 47
#>  $ citations_per_year         : num 15.7
#>  $ expected_citations_per_year: num 2.93
#>  $ field_citation_rate        : num 6.94
#>  $ is_research_article        : logi TRUE
#>  $ journal                    : chr "PLoS Biol."
#>  $ nih_percentile             : num 94.3
#>  $ relative_citation_ratio    : num 5.35
#>  $ title                      : chr "Relative Citation Ratio (RCR): A New Metric That Uses Citation Rates to Measure Influence at the Article Level."
#>  $ year                       : int 2016
```

If you are having trouble accessing the data for a particular PMID, the
`icite_api` function will also return somewhat more informative error
messages (development version only):

``` r
icite_api('42')
#> Error in icite_api("42"): 
#>         iCite API request failed [404] : no data on PMID '42'
#> 
#> 
#>         Check your pubmed ID. iCite provides citation data back to 1995, and
#>         recent papers may not be available. See https://icite.od.nih.gov/stats
#>         and https://icite.od.nih.gov/help for details of the available data.
#> 
```

It is worth noting that the iCite database presently goes back to 1995.
Earlier papers will not have any data associated with them. Also, recent
papers may not be available. See <https://icite.od.nih.gov/stats> and
<https://icite.od.nih.gov/help> for details of the iCite system that
this package works with.

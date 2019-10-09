
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

## Examples

There are two primary functions that will handle most of what the
typical user will want. The first, `get_metrics` takes as input a vector
of pubmed IDs and returns all the information yielded by the iCite API.
The second allows a user to query the iCite API for pubmed entries that
match a set of parameters.

### get\_metrics

To use `get_metrics`, you will likely already have the PMIDs that
correspond to the articles for which you wish to obtain data. For a
given article in pubmed, the ID is also printed on the page

![The PMID for the Relative Citation Rate paper on
Pubmed](vignettes/RCR_PMID.jpg)

For a given PMID(s), you can get the relative citation rate and all
other data returned by the iCite API as follows

``` r
library(iCiteR)
#> Loading iCiteR
get_metrics('27599104')
#>       pmid year
#> 1 27599104 2016
#>                                                                                                             title
#> 1 Relative Citation Ratio (RCR): A New Metric That Uses Citation Rates to Measure Influence at the Article Level.
#>                                                           authors
#> 1 B Ian Hutchins, Xin Yuan, James M Anderson, George M Santangelo
#>      journal is_research_article relative_citation_ratio nih_percentile
#> 1 PLoS Biol.                 Yes                    5.52           94.7
#>   human animal molecular_cellular  apt is_clinical citation_count
#> 1     1      0                  0 0.25          No             53
#>   citations_per_year expected_citations_per_year field_citation_rate
#> 1           17.66667                    3.201929            6.854116
#>   provisional x_coord y_coord cited_by_clin
#> 1          No       0       1            NA
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       cited_by
#> 1 28546354 30231116 28480055 28968381 30078658 28616253 30970066 30758873 28633401 30271298 27354417 27767221 27599158 28025905 29415003 28369324 26962436 30177900 28281870 28042752 31501771 30202870 29298181 29596415 29744377 29707257 30429933 29230845 29570053 28557819 29084913 27653358 30080774 30083611 30904965 29614101 30211349 30219665 29301726 31418942 29649314 28713181 27942085 30783269 30291391 29742129 30753184 30024893 28559438 28005974 28968388 27508060 30199475
#>                                                                                                                                                                                                                                                                                                                                                                                                           references
#> 1 15973362 21858251 21957321 26015563 23685358 24781693 16926219 18987179 23687012 18978030 16391221 24184289 23720314 16469928 18301760 5079701 19971689 19956649 24137834 18772421 23705970 24503830 19047558 24092745 23686606 26571133 25463148 18086910 23690180 9056804 24643863 22301307 25214575 25903611 23700504 16322762 24406983 16275915 23349264 19562078 25186869 23723423 26564899 21966387 26601961
#>                            doi
#> 1 10.1371/journal.pbio.1002541
```

The function also takes a vector of PMIDS:

``` r
get_metrics(c('27599104', '27830815', '28968388', '28968381'))
#>       pmid year
#> 1 27599104 2016
#> 2 27830815 2016
#> 3 28968381 2017
#> 4 28968388 2017
#>                                                                                                             title
#> 1 Relative Citation Ratio (RCR): A New Metric That Uses Citation Rates to Measure Influence at the Article Level.
#> 2                                                                     The quiet rise of the NIH's hot new metric.
#> 3                          Additional support for RCR: A validated article-level measure of scientific influence.
#> 4                                A critical evaluation of the algorithm behind the Relative Citation Ratio (RCR).
#>                                                                                     authors
#> 1                           B Ian Hutchins, Xin Yuan, James M Anderson, George M Santangelo
#> 2                                                                               Gautam Naik
#> 3 B Ian Hutchins, Travis A Hoppe, Rebecca A Meseroll, James M Anderson, George M Santangelo
#> 4                    A Cecile J W Janssens, Michael Goodman, Kimberly R Powell, Marta Gwinn
#>      journal is_research_article relative_citation_ratio nih_percentile
#> 1 PLoS Biol.                 Yes                    5.52           94.7
#> 2     Nature                  No                    0.55           29.3
#> 3 PLoS Biol.                  No                    0.20            9.1
#> 4 PLoS Biol.                  No                    0.76           39.9
#>   human animal molecular_cellular  apt is_clinical citation_count
#> 1     1      0                  0 0.25          No             53
#> 2     1      0                  0 0.05          No              6
#> 3     0      0                  0 0.05          No              1
#> 4     0      0                  0 0.05          No              5
#>   citations_per_year expected_citations_per_year field_citation_rate
#> 1           17.66667                    3.201929            6.854116
#> 2            2.00000                    3.622762            7.851526
#> 3            0.50000                    2.554157            5.770886
#> 4            2.50000                    3.278137            7.417886
#>   provisional x_coord y_coord cited_by_clin
#> 1          No       0    1.00            NA
#> 2          No       0    1.00            NA
#> 3         Yes       0   -0.75            NA
#> 4         Yes       0   -0.75            NA
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       cited_by
#> 1 28546354 30231116 28480055 28968381 30078658 28616253 30970066 30758873 28633401 30271298 27354417 27767221 27599158 28025905 29415003 28369324 26962436 30177900 28281870 28042752 31501771 30202870 29298181 29596415 29744377 29707257 30429933 29230845 29570053 28557819 29084913 27653358 30080774 30083611 30904965 29614101 30211349 30219665 29301726 31418942 29649314 28713181 27942085 30783269 30291391 29742129 30753184 30024893 28559438 28005974 28968388 27508060 30199475
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                        31418942 28148554 30211349 28385690 28559438 28968388
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     30271298
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                 31418942 29614101 28968381 29596415 30271298
#>                                                                                                                                                                                                                                                                                                                                                                                                           references
#> 1 15973362 21858251 21957321 26015563 23685358 24781693 16926219 18987179 23687012 18978030 16391221 24184289 23720314 16469928 18301760 5079701 19971689 19956649 24137834 18772421 23705970 24503830 19047558 24092745 23686606 26571133 25463148 18086910 23690180 9056804 24643863 22301307 25214575 25903611 23700504 16322762 24406983 16275915 23349264 19562078 25186869 23723423 26564899 21966387 26601961
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                   
#> 3                                                                                                                                                                                                                                                                                                                                                                                27599104 26462491 28559438 28968388
#> 4                                                                                                                                                                                                                                                                                                                                                                                 27599104 27830815 5079701 26462491
#>                            doi
#> 1 10.1371/journal.pbio.1002541
#> 2              10.1038/539150a
#> 3 10.1371/journal.pbio.2003552
#> 4 10.1371/journal.pbio.2002536
```

If you would rather not have the results in a dataframe, it is possible
to obtain an S3 object for the data by using the `icite_api` function

``` r
dat <- icite_api('27599104')

print(dat)
#> <iCite request: api/pubs?pmids=27599104&format=csv>
#> 'data.frame':    1 obs. of  24 variables:
#>  $ pmid                       : int 27599104
#>  $ year                       : int 2016
#>  $ title                      : chr "Relative Citation Ratio (RCR): A New Metric That Uses Citation Rates to Measure Influence at the Article Level."
#>  $ authors                    : chr "B Ian Hutchins, Xin Yuan, James M Anderson, George M Santangelo"
#>  $ journal                    : chr "PLoS Biol."
#>  $ is_research_article        : chr "Yes"
#>  $ relative_citation_ratio    : num 5.52
#>  $ nih_percentile             : num 94.7
#>  $ human                      : num 1
#>  $ animal                     : num 0
#>  $ molecular_cellular         : num 0
#>  $ apt                        : num 0.25
#>  $ is_clinical                : chr "No"
#>  $ citation_count             : int 53
#>  $ citations_per_year         : num 17.7
#>  $ expected_citations_per_year: num 3.2
#>  $ field_citation_rate        : num 6.85
#>  $ provisional                : chr "No"
#>  $ x_coord                    : num 0
#>  $ y_coord                    : num 1
#>  $ cited_by_clin              : logi NA
#>  $ cited_by                   : chr "28546354 30231116 28480055 28968381 30078658 28616253 30970066 30758873 28633401 30271298 27354417 27767221 275"| __truncated__
#>  $ references                 : chr "15973362 21858251 21957321 26015563 23685358 24781693 16926219 18987179 23687012 18978030 16391221 24184289 237"| __truncated__
#>  $ doi                        : chr "10.1371/journal.pbio.1002541"
```

If you are having trouble accessing the data for a particular PMID, the
`icite_api` function will also return somewhat more informative error
messages (development version only):

``` r
icite_api('42')
#> <iCite request: api/pubs?pmids=42&format=csv>
#> 'data.frame':    1 obs. of  24 variables:
#>  $ pmid                       : int 42
#>  $ year                       : int 1975
#>  $ title                      : chr "A competitive labeling method for the determination of the chemical properties of solitary functional groups in proteins."
#>  $ authors                    : chr "R G Duggleby, H Kaplan"
#>  $ journal                    : chr "Biochemistry"
#>  $ is_research_article        : chr "Yes"
#>  $ relative_citation_ratio    : logi NA
#>  $ nih_percentile             : logi NA
#>  $ human                      : num 0
#>  $ animal                     : num 0
#>  $ molecular_cellular         : num 1
#>  $ apt                        : num 0.05
#>  $ is_clinical                : chr "No"
#>  $ citation_count             : int 11
#>  $ citations_per_year         : num 0.25
#>  $ expected_citations_per_year: logi NA
#>  $ field_citation_rate        : num 2.86
#>  $ provisional                : chr "No"
#>  $ x_coord                    : num -0.866
#>  $ y_coord                    : num -0.5
#>  $ cited_by_clin              : logi NA
#>  $ cited_by                   : chr "3099757 7397107 7149255 3135412 6365082 7115297 2095202 10469490 7030309 7417503 3994995"
#>  $ references                 : chr "4944073 4204227 5764436 5423263 4587927 235280 6055183 5415110 5158490 804314 6022849 4656796 5777784 14314361 "| __truncated__
#>  $ doi                        : chr "10.1021/bi00694a023"
```

It is worth noting that the iCite database presently goes back to 1995.
Earlier papers will not have any data associated with them. Also, recent
papers may not be available. See <https://icite.od.nih.gov/stats> and
<https://icite.od.nih.gov/user_guide?page_id=ug_overview> for details of the iCite system that
this package works with.

### search\_metrics

If you do not have a set of PMIDS you are interested in, then
`get_metrics` may not seem to provide much use to you. Fortunately, the
iCite API also provides a means of accessing data via some more general
query parameters. In particular, you can ask for data from a given year,
or from PMIDS that are above a certain value. This functionality is
accessed with the `search_metrics` function.

For instance, if you wanted to get data from 50 papers in 2012 with
PMIDS greater than 18000000:

``` r
dat_2012 <- search_metrics(year=2012, offset = '18000000', limit = '50')
```

By default, `search_metrics` will not return more than 1000 entries. If
you wish to get more data than this, you can set page to `TRUE`. Using
this setting with no specified limit may result in a function call that
takes several hours to complete. A status message will be printed
periodically to the console, but it is not possible to estimate a time
to completion since the denominator (total number of entries to be
obtained) is not known in advance. Informal testing suggests that there
are around a million entries per year, but the database is constantly
growing.

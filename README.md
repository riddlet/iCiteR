
<!-- README.md is generated from README.Rmd. Please edit that file -->

# iCiteR

<!-- badges: start -->

[![R-CMD-check](https://github.com/riddlet/iCiteR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/riddlet/iCiteR/actions/workflows/R-CMD-check.yaml)
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

### get_metrics

To use `get_metrics`, you will likely already have the PMIDs that
correspond to the articles for which you wish to obtain data. For a
given article in pubmed, the ID is also printed on the page

![The PMID for the Relative Citation Rate paper on
Pubmed](vignettes/RCR_PMID.jpg)

For a given PMID(s), you can get the relative citation rate and all
other data returned by the iCite API as follows

``` r
library(iCiteR)
get_metrics('27599104')
#>       pmid year
#> 1 27599104 2016
#>                                                                                                             title
#> 1 Relative Citation Ratio (RCR): A New Metric That Uses Citation Rates to Measure Influence at the Article Level.
#>                                                           authors   journal
#> 1 B Ian Hutchins, Xin Yuan, James M Anderson, George M Santangelo PLoS Biol
#>   is_research_article relative_citation_ratio nih_percentile human animal
#> 1                 Yes                    9.64           97.8     1      0
#>   molecular_cellular  apt is_clinical citation_count citations_per_year
#> 1                  0 0.95          No            213           30.42857
#>   expected_citations_per_year field_citation_rate provisional x_coord y_coord
#> 1                    3.158029            6.316944          No       0       1
#>       cited_by_clin
#> 1 37552823 33539992
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       cited_by
#> 1 37184517 33948247 29415003 30271298 33031632 31600197 35348648 35836786 37463199 37688947 33025300 30429933 31869281 37706362 28968388 32162806 31539315 27508060 28557819 35086091 36197161 27767221 36434321 37406178 30177900 26564899 33186405 35378958 29614101 35998980 30080774 30078658 30083611 33796272 31771989 36845314 36343026 33244415 36640770 37043754 31633016 33219227 35344133 36334681 27599158 34195658 26962436 37031858 29742129 35306262 36341255 35765971 36397355 32656478 34265490 32334732 33085678 30758873 36475848 34032569 31136588 31314103 33271323 35940351 29084913 30199475 30291391 34979592 35288087 33170287 30211349 29298181 27335586 35928806 36709395 36001334 37001895 37850081 30783269 33165822 35695556 36711900 35559386 28005974 32005024 36598886 36304662 31680985 34586077 28546354 27653358 28968381 37574081 37711393 34103514 30231116 35255624 31831311 35481316 33149900 28713181 27942085 33624715 33787413 34657771 32454704 29707257 33248304 37921985 37801587 28559438 33345372 32410971 34086846 33631358 33539641 36947572 36316729 28042752 35876773 27599104 34549687 35852964 37601533 36405047 30753947 31801786 34840769 30970066 36789895 37347161 36003453 30917690 33451619 34283675 34581485 36624666 37766958 29172224 33835377 35255623 29649314 36287644 31501771 35989860 35100252 30024893 29301726 36147406 27354417 30219665 37452891 34827350 37552823 37788235 35146918 36343020 30904965 31600189 30636676 36743779 33937619 35774708 37775956 34455853 36234318 34600567 35734785 37095860 35733502 35680519 37577958 36477231 36743733 37431862 28480055 33532641 36306543 28025905 34991379 28369324 36623728 27570340 31418942 29230845 28616253 31575871 36403125 33819513 33110764 29570053 32529630 37089621 30753184 29596415 27492440 37437707 29744377 30202870 27578756 37218905 32417442 36240832 28281870 36042603 33198687 33539992 33754507 34972688 35402503 28633401 34710574 35500810
#>                                                                                                                                                                                                                                                                                                                                                                                                                                      references
#> 1 18987179 23690180 16926219 26015563 27599104 23705970 24137834 22301307 23349264 24643863 25463148 21858251 24092745 25903611 26564899 21966387 23700504 24184289 25214575 19562078 24503830 9056804 23723423 18772421 23720314 19047558 16391221 19956649 18978030 16275915 25186869 16469928 24781693 26571133 19971689 16322762 21957321 24406983 23685358 18301760 23687012 24399856 26601961 15973362 5079701 18086910 24156031 23686606
#>                            doi        last_modified
#> 1 10.1371/journal.pbio.1002541 11/25/2023, 17:23:06
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
#>     journal is_research_article relative_citation_ratio nih_percentile human
#> 1 PLoS Biol                 Yes                    9.64           97.8     1
#> 2    Nature                  No                    0.30           15.5     1
#> 3 PLoS Biol                  No                    0.92           47.3     0
#> 4 PLoS Biol                  No                    0.95           48.4     0
#>   animal molecular_cellular  apt is_clinical citation_count citations_per_year
#> 1      0                  0 0.95          No            213          30.428571
#> 2      0                  0 0.05          No              8           1.142857
#> 3      0                  0 0.25          No             14           2.333333
#> 4      0                  0 0.50          No             21           3.500000
#>   expected_citations_per_year field_citation_rate provisional x_coord y_coord
#> 1                    3.158029            6.316944          No       0    1.00
#> 2                    3.872574            8.201295          No       0    1.00
#> 3                    2.527861            4.367680          No       0   -0.75
#> 4                    3.679545            6.954770          No       0   -0.75
#>       cited_by_clin
#> 1 37552823 33539992
#> 2                  
#> 3                  
#> 4                  
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       cited_by
#> 1 37184517 33948247 29415003 30271298 33031632 31600197 35348648 35836786 37463199 37688947 33025300 30429933 31869281 37706362 28968388 32162806 31539315 27508060 28557819 35086091 36197161 27767221 36434321 37406178 30177900 26564899 33186405 35378958 29614101 35998980 30080774 30078658 30083611 33796272 31771989 36845314 36343026 33244415 36640770 37043754 31633016 33219227 35344133 36334681 27599158 34195658 26962436 37031858 29742129 35306262 36341255 35765971 36397355 32656478 34265490 32334732 33085678 30758873 36475848 34032569 31136588 31314103 33271323 35940351 29084913 30199475 30291391 34979592 35288087 33170287 30211349 29298181 27335586 35928806 36709395 36001334 37001895 37850081 30783269 33165822 35695556 36711900 35559386 28005974 32005024 36598886 36304662 31680985 34586077 28546354 27653358 28968381 37574081 37711393 34103514 30231116 35255624 31831311 35481316 33149900 28713181 27942085 33624715 33787413 34657771 32454704 29707257 33248304 37921985 37801587 28559438 33345372 32410971 34086846 33631358 33539641 36947572 36316729 28042752 35876773 27599104 34549687 35852964 37601533 36405047 30753947 31801786 34840769 30970066 36789895 37347161 36003453 30917690 33451619 34283675 34581485 36624666 37766958 29172224 33835377 35255623 29649314 36287644 31501771 35989860 35100252 30024893 29301726 36147406 27354417 30219665 37452891 34827350 37552823 37788235 35146918 36343020 30904965 31600189 30636676 36743779 33937619 35774708 37775956 34455853 36234318 34600567 35734785 37095860 35733502 35680519 37577958 36477231 36743733 37431862 28480055 33532641 36306543 28025905 34991379 28369324 36623728 27570340 31418942 29230845 28616253 31575871 36403125 33819513 33110764 29570053 32529630 37089621 30753184 29596415 27492440 37437707 29744377 30202870 27578756 37218905 32417442 36240832 28281870 36042603 33198687 33539992 33754507 34972688 35402503 28633401 34710574 35500810
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      28148554 33754507 30211349 28968388 28559438 28385690 31418942 33787413
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                30271298 37218905 31600197 36947572 37463199 36789895 37001895 34827350 35402503 33948234 33110764 35989860 37031858 35255624
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 37557156 35255623 36403934 31831311 30271298 35940351 35733502 29614101 31418942 37001895 33787413 36304662 37347161 36407303 33796272 36403125 28968381 35989860 32334732 35255624 29596415
#>                                                                                                                                                                                                                                                                                                                                                                                                                                      references
#> 1 18987179 23690180 16926219 26015563 27599104 23705970 24137834 22301307 23349264 24643863 25463148 21858251 24092745 25903611 26564899 21966387 23700504 24184289 25214575 19562078 24503830 9056804 23723423 18772421 23720314 19047558 16391221 19956649 18978030 16275915 25186869 16469928 24781693 26571133 19971689 16322762 21957321 24406983 23685358 18301760 23687012 24399856 26601961 15973362 5079701 18086910 24156031 23686606
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                              
#> 3                                                                                                                                                                                                                                                                                                                                                                                                           28968388 27599104 26462491 28559438
#> 4                                                                                                                                                                                                                                                                                                                                                                                                            27599104 26462491 27830815 5079701
#>                            doi        last_modified
#> 1 10.1371/journal.pbio.1002541 11/25/2023, 17:23:06
#> 2              10.1038/539150a 11/25/2023, 17:31:16
#> 3 10.1371/journal.pbio.2003552 11/25/2023, 17:27:46
#> 4 10.1371/journal.pbio.2002536 11/25/2023, 17:27:46
```

If you would rather not have the results in a dataframe, it is possible
to obtain an S3 object for the data by using the `icite_api` function

``` r
dat <- icite_api('27599104')

print(dat)
#> <iCite request: api/pubs?pmids=27599104&format=csv>
#> 'data.frame':    1 obs. of  25 variables:
#>  $ pmid                       : int 27599104
#>  $ year                       : int 2016
#>  $ title                      : chr "Relative Citation Ratio (RCR): A New Metric That Uses Citation Rates to Measure Influence at the Article Level."
#>  $ authors                    : chr "B Ian Hutchins, Xin Yuan, James M Anderson, George M Santangelo"
#>  $ journal                    : chr "PLoS Biol"
#>  $ is_research_article        : chr "Yes"
#>  $ relative_citation_ratio    : num 9.64
#>  $ nih_percentile             : num 97.8
#>  $ human                      : num 1
#>  $ animal                     : num 0
#>  $ molecular_cellular         : num 0
#>  $ apt                        : num 0.95
#>  $ is_clinical                : chr "No"
#>  $ citation_count             : int 213
#>  $ citations_per_year         : num 30.4
#>  $ expected_citations_per_year: num 3.16
#>  $ field_citation_rate        : num 6.32
#>  $ provisional                : chr "No"
#>  $ x_coord                    : num 0
#>  $ y_coord                    : num 1
#>  $ cited_by_clin              : chr "37552823 33539992"
#>  $ cited_by                   : chr "37184517 33948247 29415003 30271298 33031632 31600197 35348648 35836786 37463199 37688947 33025300 30429933 318"| __truncated__
#>  $ references                 : chr "18987179 23690180 16926219 26015563 27599104 23705970 24137834 22301307 23349264 24643863 25463148 21858251 240"| __truncated__
#>  $ doi                        : chr "10.1371/journal.pbio.1002541"
#>  $ last_modified              : chr "11/25/2023, 17:23:06"
```

If you are having trouble accessing the data for a particular PMID, the
`icite_api` function will also return somewhat more informative error
messages (development version only):

``` r
icite_api('42a')
#> Warning in stats::na.omit(as.integer(pmids)): NAs introduced by coercion
#> Error in construct_query(query_type = "pmid", pmids = pmids): No valid pubmed IDs detected. Please provide integer values, or
#>          their character representation. Try: 27599104
```

It is worth noting that the iCite database presently goes back to 1995.
Earlier papers will not have any data associated with them. Also, recent
papers may not be available. See <https://icite.od.nih.gov/stats> and
<https://icite.od.nih.gov/user_guide?page_id=ug_overview> for details of
the iCite system that this package works with.

### search_metrics

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

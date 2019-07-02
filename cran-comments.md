## Resubmission
This is a resubmission. In this version I have:

* Reformatted package, software, and API names in single quotes in the title and description in the DESCRIPTION file.

* Elaborated on the information returned by the 'iCite' API in the descriptino text.

* Registered the S3 print method in the NAMESPACE file.

* Replaced T and F with TRUE and FALSE

* Included the arguments for the to_dataframe function in the .Rd file.

## Test environments
* local OS X install, R 3.5.3
* ubuntu 14.04.5 (on travis-ci), R 3.6
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE:

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Travis Riddle <travis.riddle@nih.gov>'

New submission

Possibly mis-spelled words in DESCRIPTION:
  NIH's (2:30, 5:43)
  api (7:13)
  iCite (2:36, 5:49, 7:7)
  pubmed (6:21)


## Downstream dependencies
There are currently no downstreatm dependencies for this package.

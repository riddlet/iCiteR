context('testing misc other functions')

test_that('Prints correct details of S3 object', {
  out1 <- icite_api(pmids='1000')
  expect_match(capture_output(print(out1)), '<iCite request')
})

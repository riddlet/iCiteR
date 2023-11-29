context('testing get_metrics')

test_that('api call produces dataframe', {
  out1 <- get_metrics('27599104')
  out2 <- suppressWarnings(get_metrics('2759910a'))
  expect_is(out1, 'data.frame')
  expect_is(out2, 'data.frame')
})

test_that('data frame is expected shape', {
  out1 <- get_metrics('27599104')
  expect_equal(dim(out1)[1], 1)
  expect_equal(dim(out1)[2], 25)
})

test_that('get_metrics can handle multiple ids', {
  out1 <- get_metrics(c('27599104', '23456789', '23456790'))
  expect_equal(dim(out1)[1], 3)
  expect_equal(sum(is.na(out1$relative_citation_ratio)), 0)
})

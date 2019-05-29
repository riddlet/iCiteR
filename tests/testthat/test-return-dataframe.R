context('test_return_dataframe.R')

test_that('api call produces dataframe', {
  out1 <- get_metrics('27599104')
  out2 <- get_metrics('2759910a')
  expect_is(out1, 'data.frame')
  expect_is(out2, 'data.frame')
})

test_that('data frame is expected shape', {
  out1 <- get_metrics('27599104')
  expect_equal(dim(out1)[1], 1)
  expect_equal(dim(out1)[2], 13)
})

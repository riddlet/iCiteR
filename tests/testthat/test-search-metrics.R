context('testing search_metrics')

test_that('api call produces dataframe', {
  out1 <- search_metrics(year='2012', limit='50')
  expect_is(out1, 'data.frame')
})

test_that('paging works', {
  out1 <- search_metrics(year='2012', limit='2000', page = T)
  expect_is(out1, 'data.frame')
})

test_that('message produced if asking for more than 1000 without paging', {
  out1 <- search_metrics(year='2012', limit='2000', page=F)
  expect_message(search_metrics(year='2012', limit=2000, page=F), 'Only returning')
})

test_that('paging takes precedent over limit', {
  out1 <- search_metrics(year='2012', limit='2000', page=F)
  expect_equal(dim(out1)[1], 1000)
})

test_that("add2 adds two positive numbers", {
  expect_equal(add2(2, 3), 5)
})

test_that("add2 handles negative numbers", {
  expect_equal(add2(-1, 1), 0)
  expect_equal(add2(-3, -2), -5)
})

test_that("add2 handles zero", {
  expect_equal(add2(0, 0), 0)
})

test_that("add2 handles decimals", {
  expect_equal(add2(0.1, 0.2), 0.3, tolerance = 1e-8)
})

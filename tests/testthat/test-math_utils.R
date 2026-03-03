# Tests for divide() -------------------------------------------------------

test_that("divide returns correct result", {
  expect_equal(divide(10, 2), 5)
  expect_equal(divide(7, 2), 3.5)
})

test_that("divide handles negatives", {
  expect_equal(divide(-6, 3), -2)
  expect_equal(divide(6, -3), -2)
})

# NOTE: This test is intentionally commented out for the covr demo.
# Run covr::package_coverage() now to see the uncovered branch in divide().
# Then uncomment this test, re-run coverage, and watch it hit 100%.
test_that("divide errors on zero denominator", {
  expect_error(divide(5, 0), "Cannot divide by zero")
})


# Tests for percent_change() -----------------------------------------------

test_that("percent_change computes correctly", {
  expect_equal(percent_change(100, 150), 50)
  expect_equal(percent_change(200, 100), -50)
})

test_that("percent_change errors when old_val is zero", {
  expect_error(percent_change(0, 10), "old_val cannot be zero")
})

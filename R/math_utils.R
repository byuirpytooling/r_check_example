#' Divide two numbers
#'
#' @param x1 Numerator
#' @param x2 Denominator. Must not be zero.
#' @return Numeric result of x1 / x2
#' @export
divide <- function(x1, x2) {
  if (x2 == 0) {
    stop("Cannot divide by zero")
  }
  x1 / x2
}

#' Calculate percent change between two values
#'
#' @param old_val Starting value. Must not be zero.
#' @param new_val Ending value.
#' @return Numeric percent change from old_val to new_val.
#' @export
percent_change <- function(old_val, new_val) {
  if (old_val == 0) {
    stop("old_val cannot be zero: percent change is undefined")
  }
  (new_val - old_val) / old_val * 100
}

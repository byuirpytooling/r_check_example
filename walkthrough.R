# R Package Development Tools: Walkthrough
# =========================================
# This script walks through 5 core tools for R package development.
# Run each section line-by-line in RStudio (Ctrl+Enter / Cmd+Enter).
# Use the document outline panel (Ctrl+Shift+O) to jump between sections.
#
# Package: pkgdemo
# Functions: add2(), divide(), percent_change()


# ---- 0-setup ----
# SETUP: Install required packages (run once)
# -------------------------------------------
# Uncomment and run this block if you haven't installed these yet.

install.packages(c("devtools", "usethis", "renv", "covr",
                   "testthat", "lintr", "styler",
                   "DT", "htmltools"))   # required by covr::report()


# ---- 1-devtools-usethis ----
# TOOL 1: devtools + usethis
# ==========================
# devtools = the core package development workflow
# usethis  = helper functions for scaffolding package infrastructure

library(devtools)

# --- 1a. document() ---
# Reads roxygen2 comments (the #' lines above functions in R/)
# and auto-generates man/*.Rd help files and the NAMESPACE.
# Run this every time you change or add function documentation.
devtools::document()

# Check what was generated:
#   man/add2.Rd, man/divide.Rd, man/percent_change.Rd
#   NAMESPACE (lists all exported functions)

# --- 1b. load_all() ---
# The command you will use MOST during development.
# Simulates installing and loading your package — but much faster.
# All functions in R/ are now available in your session.
devtools::load_all()

# Confirm everything loaded:
add2(3, 5)              # 8
divide(10, 4)           # 2.5
percent_change(80, 100) # 25

# --- 1c. check() ---
# Runs R CMD check: the gold standard for package validity.
# Checks your documentation, namespace, examples, and tests.
# A clean package has: 0 errors, 0 warnings, 0 notes.
devtools::check()

# --- usethis helpers (for reference) ---
# These usethis commands created the scaffolding for this package.
# You don't need to run them now — they're shown so you know how
# to set up your own package from scratch.
#
#   usethis::create_package("path/to/mypkg")  # create new package
#   usethis::use_r("math_utils")              # create R/math_utils.R
#   usethis::use_mit_license()                # add MIT license files
#   usethis::use_testthat()                   # set up tests/ structure
#   usethis::use_readme_rmd()                 # create README.Rmd


# ---- 2-renv ----
# TOOL 2: renv
# ============
# Problem: "It works on my machine!" — package versions differ across machines.
# Solution: renv creates a project-local library and a lockfile (renv.lock)
# that records the exact version of every package your project uses.
# Anyone who clones your repo can restore the exact same environment.

library(renv)

# --- 2a. init() ---
# Creates the renv/ folder, renv.lock, and updates .Rprofile.
# Run once when starting a new project.
# NOTE: This will take a minute — it copies packages into renv/library/.
# renv::init()

# After init(), open renv.lock to see what it records:
#   {
#     "R": { "Version": "4.4.0", ... },
#     "Packages": {
#       "testthat": { "Version": "3.2.1", "Source": "Repository", ... },
#       ...
#     }
#   }

# --- 2b. snapshot() ---
# After installing or updating packages, update the lockfile to match.
# renv::snapshot()

# --- 2c. status() ---
# Check whether your lockfile matches your current library.
# Use this to detect drift between environments.
# renv::status()

# --- 2d. restore() ---
# On a new machine or after cloning, use restore() to install
# the exact package versions recorded in renv.lock.
renv::restore()

# Key rules:
#   COMMIT renv.lock to git  (this is what others use to recreate your env)
#   DO NOT commit renv/library/  (it's large and machine-specific)


# ---- 3-testthat ----
# TOOL 3: testthat
# ================
# testthat is the standard framework for unit testing in R.
# Tests live in tests/testthat/test-*.R files.
# Each test file should correspond to one source file (e.g., test-math_utils.R
# tests the functions in math_utils.R).

library(testthat)

# --- 3a. Anatomy of a test ---
# test_that() takes:
#   1. A description string (what are you testing?)
#   2. A block of expect_*() calls (what should be true?)

test_that("add2 adds two positive numbers", {
  expect_equal(add2(2, 3), 5)
})

# --- 3b. Common expectations ---

# expect_equal()  - checks value (handles floating point with tolerance)
test_that("divide returns a decimal", {
  expect_equal(divide(7, 2), 3.5)
})

# expect_error()  - checks that a function throws an error (and optionally
#                   that the error message matches a pattern)
test_that("divide errors on zero", {
  expect_error(divide(5, 0), "Cannot divide by zero")
})

# expect_true() / expect_false() - checks logical results
test_that("percent_change is positive when new > old", {
  expect_true(percent_change(100, 200) > 0)
})

# --- 3c. Run all tests ---
# Runs every test-*.R file in tests/testthat/.
# This is what you'll use most often.
devtools::test()

# --- 3d. Run a single test file ---
# Useful when working on one specific function.
testthat::test_file("tests/testthat/test-math_utils.R")

# --- 3e. Look at the test files ---
# Open tests/testthat/test-example.R    (tests for add2)
# Open tests/testthat/test-math_utils.R (tests for divide and percent_change)
#
# Notice: one test in test-math_utils.R is commented out. That's intentional
# for the covr demo in the next section!


# ---- 4-covr ----
# TOOL 4: covr
# ============
# covr measures code coverage: what percentage of your R code lines
# are actually executed when your test suite runs.
# High coverage = your tests exercise more of your logic.
# Low coverage = untested branches that might hide bugs.

library(covr)

# --- 4a. Measure coverage ---
# Runs your full test suite and tracks every line that was hit.
cov <- package_coverage()
print(cov)

# --- 4b. View the interactive HTML report ---
# Opens a browser showing covered (green) and uncovered (red) lines.
report(cov)

# --- 4c. Spot the coverage gap ---
# Look at divide() in the report. The error branch:
#   if (x2 == 0) { stop("Cannot divide by zero") }
# should appear RED — it was never reached by any test.
#
# That's because the test for it is commented out in test-math_utils.R:
#   # test_that("divide errors on zero denominator", {
#   #   expect_error(divide(5, 0), "Cannot divide by zero")
#   # })
#
# ACTION: Open tests/testthat/test-math_utils.R and uncomment those lines.
# Then re-run coverage:
cov2 <- package_coverage()
report(cov2)
# The error branch in divide() should now be GREEN (covered).

# --- 4d. Get coverage as a single number ---
percent_coverage(cov)   # before fix (should be < 100%)
percent_coverage(cov2)  # after fix  (should be 100%)


# ---- 5-lintr-styler ----
# TOOL 5: lintr + styler
# ======================
# lintr:  analyzes your code for style problems and potential bugs.
#         READ-ONLY — it reports issues but does NOT change files.
# styler: automatically reformats your code to match style conventions.
#         WRITES files — it fixes issues automatically.

library(lintr)
library(styler)

# --- 5a. Lint a single file ---
lintr::lint("R/math_utils.R")

# --- 5b. Lint the whole package ---
lintr::lint_package()

# What lintr checks for:
#   - Lines longer than 80 characters
#   - Missing spaces around operators  (x=1  should be  x = 1)
#   - Using T/F instead of TRUE/FALSE
#   - Using = instead of <- for assignment
#   - Trailing whitespace at end of lines
#   - File extension casing (.r should be .R)

# --- 5c. The trailing whitespace teaching moment ---
# Notice: R/example.r has trailing whitespace on line 4 (after @export).
# lintr flags this: "Remove trailing whitespace."
# We left it in intentionally as a live demo of lintr output.

# --- 5d. Style a single file ---
# IMPORTANT: styler modifies files. Commit your work to git first so
# you can review exactly what changed with `git diff`.
# styler::style_file("R/math_utils.R")

# # --- 5e. Style the entire package ---
# styler::style_pkg()

# What styler auto-fixes:
#   - Indentation (2 spaces, not tabs)
#   - Spaces around operators
#   - Blank lines between function definitions
#   - Trailing whitespace

# --- 5f. lintr vs styler: when to use each ---
#
#   lintr  → use in CI/CD to ENFORCE style (fails the build if violations found)
#   styler → use interactively while WRITING code (fixes things for you)
#
# Many teams run styler before committing and lintr in their GitHub Actions CI.

test_that("rwe_standards_version() matches rwedev's own standards field", {
  desc <- read.dcf(system.file("DESCRIPTION", package = "rwedev"))
  expect_identical(rwe_standards_version(), desc[[1, "Config/rwe/standards"]])
})

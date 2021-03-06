context("LNToutput methods")

dir <- paste0(tempdir(check = TRUE), "/test")
dir.create(dir)
smpl <- paste0(dir, "/", paste0("sample", c(".TXT", ".xlsx")))
file.copy(
  from = system.file("extdata", "sample.TXT", package = "LexisNexisTools"),
  to = smpl,
  overwrite = TRUE
)

test_that("Rename Sample", {
  expect_equal({
    file <- lnt_rename(smpl[1], simulate = TRUE,
                       verbose = FALSE)
    basename(file$name_new)
  }, "SampleFile_20091201-20100511_1-10.txt")
  expect_equal({
    file <- lnt_rename(smpl[1], simulate = FALSE)
    smpl[1] <- file$name_new
    file.exists(file$name_new)
  }, TRUE)
  expect_warning({
    x <- lnt_rename(smpl, simulate = TRUE, verbose = FALSE)
  }, "Not all provided files were TXT, DOC, RTF, PDF or DOCX files. Other formats are ignored.")
  expect_equal({
    capture_messages(
      test <- lnt_rename(smpl[1], simulate = TRUE, verbose = TRUE)
    )[-6]
  }, c("Checking LN files...\n",
       "1 files found to process...\n",
       "\r\t...renaming files 100.00%\n",
       "0 files renamed, ",
       "1 not renamed (file already exists), ",
       " [changes were only simulated]\n" ))
})

smpl_uni <- paste0(dir, "/", "sample.DOCX")
file.copy(
  from = system.file("extdata", "sample.DOCX", package = "LexisNexisTools"),
  to = smpl_uni,
  overwrite = TRUE
)

test_that("Rename Sample Nexis Uni", {
  expect_equal({
    file <- lnt_rename(smpl_uni, simulate = TRUE,
                       verbose = FALSE)
    basename(file$name_new)
  }, "Sample_File__00000001.docx")
  expect_equal({
    file <- lnt_rename(smpl_uni, simulate = FALSE)
    file.exists(file$name_new)
  }, TRUE)
  expect_equal({
    capture_messages(
      test <- lnt_rename(file$name_new, simulate = TRUE, verbose = TRUE)
    )[-6]
  }, c("Checking LN files...\n",
       "1 files found to process...\n",
       "\r\t...renaming files 100.00%\n",
       "0 files renamed, ",
       "1 not renamed (file already exists), ",
       " [changes were only simulated]\n" ))
})

teardown(unlink(dir, recursive = TRUE, force = TRUE))

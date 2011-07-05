#' Use roxygen to make documentation.
#'
#' @param pkg package description, can be path or package name.  See
#'   \code{\link{as.package}} for more information
#' @param check if \code{TRUE} (the default), will automatically 
#'   check documentation after running roxygen.
#' @keywords programming
#' @export
document <- function(pkg = NULL, check = TRUE) {
  roxygen_installed <- length(find.package("roxygen", quiet = T)) > 0
  
  if (!roxygen_installed || packageVersion("roxygen") < 1) {
    stop("roxygen 1.0 not found", call. = FALSE)
  }
  require("roxygen")
  
  pkg <- as.package(pkg)
  message("Updating ", pkg$package, " documentation")
  
  in_dir(pkg$path, roxygenise("."))
    
  # if (check) check_doc(pkg)
  invisible()
}

check_doc <- function(pkg = NULL) {
  pkg <- as.package(pkg)
  message("Checking ", pkg$package, " documentation")

  check <- tools:::.check_package_description(
    file.path(pkg$path, "DESCRIPTION"))
  if (length(check) > 0) {
    msg <- capture.output(tools:::print.check_package_description(check))
    message("Invalid DESCRIPTION:\n", paste(msg, collapse = "\n"))
  }
  
  path_man <- file.path(pkg$path, "man")
  files <- dir(path_man, pattern = "\\.[Rr]d$", full = TRUE)
  files <- sort(files)
  
  lapply(files, function(x) {
    print(tools::checkRd(x))
  })
  invisible()
}
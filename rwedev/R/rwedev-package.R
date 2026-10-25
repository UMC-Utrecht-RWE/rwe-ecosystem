#' @keywords internal
"_PACKAGE"

#' Version of the RWE standards this release of rwedev implements
#'
#' Packages record the version they follow in the `Config/rwe/standards`
#' field of their DESCRIPTION file.
#'
#' @return A string such as `"v2"`.
#' @export
#' @examples
#' rwe_standards_version()
rwe_standards_version <- function() {
  "v2"
}

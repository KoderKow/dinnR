#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1") {
  utils::globalVariables(
    c("amount", "dinn", "grocery_section", "gs_lead", "ingredient", "name", "quantity", "rn", "store", "last_updated", "vegan", "vegetarian", ".", "setNames")
  )
}


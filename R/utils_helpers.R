#' Find the date for the wanted next week day
#' 
#' Thank you `@aftonsteps` for the simplified code!
#'
#' @param starting_date A character. Date you are starting from.
#'
#' @references https://gist.github.com/aftonsteps/1aad7b0220e9ce8e895020a105ed3386
get_planning_dates <- function(starting_date = Sys.Date()) {
  starting_point <- as.Date(starting_date)
  
  if (lubridate::wday(starting_point) != 2) {
    starting_point <- lubridate::ceiling_date(
      x = starting_point, 
      week_start = 1, 
      unit = "weeks"
    )
  }
  
  date_sequence <- seq.Date(
    from = starting_point,
    length.out = 7,
    by = "days"
  )
  
  names(date_sequence) <- weekdays(date_sequence)
  
  return(date_sequence)
}

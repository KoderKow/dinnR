#' Find the date for the wanted next week day
#'
#' @param starting_date A character. Date you are starting from.
#' @param week_day A numeric. The next week day you want the date for.
#'
#' @references https://stackoverflow.com/questions/32434549/how-to-find-next-particular-day
next_week_day <- function(starting_date, week_day) {
  date <- as.Date(starting_date)
  
  date_diff <- week_day - lubridate::wday(starting_date)
  
  if (date_diff < 0 & lubridate::wday(starting_date) != 2) {
    date_diff <- date_diff + 7
  }
  
  starting_point <- date + date_diff
  
  all_dates <- setNames(
    object = starting_point + 0:6, 
    nm = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  )
  
  return(all_dates)
}

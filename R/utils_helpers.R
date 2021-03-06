#' Find the date for the wanted next week day
#'
#' @param starting_date A character. Date you are starting from.
#' @param week_day A numeric. The next week day you want the date for.
#'
#' @references https://stackoverflow.com/questions/32434549/how-to-find-next-particular-day
next_week_day <- function(starting_date, week_day) {
  date <- as.Date(starting_date)
  
  diff <- week_day - lubridate::wday(starting_date)
  
  if (diff < 0 & week_day == 2) {
    diff <- diff + 7
  } else if (diff <= 0 & week_day != 2) {
    diff <- diff + 7
  }
  
  if (diff == 1 & week_day == 1) {
    diff <- diff + 7
  }
  
  # date + diff
  
  return(date + diff)
}
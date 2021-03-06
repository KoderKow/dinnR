## code to prepare `days_of_the_week` dataset goes here
weekdays <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

days_of_the_week <- factor(
  x = weekdays,
  levels = weekdays
)

usethis::use_data(days_of_the_week, overwrite = TRUE)

## code to prepare `dinnR` dataset goes here
googlesheets4::gs4_deauth()

ingredients <- googlesheets4::read_sheet(
  ss = "https://docs.google.com/spreadsheets/d/1qVV-QL7l0WXnf0kbK29qOvv_y_6lIgnm_xaWG8QxYoE/edit?usp=sharing",
  sheet = "ingredients"
) %>% 
  tidyr::replace_na(list(grocery_section = "Uncategorized"))

dinn <-
  googlesheets4::read_sheet(
    ss = "https://docs.google.com/spreadsheets/d/1qVV-QL7l0WXnf0kbK29qOvv_y_6lIgnm_xaWG8QxYoE/edit?usp=sharing",
    sheet = "recipes"
  ) %>% 
  dplyr::left_join(
    y = ingredients,
    by = "ingredient"
  )

usethis::use_data(dinn, overwrite = TRUE)

last_updated <- Sys.Date()

usethis::use_data(last_updated, overwrite = TRUE)

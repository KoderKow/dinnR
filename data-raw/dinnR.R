## code to prepare `dinnR` dataset goes here
googlesheets4::sheets_deauth()

ingredients <- googlesheets4::read_sheet(
  ss = "https://docs.google.com/spreadsheets/d/1qVV-QL7l0WXnf0kbK29qOvv_y_6lIgnm_xaWG8QxYoE/edit?usp=sharing",
  sheet = "ingredients"
) %>% 
  tidyr::replace_na(list(grocery_section = "Uncategorized")) %>% 
  dplyr::select(1:3)

dinnR <-
  googlesheets4::read_sheet(
    ss = "https://docs.google.com/spreadsheets/d/1qVV-QL7l0WXnf0kbK29qOvv_y_6lIgnm_xaWG8QxYoE/edit?usp=sharing",
    sheet = "recipes"
  ) %>% 
  dplyr::left_join(
    y = ingredients,
    by = "ingredient"
  )

usethis::use_data(dinnR, overwrite = TRUE)

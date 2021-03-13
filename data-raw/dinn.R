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

dinn <-
  dinn %>% 
  dplyr::mutate(units = stringr::str_c("imp_", units)) %>%  
  dplyr::rowwise() %>% 
  dplyr::mutate(
    quantity = ifelse(
      test = units %in% measurements::conv_unit_options$volume,
      yes = measurements::conv_unit(
        x = quantity,
        from = units,
        to = "imp_oz"
      ),
      no = quantity
    ),
    quantity = plyr::round_any(quantity, 0.05)
  ) %>% 
  dplyr::ungroup() %>% 
  dplyr::mutate(
    units = ifelse(
      test = units %in% measurements::conv_unit_options$volume,
      yes = "oz",
      no = gsub("imp_", "", units)
    )
  )

usethis::use_data(dinn, overwrite = TRUE)

last_updated <- Sys.Date()

usethis::use_data(last_updated, overwrite = TRUE)

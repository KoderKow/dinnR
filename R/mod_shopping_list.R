#' shopping_list UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_shopping_list_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$br(),
    # DT::DTOutput(ns("dtable")),
    gt::gt_output(ns("table"))
  )
}

#' shopping_list Server Function
#'
#' @noRd 
mod_shopping_list_server <- function(input, output, session, r){
  ns <- session$ns
  
  output$table <- gt::render_gt({
    
    d <- dplyr::bind_rows(
      r$sunday,
      r$monday,
      r$tuesday,
      r$wednesday,
      r$thursday,
      r$friday,
      r$saturday
    )
    
    validate(
      need(
        expr = nrow(d) > 0,
        message = "Please select a recipe to begin building a shopping list."
      )
    )
    
    if (r$show_store == TRUE) {
      d_sum <-
        d %>% 
        dplyr::group_by(store, grocery_section, ingredient, units) %>% 
        dplyr::summarize(amount = sum(quantity)) %>% 
        dplyr::select(store, ingredient, amount, units) %>% 
        dplyr::ungroup() %>% 
        dplyr::group_by(store, grocery_section) %>% 
        dplyr::mutate(rn = dplyr::row_number()) %>% 
        dplyr::ungroup() %>% 
        dplyr::mutate(
          gs_lead = dplyr::lead(grocery_section),
          grocery_section = ifelse(
            test = rn > 1,
            yes = NA,
            no = grocery_section
          )
        ) %>% 
        dplyr::select(-gs_lead, -rn) %>% 
        dplyr::group_by(store)
    } else {
      d_sum <-
        d %>% 
        dplyr::group_by(grocery_section, ingredient, units) %>% 
        dplyr::summarize(amount = sum(quantity)) %>% 
        dplyr::select(ingredient, amount, units) %>% 
        dplyr::ungroup() %>% 
        dplyr::group_by(grocery_section) %>% 
        dplyr::mutate(rn = dplyr::row_number()) %>% 
        dplyr::ungroup() %>% 
        dplyr::mutate(
          gs_lead = dplyr::lead(grocery_section),
          grocery_section = ifelse(
            test = rn > 1,
            yes = NA,
            no = grocery_section
          )
        ) %>% 
        dplyr::select(-gs_lead, -rn)
    }
    
    d_sum %>% 
      gt::gt() %>% 
      gt_theme_538(
        table.background.color = "#e2e8f0",
        column_labels.background.color = "#e2e8f0",
        row.striping.background_color = "#d1dbe7",
      ) %>% 
      gt_dinnR()
  })
}

## To be copied in the UI
# mod_shopping_list_ui("shopping_list_ui_1")

## To be copied in the server
# callModule(mod_shopping_list_server, "shopping_list_ui_1", r)

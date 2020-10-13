#' recipes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipes_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$br(),
    mod_recipe_input_ui("recipe_input_ui_recipe"),
    tags$br(),
    uiOutput(ns("url")),
    tags$hr(),
    tags$h4("Ingredients"),
    gt::gt_output(ns("table"))
  )
}

#' recipes Server Functions
#'
#' @noRd 
mod_recipes_server <- function(input, output, session, r){
  ns <- session$ns
  
  output$url <- renderUI({
    req(nrow(r$recipe) > 0)
    url <- unique(r$recipe$url)
      tags$p(
        "Recipe URL: ",
        tags$a(
          url,
          href = url,
          target = "_blank"
          )
        )
  })
  
  output$table <- gt::render_gt({
    req(nrow(r$recipe) > 0)
    r$recipe %>% 
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
      dplyr::select(-gs_lead, -rn, -name, -url) %>% 
      dplyr::arrange(store, grocery_section) %>% 
      dplyr::group_by(store) %>% 
      gt::gt() %>% 
      gt_theme_538(
        table.background.color = "#e2e8f0",
        column_labels.background.color = "#e2e8f0",
        row.striping.background_color = "#d1dbe7",
      ) %>% 
      gt::fmt_missing(
        columns = dplyr::everything(),
        missing_text = ""
      ) 
  })
}

## To be copied in the UI
# mod_recipes_ui("recipes_ui_1")

## To be copied in the server
# callModule(mod_recipes_ui, "recipes_ui_1")

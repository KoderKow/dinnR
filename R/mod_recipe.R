#' recipe_input UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipe_input_ui <- function(id, h4 = TRUE){
  ns <- NS(id)
  dow <- strsplit(id, "_")[[1]][4]
  dow <- paste0(toupper(substr(dow, 1, 1)), substr(dow, 2, nchar(dow)))
  
  tagList(
    if (h4 == TRUE) h4(dow),
    selectizeInput(
      inputId = ns("recipe"),
      label = NULL,
      choices = NULL
    )
  )
}

#' recipe_input Server Function
#'
#' @noRd 
mod_recipe_input_server <- function(input, output, session, r){
  ns <- session$ns
  dow <- strsplit(ns(""), "_|-")[[1]][[4]]
  
  observeEvent(
    eventExpr = r$recipes,
    handlerExpr = {
      updateSelectizeInput(
        session = session,
        inputId = "recipe",
        choices = r$recipes,
        selected = ""
      )
    }
  )
  
  observeEvent(
    eventExpr = input$recipe,
    handlerExpr = {
      r$dow_inputs[[ns("recipe")]] <- ns("recipe")
      
      if (input$recipe != "") {
        r[[dow]] <- 
          dinn %>% 
          dplyr::filter(name == input$recipe) 
        
        r$last_selected <- input$recipe
      } else {
        r[[dow]] <- NULL
      }
    }
  )
}

## To be copied in the UI
# mod_recipe_input_ui("recipe_input_ui_1")

## To be copied in the server
# callModule(mod_recipe_input_server, "recipe_input_ui_1")


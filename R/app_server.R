#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  r <- reactiveValues()
  
  observeEvent(
    eventExpr = TRUE,
    once = TRUE,
    handlerExpr = {
      r$recipes <- sort(unique(dinn$name))
    }
  )
  
  observeEvent(
    eventExpr = input$tabs,
    handlerExpr = {
      r$tabs <- input$tabs
    }
  )
  
  observeEvent(input$show_store, r$show_store <- input$show_store)
  
  ## Modules ----
  
  ## Sidebar ----
  callModule(mod_recipe_input_server, "recipe_input_ui_sunday", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_monday", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_tuesday", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_wednesday", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_thursday", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_friday", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_saturday", r)
  
  ## Shopping List: First Tab ----
  callModule(mod_shopping_list_server, "shopping_list_ui_1", r)
  
  ## Recipe Info: Second Tab ----
  callModule(mod_recipes_server, "recipes_ui_1", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_recipe", r)
}

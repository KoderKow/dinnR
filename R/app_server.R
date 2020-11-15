#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  r <- reactiveValues(
    dow_inputs = list(),
    deletedRows = NULL,
    deletedRowIndices = list()
  )
  
  r$d_sum <- reactive({NULL})
  ## On load, get reecipe names ----
  observeEvent(
    eventExpr = TRUE,
    once = TRUE,
    handlerExpr = r$recipes <- sort(unique(dinn$name))
  )
  
  ## Store active tab ----
  observeEvent(input$tabs, r$tabs <- input$tabs)
  
  ## Show store value ----
  observeEvent(input$show_store, r$show_store <- input$show_store)
  
  ## Plan for me action ----
  observeEvent(
    eventExpr = input$plan_for_me,
    handlerExpr = {
      recipe_count <- length(r$recipes)
      r$plan_for_me <- sample(r$recipes, 7, prob = rep(1 / recipe_count, recipe_count))
        
        lapply(
          X = seq_along(r$plan_for_me),
          FUN = function(x) {
          updateSelectizeInput(
            session = session,
            inputId = names(r$dow_inputs)[x],
            selected = r$plan_for_me[x]
          )
        })
    }
  )
  
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

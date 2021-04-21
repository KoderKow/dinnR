#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  ## Sever ----
  ## For when the app times out or disconnects 
  disconnected <- sever::sever_default(
    title = "Ope!", 
    subtitle = "You have been disconnected", 
    button = "Reconnect", 
    button_class = "info"
  )
  
  sever::sever(
    html = disconnected,
    color = "#655A7C",
    bg_color = "#e2e8f0"
  )
  
  ## Reactive Values ----
  r <- reactiveValues(
    dow_inputs        = list(),
    deletedRows       = NULL,
    deletedRowIndices = list(),
    radio_measurement = "Imperial",
    d_sum             = dplyr::tibble()
  )
  
  ## Idk why I did this :')
  # r$d_sum <- reactive({NULL})
  
  ## Package Version ----
  output$package_version <- renderText({
    paste0("v", golem::get_golem_version())
  })
  
  ## On load, get recipe names + dates for the recipe ----
  observeEvent(
    eventExpr = TRUE,
    once = TRUE,
    handlerExpr = {
      ## Recipes
      r$recipes <- sort(unique(r$d$name))
      
      ## Dates
      r$calendar_dates <- get_planning_dates()
    }
  )
  
  ## Store active tab ----
  observeEvent(input$tabs, r$tabs <- input$tabs)
  
  observeEvent(input$cicerone_reset, {
    
    r$calendar_dates <- get_planning_dates(Sys.Date())
    
    updateSelectizeInput(
      session = session,
      inputId = "recipe_input_ui_dow_2-recipe",
      selected = ""
    )
    
    updateSelectizeInput(
      session = session,
      inputId = "recipe_input_ui_dow_3-recipe",
      selected = ""
    )
    
    r$d_sum <- dplyr::tibble()
  })
  
  ## Guided Tour ----
  observeEvent(
    eventExpr = input$guided_tour,
    handlerExpr = {
      guide <- cicerone::Cicerone$
        new(
          allow_close = FALSE, 
          stage_background = "transparent"
        )$
        step(
          el = "recipe_input_ui_dow_1-recipe_guide",
          title = "Select a Recipe",
          description = "These are the inputs where you get to decide what you want for dinner that night!"
        )$
        step(
          el = "recipe_input_ui_dow_2-recipe_guide",
          title = "After Selecting a Recipe",
          description = "The table will appear with ingredients blah blah.."
        )$
        step(
          el = "recipe_input_ui_dow_3-recipe_guide",
          title = "No plans",
          description = "If you have plans for take-out or other activities select no plans."
        )
      
      ## Put a random recipe as an example
      
      ## TO-DO make this a function where n is a param
      ## Get total count of recipes
      recipe_count <- length(r$recipes)
      ## Sample 7 recipes
      random_recipe <- sample(r$recipes, 1, prob = rep(1 / recipe_count, recipe_count))
      
      updateSelectizeInput(
        session = session,
        inputId = "recipe_input_ui_dow_2-recipe",
        selected = random_recipe
      )
      
      ## Show the user how to select "Other Plans"
      updateSelectizeInput(
        session = session,
        inputId = "recipe_input_ui_dow_3-recipe",
        selected = "Other Plans"
      )
      
      guide$init()$start()
    }
  )
  
  ## Plan for me action ----
  observeEvent(
    eventExpr = input$plan_for_me,
    handlerExpr = {
      ## Get total count of recipes
      recipe_count <- length(r$recipes)
      ## Sample 7 recipes
      r$plan_for_me <- sample(r$recipes, 7, prob = rep(1 / recipe_count, recipe_count))
        
      golem::print_dev(names(r$dow_inputs))
      ## Update inputs with the sampled recipes
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
  
  ## | Modules ----
  
  ## || Sidebar ----
  callModule(mod_recipe_input_server, "recipe_input_ui_dow_1", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_dow_2", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_dow_3", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_dow_4", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_dow_5", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_dow_6", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_dow_7", r)
  
  ## || Shopping List: First Tab ----
  callModule(mod_shopping_list_server, "shopping_list_ui_1", r)
  
  ## || Recipe Info: Second Tab ----
  callModule(mod_recipes_server, "recipes_ui_1", r)
  callModule(mod_recipe_input_server, "recipe_input_ui_recipe", r)
  
  ## || Options: Third Tab ----
  callModule(mod_options_server, "options_ui_1", r)
}

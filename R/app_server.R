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
  
  # observe({print(input[["options_ui_1-starting_date"]])})
  
  ## Reactive Values ----
  r <- reactiveValues(
    dow_inputs        = list(),
    deletedRows       = NULL,
    deletedRowIndices = list(),
    radio_measurement = "Imperial",
    d_sum             = dplyr::tibble(),
    date_i            = 0
  )
  
  ## Bookmarking ----
  setBookmarkExclude(c("plan_for_me", "guided_tour", "tabs", "recipes_ui_1-recipe", "bookmark_btn"))
  
  observeEvent(input$bookmark_btn, {
    session$doBookmark()
  })
  
  # Save extra values in state$values when we bookmark
  onBookmark(function(state) {
    state$values$dow_1 <- input[["recipe_input_ui_dow_1-recipe"]]
    state$values$dow_2 <- input[["recipe_input_ui_dow_2-recipe"]]
    state$values$dow_3 <- input[["recipe_input_ui_dow_3-recipe"]]
    state$values$dow_4 <- input[["recipe_input_ui_dow_4-recipe"]]
    state$values$dow_5 <- input[["recipe_input_ui_dow_5-recipe"]]
    state$values$dow_6 <- input[["recipe_input_ui_dow_6-recipe"]]
    state$values$dow_7 <- input[["recipe_input_ui_dow_7-recipe"]]
    state$values$start_date <- input[["options_ui_1-starting_date"]]
    state$values$diet <- input[["options_ui_1-dietary_preference"]]
    state$values$measurement <- input[["options_ui_1-radio_measurement"]]
    savedTime <- as.character(Sys.time())
    state$values$time <- savedTime
  })
  
  # Read values from state$values when we restore
  onRestore(function(state) {
    r$bm_dow <- list(
      state$values$dow_1,
      state$values$dow_2,
      state$values$dow_3,
      state$values$dow_4,
      state$values$dow_5,
      state$values$dow_6,
      state$values$dow_7
    )
    r$bm_start_date <- state$values$start_date
    r$bm_diet <- state$values$diet
    r$bm_measurement <- state$values$measurement
  })
  
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
      if (is.null(r$bm_start_date)) {
        r$calendar_dates <- get_planning_dates()
      } else {
        r$calendar_dates <- get_planning_dates(r$bm_start_date, next_monday = FALSE)
      }
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
      guide <-
        cicerone::Cicerone$
        new(
          allow_close = FALSE, 
          stage_background = "transparent"
        )$
        step(
          el = "recipe_input_ui_dow_1-recipe_guide",
          title = "Select a Recipe",
          description = "This is the drop down menu where you can pick the a recipe to plan each day."
        )$
        step(
          el = "recipe_input_ui_dow_2-recipe_guide",
          title = "Selecting a Recipe",
          description = "Picking a recipe will load a list of ingredients on the right. This ingredient list will become your shopping list."
        )$
        step(
          el = "recipe_input_ui_dow_3-recipe_guide",
          title = "No plans",
          description = "If you have plans for take-out or other recipes you can select \"Other Plans\"."
        )$
        step(
          el = "shopping_list_ui_1-table",
          title = "Shopping list",
          description = "If you know you have an ingredient at home to cook with, click the trash can icon to remove it from your shopping list. After you have selected your dinners for the week and have updated your shopping list, you can save or print the list (Windows: CTRL + P | Mac: CMD + P).",
          position = "left"
        )$
        step(
          el = input$tab_ids[2],
          title = "Recipe",
          description = "This tab shows you a link to the recipe and who has submitted it."
        )$
        step(
          el = input$tab_ids[3],
          title = "Submit a Recipe",
          description = "Interested in adding recipes you enjoy to the app? This page will provide a link to a google form that will let you submit recipes to be added!"
        )$
        step(
          el = input$tab_ids[4],
          title = "Options",
          description = "This tab has options for measurement preference (imperial/metric), dietary preferen (if any), and the starting date for planning."
        )$
        step(
          el = input$tab_ids[5],
          title = "About",
          description = "If you are interested in learning more about the app and the people who made it, check out this page! :)"
        )$
        step(
          el = "plan_for_me",
          title = "Plan For Me",
          description = "Have the app pick a recipe for you! This will fill in all empty days with a random recipe."
        )$
        step(
          el = "bookmark_btn",
          title = "Bookmark",
          description = "This will generate a link that you can copy and paste. The link will save the recipes you have selected, along with all of the options you have set. This will not save any modifications you have made to the shopping list."
        )
      
      ## Get a random recipe
      random_recipe <- random_recipe(r, n = 1)
      
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
  
  # observe({
  #   ## Get the days to randomly assign
  #   current_recipes <<- list(
  #     r$Monday,
  #     r$Tuesday,
  #     r$Wednesday,
  #     r$Thursday,
  #     r$Friday,
  #     r$Saturday,
  #     r$Sunday
  #   ) 
  #   
  #   days_to_assign <- current_recipes[sapply(current_recipes, is.null)] 
  #   
  #   print("hey")
  #   print(days_to_assign)
  #   print(length(days_to_assign) == 0)
  #   
  #   if (length(days_to_assign) == 0) {
  #     shinyjs::disable("plan_for_me")
  #   }
  # })
  
  ## Plan for me action ----
  observeEvent(
    eventExpr = input$plan_for_me,
    handlerExpr = {
      ## Sample 7 recipes
      r$plan_for_me <- random_recipe(r, n = 7)
      
      week_days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
      
      ## Get the days to randomly assign
      days_to_assign <- list(
        r$Monday,
        r$Tuesday,
        r$Wednesday,
        r$Thursday,
        r$Friday,
        r$Saturday,
        r$Sunday
      ) %>% 
        setNames(week_days) %>% 
        .[sapply(., is.null)] %>% 
        names()
      
      ## Iterate over the days to assign and update the wanted input
      sapply(
        X = days_to_assign,
        FUN = function(x) {
          current_day <- as.numeric(factor(x, levels = week_days))
          
          updateSelectizeInput(
            session = session,
            inputId = names(r$dow_inputs)[current_day],
            selected = r$plan_for_me[current_day]
          )
        }
      )
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

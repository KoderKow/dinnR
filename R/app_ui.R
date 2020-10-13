#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      titlePanel("What's for dinnR?"),
      sidebarLayout(
        sidebarPanel(
          mod_recipe_input_ui("recipe_input_ui_sunday"),
          mod_recipe_input_ui("recipe_input_ui_monday"),
          mod_recipe_input_ui("recipe_input_ui_tuesday"),
          mod_recipe_input_ui("recipe_input_ui_wednesday"),
          mod_recipe_input_ui("recipe_input_ui_thursday"),
          mod_recipe_input_ui("recipe_input_ui_friday"),
          mod_recipe_input_ui("recipe_input_ui_saturday")
        ),
        mainPanel(
          tabsetPanel(
            tabPanel(
              title = "Shopping List",
              mod_shopping_list_ui("shopping_list_ui_1")
            ),
            tabPanel(
              title = "Recipes",
              mod_recipes_ui("recipes_ui_1")
            )
          )
        )
        
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'dinnR'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}


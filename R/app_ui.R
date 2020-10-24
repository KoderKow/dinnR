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
          mod_recipe_input_ui("recipe_input_ui_saturday"),
          tags$hr(),
          fluidRow(
            align = "center",
            # actionButton("plan_for_me", "I don't feel like planning")
            shinyWidgets::actionBttn(
              inputId = "plan_for_me",
              label = "Plan For Me",
              style = "unite", 
              color = "warning"
            )
          ),
          tags$hr(),
          fluidRow(
            col_2(),
            col_10(
              shinyWidgets::materialSwitch(
                inputId = "show_store",
                label = "Show Store*", 
                value = TRUE,
                status = "warning"
              ) %>%
                bsplus::bs_embed_tooltip(title = "Shows the store to purchase the ingredients based on the store feature in the source data")
            )
          )
        ),
        mainPanel(
          tabsetPanel(
            id = "tabs",
            tabPanel(
              title = "Shopping List",
              value = "shopping_list",
              mod_shopping_list_ui("shopping_list_ui_1")
            ),
            tabPanel(
              title = "Recipes",
              value = "recipes",
              mod_recipes_ui("recipes_ui_1")
            ),
            tabPanel(
              title = "About",
              value = "about",
              mod_about_ui("about_ui_1")
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
    ),
    golem::activate_js(),
    bsplus::use_bs_tooltip(),
    includeHTML(system.file("app/www/google_analytics.html", package = "dinnR"))
    
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}


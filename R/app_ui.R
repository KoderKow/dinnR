#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  # current_version <- paste0("v", golem::get_golem_version())
  
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      titlePanel("What's for dinnR?"),
      sidebarLayout(
        sidebarPanel(
          mod_recipe_input_ui("recipe_input_ui_dow_1"),
          mod_recipe_input_ui("recipe_input_ui_dow_2"),
          mod_recipe_input_ui("recipe_input_ui_dow_3"),
          mod_recipe_input_ui("recipe_input_ui_dow_4"),
          mod_recipe_input_ui("recipe_input_ui_dow_5"),
          mod_recipe_input_ui("recipe_input_ui_dow_6"),
          mod_recipe_input_ui("recipe_input_ui_dow_7"),
          tags$hr(),
          fluidRow(
            align = "center",
            shinyWidgets::actionBttn(
              inputId = "plan_for_me",
              label = "Plan For Me",
              style = "unite", 
              color = "warning"
            ),
            actionButton(
              inputId = "guided_tour",
              label = "Guided Tour"
            )
          ),
          div(
            id = "sidebar-footer",
            tags$a(
              style = "font-size: 12px;",
              href= "https://github.com/KoderKow/dinnR",
              target = "_blank",
              textOutput("package_version")
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
              title = "Submit a Recipe",
              value = "submit_a_recipe",
              mod_submit_a_recipe_ui("submit_a_recipe_ui_1")
            ),
            tabPanel(
              title = "Options",
              value = "options",
              mod_options_ui("options_ui_1")
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
    sever::use_sever(),
    cicerone::use_cicerone(),
    includeHTML(system.file("app/www/google_analytics.html", package = "dinnR"))
    
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}


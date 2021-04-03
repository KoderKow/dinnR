#' submit_a_recipe UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_submit_a_recipe_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$br(),
    tags$h2("Submit a Recipe!"),
    tags$br(),
    tags$div(
      tags$p(
        style = "font-size : 15px",
        "If you would like to add a recipe to the app, you can make a submission ",
        tags$a(
          "here!",
          href = "https://forms.gle/T5pHyzZrNhzDrEd37",
          target = "_blank"
        ),
        "Please be sure to include your information if you would like to be credited!"
      )
    )
  )
}

#' submit_a_recipe Server Function
#'
#' @noRd 
mod_submit_a_recipe_server <- function(input, output, session){
  ns <- session$ns
  
}

## To be copied in the UI
# mod_submit_a_recipe_ui("submit_a_recipe_ui_1")

## To be copied in the server
# callModule(mod_submit_a_recipe_server, "submit_a_recipe_ui_1")


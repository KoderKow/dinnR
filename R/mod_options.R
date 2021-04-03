#' options UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_options_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      style = "margin-top:15px;",
      col_3(
        selectInput(
          inputId = ns("radio_measurement"),
          label = "Measurement System",
          choices = c("Imperial", "Metric"),
          selected = "Imperial"
        )
      ),
      col_3(
        selectInput(
          inputId = ns("dietary_preference"),
          label   = "Dietary Prefences",
          ## This may need to change when we add more diet styles to the data
          choices = c("None", "Vegan", "Vegetarian"),
          selected = "None"
        )
      )
    )
  )
}

#' options Server Function
#'
#' @noRd 
mod_options_server <- function(input, output, session, r){
  ns <- session$ns
  
  ## Store ingredient measurement style ----
  observeEvent(input$radio_measurement, r$radio_measurement <- input$radio_measurement)
  
  ## Store dietary preferences ----
  observeEvent(input$dietary_preference, {
    r$dietary_preference <- input$dietary_preference
    
    if (input$dietary_preference == "Vegan") {
      r$recipes <-
        dinn %>% 
        dplyr::filter(vegan == TRUE) %>% 
        dplyr::pull(name) %>% 
        unique() %>% 
        sort()
    } else if (input$dietary_preference == "Vegetarian") {
      r$recipes <-
        dinn %>% 
        dplyr::filter(vegetarian == TRUE) %>% 
        dplyr::pull(name) %>% 
        unique() %>% 
        sort()
    } else {
      ## This is for when dietary preference is "None"
      r$recipes <-
        dinn %>% 
        dplyr::pull(name) %>% 
        unique() %>% 
        sort()
    }
  })
}

## To be copied in the UI
# mod_options_ui("options_ui_1")

## To be copied in the server
# callModule(mod_options_server, "options_ui_1")


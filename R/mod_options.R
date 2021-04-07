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
          label = "Measurement",
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
      ),
      col_3(
        uiOutput(ns("starting_date_ui")) %>% 
          tippy::with_tippy(
            tooltip = "<span style='font-size:14px;'>Chaning the start date will reset any selected recipes!</span>",
            placement = "right",
            allowHTML = TRUE
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
  
  ## Starting date ----
  output$starting_date_ui <- renderUI({
    dateInput(
      inputId = ns("starting_date"),
      label = "Start Date",
      value = r$calendar_dates[1],
      min     = Sys.Date()
    ) 
  })
  
  observeEvent(
    eventExpr = input$starting_date, 
    handlerExpr = {
      date_sequence <- seq.Date(
        from = input$starting_date,
        length.out = 7,
        by = "days"
      )
      
      names(date_sequence) <- weekdays(date_sequence)
      
      r$calendar_dates <- date_sequence
      
      }
    )
}

## To be copied in the UI
# mod_options_ui("options_ui_1")

## To be copied in the server
# callModule(mod_options_server, "options_ui_1")


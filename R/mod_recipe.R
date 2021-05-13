#' recipe_input UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipe_input_ui <- function(id, h4 = TRUE){
  ns <- NS(id)
  ## The dow can be extracted from the ID, this is needed to show what day a user is selecting a recipe for
  # dow <- strsplit(id, "_")[[1]][4]
  # dow <- paste0(toupper(substr(dow, 1, 1)), substr(dow, 2, nchar(dow)))
  tagList(
    uiOutput(ns("title")),
    tags$div(
      id = ns("recipe_guide"),
      selectizeInput(
        inputId = ns("recipe"),
        label = NULL,
        choices = NULL
      )
    )
  )
}

#' recipe_input Server Function
#'
#' @noRd 
mod_recipe_input_server <- function(input, output, session, r){
  ns <- session$ns
  rv <- reactiveValues(
    i = as.numeric(strsplit(ns(""), "_|-")[[1]][5])
  )
  
  observeEvent(
    eventExpr = r$calendar_dates,
    handlerExpr = {
      rv$calendar_date <- r$calendar_dates[rv$i]
      rv$dow_title <- names(r$calendar_dates)[rv$i]
      #print(rv$i)
      #print(paste0("dow_", rv$i))
    }
  )
  
  observeEvent(
    eventExpr = {
      r$recipes
      r$calendar_dates
    },
    handlerExpr = {
      if (is.null(r$bm_dow[[rv$i]])) {
        updateSelectizeInput(
          session = session,
          inputId = "recipe",
          choices = c("Other Plans", r$recipes),
          selected = ""
        )
      } else {
        updateSelectizeInput(
          session = session,
          inputId = "recipe",
          choices = c("Other Plans", r$recipes),
          selected = r$bm_dow[[rv$i]]
        )
      }
      
      if (!rv$dow_title %in% c(NA, "Recipe")) {
        
        calendar_date <- r$calendar_dates[names(r$calendar_dates) == rv$dow_title]
        
        display_month <- lubridate::month(calendar_date, label = TRUE)
        ## It would be nice to superscript the scales::ordinal part
        display_day <- 
          calendar_date %>% 
          lubridate::day() 
        
        ## Thank you https://stackoverflow.com/questions/7963898/extracting-the-last-n-characters-from-a-string-in-r
        last_number <- 
          display_day %>% 
          sub('.*(?=.$)', '', ., perl = T) %shh% 
          as.integer()
        
        superscript <- dplyr::case_when(
          last_number == 1L ~ "st",
          last_number == 2L ~ "nd",
          last_number == 3L ~ "rd",
          TRUE ~ "th"
        )
        
        rv$display_dow_title <-
          paste0(rv$dow_title, ": ", display_month, " ", display_day, "<sup>", superscript, "</sup>") %>% 
          HTML()
      }
      
      output$title <- renderUI({
        ## Show servings when a recipe is selected
        if (!input$recipe %in% c("", "Other Plans")) {
          tags$div(
            class = "dow-titles",
            tags$h5(rv$display_dow_title),
            tags$p(
              class = "dow-servings",
              "Servings: ", unique(r[[rv$dow_title]]$number_of_servings)
            )
          )
        } else {
          tags$div(
            tags$h4(rv$display_dow_title)
          )
        }
      })
    }
  )
  
  observeEvent(
    eventExpr = input$recipe,
    handlerExpr = {
      r$dow_inputs[[ns("recipe")]] <- ns("recipe")
      if (input$recipe != "" & input$recipe != "Other Plans") {
        
        r[[rv$dow_title]] <- 
          dinn %>% 
          dplyr::filter(name == input$recipe) 
        
        r$last_selected <- input$recipe
      } else {
        r[[rv$dow_title]] <- NULL
      }
    }
  )
}

## To be copied in the UI
# mod_recipe_input_ui("recipe_input_ui_1")

## To be copied in the server
# callModule(mod_recipe_input_server, "recipe_input_ui_1")


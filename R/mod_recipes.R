#' recipes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipes_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$br(),
    selectizeInput(
      inputId = ns("recipe"),
      label = NULL,
      choices = NULL,
      options = list(placeholder = "Select a recipe to display")
    ),
    tags$br(),
    uiOutput(ns("url")),
    uiOutput(ns("submitted_by")),
    tags$h4("Ingredients"),
    gt::gt_output(ns("table"))
  )
}

#' recipes Server Functions
#'
#' @noRd 
mod_recipes_server <- function(input, output, session, r){
  ns <- session$ns
  
  observeEvent(
    eventExpr = r$recipes,
    handlerExpr = {
      updateSelectizeInput(
        session = session,
        inputId = "recipe",
        choices = r$recipes,
        selected = ""
      )
    }
  )
  
  observeEvent(
    eventExpr = {
      r$last_selected
    },
    handlerExpr = {
      if (r$tabs == "recipes") {
        updateSelectizeInput(
          session = session,
          inputId = "recipe",
          selected = r$last_selected
        )
      }
    }
  )
  
  observeEvent(
    eventExpr = {
      input$recipe
    },
    handlerExpr = {
      r$recipe <-
        dinn %>% 
        dplyr::filter(name == input$recipe) 
    }
  )
  
  
  output$url <- renderUI({
    url <- unique(r$recipe$url)
    submitted_by_name <- unique(r$recipe$submitted_by_name)
    submitted_by_url  <- unique(r$recipe$submitted_by_url)
    
    validate(
      need(
        expr = !is.null(url),
        message = "Select a recipe to view"
      )
    )
    
    tagList(
      tags$p(
        "Recipe URL: ",
        tags$a(
          url,
          href = url,
          target = "_blank"
        )
      ),
      tags$p(
        "Submitted By: ",
        tags$a(
          submitted_by_name,
          href = submitted_by_url,
          target = "_blank"
        )
      ),
      tags$hr(),
      tags$p(
        class = "dow-servings",
        "Servings: ", unique(r$recipe$number_of_servings)
      )
    )
  })
  
  output$table <- gt::render_gt({
    req(nrow(r$recipe) > 0)
    
    d_sum <- 
      r$recipe %>% 
      dplyr::group_by(grocery_section) %>% 
      dplyr::mutate(rn = dplyr::row_number()) %>% 
      dplyr::ungroup() %>% 
      dplyr::mutate(
        gs_lead = dplyr::lead(grocery_section),
        grocery_section = ifelse(
          test = rn > 1,
          yes = NA,
          no = grocery_section
        )
      ) %>% 
      dplyr::select(
        grocery_section,
        ingredient, 
        quantity,
        units
      ) %>% 
      dplyr::arrange(grocery_section, ingredient)
    
    d_sum %>% 
      gt::gt() %>% 
      gt_theme_538(
        table.background.color = "#e2e8f0",
        column_labels.background.color = "#e2e8f0",
        row.striping.background_color = "#d1dbe7",
      ) %>% 
      gt_dinnR()
  })
}

## To be copied in the UI
# mod_recipes_ui("recipes_ui_1")

## To be copied in the server
# callModule(mod_recipes_ui, "recipes_ui_1")

#' shopping_list UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_shopping_list_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$br(),
    uiOutput(ns('undoUI')),
    tags$br(),
    fluidRow(
      col_2(),
      col_8(DT::DTOutput(ns("table"))),
      col_2()
    )
    # gt::gt_output(ns("table"))
  )
}

#' shopping_list Server Function
#'
#' @noRd 
mod_shopping_list_server <- function(input, output, session, r){
  ns <- session$ns
  
  observeEvent(input$deletePressed, {
    req(r$d_sum)
    
    rowNum <- parseDeleteEvent(input$deletePressed)
    
    dataRow <- r$d_sum[rowNum,]
    
    # Put the deleted row into a data frame so we can undo
    # Last item deleted is in position 1
    r$deletedRows <- rbind(dataRow, r$deletedRows)
    
    r$deletedRowIndices <- append(
      r$deletedRowIndices,
      rowNum,
      after = 0
    )
    
    # Delete the row from the data frame
    r$d_sum <- r$d_sum[-rowNum,]
  })
  
  observeEvent(input$undo, {
    req(r$d_sum)
    
    if(nrow(r$deletedRows) > 0) {
      row <- r$deletedRows[1, ]
      r$d_sum <- addRowAt(r$d_sum, row, r$deletedRowIndices[[1]])
      
      # Remove row
      r$deletedRows <- r$deletedRows[-1,]
      # Remove index
      r$deletedRowIndices <- r$deletedRowIndices[-1]
    }
  })
  
  # Disable the undo button if we have not deleted anything
  output$undoUI <- renderUI({
    if(!is.null(r$deletedRows) && nrow(r$deletedRows) > 0) {
      actionButton(ns('undo'), label = 'Undo delete', icon('undo'))
    }
  })
  
  observe({
    d <- dplyr::bind_rows(
      r$Sunday,
      r$Monday,
      r$Tuesday,
      r$Wednesday,
      r$Thursday,
      r$Friday,
      r$Saturday
    )
    
    table_need <- need(
      expr = nrow(d) > 0,
      message = "Please select a recipe to begin building a shopping list."
    )
    
    validate(table_need)
    
    r$d_sum <-
      d %>% 
      dplyr::mutate(
        quantity = ifelse(
          test = r$radio_measurement == "Metric" & units == "cup",
          yes = quantity * 128,
          no = quantity
        ),
        units = ifelse(
          test = r$radio_measurement == "Metric" & units == "cup",
          yes = "g",
          no = units
        )
      ) %>% 
      dplyr::group_by(grocery_section, ingredient, units) %>% 
      dplyr::summarize(amount = sum(quantity)) %>% 
      dplyr::select(grocery_section, ingredient, amount, units)
  })
  
  output$table <- DT::renderDT({
    req(nrow(r$d_sum) > 0)
    
    r$d_sum %>% 
      deleteButtonColumn(ns('delete_button'), ns) %>% 
      DT::datatable(
        rownames = FALSE,
        selection = "none",
        escape = FALSE,
        colnames = c(
          "Grocery Section",
          "Ingredient",
          "Amount",
          "Units"
        ),
        ## Extensions
        extensions = c('Buttons', 'RowGroup', "Scroller"),
        options = list(
          ## Table view only
          dom = 'Bt',
          buttons = c('pdf', 'print'),
          pageLength = 5000,
          rowGroup = list(dataSrc = 1),
          columnDefs = list(
            list(visible = FALSE, targets=1),
            list(targets = 0:4, sortable = FALSE, className = 'dt-left')
            
          )
        ),
        editable = list(
          target = "cell",
          disable = list(columns = c(4))
        )
      )
  })
}

## To be copied in the UI
# mod_shopping_list_ui("shopping_list_ui_1")

## To be copied in the server
# callModule(mod_shopping_list_server, "shopping_list_ui_1", r)

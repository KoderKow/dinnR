#' A column of delete buttons for each row in the data frame for the first column
#'
#' @param df data frame
#' @param id id prefix to add to each actionButton. The buttons will be id'd as id_INDEX.
#' @return A DT::datatable with escaping turned off that has the delete buttons in the first column and \code{df} in the other
deleteButtonColumn <- function(df, id, ns, ...) {
  # function to create one action button as string
  f <- function(i) {
    delete_pressed_text <- paste0(
      'Shiny.setInputValue(\"',
      ns("deletePressed"),
      '\",  this.id, {priority: "event"})'
    )
    
    # https://shiny.rstudio.com/articles/communicating-with-js.html
    as.character(actionButton(paste(ns(id), i, sep="_"), label = NULL, icon = icon('trash'), onclick = delete_pressed_text))
  }
  
  deleteCol <- unlist(lapply(seq_len(nrow(df)), f))
  
  # Return a data table
  cbind(delete = deleteCol, df)
}

#' Extracts the row id number from the id string
#' @param idstr the id string formated as id_INDEX
#' @return INDEX from the id string id_INDEX
parseDeleteEvent <- function(idstr) {
  res <- as.integer(sub(".*_([0-9]+)", "\\1", idstr))
  if (! is.na(res)) res
}

#' Adds a row at a specified index
#'
#' @param df a data frame
#' @param row a row with the same columns as \code{df}
#' @param i the index we want to add row at.
#' @return the data frame with \code{row} added to \code{df} at index \code{i}
addRowAt <- function(df, row, i) {
  # Slow but easy to understand
  if (i > 1) {
    rbind(df[1:(i - 1), ], row, df[-(1:(i - 1)), ])
  } else {
    rbind(row, df)
  }
  
}
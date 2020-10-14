#' 538 {gt} Theme
#' 
#' Amazing theme made by [Tom Mock](https://themockup.blog/posts/2020-09-26-functions-and-themes-for-gt-tables/)
#'
#' @param data gt object.
#' @param ... Additional params to pass to [gt::tab_options()]
#'
#' @return a gt object
#' @export
gt_theme_538 <- function(data,...) {
  data %>%
    gt::opt_all_caps()  %>%
    gt::opt_table_font(
      font = list(
        gt::google_font("Chivo"),
        gt::default_fonts()
      )
    ) %>%
    gt::tab_style(
      style = gt::cell_borders(
        sides = "bottom", color = "transparent", weight = gt::px(2)
      ),
      locations = gt::cells_body(
        columns = TRUE,
        # This is a relatively sneaky way of changing the bottom border
        # Regardless of data size
        rows = nrow(data$`_data`)
      )
    )  %>% 
    gt::opt_row_striping() %>% 
    gt::tab_options(
      # column_labels.background.color = "white",
      table.border.top.width = gt::px(3),
      table.border.top.color = "transparent",
      table.border.bottom.color = "transparent",
      table.border.bottom.width = gt::px(3),
      column_labels.border.top.width = gt::px(3),
      column_labels.border.top.color = "transparent",
      column_labels.border.bottom.width = gt::px(3),
      column_labels.border.bottom.color = "black",
      data_row.padding = gt::px(3),
      source_notes.font.size = 12,
      table.font.size = 16,
      heading.align = "left",
      row_group.background.color = "#a1a6c4",
      row_group.border.top.color = "#989898",
      row_group.border.bottom.style = "none",
      ...
    ) 
}

#' Custom {gt} Styles
#' 
#' Some extra styling for the tables used in this app.
#'
#' @param .data a gt object.
#'
#' @return a gt object
#' @export
gt_dinnR <- function(.data) {
  p <-
    .data %>% 
    gt::cols_label(grocery_section = "  Grocery Section") %>% 
    gt::fmt_missing(
      columns = dplyr::everything(),
      missing_text = ""
    ) %>% 
    gt::tab_style(
      style = list(
        gt::cell_text(
          indent = gt::px(15),
          weight = "bold"
        ),
        gt::cell_borders(
          sides = "right",
          color = "#989898",
          weight = gt::px(1.5)
        )
      ),
      locations = gt::cells_body(columns = dplyr::vars(grocery_section))
    )
  
  return(p)
}
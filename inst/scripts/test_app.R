if (r$tabs == "recipes") {
  updateSelectizeInput(
    session = session,
    inputId = "recipe",
    selected = input$recipe
  )
}
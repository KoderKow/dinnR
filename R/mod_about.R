#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_about_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$br(),
    tags$h2("About"),
    tags$br(),
    # Row 1 Start
    tags$div(
      style = "display: grid; grid-template-columns: 2fr 1fr; grid-column-gap: 20px;",
      # Column 1
      tags$div(
        tags$p(
          style = "font-size : 15px",
          "Hello! Thank you for checking out the dinnR app! This app was made to simplify the dinner planning process. dinnR helps to create a weekly meal plan and generate a shopping list to show the ingredients needed for the week. If you would like to add a recipe to the app, you can make a submission ",
          tags$a(
            "here. ",
            href = "https://forms.gle/T5pHyzZrNhzDrEd37",
            target = "_blank"
          ),
          "Please be sure to include your information if you would like to be credited!"
        ),
        tags$br(),
        tags$p(
          style = "font-size : 15px",
          "We do stream the making of this app over on our ",
          tags$a(
            "Twitch channel",
            href = "https://twitch.tv/theeatgamelove",
            target = "_blank"
          ),
          ", so come say hello and let us know if you have any comments or ideas! Join our ",
          tags$a(
            "discord",
            href = "https://discord.gg/hrec3NP",
            target = "_blank"
          ),
          " and talk with us in the  #dinnr-suggestions channel as well. <3",
        )
        ),
        # column 2
        tags$div(
          tags$img(
            src = "https://raw.githubusercontent.com/koderkow/dinnr/master/inst/other/hex-dinnR.png",
            align = "center",
            width = "200"
          )
        # Row 1 End
      )
    ),
    tags$br(),
    tags$br(),
    tags$hr(
      style = "border:0;height:1px;background-image:linear-gradient(to right, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.75), rgba(0, 0, 0, 0));"
    ),
    tags$h2("Creators"),
    ## Row two Start
    tags$div(
      style = "display: grid; grid-template-columns: 1fr 2fr; grid-column-gap: 10px;",
      ## Column 1
      tags$div(
        tags$img(
          src = "www/about_us.jpg",
          style = "width:250px;border-radius:15px;border:6px solid #fe7f2d"
        )
      ),
      ## Column 2
      tags$div(
        tags$h3("Lexi"),
        tags$p("Lexi is the project manager and lead UX designer for dinnR. She also does data entry on the delicious recipes we enjoy!"),
        tags$a(
          icon("globe", class = "fa-2x"),
          href = "https://eatgamelove.com",
          style = "margin-right: 10px;",
          target = "_blank"
        ),
        tags$a(
          icon("twitter", class = "fa-2x"),
          href = "https://twitter.com/actualtoilet",
          style = "margin-right: 10px;",
          target = "_blank"
        ),
        tags$a(
          icon("linkedin", class = "fa-2x"),
          href = "https://www.linkedin.com/in/alexismeskowski/",
          style = "margin-right: 10px;",
          target = "_blank"
        ),
        tags$a(
          icon("github", class = "fa-2x"),
          href = "https://github.com/AlexisMeskowski/",
          style = "margin-right: 10px;",
          target = "_blank"
        ),
        tags$h3("Kyle"),
        tags$p("Does the code part."),
        tags$a(
          icon("twitter", class = "fa-2x"),
          href = "https://twitter.com/koderkow",
          style = "margin-right: 10px;",
          target = "_blank"
        ),
        tags$a(
          icon("linkedin", class = "fa-2x"),
          href = "https://www.linkedin.com/in/kylewharris/",
          style = "margin-right: 10px;",
          target = "_blank"
        ),
        tags$a(
          icon("github", class = "fa-2x"),
          href = "https://github.com/KoderKow/",
          style = "margin-right: 10px;",
          target = "_blank"
        )
      )
      ## Row 2 End
    ),
    tags$br(),
    tags$hr(
      style = "border:0;height:1px;background-image:linear-gradient(to right, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.75), rgba(0, 0, 0, 0));"
    ),
    tags$p(
      "This app was created using the ",
      tags$a(
        "R",
        href = "https://www.r-project.org/about.html"
      ),
      " programming language. This app uses the ",
      tags$a(
        "{shiny}",
        href = "https://rstudio.com/products/shiny/"
      ),
      " and ",
      tags$a(
        "{golem}",
        href = "https://thinkr-open.github.io/golem/"
      ),
      " frameworks. The data was last updated on ",
      paste0(
        months(as.Date(last_updated)),
        " ",
        format(as.Date(last_updated,format="%Y-%m-%d"), format = "%d"),
        ", ",
        format(as.Date(last_updated,format="%Y-%m-%d"), format = "%Y"),
        "."
      )#,
      # "App version: ",
      # paste0(
      #   golem::get_golem_version(),
      #   "."
      # )
    )
  )
}

#' about Server Functions
#'
#' @noRd 
mod_about_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
  })
}

## To be copied in the UI
# mod_about_ui("about_ui_1")

## To be copied in the server
# mod_about_server("about_ui_1")

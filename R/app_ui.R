#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd

# library(shinipsum)
# library(ggplot2)
# library(DT)
# library(fakir)

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    useShinyjs(),
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      titlePanel("Simple Analysis Panel"),
      div(
        id = "float-box",
        fileInput("file", "upload"),
        actionButton("submit", "Submit"),
        textOutput("errmessage")
      ),
      div(
        id="main-page",
        style="display: none",
        sidebarLayout(
          sidebarPanel(
            selectInput("graph_type", "Choose Graph Type:",
                        choices = c("Scatter Plot", "Histogram"),
                        selected = "Scatter Plot"),
            uiOutput("varSelections"),
          ),
          mainPanel(
            textOutput("inputted_file"),
            plotOutput("main_output")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "golex"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

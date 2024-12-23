#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyjs
#' @import readxl
#' @noRd
library(shinyjs)
library(readxl)
app_server <- function(input, output, session) {
  # Your application server logic
  observeEvent(input$submit, {
    file_name <- input$file$name
    file_path <- input$file$datapath
    if (is.null(input$file)) {
      output$errmessage <- renderText("Please upload a file")
    } else if (!grepl("\\.(csv|xlsx)$", file_name, ignore.case = TRUE)) {
      output$errmessage <- renderText("Please upload a .csv or .xlsx file")
    } else {
      print(file_name)
      output$inputted_file <- renderText({
        paste("You've uploaded", file_name)
      })
      shinyjs::show("main-page")
      shinyjs::hide("float-box")

      ##start analysis
      if(grepl("\\.csv$", file_name, ignore.case = TRUE)) {
        my_data <- read.csv(file_path)
      } else {
        my_data <- read.excel(file_path)
      }

      output$data_table <- renderTable({
        head(my_data, 10)
      })

      ##render variable selection by graph type
      output$varSelections <- renderUI({
        if (input$graph_type == "Scatter Plot") {
          tagList(
            selectInput("x_var", "Select X Variable", choices = names(my_data)),
            selectInput("y_var", "Select Y Variable", choices = names(my_data)),
            actionButton("genScatter", "Generate Plot")
          )
        } else if (input$graph_type == "Histogram") {
          tagList(
            selectInput("x_var", "Select X Variable", choices = names(my_data)),
            actionButton("genHist", "Generate Plot")
          )
        }
      })

      ##generate scatter plot
      observeEvent(input$genScatter, {
        xvar <- input$x_var
        yvar <- input$y_var
        output$main_output <- renderPlot({
          generate_scatter_plot(my_data[[xvar]], my_data[[yvar]],xvar,yvar)
          #plot(my_data[[xvar]], my_data[[yvar]], xlab = xvar, ylab = yvar)
          })
      })

      ##generate histogram
      observeEvent(input$genHist, {
        xvar <- input$x_var
        output$main_output <- renderPlot({
          hist(my_data[[xvar]], xlab = xvar)
        })
      })
    }
  })
}

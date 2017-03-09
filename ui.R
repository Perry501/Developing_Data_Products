
library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Model Building and Predictive Analysis"),
  
  navbarPage("Predictive analysis on mtcars dataset",
          tabPanel("The App",
                   sidebarLayout(
                           sidebarPanel(
                                   h3("Slope"),
                                   textOutput("slopeOut"),
                                   h3("Intercept"),
                                   textOutput("intOut"),
                                   h3("Adjusted R-Squared"),
                                   textOutput("corOut"),
                                   selectInput("select_x_axis", "Select column for X axis (Predictor)", choices = colnames(mtcars), selected = colnames(mtcars)[1]),
                                   selectInput("select_y_axis", "Select column for Y axis (Outcome)", choices = colnames(mtcars), selected = colnames(mtcars)[1]),
                                   uiOutput("sliderX")
                           ),
                           
                           mainPanel(
                                   plotOutput("plot1", brush = brushOpts(
                                           id = "brush1"
                                   )),
                                   h3("Predicted Y Value"),
                                   textOutput("y_pred"),
                                   textOutput("legend")
                           )
                   )
          ),
          tabPanel("About" ,
                   mainPanel(
                           includeMarkdown("documentation.md")
                           #includeMarkdown("test.md")
                   )
          )    
  )
  
))

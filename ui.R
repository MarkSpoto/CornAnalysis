library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predicted Corn Value Using Selected Variables"),
  
  hr(),
  
  fluidRow(
    column(3, style="background-color: lightgray",
           checkboxGroupInput("variables", "Select Variables to use in Model:",
                              choiceNames = list("Ethanol", "Soybeans", "Mpls Hi Temp"),
                              choiceValues = list("Ethanol.ZKH18", "Soybeans.ZSH18", "Mpls..MN.HI.Temp"),
                              selected = list("Ethanol.ZKH18")),
           hr(),
           tags$div("Adjust Variable Values for Predicting Price", style="text-decoration: underline; font-weight: bold;"),
           tags$div("(Note: Slider Value only valid for selected variables)", style="font-style: italic; font-size: 10px;"),
           sliderInput("sliderEthanol", "Ethanol Value:", min=1, max=4, step=0.25, value = 1.25),
           sliderInput("sliderSoybeans", "Soybean Value:", min=1, max=12, step=0.25, value = 9.50),        
           sliderInput("sliderWeather", "Weather Temp:", min=-20, max=90, step=1, value = 75)           
    ),
    column(6,
           plotOutput("plotModel")
    )
    
  ),
  fluidRow(
    column(3,
           hr(),
           h3("Prediction"),
           tags$div(tags$span("Corn:", style = "font-weight:bold;"),
                    tags$span(id = "cornValueText", class="shiny-text-output", style = "font-weight: bold; color: red;"))
    ),
    column(6,
           hr(),
           tags$div("Regression Model:", style = "font-weight: bold;"),
           verbatimTextOutput("fitInfo"))
  )
))

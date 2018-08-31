library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  tags$head(
    tags$style(".title {margin: auto; width: 50%}")
  ),
  tags$div(class="title", titlePanel("Corn Analysis Modeler")),
  
  hr(),
  
  fluidRow(
    column(3,
           fluidRow(
             column(12, style="background-color: lightgray",
                    tags$br(),
                    checkboxGroupInput("variables", "Select Variables to use in Model:",
                                       choiceNames = list("Ethanol", "Soybeans", "Mpls Hi Temp"),
                                       choiceValues = list("Ethanol.ZKH18", "Soybeans.ZSH18", "Mpls..MN.HI.Temp"),
                                       selected = list("Ethanol.ZKH18")),
                    tags$br()
            )),
           fluidRow(
             column(12,
                    hr(),
                    h3("Prediction"),
                    tags$div(tags$span("Corn:", style = "font-weight:bold;"),
                             tags$span(id = "cornValueText", class="shiny-text-output", style = "font-weight: bold; color: red;"))
             )
           ),
           fluidRow(
             column(12, style="background-color: lightgray",
                    tags$div("Adjust Variable Values for Predicting Price", style="text-decoration: underline; font-weight: bold;"),
                    tags$div("(Note: Slider Value only valid for selected variables)", style="font-style: italic; font-size: 10px;"),
                    tags$br(),
                    sliderInput("sliderEthanol", "Ethanol Value:", min=1, max=4, step=0.25, value = 1.25),
                    sliderInput("sliderSoybeans", "Soybean Value:", min=1, max=12, step=0.25, value = 9.50),        
                    sliderInput("sliderWeather", "Weather Temp:", min=-20, max=90, step=1, value = 75)           
                    
             )
           )
    ),
    column(6,
           plotOutput("plotModel"),
           hr(),
           tags$div("Regression Model:", style = "font-weight: bold;"),
           verbatimTextOutput("fitInfo"))
    )
  )
)

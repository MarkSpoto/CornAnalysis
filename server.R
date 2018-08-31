
library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  researchdata <- reactive({ 
    mydata <- read.csv("./cropdata.csv", sep = ",", header = TRUE, fill = TRUE)
    mydata <- na.omit(mydata)
    dataColumnTest = mydata[c("Corn.ZCH18","Soybeans.ZSH18","Ethanol.ZKH18","Bismarck..ND.HI.Temp")]
    apply(dataColumnTest,per_row,pMiss)
    mydata$CloseDate <- as.POSIXct(strptime(as.character(mydata$Close.Date), "%m/%d/%Y"))
    
    return(mydata)
  })
  
  corndata <- read.csv("./cropdata.csv", sep = ",", header = TRUE, fill = TRUE)
  
  modeldata <- reactive({
    corndata[, c("Corn.ZCH18", input$variables)] %>%  filter(Corn.ZCH18 < 4)
  })
  
  modelfit <- reactive({
    mdata <- modeldata()
    if (ncol(mdata) > 1) {
      fit <- lm(Corn.ZCH18 ~ ., data=mdata)
    }
    fit
  })
  
  modelpred <- reactive({
    mdata <- modeldata()
    fit <- modelfit()
    if (ncol(mdata) > 1) {
      mdata$predicted = predict(fit)
      mdata$residuals = residuals(fit)
    }
    mdata
  })
  
  output$cornValueText <- renderText({
    soybeanValue <- input$sliderSoybeans
    ethanolValue <- input$sliderEthanol
    weatherValue <- input$sliderWeather
    model <- modelfit()
    
    predict(model, newdata = data.frame(Soybeans.ZSH18 = soybeanValue, Ethanol.ZKH18 = ethanolValue, Mpls..MN.HI.Temp = weatherValue))
  })
  
  output$fitInfo <- renderPrint({
    summary(modelfit())
  })
  
  output$selectedVariables <- renderText({
    variables <- paste(input$variables, collapse = ", ")
    #paste("You Selected: ", variables)
    str(variables)
  })
  
  output$plotModel <- renderPlot({
    model <- modelpred()
    if (any(names(model) == "predicted")) {
      
      model %>% gather(key = "iv", value = "residuals", -Corn.ZCH18, -predicted, -residuals) %>%  # Get data into shape
        ggplot(aes(x = residuals, y = Corn.ZCH18)) + # Note use of 'x' here and next line
        geom_smooth(method = "lm", se = FALSE, color = "black") +
        geom_segment(aes(xend = residuals, yend = predicted), alpha = .2) +
        geom_point(aes(color = residuals)) +
        scale_color_gradient2(low = "green", mid = "blue", high = "red") +
        guides(color = FALSE) +
        geom_point(aes(y = predicted), shape = 1) +
        xlab("Residuals Based on Model and Each Variable") +
        facet_grid(~ iv, scales = "free_x") +  # Split panels here by 'iv'
        theme_bw()
    }
  })
  
  output$cornPriceText <- renderText({
    
  })
})


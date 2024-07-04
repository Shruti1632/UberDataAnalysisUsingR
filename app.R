library(shiny)
library(shinythemes)
library(readr)
library(ggplot2)
library(ggthemes)
library(lubridate)
library(dplyr)
library(tidyr)
library(DT)
library(scales)

apr_data <- read.csv("D:/Uber Data Analysis/Uber/uber-raw-data-apr14.csv")
may_data <- read.csv("D:/Uber Data Analysis/Uber/uber-raw-data-may14.csv")
jun_data <- read.csv("D:/Uber Data Analysis/Uber/uber-raw-data-jun14.csv")
jul_data <- read.csv("D:/Uber Data Analysis/Uber/uber-raw-data-jul14.csv")
aug_data <- read.csv("D:/Uber Data Analysis/Uber/uber-raw-data-aug14.csv")
sep_data <- read.csv("D:/Uber Data Analysis/Uber/uber-raw-data-sep14.csv")

data_2014 <- rbind(apr_data,may_data, jun_data, jul_data, aug_data, sep_data)
data_2014$Date.Time <- as.POSIXct(data_2014$Date.Time, format = "%m/%d/%Y %H:%M:%S")

data_2014$Time <- format(as.POSIXct(data_2014$Date.Time, format = "%m/%d/%Y %H:%M:%S"), format="%H:%M:%S")

data_2014$Date.Time <- ymd_hms(data_2014$Date.Time)

data_2014$day <- factor(day(data_2014$Date.Time))
data_2014$month <- factor(month(data_2014$Date.Time, label = TRUE))
data_2014$year <- factor(year(data_2014$Date.Time))
data_2014$dayofweek <- factor(wday(data_2014$Date.Time, label = TRUE)) 
data_2014$hour <- factor(hour(hms(data_2014$Time)))
data_2014$minute <- factor(minute(hms(data_2014$Time)))
data_2014$second <- factor(second(hms(data_2014$Time)))


ui <- fluidPage(
shinyServer(
  pageWithSidebar(
    headerPanel("Uber Data Analysis"),
    
    sidebarPanel(
      selectInput("Select","Please select",
                  choices = c("Trips by Hour","Trips EveryDay","Trips by Month","Trips by Day and Month","Trips by every minute")),
      
    ),
    
    mainPanel(
      plotOutput("myPlot")
    )
    
  )
)


)

server <- function(input, output) 
{
  output$myPlot <- renderPlot({
    selectType <- input$Select
    
    
    if(selectType == "Trips by Hour"){
      
      x <- as.numeric(data_2014$hour)
    }
     if(selectType == "Trips EveryDay")
     {
       x <- as.numeric(data_2014$day)
     }
     if(selectType == "Trips by Month")
     {
       x <- as.numeric(data_2014$month)
     }
    if(selectType == "Trips by Day and Month")
    {
      x <- as.numeric(data_2014$day+data_2014$month)
    }
    
    if(selectType == "Trips by minute")
    {
      x <- as.numeric(data_2014$minute)
    }
   
    hist(x, col=c("red","blue","orange","black","green","purple","pink"))
  })
  
}  
  
  


shinyApp(ui = ui, server = server)

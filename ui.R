# ui.R

library(shiny)

#source("helpers.R")
#library(maps) #state maps
#library(mapproj) #map projections

#data(us.cities) # need for reactive output (slider for cities and populations)
#dataset <- us.cities

#data(state) #part of core R - state database
choices <- state.name

fluidPage(
  
  titlePanel("City Populations - Approximated as of January 2006"),
  
  sidebarPanel(
    
    selectizeInput("varstate", label = "Start Typing to Select State", 
                   choices, selected = NULL, multiple = FALSE,
                   options = list(maxOptions=10)),

    sliderInput("minpop", label = "Cities with Min Population of:", 
                min=4000, max=1000000, value=40000),

    submitButton("Update View", icon("refresh"))    
  ),
  
  mainPanel(
    textOutput("text1"),
    textOutput("text2"),
    plotOutput("City_map"))

)
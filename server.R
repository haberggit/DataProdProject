# server.R - Data Prod Projects is the working directory
# Before proceeding be sure you are in the working directory for this project

library(shiny)

source("helpers.R")
library(maps) #state maps
library(mapproj) #map projections

data(us.cities) #population of US cities and lat/longs
data(state) #maps 2 digit abbreviation to state name
dataset <- us.cities #might be able to delete this command

# Define server logic required to draw state maps
shinyServer(function(input, output) {
  
  output$text1 <- renderText({
    paste("You have selected", input$varstate)
  })
  
    # get index of state.name and state.abb from input value passed (input$varstate)
    # state databases are passed from the ui.R, data(state) command
  
    #output$text3 <- renderText({
    #  sel.state.index <- grep(input$varstate, state.name)
    #  paste("State Abbreviation", state.abb[sel.state.index])
    #})
  
  # This code can be deleted, and the ui output command deleted
  #output$State_map <- renderPlot({
  #    sel.state.lower <- tolower(input$varstate)
  #    sel.state.index <- grep(input$varstate, state.name) 
  #    sel.state.abb <- state.abb[sel.state.index] 
  #    map(database="state", regions=sel.state.lower)  
  #  })
  
  # potentially delete this if the new code below works
  #output$City_map <- renderPlot({
  #  sel.state.lower <- tolower(input$varstate)
  #  sel.state.index <- grep(input$varstate, state.name) 
  #  sel.state.abb <- state.abb[sel.state.index] 
  #  map(database="state", regions=sel.state.lower)  
  #  map.cities(us.cities, country=sel.state.abb, capitals=2)
  # })
  
  ### NOTE, EVERYTHING ABOVE IS WORKING
  # be careful that the above doesn't return an empty dataset (must have at least one city)
  # if input$minpop > max(us.cities$pop for the state), 
  # set the threshold pop value in the map call to the max city pop for the state
  
    
    #dataset <- us.cities[us.cities$country.etc==sel.state.abb & us.cities$pop >= threshPop,]
    
  
  output$City_map <- renderPlot({
    sel.state.lower <- tolower(input$varstate)
    sel.state.index <- grep(input$varstate, state.name) 
    sel.state.abb <- state.abb[sel.state.index] 
    
    output$text2 <- renderText({"Cities that meet the criteria (plus capital) are displayed"})
    
    ## change this code -- count number of cities that fit the threshold
    ## display a message with the number or 0 if there are none
    
    if (max(us.cities$pop[us.cities$country.etc==sel.state.abb]) < input$minpop) 
      #threshPop <- max(us.cities$pop[us.cities$country.etc==sel.state.abb])
      output$text2 <- renderText({
        paste("Try a smaller minimum population, the median for cities in the state is ", 
              format(median(us.cities$pop[us.cities$country.etc==sel.state.abb]), 
                     big.mark=","))
      })
    
    map(database="state", regions=sel.state.lower)  
    map.cities(us.cities, capitals=2)
    map.cities(us.cities, minpop=input$minpop)
    
    })
  
  }
)
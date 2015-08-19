# server.R - DataProdProjects is the working directory

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
    paste("You have selected", input$varstate, ".", "Some nearby cities may also appear for information purposes.")
  })
  
    # get index of state.name and state.abb from input value passed (input$varstate)
    # state databases are passed from the ui.R, data(state) command
  
  output$City_map <- renderPlot({
    sel.state.lower <- tolower(input$varstate)
    sel.state.index <- grep(input$varstate, state.name) 
    sel.state.abb <- state.abb[sel.state.index] 
    
    output$text2 <- renderText({"Cities that meet the criteria (plus capital) are displayed"})
    
    # check for an empty dataset returned (no cities match threshold)
    # message about city names may not be displayed (too many for readability)
    
    if (max(us.cities$pop[us.cities$country.etc==sel.state.abb]) < input$minpop) 
      #threshPop <- max(us.cities$pop[us.cities$country.etc==sel.state.abb])
      output$text2 <- renderText({
        paste("Try a smaller minimum population, the median for cities in the state is ", 
              format(median(us.cities$pop[us.cities$country.etc==sel.state.abb]), 
                     big.mark=","))
      })
    else if (quantile(us.cities$pop[us.cities$country.etc==sel.state.abb])[2] > input$minpop)
      # city names may not be displayed due to large number of results
    output$text2 <- renderText({
      paste("Due to potentially large number of results, city names may not be displayed.  The median for the state is  ", 
            format(median(us.cities$pop[us.cities$country.etc==sel.state.abb]), 
                   big.mark=","))
    })
    
    map(database="state", regions=sel.state.lower, col="gray90", fill=TRUE)  
    map.cities(us.cities, capitals=2)
    map.cities(us.cities, minpop=input$minpop, col="blue")
    
    })
  
  }
)
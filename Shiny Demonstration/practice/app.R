library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)
library(shinythemes)
library(DT)

listings <- read.csv("listings.csv")

ui <- shinyUI(navbarPage("QASR Practice Shiny", 
                         #fill in your theme here find them at https://rstudio.github.io/shinythemes/
                         theme = shinytheme(#theme here),
                         
                         #Plot Tab
                         tabPanel("Plotting",
                                  fluidRow(
                                    #Put a plot in here 
                                  )),
                         
                         #Map
                         tabPanel("Map",
                                  tags$div(class = 'outer', 
                                           leafletOutput("MAP"))), 
                         tabPanel("Data Table" 
                                  )
                          
                          )))

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$MAP<- renderLeaflet({
    
    leaflet()                                              %>% 
      addTiles(group = "OpenStreetMap")                    %>% 
      
      addProviderTiles(providers$OpenStreetMap)            %>% 
      
      setView(lat  = 40.7, 
              lng  = -73.9, 
              zoom = 11)  
    ##End of Map
  })
  
  observe({
    #Change the Leaflet map here (add in markers for the listings)
    newmap <- leafletProxy("MAP")
    
    return(newmap)
  })
  
  output$Plot <- renderPlot({
   #make a plot here
  })
  
  output$Table <- renderDataTable(
    #make a data table here
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)


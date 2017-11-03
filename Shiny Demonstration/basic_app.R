library(shiny)
library(faraway)
library(dplyr)

data(aatemp)
ui <- fluidPage(
   titlePanel("Airline Passenger data"),
   # Sidebar with a slider input for max year
   sidebarLayout(
      sidebarPanel(
         sliderInput("Year",
                     "Select Max Year:",
                     min   = min(aatemp$year),
                     max   = max(aatemp$year),
                     value = max(aatemp$year))
      ),
      # Show a plot
      mainPanel(
         plotOutput("linePlot")
      )
   )
)

server <- function(input, output) {
   
   output$linePlot <- renderPlot({
     
      newdata <- filter(aatemp, year < input$Year)
      
      ggplot(newdata, aes(year, temp)) + 
        geom_point() + 
        geom_smooth(method = "lm")
      
   })
}
# Run the application 
shinyApp(ui = ui, server = server)


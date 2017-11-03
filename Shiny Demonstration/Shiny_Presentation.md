Working With Shiny in R
========================================================
author: Sam Gass
date: 
autosize: true

What is Shiny? 
========================================================

An R Interface that allows us to transform our analyses
into Interactive
- Dashboards
- Webpages
- Presentations

It is also a good introduction to object oriented programming

What Can We Do With Shiny?
========================================================
Take most analyses/visualizations you create in 
R and turn them into an interactive page:

Some packages that work well in Shiny
- ggplot
- leaflet (interactive maps)
- plotly (interactive visualizations)
- DT (interactive data tables)


Server vs UI
========================================================
Two Primary Parts of Shiny Code: Server and UI

Server (I'll focus more on this side today)
- The back end of your code here you create plots, 
manipulate data, and tell the app what to do when the user
clicks something

UI
- Where you put all of the different output that comes out of
your server side
- Make your App pretty

Basic Pipeline
========================================================

Normally your R Code runs like this

- DataFrame ----> ggplot function ------> graph

In Shiny We Add a Couple of Steps to this

- UI Click ----> Server Manipulation ---> New DataFrame ------> ggplot function ------> graph -----> UI Placement

Basic App (UI)
========================================================


```r
ui <- fluidPage(
   titlePanel("Airline Passenger data"),
   #Slider input for max year
   sidebarLayout(
      sidebarPanel(
         sliderInput("Year",
                     "Select Max Year:",
                     min   = min(aatemp$year),
                     max   = max(aatemp$year),
                     value = max(aatemp$year))
      ),
      # Show plot
      mainPanel(
         plotOutput("linePlot")
      )
   )
)
```


Basic App (Server)
========================================================


```r
server <- function(input, output) {
   
   output$linePlot <- renderPlot({
     
      newdata <- filter(aatemp, year < input$Year)
      
      ggplot(newdata, aes(year, temp)) + 
        geom_point() + 
        geom_smooth(method = "lm")
      
   })
}
```

UI Inputs
========================================================
How we create buttons/controls for the user to initiate changes in the code

- SliderInput (number slider)
- SelectInput (dropdown menu)
- CheckBoxInput (check boxes for multiple selections)
- Many Others


```r
selectInput(inputId = "choices", 
            label = h2("Title Here"), 
            selected = NULL, #selected when app starts        
            choices = c(#list of options))
```

- On the server side the choice selected in the dropdown menu will be saved as input$choices 

Output Functions
========================================================

- dataTableOutput(): Interactive DataTable
- htmlOutput(): raw HTML output
- imageOutput(): image
- plotOutput(): plot
- textOutput(): text

Output Syntax
========================================================
To display the output in the UI insert it into the UI with the output code and the name of the output like this: 


```r
#UI
ui <- fluidPage(
  plotOutput("plot")
)
#Server
server <- function(input, output) {
  plot <- renderPlot({
    return(ggplot(aes(x, y)) + geom_point())
  })
}
```


Reactive Expressions
========================================================
When the user clicks a button to change the input, we use reactive
expressions on the server side to change the output. 

These work in conjunction with the output syntax to create a dynamic
page that reacts when the user changes the environment


Reactive Expressions
========================================================
There are a few different types of reactive expressions including: 

- renderDataTable()
- renderPlot()
- renderImage()
- renderTable()
- renderText()
- renderUI()

Reactive Expressions
========================================================
We can also just use the reactive function to change a dataset. This 
can change multiple outputs that rely on the same data. 


```r
FilteredData <- reactive({
  #Take the user input and filter the dataset
  newdata <- filter(oldata, variable = input$userinput) 
  
  return(newinput) #return the new data
})
```


Action Buttons
========================================================
Using action buttons means the program will wait for the user 
to click the button before performing some action: 


```r
ui <- fluidPage(
  actionButton(inputID = "button", 
               label = "CLICK!")
)
```

Observe Events
========================================================
observeEvent waits for some specific action to be taken before 
performing a specific task. Works well with actionButtons


```r
ui <- fluidPage(
  actionButton(inputID = "button", 
               label = "CLICK!")
)

server <- function(input, output){
  observeEvent(input$button, #wait for click
               print("You Clicked The Button!"))
}
```

Observe Events
========================================================
Using the action button and observe event with user text input is a good
way to let the user type something in then use that string to create some 
output

```r
ui <- fluidPage(
  fluidRow(align = "center", 
           tags$form(textInput("address", 
                               h4("Please Enter Your Home Address"), "", 
                               width = "800px"), 
           actionButton("district", "Enter", width = "200px"))), 
)

server <- function(input, output){
  observeEvent(input$district, {
    output$schooldist <- renderText({
      
      if(input$address == "")
        return("")
      
      dist <- findschooldist(text$address)
      dist <- paste("You are located in District", dist, sep = " ")
      isolate(input$address)
      return(dist)
    })
  })
}
```


Using Leaflet With Shiny
========================================================
- One of the best visualization tools in R is Leaflet. It allows you to 
build interactive maps. 
- Leaflet works very well in Shiny for visualizing geospatial data


```r
server <- function(input, output) {

  output$brooklynmap<- renderLeaflet({
    
    leaflet()                                              %>% 
      addTiles(group = "OpenStreetMap")                    %>% 
      
      addProviderTiles(providers$OpenStreetMap)            %>% 
      
      setView(lat  = 40.7, 
              lng  = -73.9, 
              zoom = 11)  
  })
}
```


Using Leaflet With Shiny
========================================================
If you have a group of locations that you want to change with user input 
you can use leafletProxy

```r
server <- function(input, output) {

  output$brooklynmap<- renderLeaflet({
    
    leaflet()                                              %>% 
      addTiles(group = "OpenStreetMap")                    %>% 
      
      addProviderTiles(providers$OpenStreetMap)            %>% 
      
      setView(lat  = 40.7, 
              lng  = -73.9, 
              zoom = 11)  
    
    observe({
      new_map = leafletProxy("brooklynmap", data = tract) %>% 
        clearMarkers() %>% 
        clearShapes() %>%
        addMaerkers(data = filter(data, locations %in% input$userinput))
    })
  })
}
```


Using CSS to Customize App
========================================================
This can get complicated if you don't know CSS, but if you just 
want to change the overall style of the app you can just download a 
CSS theme and put it into the app pretty easily:




```
Error in parse(text = x, srcfile = src) : <text>:3:2: unexpected ')'
2:   #Rest of the Page Here
3: ))
    ^
```

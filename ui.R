library(shiny)
library(shinydashboard)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)



 genrelist= data%>%select(genres)%>%distinct()
 data$genres = factor(data$genres, levels = c(genrelist))
shinyUI(dashboardPage(skin = "purple",
  dashboardHeader(title = "Acoustic Prism", titleWidth = 350), 

  
#### set up sidebar panel   
 dashboardSidebar(
    sidebarUserPanel(" ", image = "https://s3.amazonaws.com/resources.audiob.us/icons/1243252791.jpg?v=1496294085"),
      sidebarMenu(id = "sideBarMenu",
      menuItem("GenrePlot", tabName = "GenrePlot", icon = icon("dance")),
      menuItem("Correlation Plot", tabName = "CorrPlot"),
      menuItem("DanceTime", tabName = "DanceTime", icon = icon("clock")),
      
      menuItem("Tracks", tabName ="Tracks", icon = icon("music")),
      menuItem("Polar-CoordPlot", tabName = "CoordPlot", icon = icon("Coordinate")),
      conditionalPanel("sideBarMenu == 'CoordPlot",
                       selectizeInput("genre", "Genre: click on Polar-CoordPlot ", choices=unique(z$genres))
                                      
                       
                                     
      )

    )),

## set up dashboard body 
  dashboardBody(
    
    tabItems(tabItem(tabName = "GenrePlot",
                     fluidRow(box(plotOutput("genrePlot"), width=11, height=500)
                              
                     )),
             tabItem(tabName = "DanceTime",
                     fluidRow(
                     box(plotOutput("timeplot",height = 550), width = 12))
             ),
    ##-------tab item2 
    tabItem(tabName = "Tracks", 
            fluidRow(
              (title = "Most Dancable Song..."),
              box(HTML('<iframe width ="560" height="315" src ="https://www.youtube.com/embed/xGrWNhDC3N8" frameborder= "0" allowfullscreen></iframe>')))),
          
    
    ###---tab item 3 
    tabItem(tabName = "CorrPlot",
               fluidRow(
                 column(width = 6,
                    box(width = NULL,
                  plotlyOutput("heat")
                    )
                 ),
                 column(width = 6,
                   box(width = NULL,
                       (title = "Scatterplot"),
                       plotlyOutput("scatterplot"),
                      fluidRow(box( verbatimTextOutput("selection")))
                   )
                 )
               )
             ),
    ### -------- tab item 4
             tabItem(tabName = "CoordPlot",
                     
                  fluidRow(
                   box(width = NULL,
                                (title ="Attributes of Genre"))),
                       box(
                          plotOutput("barPlot",height = 550), width = 8),
                  box(
                    title ="Attributes Description", width = 4, solidHeader = TRUE,
                    h5("Valence:> High value means more positive the song(happy words)"),
                    h5("Speechiness:> This is an estimate of the amount of spoken word in a particular track"),
                    h5(" Liveness:> Presence of an audience in the recording"),
                    h5("Instrumentalness: Vocal content. Higher value means less vocal content. "),
                    h5("Energy:> The energy of a song - the higher the value, the more energtic. "),
                    h5("Danceability:>The higher the value, the easier it is to dance to this song."),
                    h5( "Acousticnes:> The higher the value the more acoustic the song." )
                       )
                  )

         
                  )

             
                  )
                              
 ))

  

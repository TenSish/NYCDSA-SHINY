library(shiny)
library(shinydashboard)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(data.table)

data = read.csv("/Users/Sishe/Desktop/NYCDSA-SHINY/Music Copy.csv")
 genrelist= data%>%select(genres)%>%distinct()
 data$genres = factor(data$genres, levels = c(genrelist))
shinyUI(dashboardPage(skin = "purple",
  dashboardHeader(title = "Music Data: Acoustic Prism", titleWidth = 350), 
  
  dashboardSidebar(
    sidebarUserPanel(" ", image = "https://s3.amazonaws.com/resources.audiob.us/icons/1243252791.jpg?v=1496294085"),
    sidebarMenu(id = "sideBarMenu",
      menuItem("GenrePlot", tabName = "GenrePlot", icon = icon("map")),
      menuItem("Tracks", tabName ="Tracks", icon = icon("music")),
      menuItem("Correlation Plot", tabName = "CorrPlot", icon = icon("genre")),
      menuItem("Polar-Coord Plot", tabName = "CoordPlot", icon = icon("CoordPlot")),
      
      
      conditionalPanel("sideBarMenu == 'CoordPlot",
                       
                       selectizeInput("genre", "Genre", choices, 
                                      selected = choices[1])
                       )
   
    )),
  dashboardBody(
    tabItems(tabItem(tabName = "GenrePlot",
                     fluidRow(box(plotlyOutput("genrePlot"), width=11, height=500)
                              
                     )),
 
             
             tabItem(tabName = "Tracks", 
                    fluidRow(
                      h3("Most Dancable Song.."),
box(HTML('<iframe width ="560" height="315" src ="https://www.youtube.com/embed/xGrWNhDC3N8" frameborder= "0" allowfullscreen></iframe>')))),
             
             
             tabItem(tabName = "CorrPlot",
               fluidRow(
                 column(width = 6,
                    box(width = NULL,
                  
                        plotlyOutput("heat")
                    )
                 ),
                 column(width = 6,
                   box(width = NULL,
                       h2("Scatterplot"),
                       plotlyOutput("scatterplot"),
                      fluidRow(box( verbatimTextOutput("selection")))
                   )
                 )
               )
             ),
            
             tabItem(tabName = "CoordPlot",
                  fluidRow(
                      box(width = NULL,
                                ("Attributes of Genre"))),
                       box(
                          plotOutput("barPlot",height = 550), width = 8),
                  box(
                    title ="Attributes Description", width = 4, solidHeader = TRUE,
                    h5("Valence:> High value means more positive the song(happy words)"),
                    h5("Speechiness:> This is an estimate of the amount of spoken word in a particular track"), 
                    h5("Hottness:> How popular the song is right now."),
                    h5(" Liveness:> Presence of an audience in the recording"), 
                    h5("Instrumentalness: Vocal content. Higher value means less vocal content. "),
                    h5("Energy:> The energy of a song - the higher the value, the more energtic. "), 
                    h5("Danceability:>The higher the value, the easier it is to dance to this song."), 
                    h5( "Artist_hotness:> How much buzz the artist is getting right now."), 
                    h5("Artist_Familiarity:> How well-known the artist is?  " ), 
                    h5( "Acousticnes:> The higher the value the more acoustic the song." )
                       )
                  )
                  )
                              
                     )
)
)
  

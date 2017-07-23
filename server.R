
##server.R#

library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)





shinyServer(function(input, output, session) {
  a = data%>%select(danceability, genres)%>%mutate(danceability = round(as.numeric(danceability),4))%>%group_by(genres)%>%summarize(dance.prob = mean(danceability))
  newa = a%>%top_n(10)
   output$genrePlot <- renderPlot({
     ggplot(newa, aes(x = genres, y = dance.prob, fill = genres)) + geom_tile(height = .3, width = .1, show.legend =  FALSE) + labs( y = "Mean Danceability Score" , x = "GENRES (Top 10 genres with highest mean danceability score)")
  })
  
  ################################Correlation plot start#################################################
 
   b = data[ ,c(3:13)]
   correlation <- round(cor(b), 3)
   nms <- names(b)
  output$heat <- renderPlotly({
  
    plot_ly(x = nms, y = nms, z = correlation, 
            key = correlation, type = "heatmap", source = "heatplot") %>%
      layout(xaxis = list(title = ""), 
             yaxis = list(title = ""))
  })
  
  output$scatterplot <- renderPlotly({
    s <- event_data("plotly_click", source = "heatplot")
    if (length(s)) {
      vars <- c(s[["x"]], s[["y"]])
      d <- setNames(b[vars], c("x", "y"))
      yhat <- fitted(lm(y ~ x, data = d))
      plot_ly(d, x = ~x) %>%
        add_markers(y = ~y) %>%
        add_lines(y = ~yhat) %>%
        layout(xaxis = list(title = s[["x"]]), 
               yaxis = list(title = s[["y"]]), 
               showlegend = FALSE)
    } else {
      plotly_empty()
    }
  })
  
  output$selection <- renderPrint({
    s <- event_data("plotly_click")
    if (length(s) == 0) {
      "Click on a cell in the heatmap to display a scatterplot"
    } else {
      cat("You selected: \n\n")
      as.list(s)
    }
  })

########################start coord plot  #####################################

 
observe({
 output$barPlot <- renderPlot({
z %>% filter(genres == input$genre) %>%  group_by(genres, newname2)%>%summarise(value = mean(values)) %>% 
ggplot(aes(x = newname2, y= value, fill = newname2)) +
geom_bar(stat= "identity", width = 1, show.legend = FALSE) + labs(x = "Genre") +  coord_polar() 
 })
  })
  
  
  
  
########################Dancetime plot 
  Dancetime = data[, c(4,14,17)]
  Dancetime$date_released = as.character(Dancetime$date_released)
  Dancetime$date_released = substr(Dancetime$date_released,1,4 )
  g = Dancetime%>%group_by(genres,date_released)%>%summarise(avg = mean(danceability))%>%group_by(date_released)%>%filter(avg == max(avg))%>%drop_na()
  output$timeplot<- renderPlot({
    
    g%>%ggplot( aes(x=date_released, y=avg, fill = genres)) + geom_bar(stat="identity") + labs(x = "Year", y ="Mean Danceability Score") + theme(legend.position="top")
  })
    
  
  
})



  


##server.R#

library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(data.table)




shinyServer(function(input, output) {

  output$genrePlot <- renderPlotly({

    gp = plot_ly(a, x = ~genres, y = ~dance.prob  , type = 'bar',
           marker = list(color = 'rgb(158,202,225)',line = list(color = 'rgb(8,48,107)',
                                          width = 1.5))) %>%layout(title = "Danceability ~ Genre",
                                        xaxis = list(title = ""), yaxis = list(title = "Danceability"))
    
    
    layout(gp, autosize = TRUE)
  })
  
  ################################Correlation plot start#################################################
 
  
  output$heat <- renderPlotly({
    b = data[ ,c(3:13)]
    correlation <- round(cor(b), 3)
    nms <- names(b)
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
})



  

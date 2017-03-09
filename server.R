
library(shiny)
library(ggplot2)
library(ggthemes)


shinyServer(function(input, output) {
        
        
        model <- reactive({
                x_axis <- input$select_x_axis
                y_axis <- input$select_y_axis
                brushed_data <- brushedPoints(mtcars, input$brush1,
                                              xvar = x_axis, yvar = y_axis)
                if(nrow(brushed_data) < 2){
                        return(NULL)
                }
                formula <- as.formula(paste(y_axis, "~", x_axis))
                lm(formula = formula, data = brushed_data)
                
        })
        modelpred <- reactive ({
                x_axis <- input$select_x_axis
                inputX <- input$sliderX
                newdata <- data.frame(inputX)
                names(newdata) <- x_axis
                predict(model(), newdata = newdata)
        })
        output$y_pred <- renderText ({
                ifelse(is.null(model()),
                       "No Model Found",
                       ifelse(input$select_x_axis == input$select_y_axis,
                              input$sliderX,
                              round(modelpred(), digits = 2)
                       ))
        })
        output$slopeOut <- renderText({
                ifelse(is.null(model()),
                       "No Model Found",
                       ifelse(input$select_x_axis == input$select_y_axis,
                              1,
                              round(model()[[1]][2], digits = 3)
                              ))
        })
        output$intOut <- renderText({
                ifelse(is.null(model()),
                       "No Model Found",
                       ifelse(input$select_x_axis == input$select_y_axis,
                              0,
                              round(model()[[1]][1], digits = 3)
                       ))
        })
        output$corOut <- renderText({
                ifelse(is.null(model()),
                       "No Model Found",
                       ifelse(input$select_x_axis == input$select_y_axis,
                              "NA",
                              round(summary(model())[[9]], digits = 3)
                       ))
        })
        output$sliderX <- renderUI ({
                min_x_axis <- min(mtcars[, input$select_x_axis], na.rm = T)
                max_x_axis <- max(mtcars[, input$select_x_axis], na.rm = T)
                median_x_axis <- median(mtcars[, input$select_x_axis], na.rm = T)
                sliderInput("sliderX", paste0("Select ",input$select_x_axis," value to predict ", input$select_y_axis, " (Y Value)")
                            , min = min_x_axis,
                            max = max_x_axis,
                            value = median_x_axis,
                            round = -1, step = 0.1)
        })
        output$plot1 <- renderPlot({
                x_axis <- input$select_x_axis
                y_axis <- input$select_y_axis
                slider <- input$sliderX
                
                plot <- ggplot(data = mtcars, aes_string(x = x_axis, y = y_axis))
                plot <- plot + geom_point(aes(size = 2), show.legend = F) +
                        theme_economist() +
                        labs(fill = "",
                             title = paste0(x_axis," Vs ", y_axis,"\n"),
                             x = paste0("\n", x_axis),
                             y = paste0(y_axis, "\n")) +
                        theme(legend.position = "bottom",
                              axis.text = element_text( size = 16),
                              axis.title = element_text(size = 20),
                              plot.title = element_text(size = 25),
                              legend.title =  element_text( size = 16) ,
                              legend.text = element_text( size = 14),
                              strip.text = element_text( size = 16),
                              axis.line = element_blank())
                if(!is.null(model())){
                       ifelse(x_axis == y_axis,
                              plot <- plot + geom_abline(intercept = 0, slope = 1, color = "blue", size = 1.5) +
                                      geom_hline(color = "red", yintercept = slider, linetype = "dashed", size = 0.5) +
                                      geom_vline(color = "red", xintercept = slider, linetype = "dashed", size = 0.5),
                              plot <- plot + geom_abline(intercept = model()[[1]][1], slope = model()[[1]][2], color = "blue", size = 1.5) +
                                      geom_hline(color = "red", yintercept = modelpred(), linetype = "dashed", size = 0.5) +
                                      geom_vline(color = "red", xintercept = slider, linetype = "dashed", size = 0.5))
                }
                plot
        })
})

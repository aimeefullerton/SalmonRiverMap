# Shiny App to display temperature time series for Salmon River basin salmon subbasins
# AH Fullerton, last updated 5/25/24

library(shiny)
library(sf)
library(mapsf)

# Define UI for application 
ui <- fluidPage(
  
  navbarPage(
    "Salmon River Site Map",
              # Sidebar panel for user selections 
             sidebarLayout(
               sidebarPanel(width = 3,
                 checkboxGroupInput(inputId = "sites", label = "Sites:",
                      choices = points$Stream,
                      selected = NA),
                 checkboxInput(inputId = "only",label = "Show only selected sites", 
                      value = F),
                  downloadButton('savePlot1', "Save figure")
               ), #end sidebarPanel
               mainPanel(
                 plotOutput("Plot1", height = "700px")
               ) #end mainPanel
             ), #end sidebarLayout
  ) #end navbarPage
) #end fluidPage


# Define server logic 
server <- function(input, output, session) {
  
  updateSource <- reactive({
    return(input)
  })
  
  updatePlot1 <- reactive({
    sites.sel <- updateSource()$sites
    lbls <- points$Lbl[points$Stream %in% sites.sel]
    sel.sites.only <- updateSource()$only
    if(sel.sites.only == T & length(sites.sel) > 0) {
      points2plot <- subset(points, Stream %in% sites.sel)
    } else {
      points2plot <- points
    }

    # Map
    par(mar = c(0,0,0,1), oma = c(1,1,1,7), cex = 1.3)
    mf_theme(bg = "white", tab = TRUE, mar = c(0,0,0,0), pos = "left")
    mf_map(salmon_bdry, col = "#d8d7d2", border = NA) #"#d4dfe2"
    mf_map(streams, col = "#689ba7", lwd = 1, add = T)
    mf_map(streams5, col = "#20839b", lwd = rivers$StreamOrde/4, add = T)
    clr <- rep("grey10",length(points2plot$Lbl)); clr[which(points2plot$Lbl %in% lbls)] <- "#ac330d"
    clr2 <- rep("white",length(points2plot$Lbl)); clr2[which(points2plot$Lbl %in% lbls)] <- "#fccd04"
    if(sel.sites.only == T & length(sites.sel) > 0){
      clr <- rep("grey10",length(points2plot$Lbl))
      clr2 <- rep("white",length(points2plot$Lbl))
    }
    mf_label(points2plot, "Lbl", col = clr, halo = T, bg = clr2, overlap = F, q = 3, lines = F, cex = 0.7)
 
    # Add inset map 
    mf_inset_on(x = "worldmap", pos = "bottomleft", cex = 0.3)
    mf_map(crb, col = "gray90", border = 0)
    mf_map(pnw, col = NA, border = "white", add = T)
    mf_map(salmon_bdry, col = "gray60", border = NA, add = T)
    mf_label(pnw, "Lbl", col = "black", overlap = T, q = 3)
    mf_map(st_zm(rivers7), col = "gray40", add = T)
    mf_inset_off()
    
    # Add cartographic details
    mf_arrow("bottomleft")
    mf_scale(pos = "bottom", cex = 1.2)
    
    # Add legend
    par(mar = c(0, 5, 0, 1), oma = c(1, 1, 1, 7), new = T)
    legend("topright", legend = paste0(points2plot$Lbl, ": ", points2plot$Stream), pch = NA, bty = 'n', 
           xjust = 0, yjust = 0, xpd = T)

    recordPlot()
  })
  
  output$Plot1 <- renderPlot({
    updatePlot1()
  })
  
  output$savePlot1 <- downloadHandler(
    filename = function(){"SalmonRiverMap.png"}, 
    content = function(file){
      png(file, width = 14, height = 10, res = 300, units = "in")
      replayPlot(updatePlot1())
      dev.off()
    }
  )  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

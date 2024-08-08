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
                 checkboxInput(inputId = "only", label = "Show only selected sites", 
                      value = F),
                 checkboxInput(inputId = "shwnm", label = "Display site names", 
                      value = F),
                 checkboxInput(inputId = "inset", label = "Display inset map", 
                      value = F),
                 checkboxInput(inputId = "streams", label = "Label streams", 
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
    show.names <- updateSource()$shwnm
    show.inset <- updateSource()$inset
    show.streams <- updateSource()$streams

    streams5$NmLbl <- streams5$GNIS_NAME
    unique(streams5$NmLbl)
    streams5$NmLbl[!streams5$COMID %in% c(23449281, 23478471, 23518761, 23551114)] <- NA
    lbl <- streams5[!is.na(streams5$NmLbl),]
    lbl$NmLbl[2:4] <- gsub( " River", "", lbl$NmLbl[2:4])
    lbl$NmLbl[lbl$NmLbl == "Salmon"] <- "East Fork Salmon"
    
    # Map
    mf_theme(bg = "white", tab = TRUE, mar = c(0,0,0,0), pos = "left")
    mf_map(streams, col = "#689ba7", lwd = 1)
    mf_map(salmon_bdry, col = "#d8d7d2", border = NA, add = T) #"#d4dfe2"
    mf_map(streams5, col = "#20839b", lwd = rivers$StreamOrde/4, add = T)
    mf_map(streams, col = "#689ba7", lwd = 0.5, add = T)
    
    # add stream name labels
    if(show.streams == T){
    mf_label(lbl[1,], "NmLbl", overlap = F, lines = T, col = "#20839b",cex = 01.1, adj = c(0.2, 2), family = "serif", font = 3)
    mf_label(lbl[4,], "NmLbl", overlap = F, halo = T, bg = "#d8d7d2", col = "#20839b", lines = T, cex = 1, adj = c(0.3, -1), srt = 48, family = "serif", font = 3)
    mf_label(lbl[3,], "NmLbl", overlap = F, halo = T, bg = "#d8d7d2", col = "#20839b", lines = T, cex = 1, adj = c(0.5, -4), srt = 35, family = "serif", font = 3)
    mf_label(lbl[2,], "NmLbl", overlap = F, halo = T, bg = "#d8d7d2", col = "#20839b", lines = T, cex = 1, adj = c(-0.1, -2), srt = 55, family = "serif", font = 3)
    }
    
    # Add sites
    clr <- rep("grey10",length(points2plot$Lbl)); clr[which(points2plot$Lbl %in% lbls)] <- "#ac330d"
    clr2 <- rep("white",length(points2plot$Lbl)); clr2[which(points2plot$Lbl %in% lbls)] <- "#fccd04"
    if(sel.sites.only == T & length(sites.sel) > 0){
      clr <- rep("grey10",length(points2plot$Lbl))
      clr2 <- rep("white",length(points2plot$Lbl))
    }
    # LISA WOULD LIKE A SECTION OF STREAM HIGHLIGHTED IN ADDITION TO THE LABEL POINT
    #working: mf_map(streams[streams$COMID %in% points2plot$COMID,], col = "#fccd04", lwd = 4, add = T)
    #p2p_adj <- points2plot
    #p2p_adj$Lat <- p2p_adj$Lat + 0.2; p2p_adj$Lon <- p2p_adj$Lon + 0.2
    mf_label(points2plot, "Lbl", col = clr, halo = T, bg = clr2, overlap = F, q = 3, lines = F, cex = 0.9)
    #mf_map(points2plot, pch = 19, add = T, col = clr, cex = 0.7)
    
    # Add cartographic details
    mf_arrow("bottomleft")
    mf_scale(pos = "bottom", cex = 1.2)
    
    # Add inset map 
    if(show.inset == T){
    mf_inset_on(x = "worldmap", pos = "bottomleft", cex = 0.3)
    mf_map(crb, col = "gray90", border = 0)
    mf_map(pnw, col = NA, border = "white", add = T)
    mf_map(salmon_bdry, col = "gray60", border = NA, add = T)
    mf_label(pnw, "Lbl", col = "black", overlap = T, q = 3)
    mf_map(st_zm(rivers7), col = "gray40", lwd = 2, add = T)
    mf_inset_off()
    }
    
    # Add legend
    if(show.names == T){
      par(mar = c(0, 5, 0, 1), oma = c(1, 1, 1, 7), new = T)
      legend("topright", legend = paste0(points2plot$Lbl, ": ", points2plot$Stream), pch = NA, bty = 'n', 
             xjust = 0, yjust = 0, xpd = T)
    }
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

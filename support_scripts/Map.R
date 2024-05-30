library(sf)
library(mapsf)

# Load data
points <- sf::read_sf("data/shapefiles/Idaho_sites_prj.shp")
points$Lbl[points$Lbl == "BearValley"] <-"BearV"
points$Stream[points$Stream == "West Fork Chamberlain Creek"] <- "West Fork Chamberlain" 
points$Stream[points$Stream == "Big Creek (lower)/Rush Creek"] <- "Big Creek (lower)" 
points <- points[order(points$Name),]
crb <- sf::read_sf("data/shapefiles/CRB_boundary_prj.shp")
pnw <- sf::read_sf("data/shapefiles/PNW_prj.shp")
salmon_bdry <- sf::read_sf("data/shapefiles/Salmon_boundary_prj.shp")
rivers <- sf::read_sf("data/shapefiles/Rivers_SOgt5_prj.shp")
streams <- sf::read_sf("data/shapefiles/SalmonSnake_streams_h12.shp")
streams5 <- subset(streams, StreamOrde > 5)
rivers7 <- subset(rivers, StreamOrde > 7)

# Map
png("test.png", width = 10, height = 10, units = "in", res = 300)
par(mar = c(0,0,0,0), oma = c(1,1,1,9), cex = 1.3)
mf_theme(bg = "white", tab = TRUE, mar = c(0,0,0,0), pos = "left")
mf_map(salmon_bdry, col = "#d8d7d2", border = NA) #"#d4dfe2"
mf_map(streams, col = "#689ba7", lwd = 1, add = T)
mf_map(streams5, col = "#20839b", lwd = rivers$StreamOrde/4, add = T)
X <- c("Elk", "Secesh", "BigL")
clr <- rep("grey10",length(points$Lbl)); clr[which(points$Lbl %in% X)] <- "#ac330d"
clr2 <- rep("white",length(points$Lbl)); clr2[which(points$Lbl %in% X)] <- "#fccd04"
mf_label(points, "Lbl", col = clr, halo = T, bg = clr2, overlap = F, q = 3, lines = F, cex = 0.7)
#mf_map(points, col = "grey20", pch = 19, cex = 0.3, add = T)

# Add inset map 
mf_inset_on(x = "worldmap", pos = "bottomleft", cex = 0.35)
mf_map(crb, col = "gray90", border = 0)
mf_map(pnw, col = NA, border = "white", add = T)
mf_map(salmon_bdry, col = "gray60", border = NA, add = T)
mf_label(pnw, "Lbl", col = "black", overlap = T, q = 3)
mf_map(st_zm(rivers7), col = "gray40", add = T) #lwd = rivers$StreamOrde/8
mf_inset_off()

# Add cartographic details
mf_arrow("bottomleft")
mf_scale(pos = "bottom", cex = 0.8)

# Add legend
par(oma=c(0, 0, 0, 0), mar=c(0, 0, 0, 0), new=TRUE)
legend("topright", legend = paste0(points$Lbl, ": ", points$Stream), pch = NA, bty = 'n', 
       xjust = 0, yjust = 0) #, inset = c(-0.3, 0)) #, xpd = T)
dev.off()

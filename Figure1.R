library(sf)
library(mapsf)

crb <- sf::read_sf("data/shapefiles/CRB_boundary_prj.shp")
pnw <- sf::read_sf("data/shapefiles/PNW_prj.shp")
salmon_bdry <- sf::read_sf("data/shapefiles/Salmon_boundary_prj.shp")
rivers <- sf::read_sf("data/shapefiles/Rivers_SOgt5_prj.shp")
streams <- sf::read_sf("data/shapefiles/SalmonSnake_streams_h12.shp")
streams5 <- subset(streams, StreamOrde > 5)
rivers7 <- subset(rivers, StreamOrde > 7)


# Map
mf_export(mf,"main_map.png", width = 12, height = 12, units = "in", res = 300)
mf <- mf_init(salmon_bdry, expandBB = rep(0.1, 4))
mf <- mf_theme(bg = "white", tab = TRUE, mar = c(0,0,0,0), pos = "left", add = T)
mf <- mf_map(streams, col = "#689ba7", lwd = 1, add = T)
mf <- mf_map(salmon_bdry, col = "#d8d7d2", border = NA, add = T) #"#d4dfe2"
mf <- mf_map(streams5, col = "#20839b", lwd = round(rivers$StreamOrde/4), add = T)
mf <- mf_map(streams, col = "#689ba7", lwd = 0.5, add = T)

# Add cartographic details
mf <- mf_graticule(x = salmon_bdry, col = "grey70", lty = 3, cex = 1.75)
mf <- mf_scale(pos = "bottom", cex = 1.2)
mf <- mf_arrow("bottom")
dev.off()

# Inset map 
mf_export(mf,"inset_map.png", width = 7, height = 6, units = "in", res = 300)
mf <- mf_init(crb, expandBB = rep(0.2, 4))
mf <- mf_map(crb, col = "gray90", border = 0, add = T) 
mf <- mf_map(pnw, col = NA, border = "white", add = T)
mf <- mf_map(salmon_bdry, col = "gray60", border = NA, add = T)
mf <- mf_label(pnw, "Lbl", col = "black", overlap = T, q = 3)
mf <- mf_map(st_zm(rivers7), col = "gray40", lwd = 2, add = T)
mf <- mf_graticule(x = crb, col = "grey70", lty = 3, cex = 1.5)
dev.off()

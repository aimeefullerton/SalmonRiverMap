# Load data
points <- sf::read_sf("data/shapefiles/Idaho_sites_prj.shp")
points$Lbl[points$Lbl == "BearValley"] <-"BearV"
points$Stream[points$Stream == "West Fork Chamberlain Creek"] <- "West Fork Chamberlain" 
points$Stream[points$Stream == "Big Creek (lower)/Rush Creek"] <- "Big Creek (lower)" 
points <- points[order(points$Name),]
crb <- sf::read_sf("data/shapefiles/CRB_boundary_prj.shp")
pnw <- sf::read_sf("data/shapefiles/PNW_prj.shp")
pnw$Lbl <- toupper(substr(pnw$NAME,1,2))
salmon_bdry <- sf::read_sf("data/shapefiles/Salmon_boundary_prj.shp")
rivers <- sf::read_sf("data/shapefiles/Rivers_SOgt5_prj.shp")
streams <- sf::read_sf("data/shapefiles/SalmonSnake_streams_h12.shp")
streams5 <- subset(streams, StreamOrde > 5)
rivers7 <- subset(rivers, StreamOrde > 7)


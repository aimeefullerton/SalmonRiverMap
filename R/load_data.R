# Load data
points <- sf::read_sf("data/shapefiles/Idaho_sites_prj.shp")
points <- points[order(points$Name),]
points$Lbl[points$Stream == "Bear Valley Creek"] <- "BV"
points$Stream[points$Stream == "Big Creek (lower)/Rush Creek"] <- "Big Creek (lower)"
points$Lbl[points$Stream == "Big Creek (lower)"] <- "BL"
points$Lbl[points$Stream == "Big Creek (upper)"] <- "BU"
points$Lbl[points$Stream == "Camas Creek"] <- "CA"
points$Lbl[points$Stream == "Cape Horn Creek"] <- "CH"
points$Lbl[points$Stream == "Chamberlain Creek"] <- "CL"
points$Lbl[points$Stream == "East Fork Salmon River"] <- "EF"
points$Lbl[points$Stream == "Elk Creek"] <- "EL"
points$Lbl[points$Stream == "Herd Creek"] <- "HE"
points$Lbl[points$Stream == "Lake Creek"] <- "LA"
points$Lbl[points$Stream == "Loon Creek"] <- "LO"
points$Lbl[points$Stream == "Marsh Creek"] <- "MA"
points$Lbl[points$Stream == "Rush Creek"] <- "RU"
points$Lbl[points$Stream == "South Fork Salmon River"] <- "SF"
points$Lbl[points$Stream == "Secesh River"] <- "SE"
points$Lbl[points$Stream == "Sulphur Creek"] <- "SU"
points$Lbl[points$Stream == "Valley Creek"] <- "VA"
points$Lbl[points$Stream == "West Fork Chamberlain Creek"] <- "WC"

crb <- sf::read_sf("data/shapefiles/CRB_boundary_prj.shp")
pnw <- sf::read_sf("data/shapefiles/PNW_prj.shp")
pnw$Lbl <- toupper(substr(pnw$NAME,1,2))
salmon_bdry <- sf::read_sf("data/shapefiles/Salmon_boundary_prj.shp")
rivers <- sf::read_sf("data/shapefiles/Rivers_SOgt5_prj.shp")
streams <- sf::read_sf("data/shapefiles/SalmonSnake_streams_h12.shp")
streams5 <- subset(streams, StreamOrde > 5)
rivers7 <- subset(rivers, StreamOrde > 7)


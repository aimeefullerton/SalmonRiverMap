
#st_coordinates(salmon_bdry)
#raster::extent(salmon_bdry)
#xmin: -1603681 
#xmax: -1341408 
#ymin: 2459040 
#ymax: 2749115

# Older ----
# Inset map
plot(sf::st_geometry(sf::st_zm(crb)), col = "gray90", border = 0)
plot(sf::st_geometry(sf::st_zm(pnw)), col = NA, border = 0.5, add = T)
plot(sf::st_geometry(sf::st_zm(salmon_bdry)), col = "gray70", border = NA, add = T)
plot(sf::st_geometry(sf::st_zm(rivers)), col = "gray40", lwd = rivers$StreamOrde/5, add = T)
#plot(sf::st_geometry(sf::st_zm(streams)), col = "gray40", lwd = 0.5, add = T)

# Main map
plot(sf::st_geometry(sf::st_zm(salmon_bdry)), col = "gray90", border = NA)
plot(sf::st_geometry(sf::st_zm(streams)), col = "#689ba7", lwd = 0.5, add = T)
plot(sf::st_geometry(sf::st_zm(streams5)), col = "#20839b", lwd = rivers$StreamOrde/5, add = T)
plot(sf::st_geometry(sf::st_zm(points)), col = 2, pch = 19, cex = 0.6, add = T)

# Add specific sites
the.site <- points$Lbl[s]
siteX <- subset(points, Lbl == the.site)
plot(sf::st_geometry(sf::st_zm(siteX)), col = "purple", pch = 15, cex = 1.5, add = T)
plot(sf::st_geometry(sf::st_zm(siteX)), pch = "C", cex = 0.7, col = "white", add = T)


# Get data from NHD and subset ----
streams <- sf::st_read("data/nhdv2/NHDPlusPN/NHDPlus17/NHDSnapshot/Hydrography/NHDFlowline.shp")
vaa <- sf::st_read("data/nhdv2/NHDPlusPN/NHDPlus17/NHDPlusAttributes/PlusFlowlineVAA.dbf"); colnames(vaa)[1] <- "COMID"
streams <- dplyr::left_join(streams, vaa, by = "COMID"); rm(vaa)
streams <- streams[!streams$FTYPE == "Coastline",] # remove coastline reaches
streams <- streams[,c("COMID", "GNIS_NAME", "LENGTHKM", "StreamOrde", "AreaSqKM", "TotDASqKM", "geometry")]
streams <- sf::st_zm(streams)
wbd <- sf::st_read("data/nhdv2/NHDPlusPN/NHDPlus17/WBD/WBD_Subwatershed.shp")
wbd <- sf::st_zm(wbd)

# Subset streams and boundary to Salmon River Basin
idx <- grep("170602", wbd$HUC_8)
sal.wbd <- wbd[idx,]
sal.str <- sf::st_intersection(sal.wbd, streams)
sf::st_write(sal.str, "SalmonRiver_Streams.shp")

# Dissolve interior edges to make an outline of the whole area
crb.bdy <- sf::st_union(wbd)
sal.bdy <- sf::st_union(sal.wbd)



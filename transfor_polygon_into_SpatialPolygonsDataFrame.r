####################################################################################
# transformar o polígono do limite do parque num objecto SpatialPolygonsDataFrame
part1 <- Polygon(limite.ap,hole=FALSE) # matriz com duas colunas
mpart1 <- Polygons(list(part1),ID="SC") # criar multipart
ap.sp <- SpatialPolygons(list(mpart1),proj4string=CRS(etrs))
# tabela de atributos 
df <- data.frame(nome=c("Sintra Cascais"),row.names=c("SC"))
ap.etrs <- SpatialPolygonsDataFrame(ap.sp,df)

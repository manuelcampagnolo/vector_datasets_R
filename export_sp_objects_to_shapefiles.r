# visualizar 
plot(mde.etrs,xaxt="n", yaxt="n", box=FALSE, axes=FALSE, legend=FALSE, col=terrain.colors(100))
plot(ap.etrs,add=TRUE,border="blue")

# exportar raster para GeoTIFF
writeRaster(mde.etrs,file="mde_sintra_cascais.tif",overwrite=TRUE)

# exportar objectos sp para shapefiles
writeOGR(ap.etrs,dsn=getwd(),layer="Limite",driver="ESRI Shapefile",overwrite_layer=TRUE)
writeOGR(pov.etrs,dsn=getwd(),layer="Localidades",driver="ESRI Shapefile",overwrite_layer=TRUE)

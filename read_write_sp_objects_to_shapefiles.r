
# ler shapefile de areas protegidas (ICNF)
icnf<-readOGR(dsn=getwd(),layer="AP_JUL_2014",encoding="ISO8859-1")
plot(icnf)

# exportar como shapefile
writeOGR(icnf,dsn=getwd(),layer="ICNF",driver="ESRI Shapefile",overwrite_layer=TRUE)

# exportar raster para GeoTIFF
writeRaster(mde.etrs,file="mde_sintra_cascais.tif",overwrite=TRUE)


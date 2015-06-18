
# ler shapefile de areas protegidas (ICNF)
icnf<-readOGR(dsn=getwd(),layer="AP_JUL_2014",encoding="ISO8859-1")
plot(icnf)

# exportar como shapefile
writeOGR(icnf,dsn=getwd(),layer="ICNF",driver="ESRI Shapefile",overwrite_layer=TRUE)

# exportar como kml (Google Earth)
wgs84<-"+proj=longlat +ellps=WGS84 +datum=WGS84"
icnf.wgs<-spTransform(icnf,CRS(wgs84))
writeOGR(icnf.wgs,dsn="icnf.kml",layer="areas_protegidas",driver="KML",overwrite_layer=TRUE)

writeOGR(pov.wgs,dsn="pov_sintra.kml",layer="localidades",driver="KML",overwrite_layer=TRUE)

# exportar raster para GeoTIFF
writeRaster(mde.etrs,file="mde_sintra_cascais.tif",overwrite=TRUE)


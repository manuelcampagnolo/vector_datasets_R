########################################################################################
# construir um novo SpatialPolygonsDataFrame que contém um elipsoide à volta de cada parte positiva
library(ellipse)
multipartes<-list()
for (i in 1:length(icnf@polygons))
{
  partes<-list(); np<-0
  for (j in 1:length(icnf@polygons[[i]]@Polygons))
  {
    if (icnf@polygons[[i]]@Polygons[[j]]@hole==FALSE)
    {
      np<-np+1
      partes[[np]] <- Polygon(round(ellipse(cov(icnf@polygons[[i]]@Polygons[[j]]@coords),centre = icnf@polygons[[i]]@Polygons[[j]]@labpt),2),hole=FALSE)
    }
  }
  multipartes[[i]]<-Polygons(partes, ID=icnf@polygons[[i]]@ID )
} 
elipses.etrs<-SpatialPolygons(multipartes,proj4string=icnf@proj4string)
elipses <- SpatialPolygonsDataFrame(elipses.etrs,data=icnf@data)
writeOGR(elipses,dsn=getwd(),layer="Elipses",driver="ESRI Shapefile",overwrite_layer=TRUE)

# exportar como kml (Google Earth)
wgs84<-"+proj=longlat +ellps=WGS84 +datum=WGS84"
elipses.wgs<-spTransform(elipses,CRS(wgs84))
writeOGR(elipses.wgs,dsn="elipses.kml",layer="elipses",driver="KML",overwrite_layer=TRUE)


# imagem:
concelhos.iamb<-readOGR(dsn=getwd(),layer="conc_1998",encoding="ISO8859-1") # fonte: Instituto Ambiente
concelhos.iamb@proj4string # verificar que não tem transformação de datum!!
etrs<-"+proj=tmerc +lat_0=39.6682583 +lon_0=-8.1331083 +k=1 +x_0=0 +y_0=0 +ellps=GRS80 +units=m"
igeoe.grid <- "+proj=tmerc +lat_0=39.66666666666666  +nadgrids=ptLX_e89.gsb +lon_0=1 +k=1 +x_0=200000 +y_0=300000 +ellps=intl  +pm=lisbon +units=m"
concelhos<-concelhos.iamb # fazer cópia
# alterar o CRS de concelhos
concelhos@proj4string<-CRS(igeoe.grid)
# re-projectar para ETRS
concelhos.etrs<-spTransform(concelhos,CRS(etrs))

# exportar concelhos.etrs como shapefile
writeOGR(concelhos.etrs,dsn=getwd(),layer="Concelhos_ETRS",driver="ESRI Shapefile",overwrite_layer=TRUE)


# construir imagem das elipses sobre os concelhos
if (export)  png(paste(aulas,"mapa_areas_protegidas_elipses.png",sep="\\"), width=400, height=800, res=120)
plot(concelhos.etrs)
plot(elipses,col="green",add=TRUE)
plot(icnf,col="red",add=TRUE)
if (export) graphics.off()

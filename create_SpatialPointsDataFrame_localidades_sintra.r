#########################################################################################

library(raster)
library(rgdal)
library(sp)
library(rgeos)
#library("gdalUtils") # função remove_file_extension

library(grDevices)
export<-FALSE

# pasta de trabalho
wd<-"Y:\\Aulas\\CURSOS_R\\sigs_com_R\\dados_aulas"
aulas<-"Y:\\Aulas\\CURSOS_R\\sigs_com_R"

setwd(wd)

###########################################################################
# Exercício
# criar um cdg de pontos para localidades junto a AP Sintra-Cascais 

# comandos exercício sobre AP Sintra-Cascais
# Exercício ndvi vs elevação na área protegida Sintra-Cascais
#limite AP Sintra-Cascais
limite.ap<-as.matrix(read.table(file="limite.AP.SintraCascais.ETRS.txt",header=FALSE))

#ler elevações SRTM mde
fich.mde<-"n38_w010_3arc_v2.tif"
mde<-raster(fich.mde)
etrs<-"+proj=tmerc +lat_0=39.6682583 +lon_0=-8.1331083 +k=1 +x_0=0 +y_0=0 +ellps=GRS80 +units=m"
mde.etrs<-projectRaster(mde,crs=etrs)
mde.etrs<-crop(mde.etrs,limite.ap)

# lat/long algumas povações AP Sintra-Cascais
pov<-data.frame(
  designa=c("Sintra","Colares","Alcabideche","Almoçageme","Azoia"),
  long=c(-9.3816589,-9.4426866999,-9.4098824999, -9.470629899,-9.476644970130),
  lat=c(38.8028687,38.8066307,38.7331569,38.7967822,38.769797300600),
  codPostal=c("2710","2705","2646","2705","2705")
)

wgs84<-"+proj=longlat +ellps=WGS84 +datum=WGS84"
# criar SpatialPointsDataFrame: alternativa 1
xy<-cbind(pov$long,pov$lat) # matrix de coordenadas long/lat
# Criar objecto SpatialPoints
# a função CRS cria um objecto de classe CRS
xy.sp <- SpatialPoints(xy, proj4string=CRS(wgs84))
# Criar objecto de classe SpatialPointsDataFrame
pov.wgs<- SpatialPointsDataFrame(xy.sp,pov[,c("designa","codPostal")])

# criar SpatialPointsDataFrame: alternativa 2
pov.wgs<-pov # não é indespensável
coordinates(pov.wgs)<- ~ long + lat # converte em objecto sp
proj4string(pov.wgs) <- CRS(wgs84) # associa CRS

# re-projectar para CRS ETRS
etrs<-"+proj=tmerc +lat_0=39.6682583 +lon_0=-8.1331083 +k=1 +x_0=0 +y_0=0 +ellps=GRS80 +units=m"
pov.etrs<-spTransform(pov.wgs,CRS(etrs))

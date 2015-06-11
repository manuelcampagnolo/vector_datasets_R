library(raster)
library(rgdal)
library(sp)
library(rgeos)
#library("gdalUtils") # função remove_file_extension

library(grDevices)
export<-TRUE

# pasta de trabalho
wd<-"C:\\Users\\mlc\\Documents\\cursoR"
aulas<-"Y:\\Aulas\\sigs_com_R"
setwd(wd)

# para usar funções do package rgeos, as geometrias dos objectos devem ser válidas
# a função gIsvalid permite saber quais são os objectos geométricos válidos
valid<-gIsValid(icnf,byid=TRUE,reason=TRUE)
which(valid!="Valid Geometry") #  13 55 58 61 inválidos
# vamos restringir a análise aos objectos geométricos válidos
icnfv<-icnf[which(valid=="Valid Geometry"),]
plot(icnfv)

# ler shapefile de rios em coordenadas militares
rios<-readOGR(dsn=getwd(),layer="rios",encoding="ISO8859-1")
etrs<-"+proj=tmerc +lat_0=39.6682583 +lon_0=-8.1331083 +k=1 +x_0=0 +y_0=0 +ellps=GRS80 +units=m"
igeoe.grid <- "+proj=tmerc +lat_0=39.66666666666666  +nadgrids=ptLX_e89.gsb +lon_0=1 +k=1 +x_0=200000 +y_0=300000 +ellps=intl  +pm=lisbon +units=m"
rios@proj4string<-CRS(igeoe.grid)
# re-projectar para ETRS
rios.etrs<-spTransform(rios,CRS(etrs))
valid<-gIsValid(rios.etrs,byid=TRUE,reason=TRUE)
which(valid!="Valid Geometry") # todos válidos

# idem para concelhos
concelhos<-readOGR(dsn=getwd(),layer="conc_1998",encoding="ISO8859-1") # fonte: Instituto Ambiente
etrs<-"+proj=tmerc +lat_0=39.6682583 +lon_0=-8.1331083 +k=1 +x_0=0 +y_0=0 +ellps=GRS80 +units=m"
igeoe.grid <- "+proj=tmerc +lat_0=39.66666666666666  +nadgrids=ptLX_e89.gsb +lon_0=1 +k=1 +x_0=200000 +y_0=300000 +ellps=intl  +pm=lisbon +units=m"
# alterar o CRS de concelhos
concelhos@proj4string<-CRS(igeoe.grid)
# re-projectar para ETRS
concelhos.etrs<-spTransform(concelhos,CRS(etrs))
valid<-gIsValid(concelhos.etrs,byid=TRUE,reason=TRUE)
which(valid!="Valid Geometry") # todos válidos

plot(concelhos.etrs)
zoom(concelhos.etrs)

colnames(concelhos.etrs@data)

# eliminar objectos espúrios
dim(concelhos.etrs@data) # 332 objectos
concelhos.etrs<-concelhos.etrs[!is.na(concelhos.etrs@data$CONCELHO),]
dim(concelhos.etrs@data) # 282 objectos


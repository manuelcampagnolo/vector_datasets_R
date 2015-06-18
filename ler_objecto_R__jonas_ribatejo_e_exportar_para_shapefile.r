# exemplo parcelas agrícolas Ribatejo 
parcelas<-readOGR(dsn=getwd(),layer="ParcelasAgricolas",encoding="ISO8859-1")

ogrInfo(".","ParcelasAgricolas")
# seleccionar culturas "Sorgo" e "Luzerna"
sorgo.luzerna<-parcelas[parcelas@data$cultura=="Sorgo" | parcelas@data$cultura=="Luzerna",]
writeOGR(sorgo.luzerna,dsn=getwd(),layer="SorgoLuzerna",driver="ESRI Shapefile",overwrite_layer=TRUE)

folderjonas<-"Y:\\Dados_SIG_DR_etc\\dados Jonas Ribatejo 2005"
load(paste0(folderjonas,"\\parcelas2005.RData")) # obejcto parc2005 de class SpatialPolygonsDataFrame # CRS  +proj=utm +zone=29 +ellps=WGS84 +datum=WGS84 +units=m +towgs84=0,0,0 
#plot(parc2005,add=TRUE)

names(parc2005) # 37 variáveis incluindo NIFAP

# criar uma data.frame com dois dos atributos de parc2005
#areas<-gArea(parc2005,byid=TRUE)
#perimetros<-gLength(parc2005,byid=TRUE)
algumas.variaveis<-c("NOME_CULTU","COD_AJUDA")
parcRibatejo<-parc2005[,algumas.variaveis]
igeoe <- "+proj=tmerc +lat_0=39.66666666666666  +towgs84=-283.1,-70.7,117.4,-1.16,0.06,-0.65,-4.1 +lon_0=1 +k=1 +x_0=200000 +y_0=300000 +ellps=intl  +pm=lisbon +units=m"
parcRibatejo<-spTransform(parcRibatejo, CRS(igeoe))
valid<-gIsValid(parcRibatejo,byid=TRUE,reason=TRUE)
which(valid!="Valid Geometry")
parcRibatejo<-parcRibatejo[which(valid=="Valid Geometry"),]
writeOGR(parcRibatejo,dsn=".",layer="parcRibatejo",driver="ESRI Shapefile",overwrite_layer=TRUE)
# writeOGR dá erro mas cria .prj correcto
# para dar a volta ao problema pode usar-se:
library(maptools)
writePolyShape(parcRibatejo, "parcRibatejo")
writeSpatialShape(parcRibatejo, "parcRibatejo")

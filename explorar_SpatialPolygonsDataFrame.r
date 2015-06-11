# ler shapefile de areas protegidas (ICNF)
icnf<-readOGR(dsn=getwd(),layer="AP_JUL_2014",encoding="ISO8859-1")
plot(icnf)

# qual é o CRS do cdg?
icnf@proj4string
# quantos multi-poligonos há?
length(icnf@polygons)

# como são as primeiras linhas da tabela de atributos?
head(icnf@data)

# procurar a linha da tabela de atributos que tem Montejunto no atributo Nome
indice<-which(grepl(pattern="Montejunto",icnf@data$NOME,ignore.case = TRUE))
# verificar que é a 12a linha
icnf@data[12,]

# representar esse 12o multi-polígono de icnf
# selecciona-se um subconjunto dos polígono seleccionando a(s) linha(s) como para a tabela de atributos
class(icnf[12,]) # ainda é SpatialPolygonsDataFrame

# obter informação sobre o 12o multi-polígono:
# ID do multi-polígono
icnf@polygons[[12]]@ID 
# area do multi-polígono
icnf@polygons[[12]]@area 

# quantas partes tem o 12o multi-poligono de icnf? 
length(icnf@polygons[[12]]@Polygons) #tem 6 partes
#qual é o tipo de cada parte: "hole" ou não?
for (i in 1:6) print(icnf@polygons[[12]]@Polygons[[i]]@hole)
# qual é a área de cada parte do 12o multi-poligono?
for (i in 1:6) print(icnf@polygons[[12]]@Polygons[[i]]@area)
# quais são as coordenadas dos pontos que delimitam a 3a parte do 12o multi-polígono?
pol3 <- icnf@polygons[[12]]@Polygons[[3]]@coords # matriz com 2 colunas


# construir imagem
if (export)  png(paste(aulas,"ap_montejunto.png",sep="\\"), width=800, height=600, res=120)
plot(icnf[12,])
text(x=icnf[12,]@bbox["x","min"], y=icnf[12,]@bbox["y","max"], as.character(icnf@data[12,"NOME"]),pos=4,cex=.9) 
for (i in 1:length(icnf@polygons[[12]]@Polygons)) 
{
  aux<-icnf@polygons[[12]]@Polygons[[i]];
  if (aux@hole) polygon(aux@coords,col="yellow")  
  text(x=aux@labpt[1], y=aux@labpt[2],paste(round(aux@area/10000,1),"ha",sep=""),cex=.7,pos=4)
}
if (export) graphics.off()

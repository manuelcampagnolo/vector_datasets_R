#############################################################################
#
# intersecção de "features" de objectos sp com função gIntersection
#

# Voltando ao exemplo dos concelhos no Parque Natural da Serra da Estrela
out<-gIntersection(parque,concelhos.etrs, byid=TRUE)

# de novo, out é de classe SpatialPolygons
# para obter um objecto de classe SpatialPolygonsDataFrame é preciso 
# definir a tabela de atributos

# Pretende-se ter na tabela de atributos o nome do concelho, do distrito, e o nome do Parque

# IDs associados às multi-partes de out
names(out) #"34 115" "34 119" "34 120" "34 126" "34 131" "34 136" "34 139" "34 143"
# os IDs dos multi-partes são definidos pela concatenação dos IDs de parque, 
# neste caso sempre 34, e os IDs de concelhos.etrs
# Para saber qual é o parque e qual é o concelho é preciso
# a) extrair o ID respectivo
# b) usar as tabelas de atributos de parque e concelhos.etrs para obter as designações

# a) strsplit separa e devolve uma lista com 8 componentes
# cada componente da lista é um vector com dois elementos
# o 1o elemento é relativo a parque
# o 2o elemento é relatico a concelhos.etrs 
spl<-strsplit(names(out),split=" ")

# criar tabela de atributos
nomes.concelhos<-c()
nomes.distritos<-c()
nomes.ap<-c()
for (i in 1:length(out))
{
   nomes.ap<-c(nomes.ap,as.character(parque@data[spl[[i]][1],"NOME"]))
   nomes.concelhos<-c(nomes.concelhos,as.character(concelhos.etrs@data[spl[[i]][2],"CONCELHO"]))
   nomes.distritos<-c(nomes.distritos,as.character(concelhos.etrs@data[spl[[i]][2],"DISTRITO"]))
}
df.out <- data.frame(ap=nomes.ap,concelho=nomes.concelhos,distrito=nomes.distritos,row.names=names(out))
out.etrs<-SpatialPolygonsDataFrame(out,data=df.out)

# fazer imagem
if (export)  png(paste(aulas,"Serra_Estrela_intersection_concelhos.png",sep="\\"), width=600, height=600, res=120)
plot(out.etrs,col=brewer.pal(n=length(out.etrs), "Spectral"))
for (i in 1:length(out.etrs))
{
  xy<-out.etrs@polygons[[i]]@labpt
  text(xy[1],xy[2],out.etrs@data[i,"concelho"],pos=3,cex=0.5)
  text(xy[1],xy[2],out.etrs@data[i,"distrito"],pos=1,cex=0.5)
}
if (export) graphics.off()

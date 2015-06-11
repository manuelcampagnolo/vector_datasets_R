# re-projectar para CRS ETRS
etrs<-"+proj=tmerc +lat_0=39.6682583 +lon_0=-8.1331083 +k=1 +x_0=0 +y_0=0 +ellps=GRS80 +units=m"
pov.etrs<-spTransform(pov.wgs,CRS(etrs))

# tabela de atributos
pov.etrs@data # é uma data frame

# selecção por atributos no cdg pov.etrs
# a selecção é feita seleccionando linhas e/ou colunas tal como se faz para uma data frame
pov.etrs[2,] # devolve SpatialPointsDataFrame com um único ponto (o 2o: Colares)
pov.etrs[,"designa"] # devolve SpatialPointsDataFrame com um único atributo (designa)

# naturalmente pode fazer-se uma selecção por atributos com uma expressão lógica
# como as colunas da tabela são do tipo "factor", primeiro converte-se codPostal em numerico
cps<-as.numeric(as.character(pov.etrs@data$codPostal))
pov.etrs[cps>2700,] # devolve SpatialPointsDataFrame com 4 povoações

# spplot(mde.etrs,col.regions=terrain.colors(100));
if (export)  png(paste(aulas,"localidades_ap_sintra_cascais.png",sep="\\"), width=400, height=600, res=120)
plot(mde.etrs,xaxt="n", yaxt="n", box=FALSE, axes=FALSE, legend=FALSE, col=terrain.colors(100))
polygon(limite.ap)
#plot(pov.etrs,add=TRUE,pch=1)
# coordenadas dos pontos 
coordinates(pov.etrs)
# escrever a designação no local
text(coordinates(pov.etrs), as.character(pov.etrs@data$designa),cex=.6)
if (export) graphics.off()

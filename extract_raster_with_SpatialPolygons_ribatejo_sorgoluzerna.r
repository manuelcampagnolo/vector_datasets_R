##################################################################################
# Dados parcelas Ribatejo
# exemplo parcelas agrícolas Ribatejo 
parcelas<-readOGR(dsn=getwd(),layer="ParcelasAgricolas",encoding="ISO8859-1")
# seleccionar culturas "Sorgo" e "Luzerna"
sorgo.luzerna<-parcelas[parcelas@data$cultura=="Sorgo" | parcelas@data$cultura=="Luzerna",]
writeOGR(sorgo.luzerna,dsn=getwd(),layer="SorgoLuzerna",driver="ESRI Shapefile",overwrite_layer=TRUE)

# usar extract sobre um RasterBrick usando polígonos
sorgo.luzerna<- readOGR(dsn=getwd(),layer="SorgoLuzerna",encoding="ISO8859-1")

# Criar vector com os nomes das culturas para cada parcela
nomes.parcelas<-as.character(sorgo.luzerna@data$cultura)

# ler e formar brick de imagens Landsat da mesma região
fichs <- list.files(pattern="banda")
s <- stack(as.list(fichs))
s # devolve sumário dos dados
b <- brick(s)

# os CRS são idênticos
sorgo.luzerna@proj4string
b@crs
# plot
if (export)  png(paste(aulas,"sorgo_luzerna_sobre_rgb432.png",sep="\\"), width=600, height=800, res=120)
plotRGB(b,r=4,g=3,b=2,stretch="lin",ext=sorgo.luzerna@bbox)
plot(sorgo.luzerna,add=TRUE,col="yellow")
if (export) graphics.off()

# usar a função extract para extrair os valores das células no interior de cada polígono do objecto sorgo.luzerna
# weights=TRUE devolve a proporção de cada célula de b que está contida em cada polígono de sorgo.luzerna

# 1o vamos aplicar extract usando apenas a 1a multi-parte do objecto sorgo.luzerna
plotRGB(b,r=4,g=3,b=2,stretch="lin",ext=sorgo.luzerna[1,]@bbox)
plot(sorgo.luzerna[1,],add=TRUE,col="yellow")
# o output (out) de extract é uma lista com uma única componente.
out<-extract(b,sorgo.luzerna[1,],weights=TRUE,normalizeWeights=FALSE,cellnumbers=TRUE)
# Essa componente é uma matrix
outmat<-out[[1]]
class(outmat)
head(outmat)
# coordinates(b) é uma matrix de coordenadas do raster b (tem colunas x e y)
# em seguida seleccionam-se apenas as coordenadas das células de b que foram devolvidas por extract
xy<-coordinates(b)[outmat[,"cell"],]
# finalmente indica-se sobre a figura qual é a proporção de cada célula que está no polígono
text(xy[,1],xy[,2],round(outmat[,"weight"],2),cex=0.6)

#2o. Quando se aplica extract usando todos os polígonos de sorgo.luzerna
# obtem-se uma lista de 64 matrizes
out<-extract(b,sorgo.luzerna,weights=TRUE,normalizeWeights=FALSE)
length(out) # é 64
# empilhar as matrizes para criar uma tabela única
outmat<-out[[1]]
for (i in 2:length(out)) outmat<-rbind(outmat,out[[i]])
dim(outmat)

# para selecionar as células que estão contidas a 95% nas parcelas
outcel <- outmat[outmat[,"weight"]>0.95,] 
head(outcel)

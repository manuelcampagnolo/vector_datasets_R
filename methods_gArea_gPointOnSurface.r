##########################################################################
#
# Métodos sobre objectos geométricos

# calcular area
gArea(icnfv)
gArea(icnfv,byid=TRUE)

# determinar um ponto que intersecta cada objecto geométrico
# gPointOnSurface devolve um objecto SpatialPoints 
if (export)  png(paste(aulas,"icnf_point_on_surface.png",sep="\\"), width=600, height=800, res=120)
plot(icnfv,col="green",border=FALSE)
areas <- round(as.vector(gArea(icnfv,byid=TRUE))/10000)
xy <- coordinates(gPointOnSurface(icnfv,byid=TRUE))
text(xy[areas > 20000,1],xy[areas>20000,2],paste(areas[areas>20000]), cex=0.7)
if (export) graphics.off()

# determinar pontos que intersectam os objectos espaciais dados
nomerio<-"rio mondego"
rio<-rios.etrs[which(grepl(pattern=nomerio,rios.etrs@data$DESIGNACAO,ignore.case = TRUE)),]
plot(concelhos.etrs)
plot(icnfv,add=TRUE,col="green")
plot(rio,add=TRUE,col="blue") 

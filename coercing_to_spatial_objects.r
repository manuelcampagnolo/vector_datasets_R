# criar um SpatialPolygon a partir de ext
clipping.SP <- as(ext, Class="SpatialPolygons")
proj4string(clipping.SP) <- CRS(proj4string(parc2005))

# lançar uma amostra 2D sobr eum polígono
# usa package sp e função spsample
# SpatialPoints cria um objecto sp a apartir do polígono
# spsample define uma amostra aleatória de tamanho n sobre a extensão do polígono
amostra2D<-coordinates(spsample(SpatialPoints(limite.ap),n=1000,type="random"))
# seleccionar apenas os pontos que estão no interior de limite.ap
amostra2D.ap<-amostra2D[point.in.polygon(point.x=amostra2D[,1], point.y=amostra2D[,2],pol.x=limite.ap[,1],pol.y = limite.ap[,2])==1,]

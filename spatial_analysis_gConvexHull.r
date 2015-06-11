################################################################################################
# determinar invólucro convexo
# nota: gConvexHull devolve um objecto SpatialPolygons 
plot(icnfv,col="green",border=FALSE)
plot(gConvexHull(icnfv,byid=TRUE),border="green",add=TRUE)


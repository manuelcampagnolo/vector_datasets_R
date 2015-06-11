#################################################################################
# escrever uma função para saber quantas partes de cada tipo (hole ou não-hole) há em cada multi-poligono
# o output é uma lista com duas componentes
# $positivos: vector de número de partes em que hole=FALSE
# $negativos: vector de número de partes em que hole=TRUE
tipo.partes<-function(spdf)
{
  numero.partes.hole.false<-c()
  numero.partes.hole.true<-c()
  for (i in 1:length(spdf@polygons))
  {
    conta.hole.false<-0
    conta.hole.true<-0
    for (j in 1:length(spdf@polygons[[i]]@Polygons))
    {
      if (spdf@polygons[[i]]@Polygons[[j]]@hole) conta.hole.true<-conta.hole.true+1 else conta.hole.false<-conta.hole.false+1
    }
    numero.partes.hole.false<-c(numero.partes.hole.false,conta.hole.false)
    numero.partes.hole.true<-c(numero.partes.hole.true,conta.hole.true)
  }
  return(list(positivos=numero.partes.hole.false,negativos=numero.partes.hole.true))
}

tipo.partes(icnf)

################################################################
#
# selecção por localização
#
# quais são os concelhos atravessados por o Rio Mondego?
# its é uma matriz lógica (TRUE/FALSE) 49*282
# há 49 multi-linhas que compõem rio
# há 282 multi-polígonos que compõem concelhos.etrs
its<-gIntersects(concelhos.etrs,rio,byid=TRUE)
dim(its)

# para selecionar os concelhos que são intersectados pelo rio é 
# necessário saber quais as colunas da matriz its
# têm pelo menos um TRUE:

# definir vector de TRUE e FALSE para os concelhos 
aux<-as.logical(apply(its,2,max)) 

if (export)  png(paste(aulas,"concelhos_rio.png",sep="\\"), width=600, height=800, res=120)
plot(concelhos.etrs, xlim=c(-95000, 151000), ylim=c(11000,136000))
plot(concelhos.etrs[aux,],add=TRUE, col="yellow")
plot(rio,add=TRUE,col="blue")
if (export) graphics.off()

# concelhos no Parque Natural da Serra da Estrela
nomeap <-"estrela"
parque<-icnfv[which(grepl(pattern=nomeap,icnfv@data$NOME,ignore.case = TRUE)),]

if (export)  png(paste(aulas,"serra-estrela_concelhos.png",sep="\\"), width=800, height=700, res=120)
plot(parque,col="green")
# concelhos que intersectam o Parque
its<-gIntersects(concelhos.etrs,parque,byid=TRUE)
aux<-as.logical(apply(its,2,max)) # vector logico
plot(concelhos.etrs[aux,],add=TRUE,border="red")
# escrever nomes dos concelhos seleccionados
xy<-coordinates(gPointOnSurface(concelhos.etrs[aux,],byid=TRUE))
text(xy[,1],xy[,2],concelhos.etrs@data[aux,"CONCELHO"],cex=0.7)

# concelhos totalmente contidos no parque:
its<-gWithin(concelhos.etrs,parque,byid=TRUE)
aux<-as.logical(apply(its,2,max)) # vector logico
plot(concelhos.etrs[aux,],add=TRUE,col="red")
# escrever nome do concelho seleccionado
xy<-coordinates(gPointOnSurface(concelhos.etrs[aux,],byid=TRUE))
text(xy[,1],xy[,2],concelhos.etrs@data[aux,"CONCELHO"],cex=0.7)
if (export) graphics.off()

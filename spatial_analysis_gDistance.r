#########################################################################################
#
# métodos de análise espacial; criação de novos objectos
#

# distâncias entre concelhos e areas proteguidas com mais de 1000 ha
areas <- round(as.vector(gArea(icnfv,byid=TRUE))/10000)
icnfg<-icnfv[areas>1000,]
# d é uma matriz 27*282 que contem as distâncias entre concelhos e APs
d<-gDistance(concelhos.etrs,icnfg,byid=TRUE) # demora uns 2mn a calcular
colnames(d)<-as.character(concelhos.etrs@data$CONCELHO)
rownames(d)<-as.character(icnfg@data$NOME)

# Qual é distância mínima (em Km) de cada concelho a uma área protegida com mais de 1000ha?
dc<-round(apply(d,2,min)/1000)

#Qual o concelho que fica à maior distância?
dc[dc==max(dc)] # Mira, a 75 km

# Qual é a área protegida mais próxima desse concelho
ind<-which(dc==max(dc)) # devolve o índice do concelho (coluna de d)
aux<-d[,ind] # dá as distâncias desse concelho a todas as áreas protegidas
aux[aux==min(aux)] # devolve a área protegida à menor distância do concelho

# fazer figura
if (export)  png(paste(aulas,"mira_serra-estrela.png",sep="\\"), width=400, height=700, res=120)
plot(concelhos.etrs)
plot(concelhos.etrs[ind,],col="red",add=TRUE)
plot(icnfg,col="green",add=TRUE)
if (export) graphics.off()

library(rgdal)
library(sp)
library(raster)
library(rgeos)


# pasta de trabalho
wd<-"Y:\\Aulas\\CURSOS_R\\sigs_com_R\\dados_aulas"
aulas<-"Y:\\Aulas\\CURSOS_R\\sigs_com_R"
aulas<-"F:\\sigs_com_R"

setwd(wd)
getwd()

parcelas<-readOGR(dsn=getwd(),layer="parcRibatejo",encoding="ISO8859-1")
head(parcRibatejo)

levels(parcelas$COD_AJUDA)
if (export)  png(paste(aulas,"parcelas_ribatejo.png",sep="\\"), width=600, height=600, res=120)
par(mar=rep(0,4))
fichs <- list.files(pattern="banda")
b<-brick(stack(as.list(fichs)))
b.proj<-projectRaster(b,crs=parcelas@proj4string) # lento
if (export) png(paste(aulas,"parcelas_ribatejo.png",sep="\\"), width=600, height=600, res=120)
plotRGB(b.proj,r=4,g=3,b=2,stretch="lin") 
plot(parcelas,col=c("green", "orange", "yellow")[parcelas$COD_AJUDA],add=TRUE)
legend(x=parcelas@bbox["x","min"],y=parcelas@bbox["y","max"],legend=levels(parcelas$COD_AJUDA),fill=c("green", "orange", "yellow")) 
if (export) graphics.off()


if (export) png(paste(aulas,"parcelas_ribatejo_trigo.png",sep="\\"), width=600, height=600, res=120)
plotRGB(b.proj,r=4,g=3,b=2,stretch="lin") 
plot(parcelas,col=c("green", "orange", "yellow")[parcelas$COD_AJUDA],add=TRUE)
expressao<-"((T|t)rigo.*(M|m)ole)|((T|t)riticale)"# ".*" é qualquer sequência de caracteres
nomes.culturas[grepl(pattern=expressao,nomes.culturas)]
plot(parcelas[grepl(pattern=expressao,parcelas$NOME_CULTU),],add=TRUE,col="purple")
legend(x=parcelas@bbox["x","min"],y=parcelas@bbox["y","max"],legend=levels(parcelas$designacao),fill=c("green", "orange", "yellow")) 
if (export) graphics.off()


#tabela<-cbind(parc2005@data[,algumas.variaveis],areas,perimetros)
#save(tabela,file="Y:\\Aulas\\CURSOS_R\\sigs_com_R\\df.culturas.RData")
#head(tabela)

# explorar nomes das culturas com expressões regulares
nomes.culturas<-unique(as.character(parcelas$NOME_CULTU))
length(nomes.culturas) # 56

# Seleccionar algumas culturas:
nomes.culturas[grepl(pattern="Vinha",nomes.culturas)]
parcelas[grepl(pattern="Vinha",parcelas$NOME_CULTU),]

nomes.culturas<-unique(as.character(tabela$NOME_CULTU))
length(nomes.culturas) # 56
nomes.culturas[grepl(pattern="Vinha",nomes.culturas)]
nomes.culturas[grepl(pattern="(p|P)ermanentes$",nomes.culturas)] # acaba em "permanentes" ou "Permanentes"
nomes.culturas[grepl(pattern="?ermanentes$",nomes.culturas)] # ? pode ser qualquer caractere
parcelas[which(grepl(pattern="?ermanentes$",parcelas$NOME_CULTU)),]

# slides
nomes.culturas[grepl(pattern="(p|P)ermanentes$",nomes.culturas)] # acaba em "permanentes" ou "Permanentes"
nomes.culturas[grepl(pattern="?ermanentes$",nomes.culturas)] # ? pode ser qualquer caractere
parcelas[grepl(pattern="?ermanentes$",parcelas$NOME_CULTU),]

nomes.culturas[grepl(pattern="[a-c]|[A-C]",nomes.culturas)] 

nomes.culturas[grepl(pattern="[^a-zA-Z0-9. ()/]",nomes.culturas)] 

nomes.culturas[which(grepl(pattern="[b-c]|[B-C]",nomes.culturas))] # contém um dos seguintes: b,c,B,C
nomes.culturas[which(grepl(pattern="„",nomes.culturas))] # contem o símbolo "„"
nomes.culturas[which(grepl(pattern="[^a-zA-Z0-9. ()/]",nomes.culturas))] #  contém caractér que não é letra, número, espaço, ponto, parêntesis ou /

# criar uma tabela para substituir os nomes com símbolos indesejados por nomes mais amigáveis
maus<-nomes.culturas[which(grepl(pattern="[^a-zA-Z0-9. ()/]",nomes.culturas))] #  contém caractér que não é letra, número, espaço, ponto, parêntesis ou /
maus<-nomes.culturas[grepl(pattern="[^a-zA-Z0-9. ()/]",nomes.culturas)] 
bons<-c("Sup. forr. temp ou prados", "Pousio agronomico", 
               "Hort. reg. intensivo ao ar livre", "Retirada terras obrig ou volunt",
               "Retirada obrig. biologica", "vegetacao ripicola",
               "Sup. agri. nao utilizada", "Vinha em reg. determinada",
               "Area ripicola em abandono (mais de 3 anos)", "Tomate para industria",
               "Pera para industria", "Consociacao de especies elegiveis",
               "Maca", "Grao de bico", "Pessego para industria", "Tremocao doce")
cbind(maus,bons)
# substituir nomes antigos por nomes novos usando level no objecto sp
nomesantigos<-parcelas$NOME_CULTU # é um factor
levels(nomesantigos)[levels(nomesantigos) %in% maus]<-bons #    
parcelas$NOME_CULTU<-nomesantigos
unique(as.character(parcelas$NOME_CULTU))

# substituir nomes antigos por nomes novos usando level apenas na tabela de atributos
nomesantigos<-tabela$NOME_CULTU # é um factor
levels(nomesantigos)[levels(nomesantigos) %in% maus]<-bons #    [!which(grepl(pattern="[^a-zA-Z0-9. ()/]",nomes.culturas))]<-novos

###########################################################################################################
#
# SQL sobre data.frames -- package sqldf
#
# substituir nomes antigos por nomes novos com SQL
# left join: cruza todas as linhas da tabela --- escreve NA quando não há "match"
library(sqldf)
tabela<-parcelas@data
nomes<-data.frame(maus=maus,bons=bons)
join.string<-"select tabela.*, nomes.bons from tabela left join nomes on tabela.NOME_CULTU=nomes.maus" 
#join.string<-"select tabela.NOME_CULTU,  nomes.novos from tabela left join nomes on tabela.NOME_CULTU=nomes.antigos" 
tabela.join.nomes<-sqldf(join.string,stringsAsFactors=FALSE)
head(tabela.join.nomes)

# criar novo atributo $final com os bons nomes para (todas) as culturas
tabela.join.nomes$final<-tabela.join.nomes$bons
tabela.join.nomes$final[is.na(tabela.join.nomes$final)]<-as.character(tabela.join.nomes$NOME_CULTU)[is.na(tabela.join.nomes$final)]
head(tabela.join.nomes)

# inner join: apenas cruza quand há "match"
join.string<-"select tabela.*, nomes.bons from tabela inner join nomes on tabela.NOME_CULTU=nomes.maus" 
tabela.join.nomes<-sqldf(join.string,stringsAsFactors=FALSE)
head(tabela.join.nomes)

# em R existe a função merge que pode ser usada em vez do join:
tabela.merge.nomes<-merge(tabela,nomes,by.x="NOME_CULTU",by.y="maus",all.x=TRUE)
head(tabela.merge.nomes)
tail(tabela.merge.nomes)
str(tabela.merge.nomes) # a função merge origina novos atributos do tipo factor

# a função match do R associa a cada elemento do vector a sua posição em outro vector
bons[match(tabela$NOME_CULTU,maus)]

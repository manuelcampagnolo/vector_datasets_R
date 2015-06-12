# criar uma data.frame com dois dos atributos de parc2005, mais as areas e perimetros das parcelas
areas<-gArea(parc2005,byid=TRUE)
perimetros<-gLength(parc2005,byid=TRUE)
algumas.variaveis<-c("NOME_CULTU","COD_AJUDA")
tabela<-cbind(parc2005@data[,algumas.variaveis],areas,perimetros)
save(tabela,file="Y:\\Aulas\\CURSOS_R\\sigs_com_R\\df.culturas.RData")
head(tabela)

# explorar nomes das culturas com expressões regulares
nomes.culturas<-unique(as.character(tabela$NOME_CULTU))
length(nomes.culturas) # 56
nomes.culturas[which(grepl(pattern="Vinha",nomes.culturas))]
nomes.culturas[which(grepl(pattern="(p|P)ermanentes$",nomes.culturas))] # acaba em "permanentes" ou "Permanentes"
nomes.culturas[which(grepl(pattern="?ermanentes$",nomes.culturas))] # ? pode ser qualquer caractér
nomes.culturas[which(grepl(pattern="[b-c]|[B-C]",nomes.culturas))] # contém um dos seguintes: b,c,B,C
nomes.culturas[which(grepl(pattern="„",nomes.culturas))] # contem o símbolo "„"
nomes.culturas[which(grepl(pattern="[^a-zA-Z0-9. ()/]",nomes.culturas))] #  contém caractér que não é letra, número, espaço, ponto, parêntesis ou /

# criar uma tabela para substituir os nomes com símbolos indesejados por nomes mais amigáveis
maus<-nomes.culturas[which(grepl(pattern="[^a-zA-Z0-9. ()/]",nomes.culturas))] #  contém caractér que não é letra, número, espaço, ponto, parêntesis ou /
bons<-c("Sup. forr. temp ou prados", "Pousio agronomico", 
               "Hort. reg. intensivo ao ar livre", "Retirada terras obrig ou volunt",
               "Retirada obrig. biologica", "vegetacao ripicola",
               "Sup. agri. nao utilizada", "Vinha em reg. determinada",
               "Area ripicola em abandono (mais de 3 anos)", "Tomate para industria",
               "Pera para industria", "Consociacao de especies elegiveis",
               "Maca", "Grao de bico", "Pessego para industria", "Tremocao doce")
# substituir nomes antigos por nomes novos usando level
nomesantigos<-tabela$NOME_CULTU # é um factor
levels(nomesantigos)[levels(nomesantigos) %in% maus]<-bons #    [!which(grepl(pattern="[^a-zA-Z0-9. ()/]",nomes.culturas))]<-novos

###########################################################################################################
#
# SQL sobre data.frames -- package sqldf
#
# substituir nomes antigos por nomes novos com SQL
# left join: cruza todas as linhas da tabela --- escreve NA quando não há "match"
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
tabela.merge.nomes<-merge(tabela,nomes,by.x="NOME_CULTU",by.y="antigos",all.x=TRUE)
head(tabela.merge.nomes)
tail(tabela.merge.nomes)
str(tabela.merge.nomes) # a função merge origina novos atributos do tipo factor

# a função match do R associa a cada elemento do vector a sua posição em outro vector
bons[match(tabela$NOME_CULTU,maus)]

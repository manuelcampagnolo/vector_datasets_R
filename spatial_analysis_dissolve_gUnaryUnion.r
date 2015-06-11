#############################################################
#
# a dissolução de "features" faz-se com a função gUnaryUnion
#

# criar SpatialPolygonsDataFrame dos distritos de Portugal Continental
#
# 1o: definir um vector de IDs para agrupar as multi-partes do input
id.distritos<-as.character(concelhos.etrs@data[,"DISTRITO"])
# 2o: usar esse vector como argumento de gUnaryUnion
distritos<-gUnaryUnion(concelhos.etrs, id = id.distritos)
plot(distritos)

# gUnaryUnion devolve um objecto SpatialPolygons sem tabela de atributos
# Para obter um SpatialPolygonsDataFrame temos que criar a tabela de atributos

# 3o. Construir a tabela de atributos e associá-la ao objecto SpatialPolygons
# IDs associados às multi-partes de distritos
ids<-c(); for (i in 1:18) ids<-c(ids,distritos@polygons[[i]]@ID)
# ou, bem mais simples,
ids<-names(distritos)

colnames(concelhos.etrs@data)
# construir um vector de dimensão 18 com a região respectiva
df <- concelhos.etrs@data
regioes<-c(); 
for (i in 1:18) 
{
  rgs<-as.character(df[as.character(df$DISTRITO)==ids[i],"REGIAO"])
  regioes[i]<-rgs[1]
}
# criar data.frame para associar a distritos
df.distritos<-data.frame(nome=ids,regiao=regioes,row.names=ids)
distritos.etrs<-SpatialPolygonsDataFrame(distritos,data=df.distritos)

if (export)  png(paste(aulas,"distritos.png",sep="\\"), width=300, height=600, res=120)
plot(distritos.etrs,col=brewer.pal(n=10, "Spectral"))
if (export) graphics.off()

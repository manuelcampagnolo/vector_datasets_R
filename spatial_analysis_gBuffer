# construir buffers
# width pode ser negativo
plot(gBuffer(icnfv[12,],byid=TRUE,width=100),border="red")
plot(icnfv[12,],add=TRUE)

# opções adicionais para buffer: mais útil para linhas
# quadsegs  Number of line segments to use to approximate a quarter circle.
# capStyle   Style of cap to use at the ends of the geometry. Allowed values: ROUND,FLAT,SQUARE
# joinStyle	 Style to use for joints in the geometry. Allowed values: ROUND,MITRE,BEVEL
# mitreLimit	Numerical value that specifies how far a joint can extend if a mitre join style is used.

# Pode criar-se vários aneis d ebuffer com um ciclo:
library(RColorBrewer) # para criar paletas
display.brewer.all() # ver possíveis paletas de cores

if (export)  png(paste(aulas,"montejunto-stella.png",sep="\\"), width=600, height=600, res=120)
plot(gBuffer(icnfv[12,],width=1100),border=FALSE)
for (i in 10:1) plot(gBuffer(icnfv[12,],byid=TRUE,width=100*i),add=TRUE,col=brewer.pal(n=12, "Spectral")[i])
plot(icnfv[12,],add=TRUE,col="green")
if (export) graphics.off()

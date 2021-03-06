library(cartography)

opar <- par(mar = c(0,0,1.2,0), mfrow = c(1,1))
# Load data
data(nuts2006)
# set margins

# Create a grid layer
mygrid <- getGridLayer(spdf = nuts3.spdf, cellsize = 100000, type = "hexagonal")

# Compute data for the grid layer
df1 <- getGridData(x = mygrid, df = nuts3.df, var = "pop2008" )
df2 <- getGridData(x = mygrid, df = nuts3.df, var = "pop1999" )

# Compute the compound annual growth rate
df1$cagr <-(((df1$pop2008 / df2$pop1999)^(1/9)) - 1) * 100
v <- getBreaks(v = df1$cagr ,method = "quantile",nclass = 10)
v <- v[order(v)]
v[5] <- 0

#cols <- carto.pal(pal1 = "pink.pal", n1 = 4,pal2 = "taupe.pal", n2 = 6, middle = F )
cols <- c("#f18b61","#f7b48c","#f3d9b7","#f1eccd","#c0dec2","#91caa4","#63b285","#329966","#26734d","#1a4c33")

plot.new()
sizes <- getFigDim(spdf = nuts0.spdf, width = 18, mar = c(0,0,0,0))

png(filename = "RegularGrid", width = sizes[1], height = sizes[2],units = "cm",res = 150)

# Plot a layer with the extent of the EU28 countries with only a background color
plot(nuts0.spdf, border = NA, col = NA, bg = "#A6CAE0")

# Plot non european space
plot(world.spdf, col  = "#E3DEBF", border=NA, add=TRUE)

choroLayer(spdf = mygrid$spdf,df = df1,var = "cagr", add=TRUE,
           col=cols, lwd = 0.6, border = "#FFFFFF60",
           legend.pos = "right", breaks = v,legend.values.rnd = 2,
           legend.title.txt = "Compound\nAnnual\nGrowth Rate",)


plot(nuts0.spdf, add=T, col = NA, border = "#56514c", lwd = 0.7)


layoutLayer(title = "Demographic Trends, 1999-2008", author = "cartography", 
            sources = "Eurostat, 2008", frame = TRUE, col = "white", 
            scale = 500, coltitle = "black",
            north = TRUE, theme = "taupe.pal") 

dev.off()




#+ setup, include=F
knitr::opts_chunk$set(echo = TRUE, comment = '#>',
                      message = F, out.width = '70%',
                      fig.align='center')


#' ## Common lexical units
#+ echo=F
# Read data
deeplex <- readRDS("deeplex.rds")
cwn <- readRDS("cwn.rds")
cld <- readRDS("cld.rds")

library(VennDiagram)
library(RColorBrewer)

myCol <- brewer.pal(3, "Pastel2")


v <- venn.diagram(
        x = list(
          na.omit(deeplex$dl.lu_sim),
          na.omit(cwn$cwn.lemma_sim),
          na.omit(cld$cld.Word)
        ),
        category.names = c("DeepLex", "Chinese Wordnet", "Chinese Lexical Database"),
        filename = 'cld_deeplex_cwn.png',
        output=F,

        # Output features
        imagetype="png" ,
        height = 600 ,
        width = 600 ,
        resolution = 350,
        compression = "lzw",

        # Circles
        lwd = 2,
        lty = 'blank',
        fill = myCol,

        # Numbers
        cex = .6,
        fontface = "bold",
        fontfamily = "sans",

        # Set names
        cat.cex = 0.6,
        cat.fontface = "bold",
        cat.default.pos = "outer",
        #cat.pos = c(-15, 15, 135),
        cat.pos = c(-18, 15, -180),
        #cat.dist = c(0.045, 0.045, 0.085),
        cat.dist = c(0.05, 0.045, 0.04),
        cat.fontfamily = "sans",
        rotation = 1
)

#knitr::include_graphics("cld_deeplex_cwn.png")




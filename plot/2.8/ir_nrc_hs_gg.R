library(ggplot2)
library(reshape2)
library(ggpubr)

# Set theme
theme_set(theme_bw())

# Set input/output files
file_in_a <- "ir_hs_gg.tsv"
file_in_b <- "ir_diff_hs_gg.tsv"
file_out <- "ir_hs_gg.png"

# Functions
prepare_data <- function(filename, ir) {
  df <- read.table(filename, header = TRUE)
  df$ref <- rownames(df)

  df_molten <-
    melt(df, id.vars = "ref", variable.name = "tar", value.name = "nrc")
  df_molten$ir <- ir

  write.table(
    df_molten,
    file = paste(filename, ".tsv"),
    quote = FALSE,
    sep = "\t",
    col.names = NA
  )
}

# Data
hs_names_in <- c(
  "HS1", "HS2", "HS3", "HS4", "HS5", "HS6", "HS7", "HS8", "HS9", "HS10",
  "HS11", "HS12", "HS13", "HS14", "HS15", "HS16", "HS17", "HS18", "HS19",
  "HS20", "HS21", "HS22", "HSX", "HSY", "HSAL", "HSMT", "HSUL", "HSUP"
)
hs_names_out <- c(
  "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14",
  "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y", "AL", "MT", "UL",
  "UP"
)
gg_names_in <- c(
  "GG1", "GG2A", "GG2B", "GG3", "GG4", "GG5", "GG6", "GG7", "GG8", "GG9",
  "GG10", "GG11", "GG12", "GG13", "GG14", "GG15", "GG16", "GG17", "GG18",
  "GG19", "GG20", "GG21", "GG22", "GGX", "GGMT", "GGUL", "GGUP"
)
gg_names_out <- c(
  "1", "2A", "2B", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13",
  "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "MT", "UL", "UP"
)

## Data for a
df_hs_gg <- read.table(file_in_a, header = TRUE)
df_hs_gg$ref <-
  factor(df_hs_gg$ref, levels = hs_names_in, labels = hs_names_out)
df_hs_gg$tar <-
  factor(df_hs_gg$tar, levels = gg_names_in, labels = gg_names_out)

## Data for b
df_diff_hs_gg <- read.table(file_in_b, header = TRUE)
df_diff_hs_gg$ref <-
  factor(df_diff_hs_gg$ref, levels = hs_names_in, labels = hs_names_out)
df_diff_hs_gg$tar <-
  factor(df_diff_hs_gg$tar, levels = gg_names_in, labels = gg_names_out)

# Plot
a <- ggplot(df_hs_gg, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  coord_equal() +
  scale_fill_gradient(name = "NRC", low = "steelblue", high = "white") +
  ylab(expression(paste(italic("H. sapiens "), "(ref)"))) +
  xlab(expression(paste(italic("G. gorilla "), "(tar)"))) +
  facet_wrap(~ir.label, dir = "h")

b <- ggplot(df_diff_hs_gg, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  coord_equal() +
  scale_fill_gradient(
    name = expression(NRC[0] ~ -~ NRC[1]),
    low = "white",
    high = "orange"
  ) +
  ylab(expression(paste(italic("H. sapiens "), "(ref)"))) +
  xlab(expression(paste(italic("G. gorilla "), "(tar)")))

# Save plot
plot <- ggarrange(a, b, labels = c("a", "b"), nrow = 2)
ggsave(file_out, plot = plot, height = 12, width = 11.5)

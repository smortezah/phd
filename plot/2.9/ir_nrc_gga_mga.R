library(ggplot2)
library(reshape2)
library(ggpubr)

# Set theme
theme_set(theme_bw())

# Set input/output files
file_in_a <- "ir_gga_mga.tsv"
file_in_b <- "ir_diff_gga_mga.tsv"
file_in_c <- "ir_mga_gga.tsv"
file_in_d <- "ir_diff_mga_gga.tsv"
file_out <- "ir_gga_mga.png"

# Functions
prepare_data <- function(filename, ir) {
  df <- read.table(filename, header = TRUE)
  df$ref <- rownames(df)

  df_molten <- melt(df, id.vars = "ref", variable.name = "tar", value.name = "nrc")
  df_molten$ir.label <- ifelse(ir == 0, "\"Without IR (0)\"", "\"With IR (1)\"")

  write.table(df_molten, file = paste(filename, ".tsv"), quote = FALSE, sep = "\t", col.names = NA)
}

# Data
gga_names_in <- c(
  "GGA1", "GGA2", "GGA3", "GGA4", "GGA5", "GGA6", "GGA7", "GGA8", "GGA9", "GGA10", "GGA11", "GGA12", "GGA13", "GGA14",
  "GGA15", "GGA16", "GGA17", "GGA18", "GGA19", "GGA20", "GGA21", "GGA22", "GGA23", "GGA24", "GGA25", "GGA26", "GGA27",
  "GGA28", "GGA29", "GGA30", "GGA31", "GGA32", "GGA33", "GGALG", "GGAMT", "GGAW", "GGAZ", "GGAUL", "GGAUP"
)
gga_names_out <- c(
  "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21",
  "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "LG", "MT", "W", "Z", "UL", "UP"
)
mga_names_in <- c(
  "MGA1", "MGA2", "MGA3", "MGA4", "MGA5", "MGA6", "MGA7", "MGA8", "MGA9", "MGA10", "MGA11", "MGA12", "MGA13", "MGA14",
  "MGA15", "MGA16", "MGA17", "MGA18", "MGA19", "MGA20", "MGA21", "MGA22", "MGA23", "MGA24", "MGA25", "MGA26", "MGA27",
  "MGA28", "MGA29", "MGA30", "MGAMT", "MGAW", "MGAZ", "MGAUL", "MGAUP"
)
mga_names_out <- c(
  "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21",
  "22", "23", "24", "25", "26", "27", "28", "29", "30", "MT", "W", "Z", "UL", "UP"
)

## Data for a
df_gga_mga <- read.table(file_in_a, header = TRUE)
df_gga_mga$ref <- factor(df_gga_mga$ref, levels = gga_names_in, labels = gga_names_out)
df_gga_mga$tar <- factor(df_gga_mga$tar, levels = mga_names_in, labels = mga_names_out)

## Data for b
df_diff_gga_mga <- read.table(file_in_b, header = TRUE)
df_diff_gga_mga$ref <- factor(df_diff_gga_mga$ref, levels = gga_names_in, labels = gga_names_out)
df_diff_gga_mga$tar <- factor(df_diff_gga_mga$tar, levels = mga_names_in, labels = mga_names_out)

## Data for c
df_mga_gga <- read.table(file_in_c, header = TRUE)
df_mga_gga$ref <- factor(df_mga_gga$ref, levels = mga_names_in, labels = mga_names_out)
df_mga_gga$tar <- factor(df_mga_gga$tar, levels = gga_names_in, labels = gga_names_out)

## Data for d
df_diff_mga_gga <- read.table(file_in_d, header = TRUE)
df_diff_mga_gga$ref <- factor(df_diff_mga_gga$ref, levels = mga_names_in, labels = mga_names_out)
df_diff_mga_gga$tar <- factor(df_diff_mga_gga$tar, levels = gga_names_in, labels = gga_names_out)

# Plot
a <- ggplot(df_gga_mga, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  coord_equal() +
  scale_fill_gradient(name = "NRC                ", low = "steelblue", high = "white") +
  ylab(expression(paste(italic("G. gallus "), "(ref)"))) +
  xlab(expression(paste(italic("M. gallopavo "), "(tar)"))) +
  facet_wrap(~ir.label, dir = "v")

b <- ggplot(df_diff_gga_mga, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  coord_equal() +
  scale_fill_gradient(name = expression(NRC[0] ~ -~ NRC[1]), low = "white", high = "orange") +
  ylab(expression(paste(italic("G. gallus "), "(ref)"))) +
  xlab(expression(paste(italic("M. gallopavo "), "(tar)")))

c <- ggplot(df_mga_gga, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  scale_fill_gradient(
    name = "NRC                ",
    low = "steelblue", high = "white",
    breaks = c(0.7, 0.8, 0.9, 1.0),
    labels = c(0.7, 0.8, 0.9, "1.0"),
    limits = c(0.7, 1)
  ) +
  ylab(expression(paste(italic("M. gallopavo "), "(ref)"))) +
  xlab(expression(paste(italic("G. gallus "), "(tar)"))) +
  facet_wrap(~ir.label, dir = "v")

d <- ggplot(df_diff_mga_gga, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  scale_fill_gradient(name = expression(NRC[0] ~ -~ NRC[1]), low = "white", high = "orange") +
  ylab(expression(paste(italic("M. gallopavo "), "(ref)"))) +
  xlab(expression(paste(italic("G. gallus "), "(tar)")))

# Save plot
plot <- ggarrange(a, c, b, d, labels = c("a", "c", "b", "d"), nrow = 2, ncol = 2, heights = c(2, 1), align = "v")
ggsave(file_out, plot = plot, height = 24, width = 18)

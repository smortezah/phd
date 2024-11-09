library(ggplot2)
library(reshape2)
library(ggpubr)

# Set theme
theme_set(theme_bw())

# Set input/output files
file_in_a <- "ir_hs_pt.tsv"
file_in_b <- "ir_diff_hs_pt.tsv"
file_in_c <- "ir_pt_hs.tsv"
file_in_d <- "ir_diff_pt_hs.tsv"
file_out <- "ir_hs_pt.png"

# Functions
prepare_data <- function(filename, ir) {
  df <- read.table(filename, header = TRUE)
  df$ref <- rownames(df)

  df_molten <-
    melt(df, id.vars = "ref", variable.name = "tar", value.name = "nrc")
  df_molten$ir <- ir
  df_molten$ir.label <-
    ifelse(ir == 0, "\"Without IR (0)\"", "\"With IR (1)\"")

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
pt_names_in <- c(
  "PT1", "PT2A", "PT2B", "PT3", "PT4", "PT5", "PT6", "PT7", "PT8", "PT9",
  "PT10", "PT11", "PT12", "PT13", "PT14", "PT15", "PT16", "PT17", "PT18",
  "PT19", "PT20", "PT21", "PT22", "PTX", "PTY", "PTMT", "PTUL", "PTUP"
)
pt_names_out <- c(
  "1", "2A", "2B", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13",
  "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y", "MT", "UL",
  "UP"
)

## Data for a
df_hs_pt <- read.table(file_in_a, header = TRUE)
df_hs_pt$ref <-
  factor(df_hs_pt$ref, levels = hs_names_in, labels = hs_names_out)
df_hs_pt$tar <-
  factor(df_hs_pt$tar, levels = pt_names_in, labels = pt_names_out)

## Data for b
df_diff_hs_pt <- read.table(file_in_b, header = TRUE)
df_diff_hs_pt$ref <-
  factor(df_diff_hs_pt$ref, levels = hs_names_in, labels = hs_names_out)
df_diff_hs_pt$tar <-
  factor(df_diff_hs_pt$tar, levels = pt_names_in, labels = pt_names_out)

## Data for c
df_pt_hs <- read.table(file_in_c, header = TRUE)
df_pt_hs$ref <-
  factor(df_pt_hs$ref, levels = pt_names_in, labels = pt_names_out)
df_pt_hs$tar <-
  factor(df_pt_hs$tar, levels = hs_names_in, labels = hs_names_out)

## Data for d
df_diff_pt_hs <- read.table(file_in_d, header = TRUE)
df_diff_pt_hs$ref <-
  factor(df_diff_pt_hs$ref, levels = pt_names_in, labels = pt_names_out)
df_diff_pt_hs$tar <-
  factor(df_diff_pt_hs$tar, levels = hs_names_in, labels = hs_names_out)

# Plot
a <- ggplot(df_hs_pt, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  coord_equal() +
  scale_fill_gradient(
    name = "NRC                ",
    low = "steelblue",
    high = "white"
  ) +
  ylab(expression(paste(italic("H. sapiens "), "(ref)"))) +
  xlab(expression(paste(italic("P. troglodytes "), "(tar)"))) +
  facet_wrap(~ir.label, dir = "v")

b <- ggplot(df_diff_hs_pt, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  coord_equal() +
  scale_fill_gradient(
    name = expression(NRC[0] ~ -~ NRC[1]),
    low = "white",
    high = "orange"
  ) +
  ylab(expression(paste(italic("H. sapiens "), "(ref)"))) +
  xlab(expression(paste(italic("P. troglodytes "), "(tar)")))

c <- ggplot(df_pt_hs, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  coord_equal() +
  scale_fill_gradient(
    name = "NRC                ",
    low = "steelblue",
    high = "white"
  ) +
  ylab(expression(paste(italic("P. troglodytes "), "(ref)"))) +
  xlab(expression(paste(italic("H. sapiens "), "(tar)"))) +
  facet_wrap(~ir.label, dir = "v")

d <- ggplot(df_diff_pt_hs, aes(tar, ref)) +
  geom_tile(aes(fill = nrc), colour = "white") +
  coord_equal() +
  scale_fill_gradient(
    name = expression(NRC[0] ~ -~ NRC[1]),
    low = "white",
    high = "orange"
  ) +
  ylab(expression(paste(italic("P. troglodytes "), "(ref)"))) +
  xlab(expression(paste(italic("H. sapiens "), "(tar)")))

# Save plot
plot <- ggarrange(
  a, c,
  b, d,
  labels = c("a", "c", "b", "d"),
  nrow = 2,
  ncol = 2,
  heights = c(2, 1),
  align = "v"
)
ggsave(file_out, plot = plot, height = 20, width = 16)

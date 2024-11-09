library(ggplot2)
library(ggpubr)
library(dplyr)

# Set theme
theme_set(theme_bw())

# Set input/output files
file_in <- "survey_comp_ratio.tsv"
file_out <- "survey_comp_ratio.png"

# Data
df <- read.table(file_in, header = TRUE)
df_ref_free <- df %>% filter(format != ".")
df_ref_based <- df %>% filter(format == ".")

# Plot
a <- ggplot(df_ref_free, aes(x = order, y = comp.ratio, color = method)) +
  geom_segment(
    aes(x = order, xend = order, y = 0.0, yend = comp.ratio),
    linewidth = 0.75
  ) +
  geom_point(size = 10) +
  geom_text(label = df_ref_free$comp.ratio, color = "white", size = 2.9) +
  coord_flip() +
  ggtitle("Reference-free compression") +
  ylab("Compression ratio") +
  scale_x_discrete(breaks = df_ref_free$order, labels = df_ref_free$method) +
  facet_grid(
    factor(df_ref_free$format, levels = c("FASTA", "FASTQ", "BAM")) ~ .,
    scales = "free_y", space = "free_y"
  ) +
  theme(axis.title.y = element_blank(), legend.position = "none")

b <- ggplot(df_ref_based, aes(x = order, y = comp.ratio, color = method)) +
  geom_segment(
    aes(x = order, xend = order, y = 0.0, yend = comp.ratio),
    linewidth = 0.75
  ) +
  geom_point(size = 10) +
  geom_text(label = df_ref_based$comp.ratio, color = "white", size = 2.9) +
  coord_flip() +
  ggtitle("Reference-based compression") +
  ylab("Compression ratio") +
  scale_x_discrete(
    breaks = df_ref_based$order,
    labels = c("GeCo", "      iDoComp", "GDC 2", "GReEn", "ERGC")
  ) +
  theme(axis.title.y = element_blank(), legend.position = "none")

# Save plot
plot <- ggarrange(a, b, labels = c("a", "b"), nrow = 2, heights = c(3, 1.2))
ggsave(file_out, plot = plot, height = 8)

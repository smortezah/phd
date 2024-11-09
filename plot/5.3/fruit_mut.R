library(ggplot2)

# Set theme
theme_set(theme_bw())

# Set input/output files
file_in_real <- "fruit_ancient_uniq.tsv"
file_in_syn <- "fruit_synth_uniq.tsv"
file_out <- "fruit_mut.png"

# Data
real <- read.table(file_in_real, header = TRUE)
syn <- read.table(file_in_syn, header = TRUE)
all <- data.frame(rbind(data.frame(dataset = "Synthetic", syn), real))

# Plot
plot <- ggplot(
  all[all$k %in% c(5:10), ],
  aes(x = mut, y = unqRat, color = factor(k))
) +
  geom_line(linewidth = 1) +
  xlab("Mutation rate %") +
  ylab("Uniqueness ratio") +
  labs(color = "k") +
  facet_wrap(~dataset, ncol = 2)

# Save plot
ggsave(file_out, plot = plot)

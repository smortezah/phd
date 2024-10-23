library(ggplot2)

# Set theme
theme_set(theme_bw())

# Set working directory and input/output files
setwd("./")
file_in_real <- "../data/fruit_ancient_uniq.tsv"
file_in_syn <- "../data/fruit_synth_uniq.tsv"
file_out <- "../image/fruit_mut.png"

# Data
real <- read.table(file_in_real, header = TRUE)
syn <- read.table(file_in_syn, header = TRUE)
all <- data.frame(rbind(data.frame(dataset = "Synthetic", syn), real))

# Plot
ggplot(
  all[all$k %in% c(5:10), ],
  aes(x = mut, y = unqRat, color = factor(k))
) +
  geom_line(size = 1) +
  xlab("Mutation rate %") +
  ylab("Uniqueness ratio") +
  labs(color = "k") +
  facet_wrap(~dataset, ncol = 2)

# Save plot
ggsave(file_out)

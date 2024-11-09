library(ggplot2)
library(ggridges)
library(ggpubr)

# Set theme
theme_set(theme_bw())

# Set input/output files
file_in_hs_uniq <- "fruit_hs_uniq.tsv"
file_in_hs_stat <- "fruit_hs_stat.tsv"
file_out <- "fruit_hist_uniq_prob.png"

# Data
hs_uniq <- read.table(file_in_hs_uniq, header = TRUE)
data_uniq <- hs_uniq[hs_uniq$k %in% c(5:10), ]

hs_stat <- read.table(file_in_hs_stat, header = TRUE)
data_stat <- hs_stat[hs_stat$k %in% c(2:10), ]

# Plot
a <- ggplot(data_uniq, aes(x = unqRat, y = factor(k), fill = factor(k))) +
  scale_x_continuous(breaks = seq(0.0, 1.0, 0.2)) +
  xlab("Uniqueness ratio") +
  ylab("k-mer size") +
  geom_density_ridges(scale = 6.5, alpha = 0.92) +
  theme(legend.position = "none")

b <- ggplot(data_stat, aes(x = k, y = unqRat)) +
  geom_line(color = "darkblue") +
  geom_point(color = "darkblue", size = 3) +
  scale_x_continuous(breaks = c(2:10)) +
  xlab("k-mer size") +
  ylab("Uniqueness ratio")

c <- ggplot(data_stat, aes(x = k, y = 1 / 21^k)) +
  geom_line(color = "darkred") +
  geom_point(color = "darkred", size = 3) +
  scale_x_continuous(breaks = c(2:10)) +
  xlab("k-mer size") +
  ylab(expression(Probability ~ (1 / 21^k)))

# Save plot
plot <- ggarrange(
  a,
  ggarrange(b, c, nrow = 2, align = "v", labels = c("b", "c")),
  labels = "a",
  widths = 5:3
)
ggsave(file_out, plot = plot)

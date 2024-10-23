library(ggplot2)

# Set theme
theme_set(theme_bw())

# Set working directory and input/output files
setwd("./")
file_in <- "../data/ac_nc_size.tsv"
file_out <- "../image/ac_nc.png"

# Data
df <- read.table(file_in, header = TRUE)
sorted_domain <- c("Viruses", "Archaea", "Bacteria", "Eukaryota")

df_ave <- data.frame(
  domain = sorted_domain,
  ave.nc = c(0.96, 0.92, 0.92, 0.88),
  color = c("grey50", "blue", "brown", "purple")
)

# Plot
a <- ggplot(df, aes(x = domain, y = nc)) +
  geom_violin(aes(fill = domain)) +
  scale_x_discrete(limits = sorted_domain) +
  scale_fill_manual(
    limits = sorted_domain,
    values = c("grey50", "blue", "brown", "purple")
  ) +
  ylab("NC") +
  theme(axis.title.x = element_blank(), legend.position = "none")

b <-
  ggplot(df_ave, aes(reorder(domain, desc(ave.nc)), ave.nc, label = ave.nc)) +
  geom_segment(
    aes(
      x = reorder(domain, desc(ave.nc)),
      xend = reorder(domain, desc(ave.nc)),
      y = 0.85,
      yend = ave.nc,
    ),
    size = 0.75,
    color = df_ave$color
  ) +
  geom_point(size = 15, color = df_ave$color) +
  geom_text(color = "white", size = 3) +
  ylim(0.85, 1) +
  ylab("Average NC") +
  theme(axis.title.x = element_blank())

# Save plot
ggarrange(a, b, labels = c("a", "b"))
ggsave(file_out, height = 3, width = 7)

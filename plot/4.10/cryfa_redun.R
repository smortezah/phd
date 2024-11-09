library(ggplot2)
library(dplyr)
library(ggpubr)

# Set theme
theme_set(theme_bw())

# Set input/output files
file_in <- "cryfa_redun.tsv"
file_out <- "cryfa_redun.png"

# Data and plot
df <- read.table(file_in, header = TRUE)

## 1.1
cryfa <- df %>% filter(Method == "cryfa")
deliminate <- df %>% filter(Method == "DELIMINATE")
mfcompress <- df %>% filter(Method == "MFCompress")

color_list <- c("blue", "purple", "red", "darkgreen", "darkgray")

g11 <- ggplot(cryfa, aes(x = Size / 1024 / 1024, y = NC, color = Category)) +
  geom_point() +
  scale_color_manual(
    name = "",
    breaks = c("A", "B", "F", "P", "V"),
    labels = c("Archaea", "Bacteria", "Fungi", "Plants", "Viruses"),
    values = color_list
  ) +
  scale_y_continuous(
    limits = c(1.3, 1.5),
    breaks = c(1.3, 1.4, 1.5),
    labels = c(1.3, 1.4, 1.5)
  ) +
  xlim(0, 2) +
  theme(axis.title.x = element_blank()) +
  ggtitle("Cryfa") +
  theme(legend.position = "top")

## 1.2
archaea <- subset(cryfa, Category == "A")
bacteria <- subset(cryfa, Category == "B")
fungi <- subset(cryfa, Category == "F")
plants <- subset(cryfa, Category == "P")
viruses <- subset(cryfa, Category == "V")
df_pointrange <- data.frame(
  Category = c("A", "B", "F", "P", "V"),
  lower = c(
    min(archaea[, "NC"]),
    min(bacteria[, "NC"]),
    min(fungi[, "NC"]),
    min(plants[, "NC"]),
    min(viruses[, "NC"])
  ),
  mean = c(
    mean(archaea[, "NC"]),
    mean(bacteria[, "NC"]),
    mean(fungi[, "NC"]),
    mean(plants[, "NC"]),
    mean(viruses[, "NC"])
  ),
  upper = c(
    max(archaea[, "NC"]),
    max(bacteria[, "NC"]),
    max(fungi[, "NC"]),
    max(plants[, "NC"]),
    max(viruses[, "NC"])
  )
)

g12 <- ggplot(df_pointrange) +
  geom_pointrange(
    aes(x = Category, ymin = lower, y = mean, ymax = upper, color = Category),
    fill = "white",
    fatten = 4,
    shape = 23
  ) +
  theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
  scale_color_manual(values = color_list) +
  scale_fill_manual(values = color_list) +
  scale_y_continuous(
    position = "left",
    limits = c(1.3, 1.5),
    breaks = c(1.3, 1.4, 1.5),
    labels = c(1.3, 1.4, 1.5)
  ) +
  ggtitle("Cryfa")

## 2.1
g21 <-
  ggplot(deliminate, aes(x = Size / 1024 / 1024, y = NC, color = Category)) +
  geom_point() +
  scale_color_manual(values = color_list) +
  xlim(0, 2) +
  ylim(0.7, 1.1) +
  theme(axis.title.x = element_blank()) +
  ggtitle("DELIMINATE")

## 2.2
archaea <- subset(deliminate, Category == "A")
bacteria <- subset(deliminate, Category == "B")
fungi <- subset(deliminate, Category == "F")
plants <- subset(deliminate, Category == "P")
viruses <- subset(deliminate, Category == "V")
df_pointrange <- data.frame(
  Category = c("A", "B", "F", "P", "V"),
  lower = c(
    min(archaea[, "NC"]),
    min(bacteria[, "NC"]),
    min(fungi[, "NC"]),
    min(plants[, "NC"]),
    min(viruses[, "NC"])
  ),
  mean = c(
    mean(archaea[, "NC"]),
    mean(bacteria[, "NC"]),
    mean(fungi[, "NC"]),
    mean(plants[, "NC"]),
    mean(viruses[, "NC"])
  ),
  upper = c(
    max(archaea[, "NC"]),
    max(bacteria[, "NC"]),
    max(fungi[, "NC"]),
    max(plants[, "NC"]),
    max(viruses[, "NC"])
  )
)

g22 <- ggplot(df_pointrange) +
  geom_pointrange(
    aes(x = Category, ymin = lower, y = mean, ymax = upper, color = Category),
    fill = "white",
    fatten = 4,
    shape = 23
  ) +
  theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
  scale_color_manual(values = color_list) +
  scale_fill_manual(values = color_list) +
  xlab("") +
  scale_y_continuous(position = "left", limits = c(0.7, 1.1)) +
  ggtitle("DELIMINATE")

## 3.1
g31 <-
  ggplot(mfcompress, aes(x = Size / 1024 / 1024, y = NC, color = Category)) +
  geom_point() +
  scale_color_manual(values = color_list) +
  xlim(0, 2) +
  ylim(0.7, 1.1) +
  xlab("File size (MB)") +
  ggtitle("MFCompress")

## 3.2
archaea <- subset(mfcompress, Category == "A")
bacteria <- subset(mfcompress, Category == "B")
fungi <- subset(mfcompress, Category == "F")
plants <- subset(mfcompress, Category == "P")
viruses <- subset(mfcompress, Category == "V")
df_pointrange <- data.frame(
  Category = c("A", "B", "F", "P", "V"),
  lower = c(
    min(archaea[, "NC"]),
    min(bacteria[, "NC"]),
    min(fungi[, "NC"]),
    min(plants[, "NC"]),
    min(viruses[, "NC"])
  ),
  mean = c(
    mean(archaea[, "NC"]),
    mean(bacteria[, "NC"]),
    mean(fungi[, "NC"]),
    mean(plants[, "NC"]),
    mean(viruses[, "NC"])
  ),
  upper = c(
    max(archaea[, "NC"]),
    max(bacteria[, "NC"]),
    max(fungi[, "NC"]),
    max(plants[, "NC"]),
    max(viruses[, "NC"])
  )
)

g32 <- ggplot(df_pointrange) +
  geom_pointrange(
    aes(x = Category, ymin = lower, y = mean, ymax = upper, color = Category),
    fill = "white",
    fatten = 4,
    shape = 23
  ) +
  theme(axis.title.y = element_blank()) +
  scale_color_manual(values = color_list) +
  scale_fill_manual(values = color_list) +
  xlab("") +
  scale_y_continuous(position = "left", limits = c(0.7, 1.1)) +
  ggtitle("MFCompress")

# Save plot
plot <- ggarrange(
  g11, g12,
  g21, g22,
  g31, g32,
  labels = c("a", "b"),
  nrow = 3,
  ncol = 2,
  widths = c(4, 1),
  heights = c(1.2, 2, 2),
  common.legend = TRUE
)
ggsave(file_out, plot = plot, height = 9.5)

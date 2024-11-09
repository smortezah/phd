library(ggplot2)
library(ggpubr)
library(desc)

# Set theme
theme_set(theme_bw())

# Set output file
file_out <- "cryfa_comp_enc.png"

# Data
## Data for time
time_data <- rbind(
  c("a", "MFCompress + AES Crypt", 15.8, "FASTA", "enc"),
  c("a", "MFCompress + AES Crypt", 11.7, "FASTA", "dec"),
  c("b", "gzip + AES Crypt", 13.0, "FASTA", "enc"),
  c("b", "gzip + AES Crypt", 1.5, "FASTA", "dec"),
  c("c", "bzip2 + AES Crypt", 9.7, "FASTA", "enc"),
  c("c", "bzip2 + AES Crypt", 4.7, "FASTA", "dec"),
  c("d", "DELIMINATE + AES Crypt", 7.4, "FASTA", "enc"),
  c("d", "DELIMINATE + AES Crypt", 7.5, "FASTA", "dec"),
  c("e", "Cryfa", 0.7, "FASTA", "enc"),
  c("e", "Cryfa", 0.9, "FASTA", "dec"),
  c("f", "bzip2 + AES Crypt", 49.8, "FASTQ", "enc"),
  c("f", "bzip2 + AES Crypt", 24.2, "FASTQ", "dec"),
  c("g", "gzip + AES Crypt", 47.0, "FASTQ", "enc"),
  c("g", "gzip + AES Crypt", 9.6, "FASTQ", "dec"),
  c("h", "FQC + AES Crypt", 44.7, "FASTQ", "enc"),
  c("h", "FQC + AES Crypt", 40.9, "FASTQ", "dec"),
  c("i", "fqzcomp + AES Crypt", 14.7, "FASTQ", "enc"),
  c("i", "fqzcomp + AES Crypt", 13.1, "FASTQ", "dec"),
  c("j", "Quip + AES Crypt", 13.8, "FASTQ", "enc"),
  c("j", "Quip + AES Crypt", 22.0, "FASTQ", "dec"),
  c("k", "DSRC 2 + AES Crypt", 11.1, "FASTQ", "enc"),
  c("k", "DSRC 2 + AES Crypt", 11.3, "FASTQ", "dec"),
  c("l", "Cryfa", 8.3, "FASTQ", "enc"),
  c("l", "Cryfa", 8.2, "FASTQ", "dec")
)

df_time <- data.frame(
  order = time_data[, 1],
  method = time_data[, 2],
  time = as.numeric(time_data[, 3]),
  format = time_data[, 4],
  state = time_data[, 5]
)
df_time <- df_time %>%
  mutate(lab_ypos = ifelse(state == "enc", -time, time)) %>%
  mutate(time = ifelse(state == "enc", -time, time))

## Data for size
size_data <- rbind(
  c("a", "Cryfa", "FASTA", 2163, "Compressed", 6327, 2.9),
  c("a", "Cryfa", "FASTA", 4164, "Reduced", 6327, 2.9),
  c("b", "gzip + AES Crypt", "FASTA", 1922, "Compressed", 6327, 3.3),
  c("b", "gzip + AES Crypt", "FASTA", 4405, "Reduced", 6327, 3.3),
  c("c", "bzip2 + AES Crypt", "FASTA", 1778, "Compressed", 6327, 3.6),
  c("c", "bzip2 + AES Crypt", "FASTA", 4549, "Reduced", 6327, 3.6),
  c("d", "MFCompress + AES Crypt", "FASTA", 1495, "Compressed", 6327, 4.2),
  c("d", "MFCompress + AES Crypt", "FASTA", 4832, "Reduced", 6327, 4.2),
  c("e", "DELIMINATE + AES Crypt", "FASTA", 1509, "Compressed", 6327, 4.2),
  c("e", "DELIMINATE + AES Crypt", "FASTA", 4818, "Reduced", 6327, 4.2),
  c("f", "Cryfa", "FASTQ", 18706, "Compressed", 35542, 1.9),
  c("f", "Cryfa", "FASTQ", 16836, "Reduced", 35542, 1.9),
  c("h", "bzip2 + AES Crypt", "FASTQ", 9741, "Compressed", 35542, 3.6),
  c("h", "bzip2 + AES Crypt", "FASTQ", 25801, "Reduced", 35542, 3.6),
  c("l", "FQC + AES Crypt", "FASTQ", 7363, "Compressed", 35542, 4.8),
  c("l", "FQC + AES Crypt", "FASTQ", 28179, "Reduced", 35542, 4.8),
  c("g", "gzip + AES Crypt", "FASTQ", 12116, "Compressed", 35542, 2.9),
  c("g", "gzip + AES Crypt", "FASTQ", 23426, "Reduced", 35542, 2.9),
  c("k", "fqzcomp + AES Crypt", "FASTQ", 7673, "Compressed", 35542, 4.6),
  c("k", "fqzcomp + AES Crypt", "FASTQ", 27869, "Reduced", 35542, 4.6),
  c("i", "Quip + AES Crypt", "FASTQ", 8086, "Compressed", 35542, 4.4),
  c("i", "Quip + AES Crypt", "FASTQ", 27456, "Reduced", 35542, 4.4),
  c("j", "DSRC 2 + AES Crypt", "FASTQ", 8004, "Compressed", 35542, 4.4),
  c("j", "DSRC 2 + AES Crypt", "FASTQ", 27538, "Reduced", 35542, 4.4)
)

df_size <- data.frame(
  order = size_data[, 1],
  method = size_data[, 2],
  format = size_data[, 3],
  size = as.numeric(size_data[, 4]) / 1024,
  state = factor(size_data[, 5], levels = c("Reduced", "Compressed")),
  total.size = as.numeric(size_data[, 6]) / 1024,
  ratio = as.numeric(size_data[, 7])
)
df_size <- df_size %>%
  group_by(method, format) %>%
  mutate(lab_ypos = cumsum(size) - 0.5 * size)

# Plot
a <- ggplot(df_time, aes(x = order, y = time, fill = state)) +
  geom_col() +
  coord_flip() +
  facet_grid(format ~ ., scales = "free", space = "free") +
  geom_text(
    aes(
      y = lab_ypos,
      label = ifelse(state == "enc", -round(time, 1), round(time, 1))
    ),
    size = 3,
    color = ifelse(df_time$format == "FASTA" &
      (
        df_time$method == "Cryfa" |
          (df_time$method == "gzip + AES Crypt" & df_time$state == "dec")
      ),
    "black",
    "white"
    ),
    vjust = 0.3,
    hjust = ifelse(
      df_time$state == "enc",
      ifelse(df_time$format == "FASTA" & df_time$method == "Cryfa", 1.3, -0.3),
      ifelse(
        df_time$format == "FASTA" &
          df_time$method %in% c("Cryfa", "gzip + AES Crypt"),
        -0.3,
        1.3
      )
    )
  ) +
  ylab("Time (min)") +
  theme(axis.title.y = element_blank(), legend.position = "right") +
  scale_fill_discrete(
    name = "",
    breaks = c("enc", "dec"),
    labels = c(
      "Compress &\nEncrypt                           ",
      "Decrypt &\nDecompress"
    )
  ) +
  scale_y_continuous(breaks = c(0), labels = c(0)) +
  scale_x_discrete(breaks = df_time$order, labels = df_time$method) +
  geom_hline(yintercept = 0)

b <- ggplot(
  df_size,
  aes(x = order, y = size, fill = state)
) +
  geom_blank(aes(x = order, y = size * 1.35)) +
  geom_col() +
  geom_text(
    aes(label = round(size, digits = 1)),
    position = position_stack(0.5),
    size = 3,
    color = "white"
  ) +
  geom_text(
    aes(y = total.size, label = paste0("CR=", round(ratio, digits = 1))),
    vjust = -0.75,
    size = 2.25
  ) +
  theme(
    axis.title.x = element_blank(),
    axis.text.x = element_text(angle = -35, hjust = 0),
    legend.position = "right"
  ) +
  ylab("Size (GB)") +
  scale_x_discrete(breaks = df_size$order, labels = df_size$method) +
  scale_fill_manual(
    name = "",
    breaks = c("Compressed", "Reduced"),
    labels = c("Compressed", "Reduced\n(Original - Compressed)"),
    values = c("#56a4e9", "#E69F00")
  ) +
  facet_grid(. ~ format, scales = "free", space = "free")

# Save plot
plot <- ggarrange(a, b, labels = c("a", "b"), nrow = 2)
ggsave(file_out, plot = plot, height = 8, width = 8)

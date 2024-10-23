library(ggplot2)

# Set theme
theme_set(theme_bw())

# Set working directory and input/output files
setwd("./")
file_out <- "../image/cryfa_enc_aes.png"

# Data
## Data for time
time_data <- rbind(
  c("Cryfa", 0.7, "FASTA", "Encrypt"),
  c("Cryfa", 0.9, "FASTA", "Decrypt"),
  c("Cryfa", 8.3, "FASTQ", "Encrypt"),
  c("Cryfa", 8.2, "FASTQ", "Decrypt"),
  c("AES Crypt", 3.2, "FASTA", "Encrypt"),
  c("AES Crypt", 3.1, "FASTA", "Decrypt"),
  c("AES Crypt", 19.2, "FASTQ", "Encrypt"),
  c("AES Crypt", 16.8, "FASTQ", "Decrypt")
)

df_time <- data.frame(
  method = time_data[, 1],
  time = as.numeric(time_data[, 2]),
  format = time_data[, 3],
  state = time_data[, 4]
)
df_time <- df_time %>% mutate(time = ifelse(state == "Encrypt", -time, time))

## Data for size
size_data <- rbind(
  c("Cryfa", "FASTA", 2163, "Compressed", 6327, 2.9),
  c("Cryfa", "FASTA", 4164, "Reduced", 6327, 2.9),
  c("Cryfa", "FASTQ", 18706, "Compressed", 35542, 1.9),
  c("Cryfa", "FASTQ", 16836, "Reduced", 35542, 1.9),
  c("AES Crypt", "FASTA", 6327, "Compressed", 6327, 1.0),
  c("AES Crypt", "FASTQ", 35542, "Compressed", 35542, 1.0)
)

df_size <- data.frame(
  method = size_data[, 1],
  format = size_data[, 2],
  size = as.numeric(size_data[, 3]) / 1024,
  state = size_data[, 4],
  total.size = as.numeric(size_data[, 5]) / 1024,
  ratio = as.numeric(size_data[, 6])
)
df_size$state <- reorder(df_size$state, df_size$size)
df_size <- df_size %>%
  group_by(method, format) %>%
  mutate(lab_ypos = cumsum(size) - 0.5 * size)

# Plot
a <- ggplot(df_time, aes(x = method, y = time, fill = state)) +
  geom_col() +
  coord_flip() +
  geom_text(
    aes(
      y = time,
      label = ifelse(state == "Encrypt", -round(time, 1), round(time, 1))
    ),
    size = 3,
    color = ifelse(
      df_time$format == "FASTA" & df_time$method == "Cryfa",
      "black",
      "white"
    ),
    hjust = ifelse(
      df_time$state == "Encrypt",
      ifelse(df_time$format == "FASTA" & df_time$method == "Cryfa", 1.3, -0.3),
      ifelse(df_time$format == "FASTA" & df_time$method == "Cryfa", -0.3, 1.3)
    )
  ) +
  ylab("Time (min)") +
  theme(axis.title.y = element_blank(), legend.position = "right") +
  scale_fill_discrete(
    name = "",
    breaks = c("Encrypt", "Decrypt"),
    labels = c(
      "Encrypt /\nCompact & Encrypt         ",
      "Decrypt /\nDecrypt & Unpack"
    )
  ) +
  scale_y_continuous(breaks = c(0), labels = c(0)) +
  facet_grid(format ~ ., scales = "free") +
  geom_hline(yintercept = 0)

b <- ggplot(df_size, aes(x = method, y = size, fill = state)) +
  geom_blank(aes(x = method, y = size * 1.11)) +
  geom_col() +
  geom_text(
    aes(y = lab_ypos, label = round(size, digits = 1)),
    size = 3,
    color = "white"
  ) +
  geom_text(
    aes(y = total.size, label = paste0("CR = ", round(ratio, digits = 1))),
    vjust = -0.75,
    size = 2.5
  ) +
  theme(axis.title.x = element_blank(), legend.position = "right") +
  ylab("Size (GB)") +
  scale_fill_manual(
    name = "",
    breaks = c("Compressed", "Reduced"),
    labels = c("Compressed", "Reduced\n(Original - Compressed)"),
    values = c("#E69F00", "#56B4E9")
  ) +
  facet_grid(. ~ format, scales = "free")

# Save plot
ggarrange(a, b, labels = c("a", "b"), nrow = 2)
ggsave(file_out, height = 4.5)

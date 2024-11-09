library(ggplot2)
library(ggpubr)

# Set theme
theme_set(theme_bw())

# Set output file
file_out <- "cryfa_thread.png"

# Data
# Data for time
time_data <- rbind(
  c("viruses.fasta", 1, 0.16, "Real time", "enc"),
  c("viruses.fasta", 1, 0.12, "Real time", "dec"),
  c("viruses.fasta", 2, 0.08, "Real time", "enc"),
  c("viruses.fasta", 2, 0.10, "Real time", "dec"),
  c("viruses.fasta", 3, 0.06, "Real time", "enc"),
  c("viruses.fasta", 3, 0.09, "Real time", "dec"),
  c("viruses.fasta", 4, 0.06, "Real time", "enc"),
  c("viruses.fasta", 4, 0.09, "Real time", "dec"),
  c("viruses.fasta", 5, 0.05, "Real time", "enc"),
  c("viruses.fasta", 5, 0.08, "Real time", "dec"),
  c("viruses.fasta", 6, 0.05, "Real time", "enc"),
  c("viruses.fasta", 6, 0.08, "Real time", "dec"),
  c("viruses.fasta", 7, 0.04, "Real time", "enc"),
  c("viruses.fasta", 7, 0.07, "Real time", "dec"),
  c("viruses.fasta", 8, 0.04, "Real time", "enc"),
  c("viruses.fasta", 8, 0.07, "Real time", "dec"),
  #
  c("viruses.fasta", 1, 0.14, "CPU time", "enc"),
  c("viruses.fasta", 1, 0.12, "CPU time", "dec"),
  c("viruses.fasta", 2, 0.14, "CPU time", "enc"),
  c("viruses.fasta", 2, 0.12, "CPU time", "dec"),
  c("viruses.fasta", 3, 0.15, "CPU time", "enc"),
  c("viruses.fasta", 3, 0.13, "CPU time", "dec"),
  c("viruses.fasta", 4, 0.17, "CPU time", "enc"),
  c("viruses.fasta", 4, 0.14, "CPU time", "dec"),
  c("viruses.fasta", 5, 0.17, "CPU time", "enc"),
  c("viruses.fasta", 5, 0.15, "CPU time", "dec"),
  c("viruses.fasta", 6, 0.19, "CPU time", "enc"),
  c("viruses.fasta", 6, 0.15, "CPU time", "dec"),
  c("viruses.fasta", 7, 0.19, "CPU time", "enc"),
  c("viruses.fasta", 7, 0.16, "CPU time", "dec"),
  c("viruses.fasta", 8, 0.20, "CPU time", "enc"),
  c("viruses.fasta", 8, 0.16, "CPU time", "dec"),
  #
  c("DS-B1088_SR.fastq", 1, 0.72, "Real time", "enc"),
  c("DS-B1088_SR.fastq", 1, 0.57, "Real time", "dec"),
  c("DS-B1088_SR.fastq", 2, 0.42, "Real time", "enc"),
  c("DS-B1088_SR.fastq", 2, 0.48, "Real time", "dec"),
  c("DS-B1088_SR.fastq", 3, 0.33, "Real time", "enc"),
  c("DS-B1088_SR.fastq", 3, 0.41, "Real time", "dec"),
  c("DS-B1088_SR.fastq", 4, 0.31, "Real time", "enc"),
  c("DS-B1088_SR.fastq", 4, 0.40, "Real time", "dec"),
  c("DS-B1088_SR.fastq", 5, 0.28, "Real time", "enc"),
  c("DS-B1088_SR.fastq", 5, 0.37, "Real time", "dec"),
  c("DS-B1088_SR.fastq", 6, 0.26, "Real time", "enc"),
  c("DS-B1088_SR.fastq", 6, 0.36, "Real time", "dec"),
  c("DS-B1088_SR.fastq", 7, 0.25, "Real time", "enc"),
  c("DS-B1088_SR.fastq", 7, 0.35, "Real time", "dec"),
  c("DS-B1088_SR.fastq", 8, 0.24, "Real time", "enc"),
  c("DS-B1088_SR.fastq", 8, 0.35, "Real time", "dec"),
  #
  c("DS-B1088_SR.fastq", 1, 0.59, "CPU time", "enc"),
  c("DS-B1088_SR.fastq", 1, 0.50, "CPU time", "dec"),
  c("DS-B1088_SR.fastq", 2, 0.63, "CPU time", "enc"),
  c("DS-B1088_SR.fastq", 2, 0.55, "CPU time", "dec"),
  c("DS-B1088_SR.fastq", 3, 0.65, "CPU time", "enc"),
  c("DS-B1088_SR.fastq", 3, 0.56, "CPU time", "dec"),
  c("DS-B1088_SR.fastq", 4, 0.72, "CPU time", "enc"),
  c("DS-B1088_SR.fastq", 4, 0.62, "CPU time", "dec"),
  c("DS-B1088_SR.fastq", 5, 0.76, "CPU time", "enc"),
  c("DS-B1088_SR.fastq", 5, 0.64, "CPU time", "dec"),
  c("DS-B1088_SR.fastq", 6, 0.78, "CPU time", "enc"),
  c("DS-B1088_SR.fastq", 6, 0.68, "CPU time", "dec"),
  c("DS-B1088_SR.fastq", 7, 0.81, "CPU time", "enc"),
  c("DS-B1088_SR.fastq", 7, 0.70, "CPU time", "dec"),
  c("DS-B1088_SR.fastq", 8, 0.83, "CPU time", "enc"),
  c("DS-B1088_SR.fastq", 8, 0.72, "CPU time", "dec")
)

df_time <- data.frame(
  dataset = time_data[, 1],
  thread = as.numeric(time_data[, 2]),
  time = as.numeric(time_data[, 3]),
  type = time_data[, 4],
  state = time_data[, 5]
)
df_time$thread <- factor(df_time$thread, levels = c(1:8))

# Data for memory
memory_data <- rbind(
  c("viruses.fasta", 1, 9, "Memory", "enc"),
  c("viruses.fasta", 1, 9, "Memory", "dec"),
  c("viruses.fasta", 2, 9, "Memory", "enc"),
  c("viruses.fasta", 2, 13, "Memory", "dec"),
  c("viruses.fasta", 3, 9, "Memory", "enc"),
  c("viruses.fasta", 3, 15, "Memory", "dec"),
  c("viruses.fasta", 4, 9, "Memory", "enc"),
  c("viruses.fasta", 4, 15, "Memory", "dec"),
  c("viruses.fasta", 5, 9, "Memory", "enc"),
  c("viruses.fasta", 5, 18, "Memory", "dec"),
  c("viruses.fasta", 6, 9, "Memory", "enc"),
  c("viruses.fasta", 6, 19, "Memory", "dec"),
  c("viruses.fasta", 7, 9, "Memory", "enc"),
  c("viruses.fasta", 7, 23, "Memory", "dec"),
  c("viruses.fasta", 8, 11, "Memory", "enc"),
  c("viruses.fasta", 8, 25, "Memory", "dec"),
  #
  c("DS-B1088_SR.fastq", 1, 11, "Memory", "enc"),
  c("DS-B1088_SR.fastq", 1, 10, "Memory", "dec"),
  c("DS-B1088_SR.fastq", 2, 11, "Memory", "enc"),
  c("DS-B1088_SR.fastq", 2, 13, "Memory", "dec"),
  c("DS-B1088_SR.fastq", 3, 11, "Memory", "enc"),
  c("DS-B1088_SR.fastq", 3, 16, "Memory", "dec"),
  c("DS-B1088_SR.fastq", 4, 11, "Memory", "enc"),
  c("DS-B1088_SR.fastq", 4, 18, "Memory", "dec"),
  c("DS-B1088_SR.fastq", 5, 11, "Memory", "enc"),
  c("DS-B1088_SR.fastq", 5, 23, "Memory", "dec"),
  c("DS-B1088_SR.fastq", 6, 11, "Memory", "enc"),
  c("DS-B1088_SR.fastq", 6, 26, "Memory", "dec"),
  c("DS-B1088_SR.fastq", 7, 11, "Memory", "enc"),
  c("DS-B1088_SR.fastq", 7, 28, "Memory", "dec"),
  c("DS-B1088_SR.fastq", 8, 12, "Memory", "enc"),
  c("DS-B1088_SR.fastq", 8, 31, "Memory", "dec")
)

df_memory <- data.frame(
  dataset = memory_data[, 1],
  thread = as.numeric(memory_data[, 2]),
  memory = as.numeric(memory_data[, 3]),
  type = memory_data[, 4],
  state = memory_data[, 5]
)
df_memory$thread <- factor(df_memory$thread, levels = c(1:8))

# Plot
a <- ggplot(df_time, aes(thread, time * 60)) +
  geom_linerange(
    aes(x = thread, ymin = 0, ymax = time * 60, group = state),
    color = "lightgray", linewidth = 1.0,
    position = position_dodge2(0.6, reverse = TRUE)
  ) +
  geom_point(
    aes(color = state),
    position = position_dodge2(0.6, reverse = TRUE),
    size = 3.75
  ) +
  facet_grid(type ~ dataset) +
  xlab("Number of threads") +
  ylab("Time (sec)") +
  scale_color_discrete(
    breaks = c("enc", "dec"),
    labels = c("Compact &\nEncrypt", "Decrypt &\nUnpack")
  ) +
  theme(legend.title = element_blank())

b <- ggplot(df_memory, aes(thread, memory)) +
  geom_linerange(
    aes(x = thread, ymin = 0, ymax = memory, group = state),
    color = "lightgray", linewidth = 1.0,
    position = position_dodge2(0.6, reverse = TRUE)
  ) +
  geom_point(
    aes(color = state),
    position = position_dodge2(0.6, reverse = TRUE),
    size = 3.75
  ) +
  facet_grid(~dataset) +
  xlab("Number of threads") +
  ylab("Memory (MB)") +
  scale_color_discrete(
    breaks = c("enc", "dec"),
    labels = c("Compact &\nEncrypt", "Decrypt &\nUnpack")
  ) +
  theme(legend.title = element_blank())

# Save plot
plot <- ggarrange(a, b, labels = c("a", "b"), nrow = 2, heights = c(1.85, 1))
ggsave(file_out, plot = plot)

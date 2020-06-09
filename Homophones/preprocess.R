library(Unicode)

data_dir <- "unihan_readings/"

Unihan_Readings <- read.delim("raw/Unihan_Readings.txt", header=FALSE, comment.char="#", stringsAsFactors=FALSE, col.names = c("code", "key", "value"))

types <- sort(unique(Unihan_Readings$key))
write.table(types, paste0(data_dir, "types.csv"), quote = F, row.names = F, col.names = F)

chars <- u_char_inspect(Unihan_Readings$code)
write.table(unique(data.frame(chars$Char, Unihan_Readings$code)), paste0(data_dir, "chars.csv"), quote = F, row.names = F, col.names = F)

for (k in types) {
  write.table(Unihan_Readings[Unihan_Readings$key == k, c("code", "value")], paste0(data_dir, k, ".csv"), quote = F, row.names = F, col.names = F, sep = "|")
}
